#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import streams, random

import raytracerpkg/[
  vec3, ray, app, scene,
  shape, color, light, buffer
]

const
  WIDTH = 500
  HEIGHT = 500
  conf = (
    "raytracer",
    WIDTH, HEIGHT,
    30.0
  )

# create a new scene
var mainScene = newScene[Sphere](WIDTH, HEIGHT)
mainScene.add ((WIDTH / 2, HEIGHT / 2, 50.0), 50.0, BLUE).Sphere
mainScene.add ((WIDTH / 2, 0.0, 50.0), WHITE).Light

let mainApp = conf.init()

proc update() =
  discard mainApp.poll()

proc draw(buf: Buffer) =
  for y in 0..<HEIGHT:
    for x in 0..<WIDTH:
      let x = float(x)
      let y = float(y)

      # send a ray though each pixel
      let ray = ((x, y, 0.0).Vec3, (0.0, 0.0, 1.0).Vec3).Ray
      var t = 20_000.0

      # check for intersections
      for o in mainScene.objects:
        if o.intersect(ray, t):
          # point of intersection
          let point = ray.origin + ray.direction * t

          # color the pixel
          buf.setPixel(x.int, y.int, o.color)

          # apply lighting
          # for l in mainScene.lights:
          #   let
          #     light = l.position - point
          #     normal = o.normal(point)
          #     dt = light.norm() ^ normal.norm()
          #     pixel = buf.getPixel(x.int, y.int)
          #
          #   buf.setPixel(x.int, y.int, pixel * (l.color * dt))

# run the raytracer
mainApp.run(update, draw)
