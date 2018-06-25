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
requires "suffer >= 0.1.2"
requires "sdl2_nim >= 2.0.7.0"
