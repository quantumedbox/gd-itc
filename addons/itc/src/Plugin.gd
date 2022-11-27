tool
extends EditorPlugin

# todo: Build libraries on export
# todo: Standardize logging style to `ITC: <action>: <objects>`

const TEMP_DIR := "res://addons/itc/.temp/"


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


func load_lock_file() -> Dictionary:
  ## Load lock file that specifies dependencies for previously built target
  ## It's purpose is tracking when rebuilding is necessary
  var lock_file = ItcUtils.read_file(TEMP_DIR + "lock.json")
  if lock_file.empty():
    return {}
  var json = JSON.parse(lock_file)
  if json.error != OK:
    return {}
  assert(typeof(json.result) == TYPE_DICTIONARY)
  return json.result


func needs_building(lock: Dictionary, library: NativeLibrary) -> bool:
  if not library.title in lock:
    return true
  if lock[library.title]["script_path"] != library.script_path:
    return true
  var mod_time = ItcUtils.get_file_modification_time(library.script_path)
  if mod_time == -1:
    return true
  if int(lock[library.title]["script_modification_time"]) < mod_time:
    return true
  return false


func update_lock(lock: Dictionary, library: NativeLibrary) -> void:
  var mod_time = ItcUtils.get_file_modification_time(library.script_path)
  if mod_time == -1:
    push_error("ITC: Cannot get modification time for file: " + library.script_path)
    return
  lock[library.title] = {
    "script_path": library.script_path,
    "script_modification_time": String(mod_time)
  }


func save_lock(lock: Dictionary) -> void:
  if not ItcUtils.save_to_file(TEMP_DIR + "lock.json", JSON.print(lock)):
    push_error("ITC: Couldn't save lock, next rebuilding cannot be skipped")


# todo: Prevent building libraries with the same title
func build() -> bool:
  var root := get_tree().get_root() as Node
  var lock := load_lock_file()
  var shadows := PoolStringArray()
  for library_path in find_library_scripts("res://"):
    var library = load(library_path).new() as NativeLibrary
    if shadows.find(library.title) != -1:
      push_error("ITC: Duplicate library by the same name, which is forbidden")
      return false
    library.script_path = library_path
    library.directory = library_path.get_base_dir()
    library.identity()
    if library.title.empty():
      push_error("ITC: Library must have title, define 'identity' function with assignment to 'title': " + library_path)
      return false
    if needs_building(lock, library):
      library.builder = BinaryBuilder.new().init_default("Host")
      root.add_child(library) # Triggers building on entering the scene
      root.remove_child(library)
      update_lock(lock, library)
      library.queue_free()
    else:
      print("ITC: Skipping up-to-date: " + library.title)
    shadows.append(library.title)
  save_lock(lock)
  return true
