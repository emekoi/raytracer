#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import tables, json, streams
include prelude

proc setParallel(self: var Scene, node: JsonNode)
proc setShadowBias(self: var Scene, node: JsonNode)
proc setFov(self: var Scene, node: JsonNode)
proc getObjects(self: var Scene, node: JsonNode)
proc getSphere(self: var Scene, node: JsonNode)
proc getPlane(self: var Scene, node: JsonNode)
proc getLights(self: var Scene, node: JsonNode)
proc getDirectionalLight(self: var Scene, node: JsonNode)

proc getVec3(node: JsonNode): Vec3 =
  result.x = node[0].getFloat()
  result.y = node[1].getFloat()
  result.z = node[2].getFloat()

proc setParallel(self: var Scene, node: JsonNode) =
  self.parallel = node.getBool()

proc setShadowBias(self: var Scene, node: JsonNode) =
  self.shadowBias = node.getFloat()

proc setFov(self: var Scene, node: JsonNode) =
  self.fov = node.getFloat()

proc getObjects(self: var Scene, node: JsonNode) =
  for kind, obj in node:
    case kind:
      of "sphere":
        self.getSphere(obj)
      of "plane":
        self.getPlane(obj)
      else:
        discard

proc getSphere(self: var Scene, node: JsonNode) =
  for sphere in node:
    var shape = Sphere()
    shape.origin = sphere["origin"].getVec3()
    shape.color = sphere["color"].getVec3()
    shape.albedo = sphere["albedo"].getFloat()
    shape.radius = sphere["radius"].getFloat()
    self.add shape

proc getPlane(self: var Scene, node: JsonNode) =
  for plane in node:
    var shape = Plane()
    shape.origin = plane["origin"].getVec3()
    shape.color = plane["color"].getVec3()
    shape.albedo = plane["albedo"].getFloat()
    shape.normal = plane["normal"].getVec3()
    self.add shape

proc getLights(self: var Scene, node: JsonNode) =
  for kind, obj in node:
    case kind:
      of "directional":
        self.getDirectionalLight(obj)
      else:
        discard

proc getDirectionalLight(self: var Scene, node: JsonNode) =
  for directionalLight in node:
    var light = Light()
    light.direction = directionalLight["direction"].getVec3()
    light.color = directionalLight["color"].getVec3()
    light.intensity = directionalLight["intensity"].getFloat()
    self.add light

const PARSER = {
  "parallel": setParallel,
  "shadowBias": setShadowBias,
  "fov": setFov,
  "objects": getObjects,
  "lights": getLights,
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
  

