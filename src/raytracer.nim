#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import os, chronicles
include raytracerpkg/prelude
import raytracerpkg/parser

proc main(filenames: openarray[string]) =
  var scene: Scene
  for file in filenames:
    # load a scene from disk and render it
    scene = parser.loadScene(file)
    let (elapsed, success) = scene.render()
    info "raytracing finished", scene = file, output = scene.output,
      parallel = scene.parallel, elapsed = elapsed
    if not success:
      warn "unable to write to file", scene = file, output = scene.output
  
# run the raytracer
# main(commandLineParams())

echo (2.0, 3.0, 4.0) % (5.0, 6.0, 7.0)