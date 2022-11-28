
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

#define itc_print_error(description) \
  api->godot_print_error((description), __func__, __FILE__, __LINE__)

/**
 * @warning Should only be called inside automatically generated methods
 */
#define itc_assert(condition) { \
  if (!(condition)) { \
        itc_print_error("Assert failed: " #condition); \
        itc_variant_new_nil(&result); \
        return result; \
    } \
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

typedef godot_bool itc_bool;
typedef godot_uint itc_uint;
typedef godot_int itc_int;
typedef godot_real itc_real;
typedef godot_string itc_string;
typedef godot_vector2 itc_vector2;
typedef godot_rect2 itc_rect2;
typedef godot_vector3 itc_vector3;
typedef godot_transform2d itc_transform2d;
typedef godot_plane itc_plane;
typedef godot_quat itc_quat;
typedef godot_aabb itc_aabb;
typedef godot_basis itc_basis;
typedef godot_transform itc_transform;
typedef godot_color itc_color;
typedef godot_node_path itc_node_path;
typedef godot_rid itc_rid;
typedef godot_object itc_object;
typedef godot_dictionary itc_dictionary;
typedef godot_array itc_array;
typedef godot_pool_byte_array itc_pool_byte_array;
typedef godot_pool_int_array itc_pool_int_array;
typedef godot_pool_real_array itc_pool_real_array;
typedef godot_pool_string_array itc_pool_string_array;
typedef godot_pool_vector2_array itc_pool_vector2_array;
typedef godot_pool_vector3_array itc_pool_vector3_array;
typedef godot_pool_color_array itc_pool_color_array;

#define itc_variant_new(variant, value) api->_Generic((value) \
, itc_bool *: godot_variant_new_bool \
, itc_uint *: godot_variant_new_uint \
, itc_int *: godot_variant_new_int \
, itc_real *: godot_variant_new_real \
, itc_string *: godot_variant_new_string \
, itc_vector2 *: godot_variant_new_vector2 \
, itc_rect2 *: godot_variant_new_rect2 \
, itc_vector3 *: godot_variant_new_vector3 \
, itc_transform2d *: godot_variant_new_transform2d \
, itc_plane *: godot_variant_new_plane \
, itc_quat *: godot_variant_new_quat \
, itc_aabb *: godot_variant_new_aabb \
, itc_basis *: godot_variant_new_basis \
, itc_transform *: godot_variant_new_transform \
, itc_color *: godot_variant_new_color \
, itc_node_path *: godot_variant_new_node_path \
, itc_rid *: godot_variant_new_rid \
, itc_object *: godot_variant_new_object \
, itc_dictionary *: godot_variant_new_dictionary \
, itc_array *: godot_variant_new_array \
, itc_pool_byte_array *: godot_variant_new_pool_byte_array \
, itc_pool_int_array *: godot_variant_new_pool_int_array \
, itc_pool_real_array *: godot_variant_new_pool_real_array \
, itc_pool_string_array *: godot_variant_new_pool_string_array \
, itc_pool_vector2_array *: godot_variant_new_pool_vector2_array \
, itc_pool_vector3_array *: godot_variant_new_pool_vector3_array \
, itc_pool_color_array *: godot_variant_new_pool_color_array \
)(variant, value)

#define itc_variant_as_bool(self) api->godot_variant_as_bool(self)

#define itc_variant_as_uint(self) api->godot_variant_as_uint(self)

#define itc_variant_as_int(self) api->godot_variant_as_int(self)

#define itc_variant_as_real(self) api->godot_variant_as_real(self)

#define itc_variant_as_string(self) api->godot_variant_as_string(self)

#define itc_variant_as_vector2(self) api->godot_variant_as_vector2(self)

#define itc_variant_as_rect2(self) api->godot_variant_as_rect2(self)

#define itc_variant_as_vector3(self) api->godot_variant_as_vector3(self)

#define itc_variant_as_transform2d(self) api->godot_variant_as_transform2d(self)

#define itc_variant_as_plane(self) api->godot_variant_as_plane(self)

#define itc_variant_as_quat(self) api->godot_variant_as_quat(self)

#define itc_variant_as_aabb(self) api->godot_variant_as_aabb(self)

#define itc_variant_as_basis(self) api->godot_variant_as_basis(self)

