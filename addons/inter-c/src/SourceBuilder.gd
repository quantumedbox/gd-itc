tool
extends Object
class_name SourceBuilder

# todo: Proper identation on nested bodies
# todo: All that formatting might be quite expensive, we might consider profiling it
# todo: Implement error stack / signaling, so that following steps could be aware of success of step they're dependent on
# todo: Technically it's possible for different classes to share the same user data structure, and thus the same methods that operate on user data

## Following listed variables will be put in source in order of their appearance:
# API specific prelude
var prelude: String
# Place where user data structs are generated
var typedefs: String
var function_declarations: String = "\n/** Function declarations **/\n"
var method_declarations: String = "\n/** Method declarations **/" # todo: Do we really need those? Method calls should be done via object call anyway, not C call
var constructor_definitions: String = "\n/** Constructor definitions **/"
var destructor_definitions: String = "\n/** Destructor definitions **/"
# Function that registers classes, methods, signals and such
# GDNative: void godot_nativescript_init(void *p_handle)
var script_initialization: String = "\n/** Script initialization, manages registration of classes, their methods, signals and etc **/"
var function_defintions: String = "\n/** User function definitions **/"
var method_defintions: String = "\n/** Method definitions **/"

var _is_no_user_data_constructor_used := false
var _is_default_destructor_used := false


class Result extends Resource:
  # todo: Collect errors here, or at least success status
  var title: String
  var source_path: String


func build(library: NativeLibrary, source_output: String) -> Result:
  assert(library != null)
  assert(not source_output.empty())
  var result := Result.new()
  result.title = library.title
  print("ITC: Building source: " + library.title)
  if library.api == NativeLibrary.GDNative:
    build_gdnative(library)
  elif library.api == NativeLibrary.GDExtension:
    build_gdextension(library)
  else:
    assert("Unknown API: " + String(library.api))
  var file := File.new()
  var dir := Directory.new()
  if dir.make_dir_recursive(source_output.get_base_dir()) != OK:
    push_error("Cannot create folder for outputting source: " + source_output)
  if file.open(source_output, File.WRITE) != OK:
    push_error("Cannot open file for outputting source: " + source_output)
  file.store_string(prelude)
  file.store_string(typedefs)
  file.store_string(function_declarations)
  file.store_string(method_declarations)
  file.store_string(constructor_definitions)
  file.store_string(destructor_definitions)
  file.store_string(script_initialization)
  file.store_string(function_defintions)
  file.store_string(method_defintions)
  file.close()
  result.source_path = source_output
  return result


func build_gdnative(library: NativeLibrary) -> void:
  prelude = GDNATIVE_INTERFACE + GDNATIVE_TYPES + GDNATIVE_ABSTRACTION
  script_initialization += """
  void GDN_EXPORT godot_nativescript_init(void *p_handle) {
  """
  for class_named in library.classes:
    var cls := library.classes[class_named] as NativeLibrary.Class
    assert(cls != null)
    form_class_init_gdnative(cls)
    form_user_data(cls)
  script_initialization += "\n}\n"
  for function in library.functions:
    form_function(library.functions[function])
  if _is_no_user_data_constructor_used:
    constructor_definitions += """
    /* Constructor without provided user data */
    GDCALLINGCONV void *itcgen_no_user_data_constructor(godot_object *p_instance, void *p_method_data) {
      (void)p_instance;
      (void)p_method_data;
      return NULL;
    }
    """
  if _is_default_destructor_used:
    destructor_definitions += """
    /* Destructor without user define effects */
    GDCALLINGCONV void itcgen_common_destructor(godot_object *p_instance, void *p_method_data, void *p_user_data) {
      (void)p_instance;
      (void)p_method_data;
      // todo: Check whether NULL is valid here
      api->godot_free(p_user_data);
    }
    """


