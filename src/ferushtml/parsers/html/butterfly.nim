#[
  Smart types for CSS/HTML values for Ferus

  Basic butterfly syntax (inside Butterfly.payload) is:
  ```
  type[value in quotations]
  ```

  where `type` can be:
  b - bool
  s - string
  c - char
  i - int
  f - float

  This code is licensed under the MIT license. This is a part of the Ferus codebase.
]#
import std/[tables, strutils]

#[
  Convert some data into a boolean.

  For eg.,
  <html idonthaveanideaastoatagthatusesaboolean=true></html>

  Representation in butterfly form will be: ""true""
]#
proc ferusButterflyBool*(data: string): bool =
  if data == "true":
    return true
  elif data == "false":
    return false
  elif data == "yes":
    return true
  elif data == "no":
    return false
  
  raise newException(ValueError, "Data does not match any (true, false, yes, no)")

#[
  Convert some data into a char.
  I have no clue why this exists.
]#
proc ferusButterflyChar*(data: string): char =
  if data.len < 1:
    raise newException(ValueError, "Data length is 0")
  data[0]

#[
  Convert some data into an int.

  For eg.

  p1 {
    x: 4;
  }

  where p1[x] = 4
]#
proc ferusButterflyInt*(data: string): int =
  if data.len < 1:
    raise newException(ValueError, "Data length is 0")

  parseInt(data)

#[
  Convert some data into float form.

  For eg.

  p1 {
    x: 4.4;
  }

  where p1[x] = 4.4
]#
proc ferusButterflyFloat*(data: string): float =
  if data.len < 1:
    raise newException(ValueError, "Data length is 0")

  parseFloat(data)


type
  #[
    The type determined to be valid for a butterfly.

    btInt - integer
    btStr - string
    btBool - boolean
    btChar - character
    btFloat - floating-point number
    btRgba - red-green-blue-alpha tuple
    btNone - ???
  ]#
  ButterflyType* = enum
    btInt,
    btStr,
    btBool,
    btChar,
    btFloat,
    btRgba,
    btString,
    btNone
  
  #[
    The "quality" of the butterfly, or how quirky it is.

    This isn't used anywhere yet. This will be used to balance out quirks later.
  ]#
  ButterflyQuality* = enum
    bqGood,        # Perfectly okay butterfly payload
    bqEmpty,       # Empty butterfly payload
    bqMalformed,   # Slightly erroneous payload, Ferus will try to evaluate what it means, this may cause wonkiness. If no good evaluation is done, the quality will degrade to bqBad.
    bqBad          # Bad payload. Ferus won't even attempt to decipher what you mean.

  #[
    The Butterfly object. This is used to determine the type of an object by representing it in an intermediate representation form.
  ]#
  HTMLButterfly* = ref object of RootObj
    butterType*: ButterflyType
    payload*: string
    fastStrPath*: string
    quality*: ButterflyQuality

#[
  Process an int out of a butterfly
]#
proc processInt*(butterfly: HTMLButterfly): int {.inline.} =
  if butterfly.butterType != btInt:
    raise newException(ValueError, "Attempt to process int out of a non-int butterfly")

  return ferusButterflyInt(butterfly.payload)

#[
  Process a boolean out of a butterfly
]#
proc processBool*(butterfly: HTMLButterfly): bool {.inline.} =
  if butterfly.butterType != btBool:
    raise newException(ValueError, "[src/butterfly.nim] Attempt to process bool out of a non-bool butterfly")

  return ferusButterflyBool(butterfly.payload)

#[
  Process a character out of a butterfly
]#
proc processChar*(butterfly: HTMLButterfly): char {.inline.} =
  if butterfly.butterType != btChar:
    raise newException(ValueError, "Attempt to process char out of a non-char butterfly")

  return ferusButterflyChar(butterfly.payload)

#[
  Process a float out of a butterfly
]#
proc processFloat*(butterfly: HTMLButterfly): float {.inline.} =
  if butterfly.butterType != btFloat:
    raise newException(ValueError, "Attempt to process float out of a non-float butterfly")

  return ferusButterflyFloat(butterfly.payload)

#[
  Instantiate a new Butterfly object.
]#
proc newButterfly*(data: string): HTMLButterfly {.inline.} =
  if data.len < 1:
    raise newException(ValueError, "Butterfly payload can not be empty")

  var
    payload = ""
    bType: ButterflyType
    pIdx = -1

  for c in data:
    inc pIdx
    if c == '[' or c == ']':
      continue

    if pIdx == 0:
      continue
    payload = payload & c

  if data[0] == 'i':
    bType = ButterflyType.btInt
  elif data[0] == 's':
    bType = ButterflyType.btStr
  elif data[0] == 'c':
    bType = ButterflyType.btChar
  elif data[0] == 'b':
    bType = ButterflyType.btBool
  elif data[0] == 'f':
    bType = ButterflyType.btFloat
  else:
    raise newException(ValueError, "[src/butterfly.nim] Invalid payload! Terminating!")

  HTMLButterfly(fastStrPath: data, 
    payload: payload, butterType: 
    bType, 
    quality: ButterflyQuality.bqGood
  )