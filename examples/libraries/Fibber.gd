tool
extends NativeLibrary


func identity() -> void:
  title = "fibber"
  author = "Veclav Talica"
  version = "0.1"


func library() -> void:
  # Class which will be represented by NativeScript instance
  var fibber = add_class("Fibber", "Object")

  # Methods are glue layer between C code and Godot
  # add_method() registers everything for you, and also checks and unwraps arguments
  # Methods always return godot_variant objects, for that implicit 'result' variable is created and returned
  fibber.add_method("calculate", {"nth": type("int")}, type("int"), """
    itc_variant_new(&result, calc_recur(nth));
  """)

  # add_function() will generate forward declaration and definition at the same time,
  # so that every piece of code might reference this
  add_function("calc_recur", {"nth": type("int")}, type("int"), """
    if (nth <= 1)
      return nth;
    return calc_recur(nth - 1) + calc_recur(nth - 2);
  """)
