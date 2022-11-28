#pragma once

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
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_BOOL)
        itc_print_error("Invalid type of variant");
    itc_bool result = itc_variant_as_bool(self);
    itc_variant_destroy(self);
    return result;
}
static itc_uint itc_variant_to_uint(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_UINT)
        itc_print_error("Invalid type of variant");
    itc_uint result = itc_variant_as_uint(self);
    itc_variant_destroy(self);
    return result;
}
static itc_int itc_variant_to_int(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_INT)
        itc_print_error("Invalid type of variant");
    itc_int result = itc_variant_as_int(self);
    itc_variant_destroy(self);
    return result;
}
static itc_real itc_variant_to_real(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_REAL)
        itc_print_error("Invalid type of variant");
    itc_real result = itc_variant_as_real(self);
    itc_variant_destroy(self);
    return result;
}
static itc_string itc_variant_to_string(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_STRING)
        itc_print_error("Invalid type of variant");
    itc_string result = itc_variant_as_string(self);
    itc_variant_destroy(self);
    return result;
}
static itc_vector2 itc_variant_to_vector2(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_VECTOR2)
        itc_print_error("Invalid type of variant");
    itc_vector2 result = itc_variant_as_vector2(self);
    itc_variant_destroy(self);
    return result;
}
static itc_rect2 itc_variant_to_rect2(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_RECT2)
        itc_print_error("Invalid type of variant");
    itc_rect2 result = itc_variant_as_rect2(self);
    itc_variant_destroy(self);
    return result;
}
static itc_vector3 itc_variant_to_vector3(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_VECTOR3)
        itc_print_error("Invalid type of variant");
    itc_vector3 result = itc_variant_as_vector3(self);
    itc_variant_destroy(self);
    return result;
}
static itc_transform2d itc_variant_to_transform2d(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_TRANSFORM2D)
        itc_print_error("Invalid type of variant");
    itc_transform2d result = itc_variant_as_transform2d(self);
    itc_variant_destroy(self);
    return result;
}
static itc_plane itc_variant_to_plane(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_PLANE)
        itc_print_error("Invalid type of variant");
    itc_plane result = itc_variant_as_plane(self);
    itc_variant_destroy(self);
    return result;
}
static itc_quat itc_variant_to_quat(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_QUAT)
        itc_print_error("Invalid type of variant");
    itc_quat result = itc_variant_as_quat(self);
    itc_variant_destroy(self);
    return result;
}
static itc_aabb itc_variant_to_aabb(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_AABB)
        itc_print_error("Invalid type of variant");
    itc_aabb result = itc_variant_as_aabb(self);
    itc_variant_destroy(self);
    return result;
}
static itc_basis itc_variant_to_basis(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_BASIS)
        itc_print_error("Invalid type of variant");
    itc_basis result = itc_variant_as_basis(self);
    itc_variant_destroy(self);
    return result;
}
static itc_transform itc_variant_to_transform(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_TRANSFORM)
        itc_print_error("Invalid type of variant");
    itc_transform result = itc_variant_as_transform(self);
    itc_variant_destroy(self);
    return result;
}
static itc_color itc_variant_to_color(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_COLOR)
        itc_print_error("Invalid type of variant");
    itc_color result = itc_variant_as_color(self);
    itc_variant_destroy(self);
    return result;
}
static itc_node_path itc_variant_to_node_path(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_NODE_PATH)
        itc_print_error("Invalid type of variant");
    itc_node_path result = itc_variant_as_node_path(self);
    itc_variant_destroy(self);
    return result;
}
static itc_rid itc_variant_to_rid(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_RID)
        itc_print_error("Invalid type of variant");
    itc_rid result = itc_variant_as_rid(self);
    itc_variant_destroy(self);
    return result;
}
static itc_object itc_variant_to_object(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_OBJECT)
        itc_print_error("Invalid type of variant");
    itc_object result = itc_variant_as_object(self);
    itc_variant_destroy(self);
    return result;
}
static itc_dictionary itc_variant_to_dictionary(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_DICTIONARY)
        itc_print_error("Invalid type of variant");
    itc_dictionary result = itc_variant_as_dictionary(self);
    itc_variant_destroy(self);
    return result;
}
static itc_array itc_variant_to_array(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_ARRAY)
        itc_print_error("Invalid type of variant");
    itc_array result = itc_variant_as_array(self);
    itc_variant_destroy(self);
    return result;
}
static itc_pool_byte_array itc_variant_to_pool_byte_array(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_POOL_BYTE_ARRAY)
        itc_print_error("Invalid type of variant");
    itc_pool_byte_array result = itc_variant_as_pool_byte_array(self);
    itc_variant_destroy(self);
    return result;
}
static itc_pool_int_array itc_variant_to_pool_int_array(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_POOL_INT_ARRAY)
        itc_print_error("Invalid type of variant");
    itc_pool_int_array result = itc_variant_as_pool_int_array(self);
    itc_variant_destroy(self);
    return result;
}
static itc_pool_real_array itc_variant_to_pool_real_array(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_POOL_REAL_ARRAY)
        itc_print_error("Invalid type of variant");
    itc_pool_real_array result = itc_variant_as_pool_real_array(self);
    itc_variant_destroy(self);
    return result;
}
static itc_pool_string_array itc_variant_to_pool_string_array(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_POOL_STRING_ARRAY)
        itc_print_error("Invalid type of variant");
    itc_pool_string_array result = itc_variant_as_pool_string_array(self);
    itc_variant_destroy(self);
    return result;
}
static itc_pool_vector2_array itc_variant_to_pool_vector2_array(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_POOL_VECTOR2_ARRAY)
        itc_print_error("Invalid type of variant");
    itc_pool_vector2_array result = itc_variant_as_pool_vector2_array(self);
    itc_variant_destroy(self);
    return result;
}
static itc_pool_vector3_array itc_variant_to_pool_vector3_array(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_POOL_VECTOR3_ARRAY)
        itc_print_error("Invalid type of variant");
    itc_pool_vector3_array result = itc_variant_as_pool_vector3_array(self);
    itc_variant_destroy(self);
    return result;
}
static itc_pool_color_array itc_variant_to_pool_color_array(itc_variant *self) {
    if (itc_variant_get_type(self) != GODOT_VARIANT_TYPE_POOL_COLOR_ARRAY)
        itc_print_error("Invalid type of variant");
    itc_pool_color_array result = itc_variant_as_pool_color_array(self);
    itc_variant_destroy(self);
    return result;
}

