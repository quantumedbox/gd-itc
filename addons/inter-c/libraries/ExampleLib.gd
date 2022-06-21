tool
extends NativeLibrary

func _ready() -> void:
  title = "libexample"
  version = "0.1"

  # Class which will be represented by NativeScript instance
  root_class = add_class("Fibber", "Object")

  # Methods are glue layer between C code and Godot
  # add_method() registers everything for you, and also checks and unwraps arguments
  # They always return godot_variant objects, `ITC_X_TO_VARIANT` macros might be handy for that
  root_class.add_method(
    "calculate", [["nth", type("int")]], """
    itc_variant result;
    itc_variant_from_int(&result, calc_recur(nth));
    return result;
    """)

  # add_function() will generate forward declaration and definition at the same time, so that every piece of code might reference this
  add_function(
    "calc_recur", [["nth", type("int")]], type("int"), """
    if (nth <= 1)
      return nth;
    return calc_recur(nth - 1) + calc_recur(nth - 2);
    """)

  var source = build_source()
  var compiler = get_default_compiler()
  compiler.link_libc = false
  compiler.build(source)
