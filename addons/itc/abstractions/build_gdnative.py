#!/usr/bin/env python


pool_array_types = [
    "pool_byte_array",
    "pool_int_array",
    "pool_real_array",
    "pool_string_array",
    "pool_vector2_array",
    "pool_vector3_array",
    "pool_color_array"
]

pool_array_reader_writers = []
for t in pool_array_types:
    pool_array_reader_writers += [t + "_reader", t + "_writer"]

array_types = ["array"] + pool_array_types

variant_types = [
    "bool",
    "uint",
    "int",
    "real",
    "string",
    "vector2",
    "rect2",
    "vector3",
    "transform2d",
    "plane",
    "quat",
    "aabb",
    "basis",
    "transform",
    "color",
    "node_path",
    "rid",
    "object",
    "dictionary",
    "array"
] + pool_array_types

destroyable_types = [
    "variant",
    "dictionary",
    "string",
    "string_name",
    "char_string",
    "object",
    "node_path"] + array_types + pool_array_reader_writers


def array_element_type(t: str) -> str:
    assert(t in pool_array_types)
    if t == "array":
        return "variant"
    return t[5:t.find('_array')]


def to_variant_type(t: str) -> str:
    assert(t in variant_types)
    return "GODOT_VARIANT_TYPE_" + t.upper()


def to_godot_symbol(t: str) -> str:
    if t.endswith("reader"):
        return t[:-6] + "read_access"
    if t.endswith("writer"):
        return t[:-6] + "write_access"
    return t


def implement_type_interface(t: str, methods: []) -> str:
    result = ""
    for method in methods:
        parameters = "self"
        if len(method) > 1:
            for i, param in enumerate(method[1:]):
                parameters += f", {param}{i}"
        result += f"#define itc_{t}_{method[0]}({parameters}) api->godot_{t}_{method[0]}({parameters})\n\n"
    return result


output = """#pragma once

#include <stddef.h>
#include <stdint.h>
// todo: Dont use any libc binaries here
#include <string.h>

#include <gdnative_api_struct.gen.h>

// Aliased to keep it systematic
typedef uint8_t godot_byte;
typedef godot_byte itc_byte;

extern const godot_gdnative_core_api_struct *api;
extern const godot_gdnative_ext_nativescript_api_struct *nativescript_api;

#define itc_variant_get_type(variant) api->godot_variant_get_type(variant)

#define itc_variant_new_copy(variant, from) api->godot_variant_new_copy(variant, from)

#define itc_variant_new_nil(variant) api->godot_variant_new_nil(variant)

#define itc_variant_destroy(variant) api->godot_variant_destroy(variant)

#define itc_print_error(description) \\
  api->godot_print_error((description), __func__, __FILE__, __LINE__)

/**
 * Check for condition, automatically return 'null' variant on fail
 * @warning Should only be called inside automatically generated methods
 */
#define itc_method_assert_with_message(condition, message) { \\
  if (!(condition)) { \\
        itc_print_error(message ": " #condition); \\
        itc_variant_new_nil(&result); \\
        return result; \\
    } \\
  }

/**
 * Check for condition, automatically return 'null' variant on fail
 * @warning Should only be called inside automatically generated methods
 */
#define itc_method_assert(condition) itc_method_assert_with_message(condition, "Assertion failed")

#define itc_allocate(bytes) api->godot_alloc(bytes)

static void *itc_zero_allocate(size_t bytes) {
  void *result = itc_allocate(bytes);
  if (result)
    memset(result, 0, bytes);
  return result;
}

#define itc_realloc(mem, bytes) api->godot_realloc(mem, bytes)

#define itc_free(mem) api->godot_free(mem)

"""

for t in variant_types:
    output += f"typedef godot_{t} itc_{t};\n"
output += "\n"

output += "#define itc_variant_new(variant, value) api->_Generic((value) \\\n"
for t in variant_types:
    output += f", itc_{t} *: godot_variant_new_{t} \\\n"
output += ")(variant, value)\n\n"