#define itc_vector2_new(self, real0, real1) api->godot_vector2_new(self, real0, real1)

#define itc_vector2_as_string(self) api->godot_vector2_as_string(self)

#define itc_vector2_normalized(self) api->godot_vector2_normalized(self)

#define itc_vector2_length(self) api->godot_vector2_length(self)

#define itc_vector2_angle(self) api->godot_vector2_angle(self)

#define itc_vector2_length_squared(self) api->godot_vector2_length_squared(self)

#define itc_vector2_is_normalized(self) api->godot_vector2_is_normalized(self)

#define itc_vector2_direction_to(self, vector20) api->godot_vector2_direction_to(self, vector20)

#define itc_vector2_distance_to(self, vector20) api->godot_vector2_distance_to(self, vector20)

#define itc_vector2_distance_squared_to(self, vector20) api->godot_vector2_distance_squared_to(self, vector20)

#define itc_vector2_angle_to(self, vector20) api->godot_vector2_angle_to(self, vector20)

#define itc_vector2_angle_to_point(self, vector20) api->godot_vector2_angle_to_point(self, vector20)

#define itc_vector2_linear_interpolate(self, vector20, real1) api->godot_vector2_linear_interpolate(self, vector20, real1)

#define itc_vector2_cubic_interpolate(self, vector20, vector21, vector22, real3) api->godot_vector2_cubic_interpolate(self, vector20, vector21, vector22, real3)

