#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import math, vec3

type Ray* = tuple
  origin, direction: Vec3

proc prime*(x, y, width, height: int, fov: float): Ray =
  assert width > height

  let
    ar = width / height
    fa = (fov.degToRad() / 2.0).tan()
    sx = (((x.float + 0.5) / width.float) * 2.0 - 1.0) * ar
    sy = 1.0 - ((y.float + 0.5) / height.float) * 2.0

  (zero(), (sx * fa, sy * fa, -1.0).norm())
