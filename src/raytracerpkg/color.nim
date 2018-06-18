#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import strutils

type Color* = tuple
  r, g, b: uint8

const
  WHITE* = (0xff'u8, 0xff'u8, 0xff'u8).Color
  BLACK* = (0x00'u8, 0x00'u8, 0x00'u8).Color
  RED*   = (0xff'u8, 0x00'u8, 0x00'u8).Color
  GREEN* = (0x00'u8, 0xff'u8, 0x00'u8).Color
  BLUE*  = (0x00'u8, 0x00'u8, 0xff'u8).Color

proc `$`*(c: Color): string =
  return "$# $# $#" % [$c.r, $c.g, $c.b]