#define itc_vector2_move_toward(self, vector20, real1) api->godot_vector2_move_toward(self, vector20, real1)

#define itc_vector2_rotated(self, real0) api->godot_vector2_rotated(self, real0)

#define itc_vector2_tangent(self) api->godot_vector2_tangent(self)

#define itc_vector2_floor(self) api->godot_vector2_floor(self)

#define itc_vector2_snapped(self, vector20) api->godot_vector2_snapped(self, vector20)

#define itc_vector2_aspect(self) api->godot_vector2_aspect(self)

#define itc_vector2_dot(self, vector20) api->godot_vector2_dot(self, vector20)

#define itc_vector2_slide(self, vector20) api->godot_vector2_slide(self, vector20)

#define itc_vector2_bounce(self, vector20) api->godot_vector2_bounce(self, vector20)

#define itc_vector2_reflect(self, vector20) api->godot_vector2_reflect(self, vector20)

#define itc_vector2_abs(self) api->godot_vector2_abs(self)

#define itc_vector2_clamped(self, real0) api->godot_vector2_clamped(self, real0)

#define itc_vector2_operator_add(self, vector20) api->godot_vector2_operator_add(self, vector20)

#define itc_vector2_operator_subtract(self, vector20) api->godot_vector2_operator_subtract(self, vector20)

#define itc_vector2_operator_multiply_vector(self, vector20) api->godot_vector2_operator_multiply_vector(self, vector20)

#define itc_vector2_operator_multiply_scalar(self, real0) api->godot_vector2_operator_multiply_scalar(self, real0)

#define itc_vector2_operator_divide_vector(self, vector20) api->godot_vector2_operator_divide_vector(self, vector20)

#define itc_vector2_operator_divide_scalar(self, real0) api->godot_vector2_operator_divide_scalar(self, real0)

#define itc_vector2_operator_equal(self, vector20) api->godot_vector2_operator_equal(self, vector20)

#define itc_vector2_operator_less(self, vector20) api->godot_vector2_operator_less(self, vector20)

#define itc_vector2_operator_neg(self) api->godot_vector2_operator_neg(self)

#define itc_vector2_set_x(self) api->godot_vector2_set_x(self)

#define itc_vector2_set_y(self) api->godot_vector2_set_y(self)

#define itc_vector2_get_x(self) api->godot_vector2_get_x(self)

#define itc_vector2_get_y(self) api->godot_vector2_get_y(self)

#define itc_array_new(self) api->_Generic((self) \
, itc_array *: godot_array_new \
, itc_pool_byte_array *: godot_pool_byte_array_new \
, itc_pool_int_array *: godot_pool_int_array_new \
, itc_pool_real_array *: godot_pool_real_array_new \
, itc_pool_string_array *: godot_pool_string_array_new \
, itc_pool_vector2_array *: godot_pool_vector2_array_new \
, itc_pool_vector3_array *: godot_pool_vector3_array_new \
, itc_pool_color_array *: godot_pool_color_array_new \
)(self)

#define itc_array_new_copy(self, other0) api->_Generic((self) \
, itc_array *: godot_array_new_copy \
, itc_pool_byte_array *: godot_pool_byte_array_new_copy \
, itc_pool_int_array *: godot_pool_int_array_new_copy \
, itc_pool_real_array *: godot_pool_real_array_new_copy \
, itc_pool_string_array *: godot_pool_string_array_new_copy \
, itc_pool_vector2_array *: godot_pool_vector2_array_new_copy \
, itc_pool_vector3_array *: godot_pool_vector3_array_new_copy \
, itc_pool_color_array *: godot_pool_color_array_new_copy \
)(self, other0)

#define itc_array_append(self, item0) api->_Generic((self) \
, itc_array *: godot_array_append \
, itc_pool_byte_array *: godot_pool_byte_array_append \
, itc_pool_int_array *: godot_pool_int_array_append \
, itc_pool_real_array *: godot_pool_real_array_append \
, itc_pool_string_array *: godot_pool_string_array_append \
, itc_pool_vector2_array *: godot_pool_vector2_array_append \
, itc_pool_vector3_array *: godot_pool_vector3_array_append \
, itc_pool_color_array *: godot_pool_color_array_append \
)(self, item0)

