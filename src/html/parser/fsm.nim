#[
  Finite state machine based HTML parser
]#

import ../element, ../document, ../attribute, ../../butterfly

type 
  HTMLParserState* = enum
    psInit,
    psStartTag,
    psComment,
    psReadingTag,
    psReadingAttributes,
    psEndTag,
    psBeginClosingTag

  HTMLParser* = ref object of HTMLElement
    state*: HTMLParserState

proc isWhitespace*(c: char): bool {.inline.} =
  c == ' '

proc parse*(parser: HTMLParser, input: string): HTMLElement {.inline.} =
  var
    lastParent = newHTMLElement("root", "", @[], @[])
    tagName: string = ""

    currentAttrName: string
    currentAttrNameDone: bool = false
    currentAttrRawValue: string
    currentAttrRawValueDone: bool = false

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
      if index + 1 < input.len and index + 2 < input.len and index + 3 < input.len:
        if input[index + 1] == '!' and 
          input[index + 2] == '-' and 
          input[index + 3] == '-':
          # Comment detected!
          parser.state = psComment
          continue
      parser.state = psStartTag
    elif parser.state == psStartTag:
      if c == '/':
        parser.state = HTMLParserState.psBeginClosingTag
      else:
        parser.state = HTMLParserState.psReadingTag
        tagName = tagName & c
    elif parser.state == psReadingTag:
      if isWhitespace(c):
        parser.state = HTMLParserState.psReadingAttributes
      elif c == '>':
        # We are now ending the parsing, this element is either fully constructed or malformed.
        parser.state = HTMLParserState.psEndTag
        
        # Construct the new element itself.
        var parent = newHTMLElement(tagName, "", attributes, @[])
        parent.parent = lastParent
        lastParent.push(parent)
        lastParent = parent
      elif isWhitespace(c):
        # Attribute parsing
        parser.state = psReadingAttributes
      else:
        tagName = tagName & c
    elif parser.state == psReadingAttributes:
      if c == '>':
        currentAttrRawValueDone = true
        currentAttrNameDone = true
        parser.state = psEndTag

        var parent = newHTMLElement(tagName, "", attributes, @[])
        parent.parent = lastParent

        lastParent.push(parent)
        lastParent = parent
      else:
        # Parse attribute name
        if not currentAttrNameDone:
          if c == '=':
            currentAttrNameDone = true
            continue

          currentAttrName = currentAttrName & c
        else:
          # Parse attribute value
          if not currentAttrRawValueDone:
            if not isWhitespace(c) and c != '<':
              currentAttrRawValue = currentAttrRawValue & c
            else:
              currentAttrRawValueDone = true

              echo currentAttrName
              echo currentAttrRawValue
              var bVal = newButterfly("s[" & currentAttrRawValue & "]")
              attributes.add(newAttribute(
                currentAttrName, bVal
              ))
              currentAttrName.reset()
              currentAttrRawValue.reset()

    elif parser.state == psEndTag:
      lastParent.textContent = lastParent.textContent & c
      tagName.reset()
    elif parser.state == psBeginClosingTag:
      if c == '>':
        lastParent = lastParent.parent

  lastParent

proc parseToDocument*(parser: HTMLParser, input: string): Document {.inline.} =
  newDocument(parser.parse(input))

proc newHTMLParser*: HTMLParser {.inline.} =
  HTMLParser(state: HTMLParserState.psInit)
