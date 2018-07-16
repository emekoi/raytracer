#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

{.experimental.}

import streams, math, options, threadpool
import nimPNG, shape, light, ray, vec3, color

const PARTITION_SIZE = 2

type Scene* = object
  objects*: seq[Shape]
  lights*: seq[Light]
  width*, height*: int
  pixels*: seq[Color]
  shadowBias*: float
  fov*: float
  output*: string
  parallel*: bool

proc newScene*(width, height: int, output: string, parallel: bool=false, fov: float=90.0, shadowBias: float=1e-3): Scene =
  result.pixels = newSeq[Color](width * height)
  result.objects = @[]
  result.lights = @[]
  result.width = width
  result.height = height
  result.output = output
  result.parallel = parallel
  result.shadowBias = shadowBias
  result.fov = fov
  
proc setPixel*(self: var Scene, x, y: int, color: Color) =
  if x > self.width or x < 0: return
  if y > self.height or y < 0: return
  self.pixels[x + y * self.width] = color

proc getPixel*(self: Scene, x, y: int): Color =
  if x > self.width or x < 0: return (0.0, 0.0, 0.0)
  if y > self.height or y < 0: return (0.0, 0.0, 0.0)
  return self.pixels[x + y * self.width]

proc count*(self: Scene): int =
  self.objects.len

proc add*(self: var Scene, shape: Shape) =
  self.objects.add shape

proc add*(self: var Scene, light: Light) =
  self.lights.add light

proc trace(self: Scene, ray: Ray): Option[Intersection] =
  var intersections: seq[Intersection] = @[]

  for obj in self.objects:
    when true:
      let distance = obj.intersect(ray)
      if distance.isSome():
        intersections.add Intersection(
          distance: distance.get(),
          shape: obj
        )
    else:
      # this gives a segfault
      obj.intersect(ray).map proc(d: float) =
        let i = Intersection(distance: d, shape: obj)
        intersections.add i

  if intersections.len >= 1:
    var least = intersections[0]
    for i in intersections:
      if i.distance < least.distance:
        least = i
    return some(least)
  none(Intersection)

proc getColor(self: var Scene, ray: Ray, intersection: Intersection): Color =
  let
    hitPoint = ray.origin + (ray.direction * intersection.distance)
    surfaceNormal = intersection.shape.surfaceNormal(hitPoint)
    lightReflected = intersection.shape.albedo / PI
  for light in self.lights:
    let
      directionToLight = -light.direction.norm()
      shadowRay = (hitPoint + (surfaceNormal * self.shadowBias),
        directionToLight).Ray
      inLight = self.trace(shadowRay).isNone()
      lightIntensity = if inLight: light.intensity else: 0.0
      lightPower = (surfaceNormal ^ directionToLight).max(0.0) * lightIntensity
    result += intersection.shape.color * light.color * lightPower * lightReflected

    if intersection.shape of Plane:
      # echo (surfaceNormal)
      discard
    else:
      # echo "hit sphrere: ", intersection.shape.albedo
      discard
  result.clamp()

proc writeToDisk(self: Scene) =
  var buf = newStringOfCap(self.pixels.len * 3)
  for idx in 0 ..< self.pixels.len:
    buf.add $$self.pixels[idx]

  if not savePNG24(self.output, buf, self.width, self.height):
    echo "unable to write to " & self.output

proc renderPartition(self: ptr Scene, sx, sy: Slice[int]) =
  for y in sy:
    for x in sx:
      let
        ray = prime(x, y, self.width, self.height, self.fov)
        intersection = self.trace(ray)
      
      if intersection.isSome():
        let
          i = intersection.get()
          color = self.getColor(ray, i)
        
        self.setPixel(x, y, color)

proc renderParallel*(self: var Scene) =
  # send a ray though each pixel in parallel
  let
    stepX = self.width div PARTITION_SIZE
    stepY = self.height div PARTITION_SIZE
  # parallel:
  for y in 0..<PARTITION_SIZE:
    for x in 0..<PARTITION_SIZE:
      let
        px = (x * stepX)..<(stepX * (x + 1)).min(self.width)
        py = (y * stepY)..<(stepY * (y + 1)).min(self.height)
      spawn renderPartition(self.addr, px, py)

proc renderNormal*(self: var Scene) =
  # send a ray though each pixel
  for y in 0 ..< self.height:
    for x in 0 ..< self.width:    
      let
        ray = prime(x, y, self.width, self.height, self.fov)
        intersection = self.trace(ray)
      
      if intersection.isSome():
        let
          i = intersection.get()
          color = self.getColor(ray, i)
        
        self.setPixel(x, y, color)

proc render*(self: var Scene) =
  if not self.parallel:
    self.renderNormal()
  else:
    self.renderParallel()
  self.writeToDisk()