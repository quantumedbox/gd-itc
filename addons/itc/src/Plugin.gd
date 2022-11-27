tool
extends EditorPlugin

# todo: Build libraries on export
# todo: Standardize logging style to `ITC: <action>: <objects>`

const TEMP_DIR := "res://addons/itc/.temp"


func find_library_scripts(cd: String) -> Array:
  if cd == "res://addons/itc/":
    return []
  var dir := Directory.new()
  if dir.open(cd) != OK:
    push_error("ITC: Cannot open directory: %s" % [cd])
    return []
  dir.list_dir_begin(true, true)
  var result := []
  var entry = dir.get_next()
  while not entry.empty():
    if dir.current_is_dir():
      result += find_library_scripts(cd + entry + "/")
    elif entry.ends_with(".gd"):
      # todo: This check is really, really crude, there might be better way to do it
      var script = ResourceLoader.load(cd + entry, "GDScript") as GDScript
      if script != null and script.can_instance() and script.new() is NativeLibrary:
        result.append(cd + entry)
    entry = dir.get_next()
  dir.list_dir_end()
  return result


func build() -> bool:
  var root := get_tree().get_root() as Node
  for library_path in find_library_scripts("res://"):
    print(library_path)
    var library = load(library_path).new() as NativeLibrary
    library.builder = BinaryBuilder.new().init_default("Host")
    root.add_child(library) # Triggers building on entering the scene
    root.remove_child(library)
    library.queue_free()
  return true
