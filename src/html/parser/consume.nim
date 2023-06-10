#[
  Consume-based HTML parser 
]#

import ../element, ../attribute

type HTMLParser* = ref object of RootObj
  pos*: uint64
  input*: string

#[
  Parse a HTML source and return its root element
]#
proc parse*(parser: HTMLParser): HTMLElement =
  return

proc newHTMLParser*(input: string): HTMLParser =
  HTMLParser(pos: 0, input: input)
