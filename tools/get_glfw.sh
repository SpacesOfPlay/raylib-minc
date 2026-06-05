#!/usr/bin/env bash
# get_glfw.sh — ensure GLFW is available for the runtime binary.
#
#   macOS  : download a pinned upstream GLFW release, verify its
#            SHA-256, and drop a universal `tools/libglfw.3.dylib`
#            (build.sh copies it next to each example's binary, since
#            minc bakes an @loader_path reference). No Homebrew needed.
#   Linux  : GLFW has no official prebuilt; use the system package.
#   Windows: run `tools/get_glfw.ps1` instead.
#
# Run once per checkout — the result is reused for every example.

set -e

here="$(cd "$(dirname "$0")" && pwd)"

case "$(uname -s)" in
    Linux*)
        if pkg-config --exists glfw3 2>/dev/null; then
            v=$(pkg-config --modversion glfw3)
            echo "GLFW $v found via pkg-config."
            exit 0
        fi
        echo "GLFW not detected. Install via your package manager, e.g.:"
        echo "  Debian/Ubuntu:  sudo apt install libglfw3 libglfw3-dev"
        echo "  Fedora:         sudo dnf install glfw glfw-devel"
        echo "  Arch:           sudo pacman -S glfw"
        exit 1
        ;;
    Darwin*)
        # Pinned upstream GLFW release. The macOS archive ships a
        # universal (arm64 + x86_64) libglfw.3.dylib, so no per-arch
        # branch is needed. To rotate: bump glfw_ver, run once, paste
        # the printed SHA-256 into glfw_sha.
        glfw_ver="3.4"
        glfw_url="https://github.com/glfw/glfw/releases/download/$glfw_ver/glfw-$glfw_ver.bin.MACOS.zip"
        glfw_sha="6775085bdae60312a3002bff2e39779a83bc72a7e1c810bd806fddb00cb35fd0"
        out="$here/libglfw.3.dylib"
        if [ -e "$out" ]; then
            echo "libglfw.3.dylib already present at $out — skipping download."
            exit 0
        fi
        zip="$here/glfw-$glfw_ver.bin.MACOS.zip"
        echo "Downloading GLFW $glfw_ver from $glfw_url"
        curl -fsSL -o "$zip" "$glfw_url"
        actual="$(shasum -a 256 "$zip" | awk '{print $1}')"
        if [ "$actual" != "$glfw_sha" ]; then
            rm -f "$zip"
            echo "GLFW download SHA-256 mismatch. Expected $glfw_sha, got $actual. Refusing to proceed." >&2
            exit 1
        fi
        unzip -o -j "$zip" "glfw-$glfw_ver.bin.MACOS/lib-universal/libglfw.3.dylib" -d "$here" >/dev/null
        rm -f "$zip"
        echo "OK — libglfw.3.dylib at $out"
        exit 0
        ;;
    *)
        echo "Unsupported platform: $(uname -s)" >&2
        echo "On Windows, run tools/get_glfw.ps1 instead." >&2
        exit 1
        ;;
esac
