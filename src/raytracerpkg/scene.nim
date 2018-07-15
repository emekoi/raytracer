#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#


import streams, math, options, future
when defined(PARALLEL):
  import threadpool
  {.experimental.}
import nimPNG
import shape, light, ray, vec3, color

type Scene* = object
  objects*: seq[Shape]
  lights*: seq[Light]
  width, height: int
  pixels: seq[Color]
  shadowBias: float
  fov: float

proc newScene*(width, height: int, fov: float=90.0, shadowBias: float=1e-3): Scene =
  result.pixels = newSeq[Color](width * height)
  result.objects = @[]
  result.lights = @[]
  result.width = width
  result.height = height
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
    obj.intersect(ray).map (d: float) =>
      intersections.add Intersection(distance: d, shape: obj)

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

proc writeToDisk(self: Scene, output: string) =
  var buf = newStringOfCap(self.pixels.len * 3)
  for idx in 0 ..< self.pixels.len:
    buf.add $$self.pixels[idx]
  
  if not savePNG24(output, buf, self.width, self.height):
    echo "unable to write to " & output

when defined(PARALLEL):
  proc renderPoint(self: ptr Scene, x, y: int) =
    let
      ray = prime(x, y, self.width, self.height, self.fov)
      intersection = self.trace(ray)
    
    if intersection.isSome():
      let
        i = intersection.get()
        color = self.getColor(ray, i)
      
      self.setPixel(x, y, color)
  
  proc render*(self: var Scene, output: string) =
    # send a ray though each pixel in parallel
    parallel:
      for y in 0 ..< self.height:
        for x in 0 ..< self.width:
          spawn renderPoint(self.addr, x, y)
    
    self.writeToDisk output
else:
  proc render*(self: var Scene, output: string) =
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

    self.writeToDisk output

    