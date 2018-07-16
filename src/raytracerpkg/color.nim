#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import strutils
import vec3

type Color* = Vec3

template `r`*(self: Color): float = self.x

template `r=`*(self: var Color, v: float) =
  self.x = v

template `g`*(self: Color): float = self.y

template `g=`*(self: var Color, v: float) =
  self.y = v
  
template `b`*(cself: Color): float = self.z

template `b=`*(self: var Color, v: float) =
  self.z = v

template lerp[T](a, b, p: T): untyped =
  ((T(1) - p) * a + p * b)

proc `$$`*(self: Color): string =
  return "$#$#$#" % [
    $chr(lerp[float](0.0, 256.0, self.r).uint),
    $chr(lerp[float](0.0, 256.0, self.g).uint),
    $chr(lerp[float](0.0, 256.0, self.b).uint)
  ]

proc clamp*(self: Color): Color =
  result.x = self.x.clamp(0.0, 1.0)
  result.y = self.y.clamp(0.0, 1.0)
  result.z = self.z.clamp(0.0, 1.0)

const
  WHITE* = (1.0, 1.0, 1.0).Color
  BLACK* = (0.0, 0.0, 0.0).Color
  RED*   = (1.0, 0.0, 0.0).Color
  GREEN* = (0.0, 1.0, 0.0).Color
  BLUE*  = (0.0, 0.0, 1.0).Color
