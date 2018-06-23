#  Copyright (c) 2018 emekoi
#
#  This library is free software; you can redistribute it and/or modify it
#  under the terms of the MIT license. See LICENSE for details.
#

import sdl2/sdl, buffer, color

type
  EventType* = enum
    NONE
    QUIT
    RESIZE
    KEYDOWN
    KEYUP
    TEXTINPUT
    MOUSEMOVE
    MOUSEBUTTONDOWN
    MOUSEBUTTONUP

  Event* = object
    case id*: EventType
    of QUIT, NONE: discard
    of RESIZE: width*, height*: int
    of KEYDOWN, KEYUP: key*: string
    of TEXTINPUT: text*: string
    of MOUSEMOVE: x*, y*: int
    of MOUSEBUTTONDOWN, MOUSEBUTTONUP: press*: tuple[button: string, x, y: int]

  Config* = tuple
    title: string
    width, height: int
    max_fps: float

  App* = ref object
    window*: sdl.Window
    screen*: sdl.Surface
    canvas*: Buffer
    config*: Config
    close*: bool
    canvas_size: int

converter buttonStr(id: int): string =
  case id
  of sdl.BUTTON_LEFT: "left"
  of sdl.BUTTON_MIDDLE: "middle"
  of sdl.BUTTON_RIGHT: "right"
  of sdl.BUTTON_X1: "wheelup"
  of sdl.BUTTON_X2: "wheeldown"
  else: "?"


proc poll*(app: App): seq[Event] =
  result = @[]
  var e: sdl.Event
  while sdl.pollEvent(addr(e)) != 0:
    var event: Event
    event.id = NONE
    case e.kind
    of sdl.QUIT:
      event.id = QUIT
      app.close = true
    of sdl.WINDOWEVENT:
      if e.window.event == sdl.WINDOWEVENT_RESIZED:
        event = Event(id: RESIZE, width: e.window.data1, height: e.window.data2)
    of sdl.KEYDOWN:
        event = Event(id: KEYDOWN, key: $sdl.getKeyName(e.key.keysym.sym))
    of sdl.KEYUP:
        event = Event(id: KEYUP, key: $sdl.getKeyName(e.key.keysym.sym))
    of sdl.TEXTINPUT:
      event = Event(id: TEXTINPUT, text: $e.text.text)
    of sdl.MOUSEMOTION:
        event = Event(id: MOUSEMOVE, x: e.motion.x, y: e.motion.y)
    of sdl.MOUSEBUTTONDOWN:
        event = Event(id: MOUSEBUTTONDOWN, press: (buttonStr(e.button.button), e.button.x.int, e.button.y.int))
    of sdl.MOUSEBUTTONUP:
        event = Event(id: MOUSEBUTTONUP, press: (buttonStr(e.button.button), e.button.x.int, e.button.y.int))
    else: discard

    if event.id != NONE:
      result.add(event)

proc init*(conf: Config): App =
  new result
  if sdl.init(sdl.InitVideo) != 0:
    quit "ERROR: can't initialize SDL: " & $sdl.getError()
  # Create window
  result.window = sdl.createWindow(
    conf.title,
    sdl.WindowPosUndefined,
    sdl.WindowPosUndefined,
    conf.width, conf.height, 0)
  if result.window == nil:
    quit "ERROR: can't create window: " & $sdl.getError()
  sdl.logInfo sdl.LogCategoryApplication, "SDL initialized successfully"
  result.screen = result.window.getWindowSurface
  result.canvas = newBuffer(conf.width, conf.height)
  result.canvas_size = conf.width * conf.height * sizeof(color.Color)
  result.close = false
  result.config = conf


proc exit*(app: App) =
  app.close = true

proc draw(app: App, drawProc: proc(canvas: Buffer)) =
  drawProc(app.canvas)
  if app.screen != nil and app.screen.mustLock():
    if app.screen.lockSurface() != 0:
      quit "ERROR: couldn't lock screen: " & $sdl.getError()
  copyMem(app.screen.pixels, app.canvas.pixels[0].addr, app.canvas_size)
  if app.screen.mustLock(): app.screen.unlockSurface()
  if app.window.updateWindowSurface() != 0:
    quit "ERROR: couldn't update screen: " & $sdl.getError()

proc run*(app: App, updateProc: proc(), drawProc: proc(canvas: Buffer)) =
  var last = 0.0
  while not app.close:
    updateProc()
    app.canvas.clear(color(0x00'u8, 0x00'u8, 0x00'u8, 0xff'u8))
    app.draw(drawProc)
    let step = 1.0 / app.config.max_fps
    let now = sdl.getTicks().float / 1000.0
    let wait = step - (now - last);
    last += step
    if wait > 0:
      sdl.delay((wait * 1000.0).uint32)
    else:
      last = now

  app.window.destroyWindow()
  sdl.quit()
  sdl.logInfo sdl.LogCategoryApplication, "SDL shutdown completed"
