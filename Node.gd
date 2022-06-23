extends Node

const FIBBER_SCRIPT := preload("res://bin/libexample.gdns")


func _init() -> void:
  assert(FIBBER_SCRIPT != null)
  var fibber = FIBBER_SCRIPT.new()
  assert(fibber != null)
  print(fibber.calculate(10))
