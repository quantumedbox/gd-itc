extends Node

const FIBBER_SCRIPT := preload("res://bin/libfibber/Fibber.gdns")

func calculate(nth: int) -> int:
  if nth <= 1:
    return nth
  return calculate(nth - 1) + calculate(nth - 2)

func _init() -> void:
  assert(FIBBER_SCRIPT != null)
  var fibber = FIBBER_SCRIPT.new()
  assert(fibber != null)
  assert(fibber.calculate(10) == 55)

  var start = OS.get_ticks_msec()
  var gd = calculate(25)
  var end = OS.get_ticks_msec()
  print("GDScript solution for fib 25 took: %sms" % [end - start])

  start = OS.get_ticks_msec()
  var c = fibber.calculate(25)
  end = OS.get_ticks_msec()
  print("C solution for fib 25 took: %sms" % [end - start])

  assert(gd == c)