func form_class_init_gdnative(cls: NativeLibrary.Class) -> void:
  script_initialization += "{"
  # todo: Proper commenting
  script_initialization += """
  /* %s class registration */
  """ % cls.title
  # Handle construction
  if cls.user_data_fields.size() == 0 and cls.constructor == null:
    # Use generic no user data constructor
    _is_no_user_data_constructor_used = true
    script_initialization += """
    godot_instance_create_func constructor = { NULL, NULL, NULL };
    constructor.create_func = &itcgen_no_user_data_constructor;
    """
  elif cls.constructor == null:
    # Generate default user data constructor
    # todo: We only need to generate unique constructor for every user data of unique size
    #       If we could infer size of all fields in script we could optimize generated binary a bit
    script_initialization += """
    godot_instance_create_func constructor = { NULL, NULL, NULL };
    constructor.create_func = &%s_user_data_constructor;
    """ % cls.title
    constructor_definitions += """
    static GDCALLINGCONV void *{class_named}_user_data_constructor(godot_object *p_instance, void *p_method_data) {
      (void)instance;
      (void)method_data;
      struct {class_named}_user_data *user_data = api->godot_alloc(sizeof(struct {class_named}_user_data));
      memset(user_data, 0, sizeof(struct {class_named}_user_data));
      return user_data;
    }
    """.format({"class_named": cls.title})
  else: 
    # User defined constructor, generated later as those might be reused
    script_initialization += """
    godot_instance_create_func constructor = { NULL, NULL, NULL };
    constructor.create_func = &%s;
    """ % cls.constructor.symbol

  # Handle destruction
  if cls.destructor == null:
    _is_default_destructor_used = true
    script_initialization += """
    godot_instance_destroy_func destructor = { NULL, NULL, NULL };
    destructor.destroy_func = &itcgen_common_destructor;
    """
  else:
    # User defined destructor, generated later as those might be reused
    script_initialization += """
    godot_instance_destroy_func destructor = { NULL, NULL, NULL };
    destructor.destroy_func = &%s;
    """ % cls.destructor.symbol

  script_initialization += """
  nativescript_api->godot_nativescript_register_class(p_handle, "%s", "%s", constructor, destructor);
  """ % [cls.title, cls.base_class]

  if cls.methods.size() != 0:
    # Bind methods to registered cls
    script_initialization += """
    godot_method_attributes itcgen_basic_method_attribs = { .rpc_type = GODOT_METHOD_RPC_MODE_DISABLED };
    """
    for method_name in cls.methods:
      var method := cls.methods[method_name] as NativeLibrary.Method
      assert(method != null)
      form_method_gdnative(cls, method)
      script_initialization += """
      {
        godot_instance_method class_method = { NULL, NULL, NULL };
        class_method.method = &%s;
        nativescript_api->godot_nativescript_register_method(p_handle, "%s", "%s", itcgen_basic_method_attribs, class_method);
      }
      """ % [method.symbol, cls.title, method_name]

  script_initialization += "}"


func form_user_data(cls: NativeLibrary.Class) -> void:
  if cls.user_data_fields.size() == 0:
    return
  var fields := ""
  for user_data_field_pair in cls.user_data_fields:
    assert(user_data_field_pair is Array)
    assert(user_data_field_pair[0] is String)
    assert(user_data_field_pair[1] is NativeLibrary.Type)
    fields += user_data_field_pair[1].interface + " " + user_data_field_pair[0] + ";\n"
  typedefs += """
  struct %s_user_data {
    %s};
  """ % [cls.title, fields]


func form_method_gdnative(cls: NativeLibrary.Class, method: NativeLibrary.Method) -> void:
  # todo: Methods with default values
  # todo: One problem is that some methods might use user data, and thus be cls specific
  # todo: Check types of variants before unwrapping
  method_declarations += """
  static GDCALLINGCONV godot_variant %s(godot_object *p_instance, void *p_method_data, void *p_user_data, int p_num_args, godot_variant **p_args);
  """ % method.symbol
  method_defintions += """
  static GDCALLINGCONV godot_variant {method_symbol}(godot_object *p_instance, void *p_method_data, void *p_user_data, int num_args, godot_variant **p_args) {
  if (num_args != {parameter_count}) {
    itc_print_error("Invalid parameter count, required {parameter_count}");
    itc_variant result;
    itc_variant_from_null(&result);
    return result;
  }
  """.format({"method_symbol": method.symbol, "parameter_count": method.parameters.size()})
  # If user data is present - cast it to pointer of appropriate type
  if cls.user_data_fields.size() != 0:
    method_defintions += """
    struct %s_user_data *user_data = (struct %s_user_data *)p_user_data;
    """ % [cls.title, cls.title]
  # Unwrap variant parameters to their contained types
  var idx := 0
  for parameter_pair in method.parameters:
    assert(parameter_pair is Array)
    assert(parameter_pair[0] is String)
    assert(parameter_pair[1] is NativeLibrary.Type)
    if parameter_pair[1].gdscript == "Variant":
      method_defintions += """
      godot_variant %s = &p_args[%s];
      """ % [parameter_pair[0], idx]
    else:
      method_defintions += """
      if ({variant_type} != api->godot_variant_get_type(p_args[{arg_idx}])) {
        itc_print_error("Type {type} required as {arg_idx}th parameter");
        itc_variant result;
        itc_variant_from_null(&result);
        return result;
      }
      {type} {symbol} = itc_{type_coversion}_from_variant(p_args[{arg_idx}]);
      """.format({
        "symbol" : parameter_pair[0],
        "type": parameter_pair[1].interface,
        "type_coversion": parameter_pair[1].gdscript.to_lower(), # todo: Might need something better than that assumption
        "variant_type": parameter_pair[1].variant,
        "arg_idx": idx})
    idx += 1
  method_defintions += method.source
  method_defintions += "}"