#define itc_variant_as_transform(self) api->godot_variant_as_transform(self)

#define itc_variant_as_color(self) api->godot_variant_as_color(self)

#define itc_variant_as_node_path(self) api->godot_variant_as_node_path(self)

#define itc_variant_as_rid(self) api->godot_variant_as_rid(self)

#define itc_variant_as_object(self) api->godot_variant_as_object(self)

#define itc_variant_as_dictionary(self) api->godot_variant_as_dictionary(self)

#define itc_variant_as_array(self) api->godot_variant_as_array(self)

#define itc_variant_as_pool_byte_array(self) api->godot_variant_as_pool_byte_array(self)

#define itc_variant_as_pool_int_array(self) api->godot_variant_as_pool_int_array(self)

#define itc_variant_as_pool_real_array(self) api->godot_variant_as_pool_real_array(self)

#define itc_variant_as_pool_string_array(self) api->godot_variant_as_pool_string_array(self)

#define itc_variant_as_pool_vector2_array(self) api->godot_variant_as_pool_vector2_array(self)

#define itc_variant_as_pool_vector3_array(self) api->godot_variant_as_pool_vector3_array(self)

#define itc_variant_as_pool_color_array(self) api->godot_variant_as_pool_color_array(self)

static itc_bool itc_variant_to_bool(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_BOOL) {
        itc_print_error("Invalid type of variant");
    }
    itc_bool result = itc_variant_as_bool(self);
    itc_variant_destroy(self);
    return result;
}
static itc_uint itc_variant_to_uint(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_UINT) {
        itc_print_error("Invalid type of variant");
    }
    itc_uint result = itc_variant_as_uint(self);
    itc_variant_destroy(self);
    return result;
}
static itc_int itc_variant_to_int(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_INT) {
        itc_print_error("Invalid type of variant");
    }
    itc_int result = itc_variant_as_int(self);
    itc_variant_destroy(self);
    return result;
}
static itc_real itc_variant_to_real(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_REAL) {
        itc_print_error("Invalid type of variant");
    }
    itc_real result = itc_variant_as_real(self);
    itc_variant_destroy(self);
    return result;
}
static itc_string itc_variant_to_string(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_STRING) {
        itc_print_error("Invalid type of variant");
    }
    itc_string result = itc_variant_as_string(self);
    itc_variant_destroy(self);
    return result;
}
static itc_vector2 itc_variant_to_vector2(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_VECTOR2) {
        itc_print_error("Invalid type of variant");
    }
    itc_vector2 result = itc_variant_as_vector2(self);
    itc_variant_destroy(self);
    return result;
}
static itc_rect2 itc_variant_to_rect2(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_RECT2) {
        itc_print_error("Invalid type of variant");
    }
    itc_rect2 result = itc_variant_as_rect2(self);
    itc_variant_destroy(self);
    return result;
}
static itc_vector3 itc_variant_to_vector3(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_VECTOR3) {
        itc_print_error("Invalid type of variant");
    }
    itc_vector3 result = itc_variant_as_vector3(self);
    itc_variant_destroy(self);
    return result;
}
static itc_transform2d itc_variant_to_transform2d(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_TRANSFORM2D) {
        itc_print_error("Invalid type of variant");
    }
    itc_transform2d result = itc_variant_as_transform2d(self);
    itc_variant_destroy(self);
    return result;
}
static itc_plane itc_variant_to_plane(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_PLANE) {
        itc_print_error("Invalid type of variant");
    }
    itc_plane result = itc_variant_as_plane(self);
    itc_variant_destroy(self);
    return result;
}
static itc_quat itc_variant_to_quat(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_QUAT) {
        itc_print_error("Invalid type of variant");
    }
    itc_quat result = itc_variant_as_quat(self);
    itc_variant_destroy(self);
    return result;
}
static itc_aabb itc_variant_to_aabb(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_AABB) {
        itc_print_error("Invalid type of variant");
    }
    itc_aabb result = itc_variant_as_aabb(self);
    itc_variant_destroy(self);
    return result;
}
static itc_basis itc_variant_to_basis(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_BASIS) {
        itc_print_error("Invalid type of variant");
    }
    itc_basis result = itc_variant_as_basis(self);
    itc_variant_destroy(self);
    return result;
}
static itc_transform itc_variant_to_transform(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_TRANSFORM) {
        itc_print_error("Invalid type of variant");
    }
    itc_transform result = itc_variant_as_transform(self);
    itc_variant_destroy(self);
    return result;
}
static itc_color itc_variant_to_color(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_COLOR) {
        itc_print_error("Invalid type of variant");
    }
    itc_color result = itc_variant_as_color(self);
    itc_variant_destroy(self);
    return result;
}
static itc_node_path itc_variant_to_node_path(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_NODE_PATH) {
        itc_print_error("Invalid type of variant");
    }
    itc_node_path result = itc_variant_as_node_path(self);
    itc_variant_destroy(self);
    return result;
}
static itc_rid itc_variant_to_rid(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_RID) {
        itc_print_error("Invalid type of variant");
    }
    itc_rid result = itc_variant_as_rid(self);
    itc_variant_destroy(self);
    return result;
}
static itc_object itc_variant_to_object(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_OBJECT) {
        itc_print_error("Invalid type of variant");
    }
    itc_object result = itc_variant_as_object(self);
    itc_variant_destroy(self);
    return result;
}
static itc_dictionary itc_variant_to_dictionary(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_DICTIONARY) {
        itc_print_error("Invalid type of variant");
    }
    itc_dictionary result = itc_variant_as_dictionary(self);
    itc_variant_destroy(self);
    return result;
}
static itc_array itc_variant_to_array(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_ARRAY) {
        itc_print_error("Invalid type of variant");
    }
    itc_array result = itc_variant_as_array(self);
    itc_variant_destroy(self);
    return result;
}
static itc_pool_byte_array itc_variant_to_pool_byte_array(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_POOL_BYTE_ARRAY) {
        itc_print_error("Invalid type of variant");
    }
    itc_pool_byte_array result = itc_variant_as_pool_byte_array(self);
    itc_variant_destroy(self);
    return result;
}
static itc_pool_int_array itc_variant_to_pool_int_array(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_POOL_INT_ARRAY) {
        itc_print_error("Invalid type of variant");
    }
    itc_pool_int_array result = itc_variant_as_pool_int_array(self);
    itc_variant_destroy(self);
    return result;
}
static itc_pool_real_array itc_variant_to_pool_real_array(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_POOL_REAL_ARRAY) {
        itc_print_error("Invalid type of variant");
    }
    itc_pool_real_array result = itc_variant_as_pool_real_array(self);
    itc_variant_destroy(self);
    return result;
}
static itc_pool_string_array itc_variant_to_pool_string_array(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_POOL_STRING_ARRAY) {
        itc_print_error("Invalid type of variant");
    }
    itc_pool_string_array result = itc_variant_as_pool_string_array(self);
    itc_variant_destroy(self);
    return result;
}
static itc_pool_vector2_array itc_variant_to_pool_vector2_array(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_POOL_VECTOR2_ARRAY) {
        itc_print_error("Invalid type of variant");
    }
    itc_pool_vector2_array result = itc_variant_as_pool_vector2_array(self);
    itc_variant_destroy(self);
    return result;
}
static itc_pool_vector3_array itc_variant_to_pool_vector3_array(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_POOL_VECTOR3_ARRAY) {
        itc_print_error("Invalid type of variant");
    }
    itc_pool_vector3_array result = itc_variant_as_pool_vector3_array(self);
    itc_variant_destroy(self);
    return result;
}
static itc_pool_color_array itc_variant_to_pool_color_array(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_POOL_COLOR_ARRAY) {
        itc_print_error("Invalid type of variant");
    }
    itc_pool_color_array result = itc_variant_as_pool_color_array(self);
    itc_variant_destroy(self);
    return result;
}

