tool
extends Node
class_name NativeLibrary

# todo: version_guard() function that will lock library to particular itc version range
# todo: Better error handling
# todo: Way to define macros in orderly fashion with includes

const TEMP_DIR := "res://addons/itc/.temp/"

enum { GDNone, GDNative, GDExtension }
var api := GDNone
var api_version # todo: Handle different versions of GDNative

## Identity strings, should be assigned in 'identity' callback
var title: String
var author: String
var license: String
var version: String

var classes: Dictionary # Dictionary<String, Class>
var functions: Dictionary # Dictionary<String, Function>
var structs: Dictionary # Dictionary<String, Struct>
var destructors: Dictionary # Dictionary<String, Destructor>

var builder: Resource # BinaryBuilder
var source: Resource # SourceBuilder.Result

var sources: PoolStringArray # todo: Allow binding separate builder for each source
var includes: PoolStringArray

## Populated automatically to point to directory in which this library script is in
var directory: String
## Populated automatically to pointe to script file
var script_path: String
## Define it to put generated .c file on desired location
var source_path: String setget ,_get_source_path


func identity() -> void:
  ## Used to fill information about library
  ## Field 'title' is required to be defined
  pass


func library() -> void:
  ## Used to construct library logic, any 'add_' function is valid here
  pass


func _init() -> void:
  var version_info := Engine.get_version_info()
  if version_info.major == 3:
    api = GDNative
  elif version_info.major == 4:
    api = GDExtension
  else:
    # todo: Crash on error
    push_error("ITC: Unsupported Godot version: " + version_info.string)


# todo: Require building explicitly
func _ready():
  library()
  assert(builder != null, "ITC: Builder not set")
  # todo: Separate source and binary building, as we might want granularity
  source = build_source()
  builder.build(self)


func _get_source_path() -> String:
  var result = source_path
  if result.empty():
    result = TEMP_DIR + title + ".c"
  return result


func build_source():
  var source_builder = load("res://addons/itc/src/SourceBuilder.gd").new()
  return source_builder.build(self, _get_source_path())


func add_class(title: String, base_class: String = "Node") -> Class:
  if classes.has(title):
    push_error("ITC: Redefinition of class {} in library {}" % [title, self.title])
    return null
  var result := Class.new()
  result.title = title
  result.base_class = base_class
  result._library = self
  classes[title] = result
  return result


func add_struct(title: String, fields: Dictionary) -> Struct:
  if structs.has(title):
    push_error("ITC: Redefinition of struct {} in library {}" % [title, self.title])
    return null
  var result := Struct.new()
  if title.empty():
    title = "anonymous_struct" + String(randi())
  result.title = title
  result.fields = fields # todo: Check well formity
  result._library = self
  structs[title] = result
  return result


# todo: Ability to define non static functions?
func add_function(title: String, parameters: Dictionary, return_type: Type, source: String) -> Function:
  ## Add standalone function of which Godot is not aware
  ## When building source there will be forward definition created at the top containing `signature`
  ## Note that it will have internal linkage, aka marked 'static'
  if functions.has(title):
    push_error("ITC: Redefinition of function {} in library {}" % [title, self.title])
    return null
  var result := Function.new()
  result.title = title
  result.parameters = parameters # todo: Check well-formity of parameters
  result.return_type = return_type
  result.source = source
  functions[title] = result
  return result


func add_destructor(user_data: Type, source: String) -> Destructor:
  var result := Destructor.new()
  result.user_data = user_data
  result.source = source
  return result


func add_sources(c_sources: Array, dir: String = "") -> void:
  # Add c sources to be built and linked separately
  if dir.empty():
    dir = directory
  if not dir.ends_with("/"):
    dir += "/"
  for source in c_sources:
    if not source is String:
      push_error("ITC: Source is supposed to be String")
      return null
    sources.append(dir + source)


func add_headers(headers: Array, dir: String = "") -> void:
  # Add block of header includes
  if dir.empty():
    dir = directory
  if not dir.ends_with("/"):
    dir += "/"
  for header in headers:
    if not header is String:
      push_error("ITC: Include is supposed to be String")
      return null
    includes.append(dir + header)


class Class extends Resource:
  var title: String
  var base_class: String
  var user_data: Type
  var methods: Dictionary # Dictionary<Method>
  var constructor: Constructor = null
  var destructor: Destructor = null
  var _library: NativeLibrary # todo: Make it WeakRef?

  func add_method(title: String, parameters: Dictionary, return_type: Type, source: String) -> Method:
    if methods.has(title):
      push_error("ITC: Redefinition of method {} in class {}:{}" % [title, _library.title, self.title])
      return null
    var result := Method.new()
    result.title = title
    result.parameters = parameters # todo: Check well-formity of parameters
    result.return_type = return_type
    result.source = source
    methods[title] = result
    return result

  func add_destructor(source: String) -> Destructor:
    # todo: Error if destructor is already assigned?
    result.destructor = _library.add_destructor(result.user_data, source)
    return result.destructor


class Method extends Resource:
  var title: String
  var parameters: Dictionary # Dictionary<String, Type>
  var return_type: Type
  var source: String
  var symbol: String

  func _init() -> void:
    # todo: We need to guarantee that no symbol clashes happens
    symbol = "itcgen_method_" + String(randi())


class Function extends Resource:
  var title: String
  var parameters: Dictionary # Dictionary<String, Type>
  var return_type: Type
  var source: String


class Struct extends Resource:
  var title: String
  var fields: Dictionary # Dictionary<String, Type>
  var symbol: String
  var type: Type

  func _init() -> void:
    symbol = title
    type = Type.new()
    type.interface = symbol


class Constructor extends Resource:
  ## Class constructor
  var source: String
  var symbol: String

  func _init() -> void:
    # todo: We need to guarantee that no symbol clashes happens
    # todo: We might want to provide symbol that is known to user C code
    symbol = "itcgen_constructor_" + String(randi())


class Destructor extends Resource:
  ## Class destructor
  var source: String
  var user_data: String
  var symbol: String

  func _init() -> void:
    # todo: We need to guarantee that no symbol clashes happens
    # todo: We might want to provide symbol that is known to user C code
    symbol = "itcgen_destructor_" + String(randi())


# todo: Define getters that would check for well formity
class Type extends Resource:
  ## Gluing layer for types between C interface and GDScript
  ## For example, `int` in GDScript is typedef'd as `godot_int` in GDNative and `GDNativeInt` in GDExtension
  var gdscript: String
  var interface: String # todo: Rename to 'c_repr'?
  var variant: String

  func is_array_type() -> bool:
    return interface.ends_with("_array")


func type(type_hint: String) -> Type:
  ## Returns interface specific representation of GDScript type
  if api == GDNative:
    return _type_gdnative(type_hint)
  elif api == GDExtension:
    return _type_gdextension(type_hint)
  else:
    assert(false, "ITC: Unknown API: " + String(api))
    return null


func _type_gdnative(type_hint: String) -> Type:
  var result := Type.new()
  result.gdscript = type_hint
  result.interface = "godot_" + type_hint.to_lower()
  result.variant = "GODOT_VARIANT_TYPE_" + type_hint.to_upper()
  return result


func _type_gdextension(type_hint: String) -> Type:
  # todo: Work on it
  var result := Type.new()
  result.gdscript = type_hint
  result.interface = "GDNative" + type_hint.capitalize()
  # todo: result.variant if needed
  return result


func ctype(type_hint: String) -> Type:
  ## Propagates type to source as it is, `gdscirpt` field will not be formed
  var result := Type.new()
  result.gdscript = ""
  result.interface = type_hint
  return result
