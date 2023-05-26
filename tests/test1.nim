import unittest

import ferushtml

let x = """
<html>
  <head>
    <!--This is a test comment-->
    <title>Hello Ferus</title>
  </head>
  <body background-color="blue">
    <!--This is yet another cheeky comment-->
    <p1>Hello World</p1>
    <footer>This is truly one of the footers ever</footer>
  </body>
</html>
"""

var p = newHTMLParser()
let y = p.parse(x)

echo $typeof y

echo y.dump()