#define itc_vector2_new(self, real_0, real_1) api->godot_vector2_new(self, real_0, real_1)

#define itc_vector2_as_string(self) api->godot_vector2_as_string(self)

#define itc_vector2_normalized(self) api->godot_vector2_normalized(self)

#define itc_vector2_length(self) api->godot_vector2_length(self)

#define itc_vector2_angle(self) api->godot_vector2_angle(self)

#define itc_vector2_length_squared(self) api->godot_vector2_length_squared(self)

#define itc_vector2_is_normalized(self) api->godot_vector2_is_normalized(self)

#define itc_vector2_direction_to(self, vector2_0) api->godot_vector2_direction_to(self, vector2_0)

#define itc_vector2_distance_to(self, vector2_0) api->godot_vector2_distance_to(self, vector2_0)

#define itc_vector2_distance_squared_to(self, vector2_0) api->godot_vector2_distance_squared_to(self, vector2_0)

#define itc_vector2_angle_to(self, vector2_0) api->godot_vector2_angle_to(self, vector2_0)

#define itc_vector2_angle_to_point(self, vector2_0) api->godot_vector2_angle_to_point(self, vector2_0)

#define itc_vector2_linear_interpolate(self, vector2_0, real_1) api->godot_vector2_linear_interpolate(self, vector2_0, real_1)

