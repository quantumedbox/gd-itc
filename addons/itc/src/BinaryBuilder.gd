tool
extends Resource
class_name BinaryBuilder

## Build interface for generating binary output from C source

# todo: We need enumeratable compiler identity value for providing conditional compilation
#       Currently `cc_identity` and `cc` properties are present, but they dont convey what we want

# todo: Provide more options, at least the most used ones
# Compiler path
# Represents path to file that will be used for compilation
var cc: String

# Compiler identity
# Used primarily to distinguish between different ways of passing flags to compiler
enum { CompilerUnknown, CompilerGCC, CompilerTCC }
var cc_identity := CompilerUnknown

var arch: String

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
var include_paths := ["addons/itc/godot-headers", "addons/itc/godot-headers/gdnative"]


# todo: Return success
func build(library) -> void:
  if cc_identity == CompilerTCC:
    build_tcc(library)
  else:
    push_error("ITC: Unknown C compiler identity")
  prepare_lib(library)


func build_tcc(library) -> void:
  ## Build with tcc command line interface
  var args := ["-shared", "-Wall", "-Wunsupported"]
  match mode:
    "Debug":
      args += ["-g"]
      # todo: tcc implements bound checking, so, why dont include it on debug
    "ReleaseFast", "ReleaseSmall":
      args += ["-Wp,-opt", "-DNDEBUG", "-D__OPTIMIZE__=2"]
    _:
      push_error("ITC: Unknown compilation mode: " + mode)
  if not link_libc:
    args += ["-nostdlib"]
  for path in include_paths:
    args += ["-I" + path]
  var outpath = ItcUtils.absolute_path("res://") + "bin/" + library.title + "/" + get_target_identity() + "/" + library.title + get_target_extension()
  args += ["-o", outpath]
  args += [ItcUtils.absolute_path(library.source.path)]

  if not ItcUtils.ensure_directory_for(outpath):
    push_error("ITC: Cannot create directory structure for: " + outpath)

  var output = []
  if ItcUtils.invoke(ItcUtils.absolute_path(cc), args, output) != 0:
    push_error("ITC: Compiler invocation failed:")
    print(output) # todo: Route to log panel


func get_target_identity() -> String:
  return os.to_lower() + "-" + arch


func init_default(strategy: String):
  _init_default_shared()
  if strategy == "Host":
    _init_default_host()
  else:
    assert(false, "Undefined strategy to default initialize builder: " + strategy)
  return self


func _init_default_host() -> void:
  # todo: We could prob available compilers by `which` or `where` invocations
  os = OS.get_name()
  if os == "Windows":
    cc_identity = CompilerTCC
    cc = "tcc" # Use the one from PATH env
  else:
    cc_identity = CompilerGCC
    cc = "gcc" # Use the one from PATH env
  # todo: Cover more available arch's
  if OS.has_feature("x86_64"):
    arch = "x86_64"
  elif OS.has_feature("x86"):
    arch = "x86"


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

  var gdnlib_path: String = "res://bin/" + library.title + "/" + library.title + ".gdnlib"

  for cls_name in library.classes:
    var gdns_path: String = "res://bin/" + library.title + "/" + cls_name + ".gdns"
    var gdns_content: String = """
      [gd_resource type="NativeScript" load_steps=2 format=2]
      [ext_resource path="{gdnlib_path}" type="GDNativeLibrary" id=1]
      [resource]
      resource_name = "{cls_name}"
      class_name = "{cls_name}"
      library = ExtResource( 1 )""".format({
          "gdnlib_path": gdnlib_path,
          # "title": library.title,
          "cls_name": cls_name})

    if not ItcUtils.save_to_file(gdns_path, gdns_content):
      push_error("ITC: Cannot save: " + gdns_path)

  var gdnlib_content = """
    [general]
    singleton=false
    load_once=true
    symbol_prefix="godot_"
    reloadable=false
    [entry]
    Windows.64="res://bin/{title}/windows-x86_64/{title}.dll"
    Windows.32="res://bin/{title}/windows-x86/{title}.dll"
    X11.64="res://bin/{title}/x11-x64/lib{title}.so"
    OSX.64="res://bin/{title}/osx-x64/lib{title}.dynlib"
  """.format({"title": library.title})

  if not ItcUtils.save_to_file(gdnlib_path, gdnlib_content):
    push_error("ITC: Cannot open for writing: " + gdnlib_path)


func get_target_extension() -> String:
  # todo: Should point to target OS, not host OS
  if os == "Windows":
    return ".dll"
  else:
    return ".so"
