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

  HitRecord* = object
    normal*: Vec3
    point*: Vec3
    t*: float

  Sphere* = ref object of Hitable
    radius*: float

proc newSphere*(origin: Vec3, color: Color, radius: float): Sphere =
  new result
  result.origin = origin
  result.color = color
  result.radius = radius

method hit*(self: Hitable, ray: Ray, interval: Slice[float]): Option[HitRecord] {.base, gcsafe.} =
  raise newException(Exception, "implement hit")

method surfaceNormal*(self: Hitable, point: Vec3): Vec3 {.base, gcsafe.} =
  raise newException(Exception, "implement normal")

method hit*(self: Sphere, ray: Ray, interval: Slice[float]): Option[HitRecord] =
  let
    oc = ray.origin - self.origin
    a = ray.direction ^ ray.direction
    b = oc ^ ray.direction
    c = (oc ^ oc) - (self.radius ^ 2)
    discriminant = (b ^ 2) - a * c
  if discriminant > 0:
    var
      tmp = (-b - ((b ^ 2) - a * c).sqrt()) / a
      hit = HitRecord()
    if tmp in interval:
      hit.point = ray.pointAt(tmp)
      hit.normal = self.surfaceNormal(hit.point)
      hit.t = tmp
    tmp = (-b + ((b ^ 2) - a * c).sqrt()) / a
    if tmp in interval:
      hit.point = ray.pointAt(tmp)
      hit.normal = self.surfaceNormal(hit.point)
      hit.t = tmp
    return some(hit)
  none(HitRecord)

method surfaceNormal*(self: Sphere, point: Vec3): Vec3 =
  (point - self.origin) / self.radius