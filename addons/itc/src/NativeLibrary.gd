tool
extends Node
class_name NativeLibrary

# todo: version_guard() function that will lock library to particular itc version range
# todo: Better error handling

enum { GDNone, GDNative, GDExtension }
var api := GDNone
var api_version # todo: Handle different versions of GDNative

var title: String
var author: String
var license: String
var version: String

var classes: Dictionary # Dictionary<String, Class>
var functions: Dictionary # Dictionary<String, Function>

var builder: Resource # BinaryBuilder
var source: Resource # SourceBuilder.Result


func _init() -> void:
  var version_info := Engine.get_version_info()
  if version_info.major == 3:
    api = GDNative
  elif version_info.major == 4:
    api = GDExtension
  else:
    # todo: Crash on error
    push_error("ITC: Unsupported Godot version: " + version_info.string)


func _ready():
  assert(has_method("form_module"), "ITC: 'form_module' isn't defined")
  call("form_module")
  assert(builder != null, "ITC: Builder not set")
  source = build_source()
  builder.build(self)


# todo: Create .lock file with sha hashes of files on which library is dependent
#       If hashes are equal to previous build's hash - there's no need to run this process again
#       Problem is, we need to really be sure when something was changed or not, which means going for every include file in provided C sources, for example
#       For that we would probably need to ask from user to make their includes transparent to itc interface
func build_source(source_output: String = ""):
  if source_output.empty():
    # todo: Set this option in object manner, as it's done with Compiler
    source_output = "res://addons/itc/.temp/%s.c" % title
  var source_builder = load("res://addons/itc/src/SourceBuilder.gd").new()
  return source_builder.build(self, source_output)


func add_class(title: String, base_class: String = "Node", user_data_fields=[]) -> Class:
  var result := Class.new()
  result.title = title
  result.base_class = base_class
  result.user_data_fields = user_data_fields
  result._library = self
  if classes.has(title):
    push_error("ITC: Redefinition of class {} in library {}" % [title, self.title])
    return null
  classes[title] = result
  return result


func add_function(title: String, parameters: Array, return_type: Type, source: String) -> Function:
  ## Add standalone function of which Godot is not aware
  ## When building source there will be forward definition created at the top containing `signature`
  ## Note that will have internal linkage
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


# func add_includes(includes: Array, predefine: String = "") -> void:
  ## Add block of includes with optional defines before it


class Class extends Resource:
  var title: String
  var base_class: String
  var user_data_fields: Array # Array<Array<String, Type>>
  var methods: Dictionary # Dictionary<Method>
  var constructor: Constructor = null
  var destructor: Destructor = null
  var _library: NativeLibrary # todo: Make it WeakRef?

  func add_method(title: String, parameters: Array, return_type: Type, source: String) -> Method:
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


class Method extends Resource:
  var title: String
  var parameters: Array # Array<Array<String, Type>>
  var return_type: Type
  var source: String
  var symbol: String

  func _init() -> void:
    # todo: We need to guarantee that no symbol clashes happens
    symbol = "itcgen_method_" + String(randi())


class Function extends Resource:
  var title: String
  var parameters: Array # Array<Array<String, String>>
  var return_type: Type
  var source: String


class Constructor extends Resource:
  ## Class constructor
  ## Inputs:
  ## - itc_object *instance
  ## - void *method_data
  ## Output:
  ## - itc_class_user_data_struct *
  ## ! Should return result of `itc_alloc(sizeof(itc_class_user_data_struct))`
  var source: String
  var symbol: String

  func _init() -> void:
    # todo: We need to guarantee that no symbol clashes happens
    symbol = "itcgen_constructor_" + String(randi())


class Destructor extends Resource:
  ## Class destructor
  ## Inputs:
  ## - itc_object *instance
  ## - void *method_data
  ## - itc_class_user_data_struct *user_data
  ## ! Should call `itc_free(user_data)`
  var source: String
  var symbol: String

  func _init() -> void:
    # todo: We need to guarantee that no symbol clashes happens
    symbol = "itcgen_destructor_" + String(randi())


class Type extends Resource:
  ## Gluing layer for types between C interface and GDScript
  ## For example, `int` in GDScript is typedef'd as `godot_int` in GDNative and `GDNativeInt` in GDExtension
  var gdscript: String
  var interface: String
  var variant: String


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
