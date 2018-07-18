#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

{.experimental.}

import streams, math, options, threadpool
import stb_image/[write, read], stopwatch, chronicles
import shape, light, ray, vec3, color

const
  RENDER_PARTITION_SIZE = 2  
  CONVERT_PARTITION_SIZE = RENDER_PARTITION_SIZE * 2

type Scene* = object
  objects*: seq[Shape]
  lights*: seq[Light]
  width*, height*: int
  pixels*: seq[Color]
  shadowBias*: float
  fov*: float
  output*: string
  parallel*: bool

proc newScene*(width, height: int, output: string, parallel: bool=true, fov: float=90.0, shadowBias: float=1e-3): Scene =
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
  result = none(Intersection)
  # let result_ptr = result.addr

  for obj in self.objects:
    when true:
      let distance = obj.intersect(ray)
      if distance.isSome():
        let distance = distance.get()
        if result.isNone() or distance < result.unsafeGet().distance:
          result = some(Intersection(
            distance: distance,
            shape: obj
          ))
    else:
      # this gives a segfault
      obj.intersect(ray).map proc(distance: float) =
        if result_ptr.isNone() or distance < result_ptr.unsafeGet().distance:
          result_ptr[] = some(Intersection(
            distance: distance,
            shape: obj
          ))

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

proc renderPartition(self: var Scene, sx, sy: Slice[int]) =
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
    stepX = block:
      let sx = self.width div RENDER_PARTITION_SIZE
      if sx == 0: self.width else: sx
    stepY = block:
      let sy = self.height div RENDER_PARTITION_SIZE
      if sy == 0: self.width else: sy
  parallel:
    for y in 0..<RENDER_PARTITION_SIZE:
      for x in 0..<RENDER_PARTITION_SIZE:
        let
          px = (x * stepX)..<(stepX * (x + 1)).min(self.width)
          py = (y * stepY)..<(stepY * (y + 1)).min(self.height)
        spawn renderPartition(self.addr, px, py)

template lerp[T](a, b, p: T): untyped =
  ((T(1) - p) * a + p * b)

proc convertPartition(self: Scene, pixels: var seq[byte], partition: Slice[int]) =
  for idx in partition:
    pixels[idx * 3 + 0] = lerp(0.0, 255.99, self.pixels[idx].x).uint8
    pixels[idx * 3 + 1] = lerp(0.0, 255.99, self.pixels[idx].y).uint8
    pixels[idx * 3 + 2] = lerp(0.0, 255.99, self.pixels[idx].z).uint8

proc convertParallel(self: Scene, pixels: var seq[byte]) =
  let
    size = self.pixels.len
    step = block:
      # we multiply by 2 so we use the same number
      # of thread we do when raycasting. or at least
      # thats what i think this will do.
      let s = size div CONVERT_PARTITION_SIZE
      if s == 0: size else: s
  parallel:
    for idx in 0..<CONVERT_PARTITION_SIZE:
      let partition = (idx * step)..<(step * (idx + 1)).min(size)
      spawn convertPartition(self, pixels, partition)

proc writeImage(self: Scene): bool =
  var pixels = newSeq[byte](self.pixels.len * 3)

  # convert to 0-255 rgb format
  if self.parallel:
    self.convertParallel(pixels)
  else:
    let s = 0 ..< self.pixels.len
    self.convertPartition(pixels, s)
    
  writePNG(self.output, self.width, self.height, RGB, pixels)

proc render*(self: var Scene): (float, bool) =
  var watch = stopwatch(false)

  watch.bench:
    if self.parallel: 
      self.renderParallel()
    else:
      let
        sx = 0 ..< self.width
        sy = 0 ..< self.height
      self.renderPartition(sx, sy)
  
  (watch.secs(), self.writeImage())
  