#define itc_vector2_cubic_interpolate(self, vector2_0, vector2_1, vector2_2, real_3) api->godot_vector2_cubic_interpolate(self, vector2_0, vector2_1, vector2_2, real_3)

#define itc_vector2_move_toward(self, vector2_0, real_1) api->godot_vector2_move_toward(self, vector2_0, real_1)

#define itc_vector2_rotated(self, real_0) api->godot_vector2_rotated(self, real_0)

#define itc_vector2_tangent(self) api->godot_vector2_tangent(self)

#define itc_vector2_floor(self) api->godot_vector2_floor(self)

#define itc_vector2_snapped(self, vector2_0) api->godot_vector2_snapped(self, vector2_0)

#define itc_vector2_aspect(self) api->godot_vector2_aspect(self)

#define itc_vector2_dot(self, vector2_0) api->godot_vector2_dot(self, vector2_0)

#define itc_vector2_slide(self, vector2_0) api->godot_vector2_slide(self, vector2_0)

#define itc_vector2_bounce(self, vector2_0) api->godot_vector2_bounce(self, vector2_0)

#define itc_vector2_reflect(self, vector2_0) api->godot_vector2_reflect(self, vector2_0)

#define itc_vector2_abs(self) api->godot_vector2_abs(self)

#define itc_vector2_clamped(self, real_0) api->godot_vector2_clamped(self, real_0)

#define itc_vector2_operator_add(self, vector2_0) api->godot_vector2_operator_add(self, vector2_0)

#define itc_vector2_operator_subtract(self, vector2_0) api->godot_vector2_operator_subtract(self, vector2_0)

#define itc_vector2_operator_multiply_vector(self, vector2_0) api->godot_vector2_operator_multiply_vector(self, vector2_0)

#define itc_vector2_operator_multiply_scalar(self, real_0) api->godot_vector2_operator_multiply_scalar(self, real_0)

#define itc_vector2_operator_divide_vector(self, vector2_0) api->godot_vector2_operator_divide_vector(self, vector2_0)

#define itc_vector2_operator_divide_scalar(self, real_0) api->godot_vector2_operator_divide_scalar(self, real_0)

#define itc_vector2_operator_equal(self, vector2_0) api->godot_vector2_operator_equal(self, vector2_0)

#define itc_vector2_operator_less(self, vector2_0) api->godot_vector2_operator_less(self, vector2_0)

#define itc_vector2_operator_neg(self) api->godot_vector2_operator_neg(self)

#define itc_vector2_set_x(self) api->godot_vector2_set_x(self)

#define itc_vector2_set_y(self) api->godot_vector2_set_y(self)

#define itc_vector2_get_x(self) api->godot_vector2_get_x(self)

#define itc_vector2_get_y(self) api->godot_vector2_get_y(self)

#define itc_pool_byte_array_new(self) api->godot_pool_byte_array_new(self)

#define itc_pool_byte_array_new_copy(self, pool_byte_array_0) api->godot_pool_byte_array_new_copy(self, pool_byte_array_0)

#define itc_pool_byte_array_new_with_array(self, array_0) api->godot_pool_byte_array_new_with_array(self, array_0)

#define itc_pool_byte_array_append(self, byte_0) api->godot_pool_byte_array_append(self, byte_0)

#define itc_pool_byte_array_append_array(self, pool_byte_array_0) api->godot_pool_byte_array_append_array(self, pool_byte_array_0)

