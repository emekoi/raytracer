#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import tables, json, streams
include prelude

proc setParallel(self: var Scene, node: JsonNode)
proc setSampleCount(self: var Scene, node: JsonNode)
proc getObjects(self: var Scene, node: JsonNode)
proc getSphere(self: var Scene, node: JsonNode)

proc getVec3(node: JsonNode): Vec3 =
  result.x = node[0].getFloat()
  result.y = node[1].getFloat()
  result.z = node[2].getFloat()

proc setParallel(self: var Scene, node: JsonNode) =
  self.parallel = node.getBool()

proc setSampleCount(self: var Scene, node: JsonNode) =
  self.sampleCount = node.getInt()

proc getObjects(self: var Scene, node: JsonNode) =
  for kind, obj in node:
    case kind:
      of "sphere":
        self.getSphere(obj)
      else:
        discard

proc getSphere(self: var Scene, node: JsonNode) =
  for sphere in node:
    var shape = Sphere()
    shape.origin = sphere["origin"].getVec3()
    shape.color = sphere["color"].getVec3()
    shape.radius = sphere["radius"].getFloat()
    self.add shape

const PARSER = {
  "parallel": setParallel,
  "sampleCount": setSampleCount,
  "objects": getObjects,
}.toTable()

proc loadScene*(filename: string): Scene =
  let
    file = filename.parseFile()
    width = file["width"].getInt()
    height = file["height"].getInt()
    output = file["output"].getStr()
  result = newScene(width, height, output)
  for key, value in file:
    if PARSER.hasKey(key):
      PARSER[key](result, value)
  

