tool
extends Node
class_name BinaryBuilder

## Build interface for generating binary output from C source

# todo: Provide SHA of the TCC zip as we know it in advance
# todo: We need enumeratable compiler identity value for providing conditional compilation
#       Currently `cli` and `cc` properties are present, but they dont convey what we want

const TEMP_DIR := "res://addons/inter-c/.temp"
const TCC_BINARY_FILE := TEMP_DIR + "/tcc.zip"
const TCC_BINARY_LINK := "http://download.savannah.gnu.org/releases/tinycc/tcc-0.9.27-win64-bin.zip"
const TCC_DIR := TEMP_DIR + "/tcc"


# todo: Provide more options, at least the most used ones
# Compiler path
# Represents path to file that will be used for compilation
var cc: String

# todo: We shouldn't need this and could use compiler identity instead
# Command line interface
# Used to distinguish between different ways of passing flags to compiler
# Recognized options: `tcc`, `gcc`
var cli: String

# todo:
var arch: String = "x86_64"

# OS identity
# Uses the same string values as Godot, for example, in `OS.get_name`
var os: String

# Compilation mode, available options are: `Debug`, `ReleaseFast` and `ReleaseSmall`
# If not specified then mode is inferred from the way project is exported or played:
# In editor it's always `Debug`
# On Godot's debug export it's `Debug`, on release it's `ReleaseFast`
var mode: String

# If true, no libc will be linked and no builtin optimizations used
var link_libc := true
var include_paths := ["addons/inter-c/godot-headers", "addons/inter-c/godot-headers/gdnative"]


func build(library) -> void:
  if cli == "tcc":
    build_tcc(library)
  else:
    push_error("Unknown C compiler identity")
  prepare_lib(library)


func build_tcc(library) -> void:
  ## Build with tcc command line interface
  var args := ["-shared", "-Wall", "-Wunsupported"]
  match mode:
    "Debug":
      args += ["-g"]
      if link_libc:
        pass
        # todo: It looks like C-Chads fork refuses to link it?
        # tcc implements bound checking, so, why dont include it on debug
        # args += ["-b"]
        # if os == "Windows":
          # args += ["-L" + ItcUtils.absolute_path(TCC_DIR) + "/win32/lib"]
          # args += ["-l" + "bt-dll.o"]
    "ReleaseFast", "ReleaseSmall":
      args += ["-Wp,-opt", "-DNDEBUG", "-D__OPTIMIZE__=2"]
    _:
      push_error("ITC: Unknown compilation mode: " + mode)
  if not link_libc:
    args += ["-nostdlib"]
  for path in include_paths:
    args += ["-I" + path]
  var outpath = ItcUtils.absolute_path("res://") + "/bin/" + get_target_identity() + "/" + library.title + get_target_extension()
  args += ["-o", outpath]
  args += [ItcUtils.absolute_path(library.source.path)]

  if not ItcUtils.ensure_directory_for(outpath):
    push_error("ITC: Cannot create directory structure for: " + outpath)
  if ItcUtils.invoke(ItcUtils.absolute_path(cc), args) != 0:
    push_error("ITC: Compiler invocation failed")


func get_target_identity() -> String:
  return os.to_lower() + "-" + arch


func init_default(strategy: String):
  if strategy == "Host":
    _init_default_host()
    _init_default_shared()
  else:
    assert(false, "Undefined strategy to default initialize builder: " + strategy)
  return self


func _init_default_host() -> void:
  # todo: We could prob available compilers by `which` or `where` invocations
  os = OS.get_name()
  if os == "Windows":
    cli = "tcc"
    cc = _resolve_tcc() + ".exe"
  else:
    cli = "gcc"
    cc = "gcc" # Use the one from PATH env


func _init_default_shared() -> void:
  if OS.has_feature("editor") or OS.is_debug_build():
    mode = "Debug"
  else:
    mode = "ReleaseFast"


func prepare_lib(library) -> void:
  ## Populates `bin` folder with .gdns and .gdnlib files
  # todo: Test export
  # todo: Interface to fill gdnlib fields
  assert(library != null)
  print_debug("ITC: Preparing native library (.gdns and .gdnlib files)")

  var gdnlib_path = "res://bin/" + library.title + ".gdnlib"
  var gdns_path = "res://bin/" + library.title + ".gdns"

  var gdns_content = """
[gd_resource type="NativeScript" load_steps=2 format=2]
[ext_resource path="{gdnlib_path}" type="GDNativeLibrary" id=1]
[resource]
resource_name = "{title}"
class_name = "{root_class}"
library = ExtResource( 1 )""".format({
    "gdnlib_path": gdnlib_path,
    "title": library.title,
    "root_class": library.root_class.title})
  if not ItcUtils.save_to_file(gdns_path, gdns_content):
    push_error("ITC: Cannot open for writing: " + gdns_path)

  var gdnlib_content = """
[general]
singleton=false
load_once=true
symbol_prefix="godot_"
reloadable=false
[entry]
Windows.64="res://bin/windows-x64/{title}.dll"
Windows.32="res://bin/windows-x86/{title}.dll"
X11.64="res://bin/x11-x64/lib{title}.so"
OSX.64="res://bin/osx-x64/lib{title}.dynlib"
[dependencies]
Windows.64=[]
Windows.32=[]
X11.64=[]
OSX.64=[]""".format({"title": library.title})
  if not ItcUtils.save_to_file(gdnlib_path, gdnlib_content):
    push_error("ITC: Cannot open for writing: " + gdnlib_path)


func _resolve_tcc() -> String:
  ## Downloads TCC binary specifically for this project
  # todo: We might want to reuse downloaded compiler, for example, by putting it in non-project specific temporary folder
  # todo: Test whether TCC is already present in PATH
  # todo: Check whether present TCC is working
  # todo: Potential vulnerability as there's no checking done whether we're storing desired file, or somebody tempered with our packets along the way
  # todo: We could compile more recent fork of TCC using this, or find a mirror that hosts those
  var dir := Directory.new()
  if dir.dir_exists(TCC_DIR):
    # todo: That's a dubious way to test resolution
    print_debug("ITC: Using cached tcc distribution")
    return TCC_DIR + "/tcc"
  print_debug("ITC: Downloading tcc distribution via internet")
  if dir.make_dir_recursive(TEMP_DIR) != OK:
    push_error("ITC: Cannot create folder for saving tcc distribution at " + TEMP_DIR)
  var request_node = preload("res://addons/inter-c/src/RequestNode.gd").new()
  add_child(request_node)
  if request_node.request_file(TCC_BINARY_LINK, TCC_BINARY_FILE) != OK:
    push_error("ITC: Error on making HTTP request")
    return
  yield(request_node, "finished")
  # todo: One problem is that `yield` will return control to caller immediately, without awaiting
  _unzip_contents(TCC_BINARY_FILE, TEMP_DIR)
  print_debug("ITC: Done unzipping")
  return TCC_DIR + "/tcc"


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


func get_target_extension() -> String:
  # todo: Should point to target OS, not host OS
  if os  == "Windows":
    return ".dll"
  else:
    return ".so"
