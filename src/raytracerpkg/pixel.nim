#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import suffer, vec3

const
  WHITE* = color(0xff, 0xff, 0xff)
  BLACK* = color(0x00, 0x00, 0x00)
  RED*   = color(0xff, 0x00, 0x00)
  GREEN* = color(0x00, 0xff, 0x00)
  BLUE*  = color(0x00, 0x00, 0xff)

proc `+`*(self, rhs: Pixel): Pixel =
  result.rgba.r = self.rgba.r + rhs.rgba.r
  result.rgba.g = self.rgba.g + rhs.rgba.g
  result.rgba.b = self.rgba.b + rhs.rgba.b
  result.rgba.a = self.rgba.a + rhs.rgba.a

proc `-`*(self, rhs: Pixel): Pixel =
  result.rgba.r = self.rgba.r - rhs.rgba.r
  result.rgba.g = self.rgba.g - rhs.rgba.g
  result.rgba.b = self.rgba.b - rhs.rgba.b
  result.rgba.a = self.rgba.a - rhs.rgba.a

proc `*`*(self, rhs: Pixel): Pixel =
  result.rgba.r = self.rgba.r * rhs.rgba.r
  result.rgba.g = self.rgba.g * rhs.rgba.g
  result.rgba.b = self.rgba.b * rhs.rgba.b
  result.rgba.a = self.rgba.a * rhs.rgba.a

proc `/`*(self, rhs: Pixel): Pixel =
  result.rgba.r = self.rgba.r div rhs.rgba.r
  result.rgba.g = self.rgba.g div rhs.rgba.g
  result.rgba.b = self.rgba.b div rhs.rgba.b
  result.rgba.a = self.rgba.a div rhs.rgba.a

proc `*`*(self: Pixel, rhs: float): Pixel =
  result.rgba.r = (float(self.rgba.r) * rhs).uint8
  result.rgba.g = (float(self.rgba.g) * rhs).uint8
  result.rgba.b = (float(self.rgba.b) * rhs).uint8
  result.rgba.a = self.rgba.a

proc `*`*(self: Pixel, rhs: Vec3): Pixel =
  result.rgba.r = (float(self.rgba.r) * rhs.x).uint8
  result.rgba.g = (float(self.rgba.g) * rhs.y).uint8
  result.rgba.b = (float(self.rgba.b) * rhs.z).uint8
  result.rgba.a = self.rgba.a