func form_function(function: NativeLibrary.Function) -> void:
  var parameter_list := ""
  for idx in range(0, function.parameters.size()):
    var parameter_pair := function.parameters[idx] as Array
    assert(parameter_pair != null)
    assert(parameter_pair[0] is String)
    assert(parameter_pair[1] is NativeLibrary.Type)
    parameter_list += parameter_pair[1].interface + " " + parameter_pair[0]
    if idx != function.parameters.size() - 1:
      parameter_list += ", "
  var signature := ("static " + function.return_type.interface + " " + function.title + "(" + parameter_list + ")") as String
  function_declarations += signature + ";\n"
  function_defintions += "\n" + signature + " {\n" + function.source + "\n}\n"


func build_gdextension(library: NativeLibrary) -> void:
  assert(false, "Unimplemented")


const GDNATIVE_TYPES = """
/** Interface agnostic typedefs fror basic types **/
#define itc_variant godot_variant
#define itc_int godot_int
"""


const GDNATIVE_ABSTRACTION = """
/** Abstraction layer for GDNative functionalities **/
/* Print godot error with current function, line and file location and given description */
#define itc_print_error(description) api->godot_print_error((description), __func__, __FILE__, __LINE__)

/* Allocates N bytes using Godot provided allocator and returns type erased address to allocated region
    Note that it doesn't specify whether it zeroes the data, use `itc_calloc(N)` if you need zeroed memory
*/
#define itc_alloc(N) api->godot_alloc(N)

/* Zeroed allocation */
static void *itc_calloc(size_t N) {
  void *result = itc_alloc(N);
  char *zero_ptr = (char *)result;
  while (N-- > 0) *zero_ptr++ = 0;
  return result;
}

/* To variant conversions, assumes that source object is no longer needed
  Parameter `var` is non-const pointer to `itc_variant`
  Parameter `val` is specific to particular function. Generally, fundamental types are passed by value, while everything else by const pointer
*/
#define itc_variant_from_null(var) api->godot_variant_new_nil(var)
#define itc_variant_from_int(var, val) api->godot_variant_new_int(var, val)

/* From variant conversions, assumes that source variant is no longer needed
  Parameter `var` is non-const pointer to `itc_variant`
*/
static itc_int itc_int_from_variant(itc_variant *self) {
  itc_int result = api->godot_variant_as_int(self);
  api->godot_variant_destroy(self);
  return result;
}
"""


const GDNATIVE_INTERFACE = """
/** Prelude **/
#include <stddef.h>

#include <gdnative_api_struct.gen.h>

/* Check for this definition if you need to conditionally compile with particular api in mind */
#define ITC_API_GDNATIVE

static const godot_gdnative_core_api_struct *api = NULL;
static const godot_gdnative_ext_nativescript_api_struct *nativescript_api = NULL;

// todo: We might provide way to include library code in here
void GDN_EXPORT godot_gdnative_init(godot_gdnative_init_options *p_options) {
  api = p_options->api_struct;
  for (unsigned int i = 0; i < api->num_extensions; i++) {
    if (api->extensions[i]->type == GDNATIVE_EXT_NATIVESCRIPT) {
      nativescript_api = (godot_gdnative_ext_nativescript_api_struct *)api->extensions[i];
    }
  }
}

// todo: We might provide way to include library code in here
void GDN_EXPORT godot_gdnative_terminate(godot_gdnative_terminate_options *p_options) {
  (void)p_options;
  api = NULL;
  nativescript_api = NULL;
}
"""
