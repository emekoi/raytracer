#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import math
import vec3

type Ray* = tuple
  origin, direction: Vec3

proc pointAt*(self: Ray, t: float): Vec3 =
  self.origin + self.direction * t