#define itc_pool_byte_array_insert(self, int_0, byte_1) api->godot_pool_byte_array_insert(self, int_0, byte_1)

#define itc_pool_byte_array_invert(self) api->godot_pool_byte_array_invert(self)

#define itc_pool_byte_array_push_back(self, byte_0) api->godot_pool_byte_array_push_back(self, byte_0)

#define itc_pool_byte_array_remove(self, int_0) api->godot_pool_byte_array_remove(self, int_0)

#define itc_pool_byte_array_resize(self, int_0) api->godot_pool_byte_array_resize(self, int_0)

#define itc_pool_byte_array_sort(self) api->godot_pool_byte_array_sort(self)

#define itc_pool_byte_array_set(self, int_0, byte_1) api->godot_pool_byte_array_set(self, int_0, byte_1)

#define itc_pool_byte_array_get(self, int_0) api->godot_pool_byte_array_get(self, int_0)

#define itc_pool_byte_array_size(self) api->godot_pool_byte_array_size(self)

#define itc_pool_byte_array_empty(self) api->godot_pool_byte_array_empty(self)

#define itc_pool_byte_array_has(self, byte_0) api->godot_pool_byte_array_has(self, byte_0)

#define itc_pool_byte_array_destroy(self) api->godot_pool_byte_array_destroy(self)

#define itc_pool_int_array_new(self) api->godot_pool_int_array_new(self)

#define itc_pool_int_array_new_copy(self, pool_int_array_0) api->godot_pool_int_array_new_copy(self, pool_int_array_0)

#define itc_pool_int_array_new_with_array(self, array_0) api->godot_pool_int_array_new_with_array(self, array_0)

#define itc_pool_int_array_append(self, int_0) api->godot_pool_int_array_append(self, int_0)

#define itc_pool_int_array_append_array(self, pool_int_array_0) api->godot_pool_int_array_append_array(self, pool_int_array_0)

#define itc_pool_int_array_insert(self, int_0, int_1) api->godot_pool_int_array_insert(self, int_0, int_1)

#define itc_pool_int_array_invert(self) api->godot_pool_int_array_invert(self)

#define itc_pool_int_array_push_back(self, int_0) api->godot_pool_int_array_push_back(self, int_0)

#define itc_pool_int_array_remove(self, int_0) api->godot_pool_int_array_remove(self, int_0)

#define itc_pool_int_array_resize(self, int_0) api->godot_pool_int_array_resize(self, int_0)

#define itc_pool_int_array_sort(self) api->godot_pool_int_array_sort(self)

#define itc_pool_int_array_set(self, int_0, int_1) api->godot_pool_int_array_set(self, int_0, int_1)

#define itc_pool_int_array_get(self, int_0) api->godot_pool_int_array_get(self, int_0)

#define itc_pool_int_array_size(self) api->godot_pool_int_array_size(self)

#define itc_pool_int_array_empty(self) api->godot_pool_int_array_empty(self)

#define itc_pool_int_array_has(self, int_0) api->godot_pool_int_array_has(self, int_0)

#define itc_pool_int_array_destroy(self) api->godot_pool_int_array_destroy(self)

#define itc_pool_real_array_new(self) api->godot_pool_real_array_new(self)

#define itc_pool_real_array_new_copy(self, pool_real_array_0) api->godot_pool_real_array_new_copy(self, pool_real_array_0)

#define itc_pool_real_array_new_with_array(self, array_0) api->godot_pool_real_array_new_with_array(self, array_0)

#define itc_pool_real_array_append(self, real_0) api->godot_pool_real_array_append(self, real_0)

#define itc_pool_real_array_append_array(self, pool_real_array_0) api->godot_pool_real_array_append_array(self, pool_real_array_0)

#define itc_pool_real_array_insert(self, int_0, real_1) api->godot_pool_real_array_insert(self, int_0, real_1)

#define itc_pool_real_array_invert(self) api->godot_pool_real_array_invert(self)

#define itc_pool_real_array_push_back(self, real_0) api->godot_pool_real_array_push_back(self, real_0)

#define itc_pool_real_array_remove(self, int_0) api->godot_pool_real_array_remove(self, int_0)

#define itc_pool_real_array_resize(self, int_0) api->godot_pool_real_array_resize(self, int_0)