#define itc_array_insert(self, int0, item1) api->_Generic((self) \
, itc_array *: godot_array_insert \
, itc_pool_byte_array *: godot_pool_byte_array_insert \
, itc_pool_int_array *: godot_pool_int_array_insert \
, itc_pool_real_array *: godot_pool_real_array_insert \
, itc_pool_string_array *: godot_pool_string_array_insert \
, itc_pool_vector2_array *: godot_pool_vector2_array_insert \
, itc_pool_vector3_array *: godot_pool_vector3_array_insert \
, itc_pool_color_array *: godot_pool_color_array_insert \
)(self, int0, item1)

#define itc_array_invert(self) api->_Generic((self) \
, itc_array *: godot_array_invert \
, itc_pool_byte_array *: godot_pool_byte_array_invert \
, itc_pool_int_array *: godot_pool_int_array_invert \
, itc_pool_real_array *: godot_pool_real_array_invert \
, itc_pool_string_array *: godot_pool_string_array_invert \
, itc_pool_vector2_array *: godot_pool_vector2_array_invert \
, itc_pool_vector3_array *: godot_pool_vector3_array_invert \
, itc_pool_color_array *: godot_pool_color_array_invert \
)(self)

#define itc_array_push_back(self, item0) api->_Generic((self) \
, itc_array *: godot_array_push_back \
, itc_pool_byte_array *: godot_pool_byte_array_push_back \
, itc_pool_int_array *: godot_pool_int_array_push_back \
, itc_pool_real_array *: godot_pool_real_array_push_back \
, itc_pool_string_array *: godot_pool_string_array_push_back \
, itc_pool_vector2_array *: godot_pool_vector2_array_push_back \
, itc_pool_vector3_array *: godot_pool_vector3_array_push_back \
, itc_pool_color_array *: godot_pool_color_array_push_back \
)(self, item0)

#define itc_array_remove(self, int0) api->_Generic((self) \
, itc_array *: godot_array_remove \
, itc_pool_byte_array *: godot_pool_byte_array_remove \
, itc_pool_int_array *: godot_pool_int_array_remove \
, itc_pool_real_array *: godot_pool_real_array_remove \
, itc_pool_string_array *: godot_pool_string_array_remove \
, itc_pool_vector2_array *: godot_pool_vector2_array_remove \
, itc_pool_vector3_array *: godot_pool_vector3_array_remove \
, itc_pool_color_array *: godot_pool_color_array_remove \
)(self, int0)

#define itc_array_resize(self, int0) api->_Generic((self) \
, itc_array *: godot_array_resize \
, itc_pool_byte_array *: godot_pool_byte_array_resize \
, itc_pool_int_array *: godot_pool_int_array_resize \
, itc_pool_real_array *: godot_pool_real_array_resize \
, itc_pool_string_array *: godot_pool_string_array_resize \
, itc_pool_vector2_array *: godot_pool_vector2_array_resize \
, itc_pool_vector3_array *: godot_pool_vector3_array_resize \
, itc_pool_color_array *: godot_pool_color_array_resize \
)(self, int0)

#define itc_array_sort(self) api->_Generic((self) \
, itc_array *: godot_array_sort \
, itc_pool_byte_array *: godot_pool_byte_array_sort \
, itc_pool_int_array *: godot_pool_int_array_sort \
, itc_pool_real_array *: godot_pool_real_array_sort \
, itc_pool_string_array *: godot_pool_string_array_sort \
, itc_pool_vector2_array *: godot_pool_vector2_array_sort \
, itc_pool_vector3_array *: godot_pool_vector3_array_sort \
, itc_pool_color_array *: godot_pool_color_array_sort \
)(self)

