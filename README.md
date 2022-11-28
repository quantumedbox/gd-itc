# gd-itc Native Library Building Plugin
Interface agnostic way of writing Godot native libraries using GDScript
with aim to create the easiest way of creating C libraries, both for developers and deployers of libraries

! WIP, it's expected that compatibility will break often

## Goals
- Full integration of Godot, no need to care for user about anything else
- No external dependencies except Godot itself, godot-headers repository and C11 compiler
- GDNative and GDExtension agnostic, meaning that your library/wrapper could be supported by 3.x and 4.x versions of Godot without any changes (or handled with conditional compilation in more complex cases)

## How to use
- Clone this repo
- Get godot-headers via: `git submodule update --init --recursive`
- Copy `addons` folder to your project
