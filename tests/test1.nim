import unittest

import ferushtml

let x = """
<html>
  <head>
    <title>Hello Ferus</title>
  </head>
  <body>
    <p1>Hello World</p1>
    <footer>This is truly one of the footers ever</footer>
  </body>
</html>
"""

var p = newHTMLParser()
let y = p.parse(x)

echo y.dump()
