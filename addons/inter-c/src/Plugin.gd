tool
extends EditorPlugin

# todo: Build libraries on export
# todo: Standardize logging style to `ITC: <action>: <objects>`


func _enter_tree() -> void:
  pass


func _exit_tree() -> void:
  pass


func build() -> bool:
  var dir := Directory.new()
  if dir.open("res://addons/inter-c/libraries") != OK:
    push_error("Cannot open inter-c libraries folder")
    return false
  dir.list_dir_begin()
  var file_name = dir.get_next()
  var root := get_tree().get_root() as Node
  while not file_name.empty():
    if not dir.current_is_dir() and file_name.ends_with(".gd"):
      var library = load("res://addons/inter-c/libraries/" + file_name).new() as NativeLibrary
      if library == null:
        push_error("Invalid library script {}, it should extend NativeLibrary" % file_name)
        dir.dir_list_end()
        return false
      root.add_child(library) # Triggers building on entering the scene
    file_name = dir.get_next()
  dir.list_dir_end()
  return true
