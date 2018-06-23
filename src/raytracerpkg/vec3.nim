#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import math

type Vec3* = tuple
  x, y, z: float

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

proc `^`*(self, rhs: Vec3): float =
  self.x * rhs.x + self.y * rhs.y + self.z * rhs.z

proc mag*(self: Vec3): float =
  result = ((self.x ^ 2) + (self.y ^ 2) + (self.z ^ 2)).sqrt()

proc norm*(self: Vec3): Vec3 =
  let m = self.mag()
  if m > 0: return self / m
  else: return self
