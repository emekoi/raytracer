#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import random

import raytracerpkg/[
  vec3, ray, scene, shape
]

const
  WIDTH = 500
  HEIGHT = 500

proc main() =
  # create a new scene
  var scene = newScene[Sphere]()

  # for each pixel
  for y in 0..<HEIGHT:
    for x in 0..<WIDTH:

      # send a ray though each pixel
      let ray = ((x, y, 0.0), (0.0, 0.0, 1.0))

      # check for intersections

main()
