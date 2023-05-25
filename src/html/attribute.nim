#[
  HTML attributes.

  This code is licensed under the MIT license
]#
import ../butterfly

type Attribute* = ref object of RootObj
  name*: string
  value*: Butterfly

proc newAttribute*(name: string, value: Butterfly): Attribute {.inline.} = 
  Attribute(name: name, value: value)