#define itc_array_set(self, int0, item1) api->_Generic((self) \
, itc_array *: godot_array_set \
, itc_pool_byte_array *: godot_pool_byte_array_set \
, itc_pool_int_array *: godot_pool_int_array_set \
, itc_pool_real_array *: godot_pool_real_array_set \
, itc_pool_string_array *: godot_pool_string_array_set \
, itc_pool_vector2_array *: godot_pool_vector2_array_set \
, itc_pool_vector3_array *: godot_pool_vector3_array_set \
, itc_pool_color_array *: godot_pool_color_array_set \
)(self, int0, item1)

#define itc_array_get(self, int0) api->_Generic((self) \
, itc_array *: godot_array_get \
, itc_pool_byte_array *: godot_pool_byte_array_get \
, itc_pool_int_array *: godot_pool_int_array_get \
, itc_pool_real_array *: godot_pool_real_array_get \
, itc_pool_string_array *: godot_pool_string_array_get \
, itc_pool_vector2_array *: godot_pool_vector2_array_get \
, itc_pool_vector3_array *: godot_pool_vector3_array_get \
, itc_pool_color_array *: godot_pool_color_array_get \
)(self, int0)

#define itc_array_size(self) api->_Generic((self) \
, itc_array *: godot_array_size \
, itc_pool_byte_array *: godot_pool_byte_array_size \
, itc_pool_int_array *: godot_pool_int_array_size \
, itc_pool_real_array *: godot_pool_real_array_size \
, itc_pool_string_array *: godot_pool_string_array_size \
, itc_pool_vector2_array *: godot_pool_vector2_array_size \
, itc_pool_vector3_array *: godot_pool_vector3_array_size \
, itc_pool_color_array *: godot_pool_color_array_size \
)(self)

#define itc_array_empty(self) api->_Generic((self) \
, itc_array *: godot_array_empty \
, itc_pool_byte_array *: godot_pool_byte_array_empty \
, itc_pool_int_array *: godot_pool_int_array_empty \
, itc_pool_real_array *: godot_pool_real_array_empty \
, itc_pool_string_array *: godot_pool_string_array_empty \
, itc_pool_vector2_array *: godot_pool_vector2_array_empty \
, itc_pool_vector3_array *: godot_pool_vector3_array_empty \
, itc_pool_color_array *: godot_pool_color_array_empty \
)(self)

#define itc_array_has(self, item0) api->_Generic((self) \
, itc_array *: godot_array_has \
, itc_pool_byte_array *: godot_pool_byte_array_has \
, itc_pool_int_array *: godot_pool_int_array_has \
, itc_pool_real_array *: godot_pool_real_array_has \
, itc_pool_string_array *: godot_pool_string_array_has \
, itc_pool_vector2_array *: godot_pool_vector2_array_has \
, itc_pool_vector3_array *: godot_pool_vector3_array_has \
, itc_pool_color_array *: godot_pool_color_array_has \
)(self, item0)

typedef godot_pool_byte_array_read_access itc_pool_byte_array_reader;
typedef godot_pool_byte_array_read_access itc_pool_byte_array_writer;

typedef godot_pool_int_array_read_access itc_pool_int_array_reader;
typedef godot_pool_int_array_read_access itc_pool_int_array_writer;

typedef godot_pool_real_array_read_access itc_pool_real_array_reader;
typedef godot_pool_real_array_read_access itc_pool_real_array_writer;

typedef godot_pool_string_array_read_access itc_pool_string_array_reader;
typedef godot_pool_string_array_read_access itc_pool_string_array_writer;

typedef godot_pool_vector2_array_read_access itc_pool_vector2_array_reader;
typedef godot_pool_vector2_array_read_access itc_pool_vector2_array_writer;

typedef godot_pool_vector3_array_read_access itc_pool_vector3_array_reader;
typedef godot_pool_vector3_array_read_access itc_pool_vector3_array_writer;

typedef godot_pool_color_array_read_access itc_pool_color_array_reader;
typedef godot_pool_color_array_read_access itc_pool_color_array_writer;

