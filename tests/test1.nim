import unittest

import ferushtml

var html = newHTMLElement("html", "", @[], @[])
html.push(
  newHTMLElement(
    "head", "", @[], @[
      newHTMLElement("title", "Hello ferushtml", @[], @[])
    ]
  )
)
html.push(
  newHTMLElement(
    "body", "", @[], @[
      newHTMLElement("p1", "Does parenting work?", @[], @[])
    ]
  )
)
html.push(
  newHTMLElement(
    "thisisntreal", "", @[], @[
      newHTMLElement("p1", "OBAMA GRILLED CHEESE SANDWICH!!!!", @[], @[
        newHTMLElement("p2", "IS THE ONE PIECE REAL!?", @[], @[])
      ])
    ]
  )
)
html.push(
  newHTMLElement(
    "thisisntrealeither", "", @[], @[
      newHTMLElement("p420", "(breakn bd refrenc)", @[], @[])
    ]
  )
)

echo html.dump()
