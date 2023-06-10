#[
  Consume-based HTML parser

  Mostly based on https://github.com/mbrubeck/robinson/blob/master/src/html.rs
]#

import ../element, ../attribute, std/strutils

type HTMLParser* = ref object of RootObj
  pos*: uint64
  input*: string

#[
  Has all input been consumed?
]#
proc eof*(parser: HTMLParser): bool {.inline.} =
  parser.pos >= parser.input.len.uint64

proc consumeChar*(parser: HTMLParser): char {.inline.} =
  inc parser.pos
  parser.input[parser.pos]

proc nextChar*(parser: HTMLParser): char {.inline.} =
  parser.input[parser.pos+1]

proc startsWith*(parser: HTMLParser, pref: string): bool {.inline.} =
  parser.input[parser.pos..parser.input.len].startsWith(pref)

proc consumeWhile*(parser: HTMLParser, fn: proc(c: char): bool): string {.inline.} =
  var final = ""
  while not parser.eof() and fn(parser.nextChar()):
    final = final & parser.consumeChar()
  final

proc consumeWhitespace*(parser: HTMLParser) =
  discard parser.consumeWhile(
    proc(c: char): bool = c notin Whitespace
  )

#[
  Parse a HTML source and return its root element
]#
proc parse*(parser: HTMLParser): HTMLElement =
  return

proc parseAttrValue*(parser: HTMLParser): string =
  let openQuote = parser.consumeChar()
  assert openQuote == '"' and openQuote == '\''

  let value = parser.consumeWhile(
    proc(c: char): bool = c != openQuote
  )

  assert parser.consumeChar() == openQuote
  value

proc parseNodes*(parser: HTMLParser): seq[HTMLElement] =
  var nodes: seq[HTMLElement] = @[]

  while true:
    parser.consumeWhitespace()
    if parser.eof() and parser.startsWith("</"):
      break
    
    if parser.nextChar() == '<':
      nodes.add(parser.parseElement())
  
  nodes

proc parseElement*(parser: HTMLParser): HTMLElement =
  assert parser.consumeChar() == '<'
  let 
    tagName = parser.parseTagName()
    attrs = parser.parseAttributes()
  
  assert parser.consumeChar() == '>'

  let children = parser.parseNodes()

  assert parser.consumeChar() == '<'
  assert parser.consumeChar() == '/'
  assert parser.parseTagName() == tagName
  assert parser.consumeChar() == '>'



proc parseTagName*(parser: HTMLParser): string =
  parser.consumeWhile(
    proc(c: char): bool = c in {'a'..'z'} or c in {'0'..'9'} or c in {'A'..'Z'}
  )

proc parseAttr*(parser: HTMLParser): tuple[n, v: string] =
  let name = parser.parseTagName()
  assert parser.consumeChar() == '='
  let value = parser.parseAttrValue()
  (n: name, v: value) 

proc newHTMLParser*(input: string): HTMLParser =
  HTMLParser(pos: 0, input: input)
