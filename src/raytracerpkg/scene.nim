#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

{.experimental.}

import streams, math, options, random, threadpool
import stb_image/[write, read], stopwatch, chronicles
import hitable, ray, vec3, color, util, camera

const
  RENDER_PARTITION_SIZE = 2  
  CONVERT_PARTITION_SIZE = RENDER_PARTITION_SIZE * 2
  HIT_INTERVAL = float.low() .. float.high()

type Scene* = object
  hitables*: seq[Hitable]
  width*, height*: int
  pixels*: seq[Color]
  camera*: Camera
  output*: string
  parallel*: bool
  sampleCount*: int

proc newScene*(width, height: int, output: string, parallel: bool=true, sampleCount: int=100): Scene =
  result.pixels = newSeq[Color](width * height)
  result.hitables = @[]
  result.width = width
  result.height = height
  result.output = output
  result.parallel = parallel
  result.sampleCount = sampleCount
  result.camera = newCamera()

proc count*(self: Scene): int =
  self.hitables.len

proc add*(self: var Scene, hitable: Hitable) =
  self.hitables.add hitable

proc trace(self: Scene, ray: Ray, interval: Slice[float]): Option[HitRecord] =
  result = none(HitRecord)
  var interval = interval
  for hitable in self.hitables:
    let hit = hitable.hit(ray, interval)
    if hit.isSome():
      interval.b = hit.unsafeGet().t
      result = hit

proc getColor(self: Scene, ray: Ray): Color =
  let hit = self.trace(ray, HIT_INTERVAL)
  if hit.isSome():
    return (hit.unsafeGet().normal + 1) * 0.5
  let
    unit_direction = ray.direction.norm()
    t = 0.5 * (unit_direction.y + 1.0)
  (((1.0, 1.0, 1.0) * (1.0 - t)) + ((0.5, 0.7, 1.0) * t)).clamp()

proc renderPartition(self: var Scene, sx, sy: Slice[int]) =
  let
    lower_left_corner = (-2.0, -1.0, -1.0)
    horizontal = (4.0, 0.0, 0.0)
    vertical = (0.0, 2.0, 0.0)
    origin = (0.0, 0.0, 0.0)
  for y in sy:
    for x in sx:
      # for s in sampleCount:
      let
        u = float(x) / float(self.width)
        v = float(y) / float(self.height)
        ray = (origin, lower_left_corner + horizontal * u + vertical * v)
      self.pixels[x + y * self.width] = self.getColor(ray)

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
        spawn renderPartition(self, px, py)

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
  