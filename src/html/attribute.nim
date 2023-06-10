#[
  HTML attributes.

  This code is licensed under the MIT license
]#
import butterfly

type Attribute* = ref object of RootObj
  name*: string
  value*: HTMLButterfly

proc newAttribute*(name: string, value: HTMLButterfly): Attribute {.inline.} = 
  Attribute(name: name, value: value)