#define itc_pool_real_array_sort(self) api->godot_pool_real_array_sort(self)

#define itc_pool_real_array_set(self, int_0, real_1) api->godot_pool_real_array_set(self, int_0, real_1)

#define itc_pool_real_array_get(self, int_0) api->godot_pool_real_array_get(self, int_0)

#define itc_pool_real_array_size(self) api->godot_pool_real_array_size(self)

#define itc_pool_real_array_empty(self) api->godot_pool_real_array_empty(self)

#define itc_pool_real_array_has(self, real_0) api->godot_pool_real_array_has(self, real_0)

#define itc_pool_real_array_destroy(self) api->godot_pool_real_array_destroy(self)

#define itc_pool_string_array_new(self) api->godot_pool_string_array_new(self)

#define itc_pool_string_array_new_copy(self, pool_string_array_0) api->godot_pool_string_array_new_copy(self, pool_string_array_0)

#define itc_pool_string_array_new_with_array(self, array_0) api->godot_pool_string_array_new_with_array(self, array_0)

#define itc_pool_string_array_append(self, string_0) api->godot_pool_string_array_append(self, string_0)

#define itc_pool_string_array_append_array(self, pool_string_array_0) api->godot_pool_string_array_append_array(self, pool_string_array_0)

#define itc_pool_string_array_insert(self, int_0, string_1) api->godot_pool_string_array_insert(self, int_0, string_1)

#define itc_pool_string_array_invert(self) api->godot_pool_string_array_invert(self)

#define itc_pool_string_array_push_back(self, string_0) api->godot_pool_string_array_push_back(self, string_0)

#define itc_pool_string_array_remove(self, int_0) api->godot_pool_string_array_remove(self, int_0)

#define itc_pool_string_array_resize(self, int_0) api->godot_pool_string_array_resize(self, int_0)

#define itc_pool_string_array_sort(self) api->godot_pool_string_array_sort(self)

#define itc_pool_string_array_set(self, int_0, string_1) api->godot_pool_string_array_set(self, int_0, string_1)

#define itc_pool_string_array_get(self, int_0) api->godot_pool_string_array_get(self, int_0)

#define itc_pool_string_array_size(self) api->godot_pool_string_array_size(self)

#define itc_pool_string_array_empty(self) api->godot_pool_string_array_empty(self)

#define itc_pool_string_array_has(self, string_0) api->godot_pool_string_array_has(self, string_0)

#define itc_pool_string_array_destroy(self) api->godot_pool_string_array_destroy(self)

#define itc_pool_vector2_array_new(self) api->godot_pool_vector2_array_new(self)

#define itc_pool_vector2_array_new_copy(self, pool_vector2_array_0) api->godot_pool_vector2_array_new_copy(self, pool_vector2_array_0)

#define itc_pool_vector2_array_new_with_array(self, array_0) api->godot_pool_vector2_array_new_with_array(self, array_0)

#define itc_pool_vector2_array_append(self, vector2_0) api->godot_pool_vector2_array_append(self, vector2_0)

#define itc_pool_vector2_array_append_array(self, pool_vector2_array_0) api->godot_pool_vector2_array_append_array(self, pool_vector2_array_0)

#define itc_pool_vector2_array_insert(self, int_0, vector2_1) api->godot_pool_vector2_array_insert(self, int_0, vector2_1)

#define itc_pool_vector2_array_invert(self) api->godot_pool_vector2_array_invert(self)

#define itc_pool_vector2_array_push_back(self, vector2_0) api->godot_pool_vector2_array_push_back(self, vector2_0)

#define itc_pool_vector2_array_remove(self, int_0) api->godot_pool_vector2_array_remove(self, int_0)

#define itc_pool_vector2_array_resize(self, int_0) api->godot_pool_vector2_array_resize(self, int_0)

#define itc_pool_vector2_array_sort(self) api->godot_pool_vector2_array_sort(self)

#define itc_pool_vector2_array_set(self, int_0, vector2_1) api->godot_pool_vector2_array_set(self, int_0, vector2_1)

#define itc_pool_vector2_array_get(self, int_0) api->godot_pool_vector2_array_get(self, int_0)

#define itc_pool_vector2_array_size(self) api->godot_pool_vector2_array_size(self)

