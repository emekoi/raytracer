#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import streams, random, math, suffer

import raytracerpkg/[
  vec3, ray, app, scene,
  shape, pixel, light
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
mainScene.add ((WIDTH / 2, HEIGHT / 2, 50.0), 50.0, RED).Sphere
mainScene.add ((WIDTH / 2, 0.0, 50.0), WHITE).Light
# mainScene.add ((WIDTH / 2, (HEIGHT / 2) + 50.0, 50.0), WHITE).Light

let mainApp = conf.init()

proc update() =
  discard mainApp.poll()

proc draw(buf: Buffer) =
  buf.setBlend(BlendMode.BLEND_MULTIPLY)

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
          buf.setPixel(o.color, x.int, y.int)

          # apply lighting
          for l in mainScene.lights.mitems:
            let
              light = l.position - point
              dt = light.norm() ^ o.normal(point).norm()
            buf.drawPixel(l.color * dt, x.int, y.int)


# run the raytracer
mainApp.run(update, draw)
