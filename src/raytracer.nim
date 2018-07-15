#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import streams, random, math

import raytracerpkg/[
  vec3, ray, scene,
  shape, color, light
]

const
  WIDTH = 800
  HEIGHT = 600

proc main(filename: string) =
  # create a new scene
  var scene = newScene(WIDTH, HEIGHT)
  scene.add newPlane((0.0, -10.0, 1.0), (0.678, 0.847, 0.901), 0.18, (0.0, 0.0, -1.0))
  # scene.add newPlane((0.0, 0.0, -10.0), (0.678, 0.3, 0.901), 0.18, (0.0, 0.0, -1.0))
  # scene.add newPlane((0.0, -1.0, -10.0), (0.901, 0.847, 0.678), 0.18, (0.0, -1.0, 0.0))
  # scene.add newPlane((0.0, 0.0, 0.0), (0.5, 0.5, 0.678), 0.18, (0.0, 0.0, 1.0))
  

  scene.add newSphere((0.0, 0.0, -3.0), RED, 0.18, 1.0)
  scene.add newSphere((1.0, 0.5, -2.0), GREEN, 0.18, 1.0)
  scene.add newSphere((-1.0, -0.5, -4.0), BLUE, 0.18, 1.0)
  
  scene.add newLight((0.0, 0.0, -1.0), WHITE, 10.0)

  # render the scene to disk
  scene.render(filename)

# run the raytracer
main("bin/out.png")