#define itc_pool_vector2_array_empty(self) api->godot_pool_vector2_array_empty(self)

#define itc_pool_vector2_array_has(self, vector2_0) api->godot_pool_vector2_array_has(self, vector2_0)

#define itc_pool_vector2_array_destroy(self) api->godot_pool_vector2_array_destroy(self)

#define itc_pool_vector3_array_new(self) api->godot_pool_vector3_array_new(self)

#define itc_pool_vector3_array_new_copy(self, pool_vector3_array_0) api->godot_pool_vector3_array_new_copy(self, pool_vector3_array_0)

#define itc_pool_vector3_array_new_with_array(self, array_0) api->godot_pool_vector3_array_new_with_array(self, array_0)

#define itc_pool_vector3_array_append(self, vector3_0) api->godot_pool_vector3_array_append(self, vector3_0)

#define itc_pool_vector3_array_append_array(self, pool_vector3_array_0) api->godot_pool_vector3_array_append_array(self, pool_vector3_array_0)

#define itc_pool_vector3_array_insert(self, int_0, vector3_1) api->godot_pool_vector3_array_insert(self, int_0, vector3_1)

#define itc_pool_vector3_array_invert(self) api->godot_pool_vector3_array_invert(self)

#define itc_pool_vector3_array_push_back(self, vector3_0) api->godot_pool_vector3_array_push_back(self, vector3_0)

#define itc_pool_vector3_array_remove(self, int_0) api->godot_pool_vector3_array_remove(self, int_0)

#define itc_pool_vector3_array_resize(self, int_0) api->godot_pool_vector3_array_resize(self, int_0)

#define itc_pool_vector3_array_sort(self) api->godot_pool_vector3_array_sort(self)

#define itc_pool_vector3_array_set(self, int_0, vector3_1) api->godot_pool_vector3_array_set(self, int_0, vector3_1)

#define itc_pool_vector3_array_get(self, int_0) api->godot_pool_vector3_array_get(self, int_0)

#define itc_pool_vector3_array_size(self) api->godot_pool_vector3_array_size(self)

#define itc_pool_vector3_array_empty(self) api->godot_pool_vector3_array_empty(self)

#define itc_pool_vector3_array_has(self, vector3_0) api->godot_pool_vector3_array_has(self, vector3_0)

#define itc_pool_vector3_array_destroy(self) api->godot_pool_vector3_array_destroy(self)

#define itc_pool_color_array_new(self) api->godot_pool_color_array_new(self)

#define itc_pool_color_array_new_copy(self, pool_color_array_0) api->godot_pool_color_array_new_copy(self, pool_color_array_0)

#define itc_pool_color_array_new_with_array(self, array_0) api->godot_pool_color_array_new_with_array(self, array_0)

#define itc_pool_color_array_append(self, color_0) api->godot_pool_color_array_append(self, color_0)

#define itc_pool_color_array_append_array(self, pool_color_array_0) api->godot_pool_color_array_append_array(self, pool_color_array_0)

#define itc_pool_color_array_insert(self, int_0, color_1) api->godot_pool_color_array_insert(self, int_0, color_1)

#define itc_pool_color_array_invert(self) api->godot_pool_color_array_invert(self)

#define itc_pool_color_array_push_back(self, color_0) api->godot_pool_color_array_push_back(self, color_0)

#define itc_pool_color_array_remove(self, int_0) api->godot_pool_color_array_remove(self, int_0)

#define itc_pool_color_array_resize(self, int_0) api->godot_pool_color_array_resize(self, int_0)

#define itc_pool_color_array_sort(self) api->godot_pool_color_array_sort(self)

#define itc_pool_color_array_set(self, int_0, color_1) api->godot_pool_color_array_set(self, int_0, color_1)

#define itc_pool_color_array_get(self, int_0) api->godot_pool_color_array_get(self, int_0)

#define itc_pool_color_array_size(self) api->godot_pool_color_array_size(self)

#define itc_pool_color_array_empty(self) api->godot_pool_color_array_empty(self)

#define itc_pool_color_array_has(self, color_0) api->godot_pool_color_array_has(self, color_0)

#define itc_pool_color_array_destroy(self) api->godot_pool_color_array_destroy(self)

