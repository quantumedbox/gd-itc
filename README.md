# gd-inter-c Native Library Building Plugin
Interface agnostic way of writing Godot native libraries using GDScript
with aim to create the easiest way for creating C libraries, both for developers and deployers of libraries

! WIP, it's expected that compatibility will break often

## Main points
- No external dependencies except Godot itself, godot-headers repository and C compiler
- GDNative and GDExtension agnostic, meaning that your library/wrapper could be supported by 3.x and 4.x versions of Godot without any changes (or handled with conditional compilation in more complex cases)
- Automatic compiler resolution on export and running of project in editor. It's especially helpful for developers under Windows as no C compiler is provided there by default (uses Bellard's TCC)

## Caveats
- APIs of GDNative and GDExtension are not 1 to 1 equal, so we aren't able to just wrap, some functionalities are interface specific, and you might need to handle it by hand (for now)

```GDScript
extends NativeLibrary

func _init() -> void:
    name = "gd-libopenmpt"
    version = "0.1"

    link_dynamic_library("libopenmpt")
    include_header("libopenmpt/libopenmpt.h")

    var tracker = add_class(
        "Tracker", Node
        # User data fields, used for defining class' user data struct
        ["module", "openmpt*"])

    tracker.add_method(
        "play_module",
        [["path", String]],
        tracker_play_module_source)

    # Class which will be represented by NativeScript instance
    root_class = tracker

# `add_method()` will generate prelude to enforce parameter count and conversion to types from variants, local variable names will be the same
# Symbol `data` will be included as cast from `void *p_user_data` to user data struct
const tracker_play_module_source = """
    godot_char_string filepath = interc_string_to_ascii(path);
    data->module = openmpt_module_create_whatever(/* */);
"""
```
