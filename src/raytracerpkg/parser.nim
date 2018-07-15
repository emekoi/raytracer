#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import tables, json, streams
include prelude

const PARSER_PROC = {
  "width": proc(self: var Scene, node: JsonNode) =
    self.width = node.getInt(),
  "height": proc(self: var Scene, node: JsonNode) =
    self.height = node.getInt(),
  "shadowBias": proc(self: var Scene, node: JsonNode) =
    self.shadowBias = node.getFloat(),
  "fov":  proc(self: var Scene, node: JsonNode) =
    self.fov = node.getFloat(),
  "objects": proc(self: var Scene, node: JsonNode) =
    for obj in node:
      echo obj.str
}.toTable()

proc testData*() =
  var scene = newScene(800, 600)
  scene.add newPlane((0.0, -10.0, 1.0), (0.678, 0.847, 0.901), 0.18, (0.0, 0.0, -1.0))
  scene.add newSphere((0.0, 0.0, -3.0), RED, 0.18, 1.0)
  scene.add newSphere((1.0, 0.5, -2.0), GREEN, 0.18, 1.0)
  scene.add newSphere((-1.0, -0.5, -4.0), BLUE, 0.18, 1.0)
  scene.add newLight((0.0, 0.0, -1.0), WHITE, 10.0)
  scene.pixels = nil
  let file = open("bin/test.json", fmWrite).newFileStream()
  # file.write $$scene
  file.close

proc loadScene*(filename: string): Scene =
  let node = filename.parseFile()
  echo node["width"]

