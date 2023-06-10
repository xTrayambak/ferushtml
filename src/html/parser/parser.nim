when defined(ferusHtmlFsmParser):
  import fsm
  export fsm
else:
  import consume
  export consume
