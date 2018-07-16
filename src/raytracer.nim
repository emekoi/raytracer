#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

include raytracerpkg/prelude
import raytracerpkg/parser

proc main(filenames: varargs[string]) =
  var scene: Scene
  for file in filenames:
    # load a scene from disk and render it
    scene = parser.loadScene(file)
    scene.render()
  
# run the raytracer
main("scenes/test0.json")