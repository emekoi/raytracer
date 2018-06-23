#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import streams, shape, color, light

type Scene*[T: Shape] = object
  objects*: seq[T]
  lights*: seq[Light]
  width, height: int

proc newScene*[T: Shape](width, height: int): Scene[T] =
  result.objects = @[]
  result.lights = @[]
  result.width = width
  result.height = height

proc count*(s: Scene): int =
  s.objects.len

proc add*(s: var Scene, shape: Shape) =
  s.objects.add shape

proc add*(s: var Scene, light: Light) =
  s.lights.add light
