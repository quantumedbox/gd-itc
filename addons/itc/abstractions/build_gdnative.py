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

def pool_array_element_type(t: str) -> str:
    assert(t in pool_array_types)
    return t[5:t.find('_array')]


def to_variant_type(t: str) -> str:
    assert(t in variant_types)
    return "GODOT_VARIANT_TYPE_" + t.upper()


def implement_type_interface(t: str, methods: []) -> str:
    result = ""
    for method in methods:
        parameters = "self"
        if len(method) > 1:
            for i, param in enumerate(method[1:]):
                parameters += f", {param}_{i}"
        result += f"#define itc_{t}_{method[0]}({parameters}) api->godot_{t}_{method[0]}({parameters})\n\n"
    return result


output = """
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
 * @warning Should only be called inside automatically generated methods
 */
#define itc_assert(condition) { \\
  if (!(condition)) { \\
        itc_print_error("Assert failed: " #condition); \\
        itc_variant_new_nil(&result); \\
        return result; \\
    } \\
  }

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

# todo: Should it crash instead on type mismatch?
# todo: Only check for type mismatch on debug?
for t in variant_types:
    output += f"""static itc_{t} itc_variant_to_{t}(itc_variant *self) {{
    if (itc_variant_get_type(self) != {to_variant_type(t)}) {{
        itc_print_error("Invalid type of variant");
    }}
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

for t in pool_array_types:
    element_type = pool_array_element_type(t)
    output += implement_type_interface(t, [
        ["new"],
        ["new_copy", t],
        ["new_with_array", "array"],
        ["append", element_type],
        ["append_array", t],
        ["insert", "int", element_type],
        ["invert"],
        ["push_back", element_type],
        ["remove", "int"],
        ["resize", "int"],
        ["sort"],
        ["set", "int", element_type],
        ["get", "int"],
        ["size"],
        ["empty"],
        ["has", element_type],
        ["destroy"]
    ])

# godot_pool_byte_array_read_access GDAPI *godot_pool_byte_array_read(const godot_pool_byte_array *p_self);
# godot_pool_byte_array_write_access GDAPI *godot_pool_byte_array_write(godot_pool_byte_array *p_self);

with open("gdnative.h", "w") as f:
    f.write(output)
