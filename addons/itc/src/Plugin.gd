tool
extends EditorPlugin

# todo: Build libraries on export
# todo: Standardize logging style to `ITC: <action>: <objects>`

const TEMP_DIR := "res://addons/itc/.temp"


func _enter_tree() -> void:
  pass


func _exit_tree() -> void:
  pass


func build() -> bool:
  var dir := Directory.new()
  if dir.open("res://addons/itc/libraries") != OK:
    push_error("ITC: Cannot open itc libraries folder")
    return false
  dir.list_dir_begin()
  var dir_name = dir.get_next()
  var root := get_tree().get_root() as Node
  var file = File.new()
  while not dir_name.empty():
    var module = "res://addons/itc/libraries/" + dir_name + "/Module.gd"
    if dir.current_is_dir() and file.file_exists(module):
      var library = load(module).new() as NativeLibrary
      if library == null:
        push_error("ITC: Invalid library script %s, it should extend NativeLibrary" % dir_name)
        dir.dir_list_end()
        return false
      var builder = BinaryBuilder.new().init_default("Host")
      library.builder = builder
      root.add_child(library) # Triggers building on entering the scene
      root.remove_child(library)
      library.queue_free()
    dir_name = dir.get_next()
  dir.list_dir_end()
  return true
