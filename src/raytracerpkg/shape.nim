#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import math, vec3, ray

type
  Shape* = concept S
    S.center is Vec3
    S.intersect(Ray, var float) is bool

  Sphere* = tuple
    center: Vec3
    radius: float

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
