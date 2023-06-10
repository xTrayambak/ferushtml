#[
  An HTML element/node
]#
import attribute

type
  HTMLElementType* = enum
    etNode, etText, etComment

  HTMLElement* = ref object of RootObj
    tag*: string
    textContent*: string
    attributes*: seq[Attribute]
    parent*: HTMLElement
    children*: seq[HTMLElement]

#[
  Get all the attributes of this node
  eg.
  <body background="green"> results in {"background": Butterfly(payload: "s[green]")}
]#
proc getAttrs*(htmlElement: HTMLElement): seq[Attribute] {.inline.} =
  htmlElement.attributes

#[
  Find a child by it's tag, returns the first occurence of said tag.

  Raises an exception if no such child is found.
]#
proc findChildByTag*(htmlElement: HTMLElement, tag: string): HTMLElement {.inline.} =
  for child in htmlElement.children:
    if child.tag == tag:
      return child

  raise newException(ValueError, "Could not find tag by name " & '"' & tag & '"')

#[
  Find all children by a tag name, and return all occurences.

  Returns an empty sequence if none such children are found, a lot less 
  aggressive/error-prone than findChildByTag() but it's also more slow and consumes
  more memory, so only use it when you need to, for maximum performance.
]#
proc findAllChildrenByTag*(htmlElement: HTMLElement, tag: string): seq[HTMLElement] {.inline.} =
  var s: seq[HTMLElement] = @[]
  for child in htmlElement.children:
    if child.tag == tag:
      s.add(child)
  
  s
#[
  Push another HTML element into this one's children stack
]#
proc push*(parent: HTMLElement, child: HTMLElement) {.inline.} =
  parent.children.add(child)

#[
  Create a new HTML element
]#
proc newHTMLElement*(tag: string, 
                     elemTextContent: string, 
                     attributes: seq[Attribute], 
                     children: seq[HTMLElement],
                     parent: HTMLElement = HTMLElement(tag: "", textContent: "", attributes: @[], children: @[])
                    ): HTMLElement {.inline.} =
  HTMLElement(tag: tag, 
              textContent: elemTextContent, 
              attributes: attributes, children: children)
