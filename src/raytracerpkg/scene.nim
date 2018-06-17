#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import shape

type Scene*[T: Shape] = object
  objects: seq[T]

iterator items*[T: Shape](s: Scene[T]): T =
  for o in s.objects: yield o

proc newScene*[T: Shape](): Scene[T] =
  result.objects = @[]

proc count*(s: Scene): int =
  s.objects.len

proc add*(s: Scene, shape: Shape) =
  s.objects.add shape
