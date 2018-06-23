#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import strutils, vec3

when defined(MODE_RGBA):
  type Color* = tuple[r, g, b, a: uint8]
elif defined(MODE_ARGB):
  type Color* = tuple[a, r, g, b: uint8]
elif defined(MODE_ABGR):
  type Color* = tuple[a, b, g, r: uint8]
else:
  type Color* = tuple[b, g, r, a: uint8]

proc `$`*(c: Color): string =
  return "Color($# $# $# $#)" % [$c.r, $c.g, $c.b, $c.a]

proc color*(r, g, b, a: uint8 = 0xff): Color =
  result.r = r
  result.g = g
  result.b = b
  result.a = a

proc `+`*(self, rhs: Color): Color =
  result.r = self.r + rhs.r
  result.g = self.g + rhs.g
  result.b = self.b + rhs.b
  result.a = self.a + rhs.a

proc `-`*(self, rhs: Color): Color =
  result.r = self.r - rhs.r
  result.g = self.g - rhs.g
  result.b = self.b - rhs.b
  result.a = self.a - rhs.a

proc `*`*(self, rhs: Color): Color =
  result.r = self.r * rhs.r
  result.g = self.g * rhs.g
  result.b = self.b * rhs.b
  result.a = self.a * rhs.a

proc `/`*(self, rhs: Color): Color =
  result.r = self.r div rhs.r
  result.g = self.g div rhs.g
  result.b = self.b div rhs.b
  result.a = self.a div rhs.a

proc `*`*(self: Color, rhs: float): Color =
  result.r = (float(self.r) * rhs).uint8
  result.g = (float(self.g) * rhs).uint8
  result.b = (float(self.b) * rhs).uint8

proc `*`*(self: Color, rhs: Vec3): Color =
  result.r = (float(self.r) * rhs.x).uint8
  result.g = (float(self.g) * rhs.y).uint8
  result.b = (float(self.b) * rhs.z).uint8

const
  WHITE* = color(0xff'u8, 0xff'u8, 0xff'u8, 0xff'u8)
  BLACK* = color(0x00'u8, 0x00'u8, 0x00'u8, 0xff'u8)
  RED*   = color(0xff'u8, 0x00'u8, 0x00'u8, 0xff'u8)
  GREEN* = color(0x00'u8, 0xff'u8, 0x00'u8, 0xff'u8)
  BLUE*  = color(0x00'u8, 0x00'u8, 0xff'u8, 0xff'u8)
