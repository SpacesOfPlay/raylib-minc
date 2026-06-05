#!/usr/bin/env bash
# build.sh — build (and run) a raylib-minc example on Linux/macOS.
#
# Usage:
#   ./build.sh                          # build + run examples/core/core_basic_window.mc
#   ./build.sh <path-to-main.mc>        # build + run any .mc file
#   ./build.sh <path-to-main.mc> --no-run  # just compile, don't run
#
# Your `.mc` file just writes:
#
#   import raylib;
#   i32 main() { InitWindow(...); ... }
#
# The binary is named after the .mc file's stem. If the .mc sits
# next to a `resources/` subdir, that subdir is mirrored into
# `build/` so relative `LoadImage("resources/...")` calls resolve.
# GLFW resolves from the system package (`libglfw.so.3` / `libglfw.3.dylib`).

set -e

src="${1:-}"
no_run=0
if [ "${2:-}" = "--no-run" ]; then no_run=1; fi
if [ "$src" = "--no-run" ]; then src=""; no_run=1; fi

root="$(cd "$(dirname "$0")" && pwd)"

# No argument → run the canonical hello-window example. Self-contained
# (no assets, no codecs) so it'll always work on a fresh clone; serves
# as the smoke-test for "does this dist work".
default_example="examples/core/core_basic_window.mc"
if [ -z "$src" ]; then
    src="$default_example"
    echo "no source given — running default example: $src"
    echo "  other examples:"
    find "$root/examples" -name '*.mc' -type f | while read -r f; do
        rel="${f#$root/}"
        if [ "$rel" != "$default_example" ]; then
            echo "    ./build.sh $rel"
        fi
    done
    echo
fi

case "$src" in
    /*) ;;
    *)  src="$root/$src" ;;
esac

# Accept either `<dir>/<file>.mc` or `<dir>` (legacy: dir containing main.mc).
if [ -d "$src" ]; then
    main_mc="$src/main.mc"
    [ -f "$main_mc" ] || { echo "no main.mc in $src" >&2; exit 1; }
else
    main_mc="$src"
    [ -f "$main_mc" ] || { echo "no such file: $main_mc" >&2; exit 1; }
fi

src_dir="$(dirname "$main_mc")"
name="$(basename "$main_mc" .mc)"

# Locate minc — tools/minc/ (get_minc.sh drops it here), then PATH.
minc=""
if [ -x "$root/tools/minc/minc" ]; then
    minc="$root/tools/minc/minc"
else
    minc="$(command -v minc 2>/dev/null || true)"
fi
if [ -z "$minc" ]; then
    echo "" >&2
    echo "minc compiler not found." >&2
    echo "" >&2
    echo "Options:" >&2
    echo "  1. Auto-fetch the pinned closed-source binary:" >&2
    echo "       ./tools/get_minc.sh" >&2
    echo "     (drops a tools/minc/minc; gitignored; license at tools/minc/LICENSE.md)" >&2
    echo "" >&2
    echo "  2. Install manually from" >&2
    echo "       https://github.com/SpacesOfPlay/minc-dev/releases" >&2
    echo "     and put minc on PATH." >&2
    echo "" >&2
    echo "See README.md (Prerequisites) and LICENSE.md (minc is separately licensed)." >&2
    exit 1
fi

# Confirm GLFW is installed via the system package manager.
"$root/tools/get_glfw.sh" >/dev/null || {
    echo "GLFW not installed — see tools/get_glfw.sh output." >&2
    exit 1
}

lib_dir="$root/lib"
[ -f "$lib_dir/raylib.mc" ] || { echo "missing $lib_dir/raylib.mc — dist is corrupt" >&2; exit 1; }

build_dir="$root/build"
mkdir -p "$build_dir"
exe="$build_dir/$name"

# Run minc with the dist root as CWD so `import raylib;` resolves.
echo "compiling $name..."
(cd "$root" && "$minc" "$main_mc" -o "$exe")

# Mirror resources/ subdir (if any) next to the exe.
if [ -d "$src_dir/resources" ]; then
    rm -rf "$build_dir/resources"
    cp -r "$src_dir/resources" "$build_dir/resources"
fi

echo "built $exe"

# macOS: minc bakes @loader_path/libglfw.3.dylib into the binary, so the
# dylib (fetched by tools/get_glfw.sh) must sit next to the exe.
if [ "$(uname -s)" = "Darwin" ] && [ -e "$root/tools/libglfw.3.dylib" ]; then
    cp "$root/tools/libglfw.3.dylib" "$build_dir/libglfw.3.dylib"
fi

if [ "$no_run" -eq 0 ]; then
    echo "running..."
    (cd "$build_dir" && "$exe")
fi
