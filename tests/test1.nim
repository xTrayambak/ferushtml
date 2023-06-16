import unittest

import ferushtml

let x = readFile("test.html")

var p = newHTMLParser()
let y = p.parse(x)

echo $typeof y

echo y.dump()