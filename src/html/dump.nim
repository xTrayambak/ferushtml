import element, document, strutils, strformat

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

  let elemInfo = fmt"[tag: {elem.tag}; numchildren: {elem.children.len}; textContent: {textContent}]"
  var tabs = ""

  for x in 0..rounds:
    if x != 0:
      tabs = tabs & "\t"

  str = str & tabs & elemInfo & "\n"
  
  # Now, rinse and repeat! :D
  if elem.children.len > 0:
    for child in elem.children:
      inc rounds
      str = str & dump(child, rounds)
      dec rounds

  str

proc dump*(document: Document): string {.inline.} =
  dump(document.root)

#[
  Handy macro for printing an element dump into stdout

  !!elem => entire dump of the element, printing into stdout
]#
proc `!!`(elem: HTMLElement) {.inline.} =
  echo dump(elem)
