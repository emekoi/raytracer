#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import streams, shape, color

type Scene*[T: Shape] = object
  objects: seq[T]
  frame: seq[Color]
  width, height: int

iterator items*[T: Shape](s: Scene[T]): T =
  for o in s.objects: yield o

proc newScene*[T: Shape](width, height: int): Scene[T] =
  result.objects = @[]
  result.width = width
  result.height = height
  result.frame = newSeq[Color](width * height)

proc count*(s: Scene): int =
  s.objects.len

proc add*(s: var Scene, shape: Shape) =
  s.objects.add shape

proc render*(s: Scene, output: Stream) =
  # write the header for the ppm file
  output.writeLine "P3"
  output.writeLine $s.width
  output.writeLine $s.height
  output.writeLine "255"
  for p in s.frame:
    output.writeLn p
  output.flush

proc setPixel*(s: var Scene, x, y: int, color: Color) =
  if x > s.width or x < 0: return
  if y > s.height or y < 0: return
  s.frame[x + y * s.width] = color

proc getPixel*(s: Scene, x, y: int): Color =
  if x > s.width or x < 0: return (0'u8, 0'u8, 0'u8)
  if y > s.height or y < 0: return (0'u8, 0'u8, 0'u8)
  return s.frame[x + y * s.width]
