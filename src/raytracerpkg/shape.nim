#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import math, vec3, ray, color

type
  Shape* = concept S
    S.center is Vec3
    S.color is Color
    S.intersect(Ray, var float) is bool
    S.normal(Vec3) is Vec3

  Sphere* = tuple
    center: Vec3
    radius: float
    color: Color

proc intersect*(s: Sphere, r: Ray, t: var float): bool =
  let
    oc = r.origin - s.center
    b = 2 * (oc ^ r.direction)
    c = (oc ^ oc) - (s.radius ^ 2)
    disc = b * b - 4 * c;
  if disc < 0:
    return false
  else:
    let
      disc = disc.sqrt()
      t0 = -b - disc
      t1 = -b + disc
    t = t0.min(t1)
    return true

proc normal*(s: Sphere, point: Vec3): Vec3 =
  (s.center - point) / s.radius
