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
proc getAttrs*(htmlElement: HTMLElement): seq[Attribute] =
  htmlElement.attributes

#[
  Push another HTML element into this one's children stack
]#
proc push*(parent: HTMLElement, child: HTMLElement) =
  parent.children.add(child)

#[
  Create a new HTML element
]#
proc newHTMLElement*(tag: string, 
                     elemTextContent: string, 
                     attributes: seq[Attribute], 
                     children: seq[HTMLElement],
                     parent: HTMLElement = HTMLElement(tag: "", textContent: "", attributes: @[], children: @[])): HTMLElement =
  HTMLElement(tag: tag, 
              textContent: elemTextContent, 
              attributes: attributes, children: children)
