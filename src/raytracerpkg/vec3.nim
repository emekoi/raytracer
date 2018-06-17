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
