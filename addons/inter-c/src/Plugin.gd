tool
extends EditorPlugin

# todo: Build libraries on export
# todo: Standardize logging style to `ITC: <action>: <objects>`

const TEMP_DIR := "res://addons/inter-c/.temp"
const TCC_BINARY_FILE := TEMP_DIR + "/tcc-0.9.27-win64-bin.zip"
const TCC_BINARY_LINK := "http://download.savannah.gnu.org/releases/tinycc/tcc-0.9.27-win64-bin.zip"
const TCC_DIR := TEMP_DIR + "/tcc"


func _enter_tree() -> void:
  # todo: Should we do it automatically? User might want to use different compiler and have no need for tcc
  # Would be better to create popup window with suggestion to download the TCC for you, and do it only if user agrees
  # We could also just distribute TCC binary with this plugin directly, potentially
  _resolve_tcc()


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
      var builder = BinaryBuilder.new().init_default("Host")
      library.builder = builder
      root.add_child(library) # Triggers building on entering the scene
      root.remove_child(library)
      library.queue_free()
    file_name = dir.get_next()
  dir.list_dir_end()
  return true


func _resolve_tcc() -> void:
  ## Downloads TCC binary specifically for this project
  # todo: We might want to reuse downloaded compiler, for example, by putting it in non-project specific temporary folder
  # todo: Test whether TCC is already present in PATH
  # todo: Check whether present TCC is working
  # todo: Potential vulnerability as there's no checking done whether we're storing desired file, or somebody tempered with our packets along the way
  # todo: We could compile more recent fork of TCC using this, or find a mirror that hosts those
  var dir := Directory.new()
  if dir.dir_exists(TCC_DIR):
    # todo: That's a dubious way to test resolution, we need to test whether binary working, and it's indeed a compiler
    print_debug("ITC: Using cached tcc distribution")
    return
  print_debug("ITC: Downloading tcc distribution via internet")
  if dir.make_dir_recursive(TEMP_DIR) != OK:
    push_error("ITC: Cannot create folder for saving tcc distribution at " + TEMP_DIR)
  var request_node = preload("res://addons/inter-c/src/RequestNode.gd").new()
  var root := get_tree().get_root() as Node
  root.call_deferred("add_child", request_node)
  yield(get_tree(), "idle_frame")
  var err = request_node.request_file(TCC_BINARY_LINK, TCC_BINARY_FILE)
  if err != OK:
    root.remove_child(request_node)
    request_node.queue_free()
    push_error("ITC: Error on making HTTP request: Code " + String(err))
  yield(request_node, "finished")
  root.remove_child(request_node)
  request_node.queue_free()
  # todo: One problem is that `yield` will return control to caller immediately, without awaiting
  _unzip_contents(TCC_BINARY_FILE, TEMP_DIR)
  print_debug("ITC: Done unzipping")


static func _unzip_contents(file_path: String, dest_dir: String) -> void:
  # Currently uses gdunzip.gd: https://github.com/jellehermsen/gdunzip
  # It's rather slow, but provides a portable way of doing so
  # Once Zip api exposure to GDScript is finally merged, we could get rid of it: https://github.com/godotengine/godot/pull/34444
  print_debug("ITC: Unzipping tcc distribution")
  var gdunzip = load("res://addons/inter-c/src/extern/gdunzip.gd").new()
  var archive = gdunzip.load(file_path)
  if not archive:
    push_error("ITC: Cannot open %s for unzipping" % file_path)
    return
  var file := File.new()
  var dir := Directory.new()
  for file_meta in gdunzip.files.values():
    if file_meta["uncompressed_size"] == 0:
      # Directories could be distinguished this way
      continue
    var data = gdunzip.uncompress(file_meta["file_name"])
    if not data:
      push_error("ITC: Error on uncompressing: " + file_meta["file_name"])
      continue
    var path := (dest_dir + "/" + file_meta["file_name"]) as String
    var dir_path := path.get_base_dir()
    if dir.make_dir_recursive(dir_path) != OK:
      push_error("ITC: Cannot create folder for unzipping tcc distribution: " + dir_path)
    file.open(path, File.WRITE)
    file.store_buffer(data)
    file.close()
    print_debug("ITC: Unzipped: " + file_meta["file_name"])
