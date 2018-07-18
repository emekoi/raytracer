#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import vec3

type Camera* = object
  origin*: Vec3
  lowerLeftCorner*: Vec3
  horizontal*: Vec3
  vertical*: Vec3

proc newCamera*(origin: Vec3=zero()): Camera =
  result.origin = origin
  result.lower_left_corner = (-2.0, -1.0, -1.0)
  result.horizontal = (4.0, 0.0, 0.0)
  result.vertical = (0.0, 2.0, 0.0)
