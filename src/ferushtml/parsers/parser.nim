#[
  HTML/XML parser
]#
import html/parser, std/[strformat, strutils]

type
  InvalidParseDefect* = Defect
  ParserDoctype* = enum
    pdHtml   # HTML
    pdXml    # XML
    pdXhtml  # ..and their obnoxious child XHTML
 
  Parser* = ref object of RootObj
    source*: string
    doctype*: ParserDoctype

proc parseHTML*(parser: Parser): HTMLDocument {.inline raises: [Defect].} =
  if parser.doctype != pdHtml:
    raise newException(InvalidParseDefect, 
      fmt"Attempted to call parseHTML() when detected doctype is {parser.doctype}"
    )

  let parser = newHTMLParser()
  parser.parse(parser.source)

proc getDoctype*(source: string): ParserDoctype =
  let doctypeLine = source.splitLines()[0]
  if doctypeLine[0] == '<':
    if doctypeLine.len > 9:
      if doctypeLine[1..9] == "!doctype ":
        let doctypeStr = doctypeLine[1..14].removePrefix("!doctype ").toLowerAscii()
        case doctypeStr:
          of "html":
            return pdHtml
          of "xhtml":
            return pdXhtml
          of "xml":
            return pdXml
          else:
            return pdHtml

proc newParser*(source: string): Parser =
  Parser(source: source, doctype: getDoctype(source))