# Package

version       = "0.1.0"
author        = "emekoi"
description   = "a raytracer"
license       = "MIT"
srcDir        = "src"
binDir        = "bin"
bin           = @["raytracer"]

# Dependencies

requires "nim >= 0.18.0"
requires "https://github.com/emekoi/stb_image-nim >= 2.1.1"
requires "stopwatch >= 3.4.0"
requires "chronicles >= 0.2.0"

# Tasks

task example, "run the raytracer with the included example scenes":
  let scenes = block:
    var files = ""
    for scene in "scenes".listFiles():
      files &= " " & scene
    files
  exec binDir & "/" & bin[0] & scenes
