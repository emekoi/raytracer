#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import math, options
import vec3, ray, color

type
  Hitable* = ref object of RootObj
    origin*: Vec3
    color*: Color
    albedo*: float

  Intersection* = object
    distance*: float
    hitable*: Hitable

  Sphere* = ref object of Hitable
    radius*: float

proc newSphere*(origin: Vec3, color: Color, albedo: float, radius: float): Sphere =
  new result
  result.origin = origin
  result.color = color
  result.albedo = albedo
  result.radius = radius

method intersect*(self: Hitable, ray: Ray): Option[float] {.base, gcsafe.} =
  raise newException(Exception, "implement intersect")

method surfaceNormal*(self: Hitable, point: Vec3): Vec3 {.base, gcsafe.} =
  raise newException(Exception, "implement normal")

method intersect*(self: Sphere, ray: Ray): Option[float] =
  let
    l = self.origin - ray.origin
    adj = l ^ ray.direction
    d2 = (l ^ l) - (adj ^ 2)
    r2 = self.radius ^ 2
  
  if d2 > r2:
    return none(float)

  let
    thc = (r2 - d2).sqrt()
    t0 = adj - thc
    t1 = adj + thc
  
  if t0 < 0.0 and t1 < 0.0:
    return none(float)

  some(t0.min(t1))

method surfaceNormal*(self: Sphere, point: Vec3): Vec3 =
  (point - self.origin).norm()