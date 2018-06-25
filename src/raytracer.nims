when defined(macosx):
  # switch("define", "MODE_RGBA")
  discard
elif defined(linux):
  switch("define", "MODE_ABGR")
