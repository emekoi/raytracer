#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import math, options
import vec3, ray, color

type
  Shape* = ref object of RootObj
    origin*: Vec3
    color*: Color

  Intersection* = object
    distance*: float
    shape*: Shape

  Sphere* = ref object of Shape
    radius: float
  
  Plane* = ref object of Shape
    normal: Vec3

proc newSphere*(origin: Vec3, color: Color, radius: float): Sphere =
  new result
  result.origin = origin
  result.color = color
  result.radius = radius
  
proc newPlane*(origin: Vec3, color: Color, normal: Vec3): Plane =
  new result
  result.origin = origin
  result.color = color
  result.normal = normal

method intersect*(self: Shape, ray: Ray): Option[float] {.base.} =
  raise newException(Exception, "implement intersect")

method normal*(self: Shape, point: Vec3): Vec3 {.base.} =
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

# method normal*(self: Sphere, point: Vec3): Vec3 =
#   (point - self.origin) / self.radius

method intersect*(self: Plane, ray: Ray): Option[float] =
  let denom = self.normal ^ ray.direction
  # echo denom
  if denom > 1e-6:
    let
      v = self.origin - ray.origin
      dist = (v ^ self.normal) / denom
    echo (v ^ self.normal)
    if dist >= 0.0:
      if dist != 0.0:
        echo "zero"
      return some(dist)
  none(float)
