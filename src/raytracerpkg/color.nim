#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

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

proc clamp[T](x: T, interval: Slice[T]): T =
  x.clamp interval.a, interval.b

proc clamp*(self: Color, interval: Slice[float]=0.0 .. 1.0): Color =
  result.x = self.x.clamp interval
  result.y = self.y.clamp interval
  result.z = self.z.clamp interval

proc clamp*(self: var Color, interval: Slice[float]=0.0 .. 1.0)=
  self.x = self.x.clamp interval
  self.y = self.y.clamp interval
  self.z = self.z.clamp interval

const
  WHITE* = (1.0, 1.0, 1.0).Color
  BLACK* = (0.0, 0.0, 0.0).Color
  RED*   = (1.0, 0.0, 0.0).Color
  GREEN* = (0.0, 1.0, 0.0).Color
  BLUE*  = (0.0, 0.0, 1.0).Color
