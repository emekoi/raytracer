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
    oc = ray.origin - self.origin
    a = ray.direction ^ ray.direction
    b = 2.0 * (oc ^ ray.direction)
    c = (oc ^ oc) - (self.radius ^ 2)
    discriminant = (b ^ 2) - 4 * a * c
  if discriminant < 0:
    some(-1.0)
  else:
    some((-b - discriminant.sqrt()) / (2.0 * a))

method surfaceNormal*(self: Sphere, point: Vec3): Vec3 =
  (point - self.origin).norm()