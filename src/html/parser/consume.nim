#[
  Consume-based HTML parser 
]#

import ../element, ../attribute

type HTMLParser* = ref object of RootObj
  pos*: uint64
  input*: string

proc parse*(parser: HTMLParser, input: string): HTMLElement =


proc newHTMLParser*: HTMLParser =
  HTMLParser(pos: 0, input: "")
