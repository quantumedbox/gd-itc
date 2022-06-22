tool
extends Node
class_name BinaryBuilder

# todo: Distinguish between x86 and x64
# todo: Provide SHA of the TCC zip as we know it in advance

const TEMP_DIR := "res://addons/inter-c/.temp"
const TCC_BINARY_FILE := TEMP_DIR + "/tcc.zip"
const TCC_BINARY_LINK := "http://download.savannah.gnu.org/releases/tinycc/tcc-0.9.27-win64-bin.zip"

## Build interface for generating binary output from C source
# todo: Provide more options, at least the most used ones
# Compiler identity
# Represents path to file that will be used as compiler
var cc: String
# Command line interface
# Used to distinguish between different ways of passing flags to compiler
# Recognized options: `tcc`, `gcc`
var cli: String
var cpu: String
var os: String
# Compilation mode, available options are: `Debug`, `ReleaseFast` and `ReleaseSmall`
# If not specified then mode is inferred from the way project is exported or played:
# In editor it's always `Debug`
# On Godot's debug export it's `Debug`, on release it's `ReleaseFast`
var mode: String
# If true, no libc will be linked and no builtin optimizations used
var link_libc := true
var include_paths := ["addons/inter-c/godot-headers", "addons/inter-c/godot-headers/gdnative"]


func build(source_result) -> void:
  if cli == "tcc":
    build_tcc(source_result)
  else:
    push_error("Unknown C compiler identity")


func build_tcc(source_result) -> void:
  ## Build with tcc command line interface
  var args := ["-shared", "-Wall", "-Wunsupported"]
  match mode:
    "Debug":
      args += ["-g"]
      if link_libc:
        # tcc implements bound checking, so, why dont include it by default
        args += ["-b"]
    "ReleaseFast", "ReleaseSmall":
      args += ["-opt", "-DNDEBUG", "-D__OPTIMIZE__=2"]
    _:
      push_error("ITC: Unknown compilation mode: " + mode)
  if not link_libc:
    args += ["-nostdlib"]
  for path in include_paths:
    args += ["-I" + path]
  args += ["-o", ProjectSettings.globalize_path("res://") + source_result.title + get_target_extension()]
  args += [ProjectSettings.globalize_path(source_result.source_path)]
  if invoke(ProjectSettings.globalize_path(cc), args) != 0:
    push_error("ITC: Compiler invocation failed")


func invoke(file: String, args: Array) -> int: # Status Code
  # todo: Optionally capture output?
  print_debug("ITC: Invocation: ", file, ": ", args)
  if OS.get_name() == "Windows":
    return OS.execute("CMD.EXE", ["/C" + file] + args)
  else:
    return OS.execute(file, args)


func init_default():
  if OS.get_name() == "Windows":
    cli = "tcc"
    cc = _resolve_tcc() + ".exe"
  else:
    # todo: Just use tcc for now too?
    assert(false, "Unimplemented")
  # if OS.has_feature("editor") or OS.is_debug_build():
  #   mode = "Debug"
  # else:
  mode = "ReleaseFast"
  return self


func _resolve_tcc() -> String:
  ## Downloads TCC binary specifically for this project
  # todo: We might want to reuse downloaded compiler, for example, by putting it in non-project specific temporary folder
  # todo: Test whether TCC is already present in PATH
  # todo: Check whether present TCC is working
  # todo: Potential vulnerability as there's no checking done whether we're storing desired file, or somebody tempered with our packets along the way
  # todo: We could compile more recent fork of TCC using this, or find a mirror that hosts those
  var dir := Directory.new()
  if dir.dir_exists(TEMP_DIR + "/tcc"):
    # todo: That's a dubious way to test resolution
    return TEMP_DIR + "/tcc/tcc"
  print_debug("ITC: Downloading tcc distribution via internet")
  if dir.make_dir_recursive(TEMP_DIR) != OK:
    push_error("Cannot create folder for saving tcc distribution at " + TEMP_DIR)
  var request_node = preload("res://addons/inter-c/src/RequestNode.gd").new()
  add_child(request_node)
  if request_node.request_file(TCC_BINARY_LINK, TCC_BINARY_FILE) != OK:
    push_error("Error on making HTTP request")
    return
  yield(request_node, "finished")
  # todo: One problem is that `yield` will return control to caller immediately, without awaiting
  _unzip_contents(TCC_BINARY_FILE, TEMP_DIR)
  print_debug("ITC: Done unzipping")
  return TEMP_DIR + "/tcc/tcc"


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
      # Directories could be distinguished like that
      continue
    var data = gdunzip.uncompress(file_meta["file_name"])
    if not data:
      push_error("ITC: Error uncompressing: " + file_meta["file_name"])
      continue
    var path := (dest_dir + "/" + file_meta["file_name"]) as String
    var dir_path := path.get_base_dir()
    if dir.make_dir_recursive(dir_path) != OK:
      push_error("ITC: Cannot create folder for unzipping tcc distribution: " + dir_path)
    file.open(path, File.WRITE)
    file.store_buffer(data)
    file.close()
    print_debug("IRC: Unzipped: " + file_meta["file_name"])


func get_target_extension() -> String:
  # todo: Should point to target OS, not host OS
  if OS.get_name() == "Windows":
    return ".dll"
  else:
    return ".so"