#define itc_array_new_reader(array) api->_Generic((array) \
, itc_pool_byte_array *: godot_pool_byte_array_read \
, itc_pool_int_array *: godot_pool_int_array_read \
, itc_pool_real_array *: godot_pool_real_array_read \
, itc_pool_string_array *: godot_pool_string_array_read \
, itc_pool_vector2_array *: godot_pool_vector2_array_read \
, itc_pool_vector3_array *: godot_pool_vector3_array_read \
, itc_pool_color_array *: godot_pool_color_array_read \
)(array)

#define itc_reader_get_ptr(reader) api->_Generic((reader) \
, itc_pool_byte_array_reader *: godot_pool_byte_array_read_access_ptr \
, itc_pool_int_array_reader *: godot_pool_int_array_read_access_ptr \
, itc_pool_real_array_reader *: godot_pool_real_array_read_access_ptr \
, itc_pool_string_array_reader *: godot_pool_string_array_read_access_ptr \
, itc_pool_vector2_array_reader *: godot_pool_vector2_array_read_access_ptr \
, itc_pool_vector3_array_reader *: godot_pool_vector3_array_read_access_ptr \
, itc_pool_color_array_reader *: godot_pool_color_array_read_access_ptr \
)(reader)

#define itc_array_new_writer(array) api->_Generic((array) \
, itc_pool_byte_array *: godot_pool_byte_array_write \
, itc_pool_int_array *: godot_pool_int_array_write \
, itc_pool_real_array *: godot_pool_real_array_write \
, itc_pool_string_array *: godot_pool_string_array_write \
, itc_pool_vector2_array *: godot_pool_vector2_array_write \
, itc_pool_vector3_array *: godot_pool_vector3_array_write \
, itc_pool_color_array *: godot_pool_color_array_write \
)(array)

#define itc_destroy(object) api->_Generic((object) \
, itc_variant *: godot_variant_destroy \
, itc_dictionary *: godot_dictionary_destroy \
, itc_string *: godot_string_destroy \
, itc_string_name *: godot_string_name_destroy \
, itc_char_string *: godot_char_string_destroy \
, itc_object *: godot_object_destroy \
, itc_node_path *: godot_node_path_destroy \
, itc_array *: godot_array_destroy \
, itc_pool_byte_array *: godot_pool_byte_array_destroy \
, itc_pool_int_array *: godot_pool_int_array_destroy \
, itc_pool_real_array *: godot_pool_real_array_destroy \
, itc_pool_string_array *: godot_pool_string_array_destroy \
, itc_pool_vector2_array *: godot_pool_vector2_array_destroy \
, itc_pool_vector3_array *: godot_pool_vector3_array_destroy \
, itc_pool_color_array *: godot_pool_color_array_destroy \
, itc_pool_byte_array_reader *: godot_pool_byte_array_read_access_destroy \
, itc_pool_byte_array_writer *: godot_pool_byte_array_write_access_destroy \
, itc_pool_int_array_reader *: godot_pool_int_array_read_access_destroy \
, itc_pool_int_array_writer *: godot_pool_int_array_write_access_destroy \
, itc_pool_real_array_reader *: godot_pool_real_array_read_access_destroy \
, itc_pool_real_array_writer *: godot_pool_real_array_write_access_destroy \
, itc_pool_string_array_reader *: godot_pool_string_array_read_access_destroy \
, itc_pool_string_array_writer *: godot_pool_string_array_write_access_destroy \
, itc_pool_vector2_array_reader *: godot_pool_vector2_array_read_access_destroy \
, itc_pool_vector2_array_writer *: godot_pool_vector2_array_write_access_destroy \
, itc_pool_vector3_array_reader *: godot_pool_vector3_array_read_access_destroy \
, itc_pool_vector3_array_writer *: godot_pool_vector3_array_write_access_destroy \
, itc_pool_color_array_reader *: godot_pool_color_array_read_access_destroy \
, itc_pool_color_array_writer *: godot_pool_color_array_write_access_destroy \
)(object)

