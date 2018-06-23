when defined(macosx):
  switch("define", "MODE_ARGB")
elif defined(linux):
  switch("define", "MODE_ABGR")
