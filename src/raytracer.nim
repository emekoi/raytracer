#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import streams, random

import raytracerpkg/[
  vec3, ray, scene, shape, color
]

const
  WIDTH = 500
  HEIGHT = 500

proc main(filename: string) =
  # create a new scene
  var scene = newScene[Sphere](WIDTH, HEIGHT)

  scene.add ((WIDTH / 2, HEIGHT / 2, 50.0), 50.0, WHITE).Sphere

  # for each pixel
  for y in 0..<HEIGHT:
    for x in 0..<WIDTH:
      let x = float(x)
      let y = float(y)

      # send a ray though each pixel
      let ray = ((x, y, 0.0).Vec3, (0.0, 0.0, 1.0).Vec3).Ray

      var t = 20_000.0

      # check for intersections
      for o in scene:
        if o.intersect(ray, t):
          # color the pixel
          scene.setPixel(x.int, y.int, o.color)

  # render the scene out
  let output = open(filename, fmWrite).newFileStream()
  scene.render(output)

# run the raytracer
main("bin/out.ppm")
