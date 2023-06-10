import element

type HTMLDocument* = ref object of RootObj
  # This should never be used, only internal ferushtml components should use root.
  root*: HTMLElement

  # <head>
  head*: HTMLElement

  # <body>
  body*: HTMLElement

#[
  Create a new HTML document
]#
proc newDocument*(root: HTMLElement): HTMLDocument {.inline.} =
  let htmlTag = root.findChildByTag("html")
  HTMLDocument(root: root, head: htmlTag.findChildByTag("head"), body: htmlTag.findChildByTag("body"))
