#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#


import streams, math, options, future
import nimPNG
import shape, light, ray, vec3, color

type Scene* = object
  objects*: seq[Shape]
  lights*: seq[Light]
  width, height: int
  pixels: seq[Color]
  fov: float

proc newScene*(width, height: int, fov: float=90.0): Scene =
  result.pixels = newSeq[Color](width * height)
  result.objects = @[]
  result.lights = @[]
  result.width = width
  result.height = height
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
    obj.intersect(ray).map proc(d: float) =
      intersections.add Intersection(distance: d, shape: obj)

  if intersections.len >= 1:
    var least = intersections[0]
    for i in intersections:
      if i.distance < least.distance:
        least = i
        
    return some(least)

  none(Intersection)

proc render*(self: var Scene, output: string) =
  # send a ray though each pixel

  for y in 0 ..< self.height:
    for x in 0 ..< self.width:    
      let
        ray = prime(x, y, self.width, self.height, self.fov)
        intersection = self.trace(ray)
      
      if intersection.isSome():
        let
          intersection = intersection.get()
          hitPoint = ray.origin + (ray.direction * intersection.distance)
          surfaceNormal = intersection.shape.surfaceNormal(hitPoint)
        for light in self.lights:
          let
            directionToLight = -light.direction
            lightPower = (surfaceNormal ^ directionToLight) * light.intensity
            lightReflected = intersection.shape.albedo / PI
            color = intersection.shape.color * light.color * lightPower * lightReflected
          
          self.setPixel(x, y, color)



        # self.setPixel(x, y, i.shape.color)
      
      # for obj in self.objects:
        # let i = obj

          # color the pixel
          # self.setPixel(x.int, y.int, obj.color)

          # apply lighting
          # for l in self.lights.mitems:
          #   let
          #     light = l.position - point
          #     dt = light.norm() ^ o.normal(point).norm()
          #   self.setPixel( x.int, y.int, l.color * dt)

  # write to disk

  var buf = newStringOfCap(self.pixels.len * 3)
  for idx in 0 ..< self.pixels.len:
    buf.add $$self.pixels[idx]
  
  if not savePNG24(output, buf, self.width, self.height):
    echo "unable to write to " & output