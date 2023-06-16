import element, butterfly, document, strutils, strformat

#[
  Dump all attributes of an element
]#
proc dumpAttrs(elem: HTMLElement, tabs: string): string {.inline.} =
  var attrInf = ""
  for attr in elem.attributes:
    attrInf = attrInf & "* " & attr.name & " = " & attr.value.payload & "\n" & tabs
  
  attrInf

#[
  Dump an element and it's children, and their children, and their children's children, and their children's childr-Maximum recursion depth reached.

  This is mostly copied from Ferus' old HTML engine's dump method, as it is a true piece of art.
  It's mostly been decoupled from Ferus internals like the root element which was to be discarded purely for aesthetic reasons.
]#
proc dump*(elem: HTMLElement,
           rounds: int = 0): string =
  var
    str = ""
    rounds = rounds
    textContent: string

  if elem.textContent.len > 0 and not isEmptyOrWhitespace(elem.textContent):
    textContent = elem.textContent
  else:
    textContent = ""

  var tabs: string
  
  for x in 0..rounds:
    if x != 0:
      tabs = tabs & "\t"

  let elevate = "\t"
  let nextline = "\n"

  let elemInfo = fmt"[tag: {elem.tag}; " & 
  fmt"numchildren: {elem.children.len}; " & 
  fmt"textContent: {textContent}];{nextline}{tabs}{elevate}" & # tabbing schenanigans
  dumpAttrs(elem, tabs & "\t")

  str = str & tabs & elemInfo & "\n"
  
  # Now, rinse and repeat! :D
  if elem.children.len > 0:
    for child in elem.children:
      inc rounds
      str = str & dump(child, rounds)
      dec rounds

  str