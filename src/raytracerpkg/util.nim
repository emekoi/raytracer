#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

template lerp*[T](a, b, p: T): untyped =
  ((T(1.0) - p) * a + p * b)
