when defined(ferusHtmlConsumeParser):
  echo "[ERR] The consume parser is not available yet."
  quit 0
else:
  import fsm

  export fsm
