when defined(ferusHtmlConsumeParser):
  import consume
  export consume
else:
  import fsm
  export fsm