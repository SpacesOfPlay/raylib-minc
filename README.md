# raylib-minc

A [minc](https://minc.dev)-language port of
[raylib](https://github.com/raysan5/raylib), transpiled from
raylib's C source.

## Quickstart (Windows)

```powershell
git clone https://github.com/SpacesOfPlay/raylib-minc
cd raylib-minc
./tools/get_minc.ps1                              # downloads minc compiler
./tools/get_glfw.ps1                              # downloads GLFW
./build.ps1                                       # builds + runs the default example
```

Opens a window saying "hello, raylib-minc". Close it with the X
button or ESC.

## Quickstart (Linux)

```sh
sudo apt install libglfw3 libglfw3-dev          # Debian/Ubuntu
# sudo dnf install glfw glfw-devel              # Fedora
# sudo pacman -S glfw                           # Arch
git clone https://github.com/SpacesOfPlay/raylib-minc
cd raylib-minc
./tools/get_minc.sh                             # downloads minc compiler
./build.sh                                      # builds + runs the default example
```

## Quickstart (macOS)

```sh
git clone https://github.com/SpacesOfPlay/raylib-minc
cd raylib-minc
./tools/get_minc.sh                             # downloads minc compiler
./tools/get_glfw.sh                             # downloads GLFW (no Homebrew needed)
./build.sh                                      # builds + runs the default example
```

`get_glfw.sh` fetches a universal (arm64 + x86_64) GLFW release;
`build.sh` copies the dylib next to each binary.

## Prerequisites

- **minc compiler** — `./tools/get_minc.{ps1,sh}` fetches a pinned
  release into `tools/minc/`. Or put `minc(.exe)` on PATH yourself.
  minc is separately licensed; see [`LICENSE.md`](LICENSE.md).
- **GLFW 3.x** — Windows + macOS run `tools/get_glfw.{ps1,sh}`.
  Linux installs via package manager.

## What works

| Module       | State |
|--------------|-------|
| Window + input (`rcore`)   | ✅ |
| 2D shapes (`rshapes`)      | ✅ |
| Textures (`rtextures`)     | ✅ PNG only |
| Text (`rtext`)             | ✅ TTF + default font |
| 3D models (`rmodels`)      | ⚠ drawing only; no model loaders |
| Audio (`raudio`)           | ❌ |
| Camera (`rcamera`)         | ✅ |
| Gestures (`rgestures`)     | ✅ |

## Hello world

```mc
import raylib;

i32 main() {
    InitWindow(640, 480, "hello, raylib-minc");
    SetTargetFPS(60);
    while !WindowShouldClose() {
        BeginDrawing();
        ClearBackground(RAYWHITE);
        DrawText("hello, world", 40, 40, 20, BLACK);
        EndDrawing();
    }
    CloseWindow();
    return 0;
}
```

Save as `hello.mc`, then:

```
./build.ps1 hello.mc          # Windows
./build.sh hello.mc           # Linux
```

The examples tree mirrors [upstream raylib's `examples/`
layout](https://github.com/raysan5/raylib/tree/master/examples).

## How it works

`lib/raylib.mc` imports the shims and picks the OS-appropriate
transpiled raylib at compile time. Output is a self-contained
native binary — only GLFW, the OS C runtime, and OpenGL are
external.

The `lib/raylib_<os>.mc` files are transpile snapshots. Fix bugs
by re-publishing from updated sources, not by editing them by
hand. Snapshot sources are listed in [`VERSION`](VERSION).

## Troubleshooting

- **"minc compiler not found"** — run `./tools/get_minc.{ps1,sh}`
  or put `minc` on PATH.
- **"glfw3.dll not found"** (Windows) — run `./tools/get_glfw.ps1`.
- **"libglfw.3.dylib not found"** (macOS) — run `./tools/get_glfw.sh`
  then rebuild.
- **"libglfw.so.3 not found"** (Linux) — install the runtime
  package (`libglfw3`), not just `-dev`.
- **"could not open import 'raylib'"** — run `build.ps1` / `build.sh`
  from the dist root.
- **Black window** — your GPU driver may not support GL 3.3 core.

## See also

- [`PORTING.md`](PORTING.md) — C-raylib → minc-raylib delta
- [`examples/README.md`](examples/README.md) — index of ported examples
- [`LICENSE.md`](LICENSE.md) — zlib/libpng (inherited from raylib + GLFW)

## Credits

raylib (c) Ramon Santamaria (@raysan5) and contributors. GLFW
(c) Marcus Geelnard and Camilla Löwy. stb_* (c) Sean Barrett. Port
by Mattias Ljungström, Spaces of Play UG. All upstream projects are 
zlib/libpng licensed; this port inherits that license, see LICENSE.md.