output += implement_type_interface("variant", [
    ["as_bool"],
    ["as_uint"],
    ["as_int"],
    ["as_real"],
    ["as_string"],
    ["as_vector2"],
    ["as_rect2"],
    ["as_vector3"],
    ["as_transform2d"],
    ["as_plane"],
    ["as_quat"],
    ["as_aabb"],
    ["as_basis"],
    ["as_transform"],
    ["as_color"],
    ["as_node_path"],
    ["as_rid"],
    ["as_object"],
    ["as_dictionary"],
    ["as_array"],
    ["as_pool_byte_array"],
    ["as_pool_int_array"],
    ["as_pool_real_array"],
    ["as_pool_string_array"],
    ["as_pool_vector2_array"],
    ["as_pool_vector3_array"],
    ["as_pool_color_array"]
])

# todo: Similar function but which does destroy object from which variant is initialized?
# todo: Should it crash instead on type mismatch?
# todo: Only check for type mismatch on debug?
for t in variant_types:
    output += f"""static itc_{t} itc_variant_to_{t}(itc_variant *self) {{
    if (itc_variant_get_type(self) != {to_variant_type(t)})
        itc_print_error("Invalid type of variant");
    itc_{t} result = itc_variant_as_{t}(self);
    itc_variant_destroy(self);
    return result;
}}\n"""
output += "\n"

output += implement_type_interface("vector2", [
    ["new", "real", "real"],
    ["as_string"],
    ["normalized"],
    ["length"],
    ["angle"],
    ["length_squared"],
    ["is_normalized"],
    ["direction_to", "vector2"],
    ["distance_to", "vector2"],
    ["distance_squared_to", "vector2"],
    ["angle_to", "vector2"],
    ["angle_to_point", "vector2"],
    ["linear_interpolate", "vector2", "real"],
    ["cubic_interpolate", "vector2", "vector2", "vector2", "real"],
    ["move_toward", "vector2", "real"],
    ["rotated", "real"],
    ["tangent"],
    ["floor"],
    ["snapped", "vector2"],
    ["aspect"],
    ["dot", "vector2"],
    ["slide", "vector2"],
    ["bounce", "vector2"],
    ["reflect", "vector2"],
    ["abs"],
    ["clamped", "real"],
    ["operator_add", "vector2"],
    ["operator_subtract", "vector2"],
    ["operator_multiply_vector", "vector2"],
    ["operator_multiply_scalar", "real"],
    ["operator_divide_vector", "vector2"],
    ["operator_divide_scalar", "real"],
    ["operator_equal", "vector2"],
    ["operator_less", "vector2"],
    ["operator_neg"],
    ["set_x"],
    ["set_y"],
    ["get_x"],
    ["get_y"]
])

array_methods = [
    ["new"],
    ["new_copy", "other"],
    #["new_with_array", "array"],
    ["append", "item"],
    #["append_array", t],
    ["insert", "int", "item"],
    ["invert"],
    ["push_back", "item"],
    ["remove", "int"],
    ["resize", "int"],
    ["sort"],
    ["set", "int", "item"],
    ["get", "int"],
    ["size"],
    ["empty"],
    ["has", "item"],
    #["destroy"]
]

for method in array_methods:
    parameters = "self"
    if len(method) > 1:
        for i, param in enumerate(method[1:]):
            parameters += f", {param}{i}"
    output += f"#define itc_array_{method[0]}({parameters}) api->_Generic((self) \\\n"
    for t in array_types:
        output += f", itc_{t} *: godot_{t}_{method[0]} \\\n"
    output += f")({parameters})\n\n"

for t in pool_array_types:
    output += f"typedef godot_{t}_read_access itc_{t}_reader;\n"
    output += f"typedef godot_{t}_read_access itc_{t}_writer;\n\n"

# todo: Function to reproduce this idiom

output += "#define itc_array_new_reader(array) api->_Generic((array) \\\n"
for t in pool_array_types:
    output += f", itc_{t} *: godot_{t}_read \\\n"
output += ")(array)\n\n"

output += "#define itc_reader_get_ptr(reader) api->_Generic((reader) \\\n"
for t in pool_array_types:
    output += f", itc_{t}_reader *: godot_{t}_read_access_ptr \\\n"
output += ")(reader)\n\n"

output += "#define itc_array_new_writer(array) api->_Generic((array) \\\n"
for t in pool_array_types:
    output += f", itc_{t} *: godot_{t}_write \\\n"
output += ")(array)\n\n"

output += "#define itc_destroy(object) api->_Generic((object) \\\n"
for t in destroyable_types:
    output += f", itc_{t} *: godot_{to_godot_symbol(t)}_destroy \\\n"
output += ")(object)\n\n"

with open("gdnative.h", "w") as f:
    f.write(output)
