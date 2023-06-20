#[
  Finite state machine based HTML parser
]#

import element, document, attribute, butterfly, 
      std/[strutils, strformat]

type 
  HTMLParserState* = enum
    psInit,
    psStartTag,
    psComment,
    psReadingTag,
    psReadingAttributeName,
    psReadingAttributeValue,
    psEndTag,
    psBeginClosingTag

  HTMLParser* = ref object of HTMLElement
    state*: HTMLParserState

proc isWhitespace*(c: char): bool {.inline.} =
  c == ' '

proc parse*(parser: HTMLParser, input: string): HTMLElement =
  var
    lastParent = newHTMLElement("root", "", @[], @[])
    tagName: string = ""

    currentAttrName: string
    currentAttrRawValue: string

    attributes: seq[Attribute]

    index: int = -1

  for c in input:
    inc index

    # Comment handler
    if parser.state == psComment:
      if c == '-':
        if index + 1 < input.len and index + 2 < input.len:
          if input[index + 1] == '-' and input[index + 2] == '>':
            # Comment end!
            parser.state = psInit
            continue

      continue

    if c == '<':
      # Code to handle comments. They're just discarded by the parser.
      if index + 3 < input.len:
        if input[index + 1] == '!' and 
          input[index + 2] == '-' and 
          input[index + 3] == '-':
          # Comment detected!
          parser.state = psComment
          continue
      # TODO(xTrayambak): DOCTYPE ignoring support
      parser.state = psStartTag
    elif parser.state == psStartTag:
      if c == '/':
        parser.state = psBeginClosingTag
      else:
        parser.state = psReadingTag
        tagName = tagName & c

    elif parser.state == psReadingTag:
      if isWhitespace(c):
        parser.state = psReadingAttributeName
      elif c == '>':
        # We are now ending the parsing, this element is either fully constructed or malformed.
        parser.state = psEndTag

        # Construct the new element itself.
        var parent = newHTMLElement(tagName.toLowerAscii(), "", attributes, @[])
        parent.parent = lastParent
        lastParent.push(parent)
        lastParent = parent
        tagName.reset()
      else:
        tagName = tagName & c
    elif parser.state == psReadingAttributeName:
      if c != '=':
        currentAttrName = currentAttrName & c
      else:
          if currentAttrName.len < 1:
            raise newException(
              ValueError, 
              fmt"At char {index}: expected inline attribute name, got '=' instead"
            )
          
          parser.state = psReadingAttributeValue
          continue
    elif parser.state == psReadingAttributeValue:
      if c == '>':
        when defined(ferusHtmlExperimentalErrors):
          if currentAttrRawValue.len < 1:
            raise newException(
              ValueError, 
              fmt"At char {index}: Tag attribute value section abruptly ended by trailing character '>'"
            )

        attributes.add(
          newAttribute(
            currentAttrName.toLowerAscii(),
            newButterfly(fmt"s[{currentAttrRawValue}]")
          )
        )

        currentAttrName.reset()
        currentAttrRawValue.reset()
      
        parser.state = psEndTag

        var parent = newHTMLElement(tagName.toLowerAscii(), "", attributes, @[])
        parent.parent = lastParent
        lastParent.push(parent)
        lastParent = parent
        attributes.reset()
        continue
      else:
        #[
          Ignore       Real
          this         end
          |            |
          V            V
          "blahblahblah"
          ^            ^
          |            |
          length       length } hence we can infer that the 
          is 0         is 12  } value is probably complete
        ]#
        if c != '"':
          currentAttrRawValue = currentAttrRawValue & c
        elif c == '"' and currentAttrRawValue.len > 1:
          attributes.add(
            newAttribute(
              currentAttrName.toLowerAscii(),
              newButterfly(fmt"s[{currentAttrRawValue}]")
            ) 
          )

          if input[index + 1] in Whitespace:
            parser.state = psReadingAttributeName
          else:
            var parent = newHTMLElement(tagName.toLowerAscii(), "", attributes, @[])
            parent.parent = lastParent
            lastParent.push(parent)
            lastParent = parent
            parser.state = psEndTag

          currentAttrName.reset()
          currentAttrRawValue.reset()
          continue
    elif parser.state == psEndTag:
      if c != '>':
        lastParent.textContent = lastParent.textContent & c
        tagName.reset()
    elif parser.state == psBeginClosingTag:
      if c == '>':
        lastParent = lastParent.parent

  lastParent

proc parseToDocument*(parser: HTMLParser, input: string): HTMLDocument {.inline.} =
  newDocument(parser.parse(input))

proc newHTMLParser*: HTMLParser {.inline.} =
  HTMLParser(state: HTMLParserState.psInit)