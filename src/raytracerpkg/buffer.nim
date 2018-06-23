#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import color, sequtils

type Buffer* = ref object
  width*, height*: int
  pixels*: seq[Color]

proc newBuffer*(width, height: int): Buffer =
  new result
  result.pixels = newSeq[Color](width * height)
  result.width = width
  result.height = height

proc clear*(buf: Buffer, c: Color) =
  for pixel in mitems(buf.pixels): pixel = c

proc setPixel*(buf: Buffer, x, y: int, c: Color) =
  if x > buf.width or x < 0: return
  if y > buf.height or y < 0: return
  buf.pixels[x + y * buf.width] = c

proc getPixel*(buf: Buffer, x, y: int): Color =
  if x > buf.width or x < 0: return color(0x0'u8, 0x0'u8, 0x0'u8, 0xff'u8)
  if y > buf.height or y < 0: return color(0x0'u8, 0x0'u8, 0x0'u8, 0xff'u8)
  return buf.pixels[x + y * buf.width]
