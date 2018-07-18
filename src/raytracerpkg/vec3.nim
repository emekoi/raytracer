#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import math

type Vec3* = tuple
  x, y, z: float

{.push inline.}

proc `+`*(self, rhs: Vec3): Vec3 =
  (self.x + rhs.x, self.y + rhs.y, self.z + rhs.z)

proc `+=`*(self: var Vec3, rhs: Vec3)=
  self = (self.x + rhs.x, self.y + rhs.y, self.z + rhs.z)

proc `+`*(self: Vec3, rhs: float): Vec3 =
  (self.x + rhs, self.y + rhs, self.z + rhs)

proc `+=`*(self: var Vec3, rhs: float)=
  self = (self.x + rhs, self.y + rhs, self.z + rhs)

proc `-`*(self, rhs: Vec3): Vec3 =
  (self.x - rhs.x, self.y - rhs.y, self.z - rhs.z)

proc `-=`*(self: var Vec3, rhs: Vec3)=
  self = (self.x - rhs.x, self.y - rhs.y, self.z - rhs.z)

proc `-`*(self: Vec3, rhs: float): Vec3 =
  (self.x - rhs, self.y - rhs, self.z - rhs)

proc `-=`*(self: var Vec3, rhs: float)=
  self = (self.x - rhs, self.y - rhs, self.z - rhs)

proc `*`*(self, rhs: Vec3): Vec3 =
  (self.x * rhs.x, self.y * rhs.y, self.z * rhs.z)

proc `*=`*(self: var Vec3, rhs: Vec3)=
  self = (self.x * rhs.x, self.y * rhs.y, self.z * rhs.z)

proc `*`*(self: Vec3, rhs: float): Vec3 =
  (self.x * rhs, self.y * rhs, self.z * rhs)

proc `*=`*(self: var Vec3, rhs: float)=
  self = (self.x * rhs, self.y * rhs, self.z * rhs)

proc `/`*(self, rhs: Vec3): Vec3 =
  (self.x / rhs.x, self.y / rhs.y, self.z / rhs.z)

proc `/=`*(self: var Vec3, rhs: Vec3)=
  self = (self.x / rhs.x, self.y / rhs.y, self.z / rhs.z)

proc `/`*(self: Vec3, rhs: float): Vec3 =
  (self.x / rhs, self.y / rhs, self.z / rhs)

proc `/=`*(self: var Vec3, rhs: float)=
  self = (self.x / rhs, self.y / rhs, self.z / rhs)

proc `-`*(self: Vec3): Vec3 =
  result.x = if self.x != 0.0: -self.x else: 0.0
  result.y = if self.y != 0.0: -self.y else: 0.0
  result.z = if self.z != 0.0: -self.z else: 0.0

proc `^`*(self, rhs: Vec3): float =
  result += (self.x * rhs.x)
  result += (self.y * rhs.y)
  result += (self.z * rhs.z)

proc `%`*(self, rhs: Vec3): Vec3 =
  result.x = (self.y * rhs.z) - (self.z * rhs.y)
  result.y = (self.z * rhs.x) - (self.x * rhs.z)
  result.z = (self.x * rhs.y) - (self.y * rhs.x)

proc mag*(self: Vec3): float =
  result = ((self.x ^ 2) + (self.y ^ 2) + (self.z ^ 2)).sqrt()

proc norm*(self: Vec3): Vec3 =
  let m = self.mag()
  if m > 0: return self / m
  else: return self

proc zero*(): Vec3 =
  (0.0, 0.0, 0.0)