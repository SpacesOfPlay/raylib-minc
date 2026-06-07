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
        # GLFW is present if the runtime shared object resolves — that's
        # what minc links by soname and what the loader needs. Probe the
        # dynamic-linker cache and the standard libdirs directly; pkg-config
        # is only a fallback, never the gate (it lives in dev tooling and is
        # not a documented prerequisite, so its absence must not fail us).
        if ldconfig -p 2>/dev/null | grep -q 'libglfw\.so\.3'; then
            echo "GLFW found (libglfw.so.3 via ldconfig)."
            exit 0
        fi
        for d in /usr/lib /usr/lib/x86_64-linux-gnu /usr/lib64 \
                 /lib /lib/x86_64-linux-gnu /usr/local/lib; do
            if [ -e "$d/libglfw.so.3" ]; then
                echo "GLFW found ($d/libglfw.so.3)."
                exit 0
            fi
        done
        if command -v pkg-config >/dev/null 2>&1 && pkg-config --exists glfw3 2>/dev/null; then
            echo "GLFW $(pkg-config --modversion glfw3) found via pkg-config."
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
