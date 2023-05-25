import element

type Document* = ref object of RootObj
  # This should never be used, only internal ferushtml components should use root.
  root*: HTMLElement
  head*: HTMLElement
  body*: HTMLElement

#[
  Create a new HTML document
]#
proc newDocument*(root: HTMLElement): Document {.inline.} =
  let htmlTag = root.findChildByTag("html")
  Document(root: root, head: htmlTag.findChildByTag("head"), body: htmlTag.findChildByTag("body"))
