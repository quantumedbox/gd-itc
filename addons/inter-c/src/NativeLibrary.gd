tool
extends Resource
class_name NativeLibrary

# todo: version_guard() function that will lock library to particular inter-c version range
# todo: Better error handling

enum { InterfaceUnknown, GDNative, GDExtension }
var api := InterfaceUnknown
var api_version # todo: Handle different versions of GDNative

var name: String
var version: String
var root_class: Class = null
var classes: Dictionary # Dictionary<String, Class>
var functions: Dictionary # Dictionary<String, Function>

# Specifies where to output C source, if not specified then it's defaulted to `res://addons/inter-c/.temp/<self.name>.c`
var source_output: String setget ,_get_source_output


func _init() -> void:
  var version_info := Engine.get_version_info()
  if version_info.major == 3:
    api = GDNative
  elif version_info.major == 4:
    api = GDExtension
  else:
    push_error("Godot version {} isn't supported" % version_info.string)
    # todo: Crash on error


# todo: Create .lock file with sha hashes of files on which library is dependent
#       If hashes are equal to previous build's hash - there's no need to run this process again
#       Problem is, we need to really be sure when something was changed or not, which means going for every include file in provided C sources, for example
#       For that we would probably need to ask from user to make their includes transparent to inter-c interface
func build_source() -> void:
  var builder = load("res://addons/inter-c/src/SourceBuilder.gd").new()
  builder.build(self)


func add_class(name: String, base_class: String = "Node", user_data_fields=[]) -> Class:
  var result := Class.new()
  result.name = name
  result.base_class = base_class
  result.user_data_fields = user_data_fields
  result._library = self
  if classes.has(name):
    push_error("Redefinition of class {} in library {}" % [name, self.name])
    return null
  classes[name] = result
  return result


func add_function(name: String, parameters: Array, return_type: Type, source: String) -> Function:
  ## Add standalone function of which Godot is not aware
  ## When building source there will be forward definition created at the top containing `signature`
  ## Note that will have internal linkage
  if functions.has(name):
    push_error("Redefinition of function {} in library {}" % [name, self.name])
    return null
  var result := Function.new()
  result.name = name
  result.parameters = parameters # todo: Check well-formity of parameters
  result.return_type = return_type
  result.source = source
  functions[name] = result
  return result


class Class extends Resource:
  var name: String
  var base_class: String
  var user_data_fields: Array # Array<Array<String, Type>>
  var methods: Dictionary # Dictionary<Method>
  var constructor: Constructor = null
  var destructor: Destructor = null
  var _library: NativeLibrary # todo: Make it WeakRef?

  func add_method(name: String, parameters: Array, source: String) -> Method:
    if methods.has(name):
      push_error("Redefinition of method {} in class {}:{}" % [name, _library.name, self.name])
      return null
    var result := Method.new()
    result.name = name
    result.parameters = parameters # todo: Check well-formity of parameters
    result.source = source
    methods[name] = result
    return result


class Method extends Resource:
  var name: String
  var parameters: Array # Array<Array<String, Type>>
  var source: String
  var symbol: String

  func _init() -> void:
    # todo: We need to guarantee that no symbol clashes happens
    symbol = "method_" + String(randi())


class Function extends Resource:
  var name: String
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
    symbol = "user_data_constructor_" + String(randi())


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
    symbol = "user_data_constructor_" + String(randi())


class Type extends Resource:
  ## Gluing layer for types between C interface and GDScript
  ## For example, `int` in GDScript is typedef'd as `godot_int` in GDNative and `GDNativeInt` in GDExtension
  var gdscript: String
  var interface: String


func type(type_hint: String) -> Type:
  ## Returns interface specific representation of GDScript type
  if api == GDNative:
    return _type_gdnative(type_hint)
  elif api == GDExtension:
    return _type_gdextension(type_hint)
  else:
    assert(false, "Unknown API: " + String(api))
    return null


func _type_gdnative(type_hint: String) -> Type:
  var result := Type.new()
  result.gdscript = type_hint
  result.interface = "godot_" + type_hint.to_lower()
  return result


func _type_gdextension(type_hint: String) -> Type:
  # todo: Work on it
  var result := Type.new()
  result.gdscript = type_hint
  result.interface = "GDNative" + type_hint.capitalize()
  return result


func _get_source_output() -> String:
  if source_output.empty():
    return "res://addons/inter-c/.temp/%s.c" % name
  else:
    return source_output