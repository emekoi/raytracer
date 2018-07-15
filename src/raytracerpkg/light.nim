#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import vec3, color

# type Light* = tuple
#   position: Vec3
#   color: Color

type Light* = ref object of RootObj
  direction*: Vec3
  color*: Color
  intensity*: float

proc newLight*(direction: Vec3, color: Color, intensity: float): Light =
  new result
  result.direction = direction
  result.color = color
  result.intensity = intensity