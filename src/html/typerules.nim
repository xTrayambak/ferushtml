#[
  Type rules for HTML attributes (just returns butterfly type)
]#
import tables

const HTML_ATTR_TYPES = {
  "background-color": "s",
  "size": "f"
}.toTable
