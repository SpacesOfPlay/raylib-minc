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

## Run in the browser (WebAssembly)

raylib-minc also targets the web — compiled straight to WebAssembly
(WebGL2), no emscripten. The **same source** builds for desktop and web:

```
./build.sh examples/core/core_basic_window.mc        # desktop
./build.sh wasm examples/core/core_basic_window.mc   # web  (build.ps1 on Windows)
```

The `wasm` subcommand compiles the example to `.wasm`, stages the JS host
+ HTML harness (declared by `lib/rcore_wasm_app.mc`), serves it, and opens
a browser — all via the bundled `tools/minc` (no compiler on PATH needed).
Add `--no-run` (`-NoRun` on Windows) to serve without auto-opening. Under
the hood it runs `minc run --target wasm <example>`.

**One cross-platform seam — the main loop.** A browser can't run a
blocking `while (!WindowShouldClose())`, so a portable example puts its
loop body in a shared `UpdateDrawFrame()` and branches once in `main`
(exactly like upstream raylib's `PLATFORM_WEB` / `emscripten_set_main_loop`
split):

```minc
when os(wasm) {
    rl_web_set_main_loop(UpdateDrawFrame);   // host requestAnimationFrame drives frames
} else {
    SetTargetFPS(60);
    while !WindowShouldClose() { UpdateDrawFrame(); }
    CloseWindow();
}
```

**All bundled examples** use this portable shape, so any of them runs on
the web — e.g. `./build.sh wasm examples/shapes/shapes_bouncing_ball.mc`.

Asset loaders (`text_font_loading`, `textures_image_loading`,
`textures_logo_raylib`) just work: `./build.sh wasm <example>` copies the
example's `resources/` next to the page and writes an `assets.json`
manifest the host preloads into the VFS, so `LoadImage`/`LoadFont`/
`LoadFontEx`(`"resources/..."`) resolve in the browser.

A few examples rely on platform features the web target doesn't fully
provide yet (they still build and run, just with reduced behavior):
- **Storage** (`core_storage_values`) writes a save file — the web VFS is
  read-only, so values don't persist.
- **Mouse-look cameras** (`core_3d_camera_first_person`, `..._free`) use
  pointer lock; the browser grants it only after you click the canvas.
- **Window-state** examples (`core_window_flags`, `core_window_should_close`,
  raygui `portable_window`) toggle OS-window properties that are no-ops on
  a single canvas.

Assets: list files your example `LoadXxx()`es at runtime in the harness's
`ASSETS` array (`lib/raylib_wasm_harness.html`); the host preloads them
into an in-memory VFS before the module runs.

Audio and gamepad are not wired on the web target yet.

## Run every example (verification)

To walk the whole `examples/` tree one at a time:

```
./run_examples.ps1            # Windows, native
./run_examples.sh             # Linux/macOS, native
./run_examples.ps1 wasm       # Windows, web
./run_examples.sh wasm        # Linux/macOS, web
```

- **Native** builds and runs each example in turn. Close its window (or
  press Enter) to advance; at the prompt: `r` replays, `s` runs the rest
  back-to-back, `q` quits. Resume partway with `native 10` / `-Start 10`.
- **Web** compiles every example to `build/web_all/` and serves a single
  clickable **menu** (`menu.html`) — click an example, view it, use the
  browser **Back** button to return. Needs `python` on PATH; pick a port
  with `-Port 9000` / `PORT=9000`.

## How it works

`lib/raylib.mc` imports the shims and picks the right transpiled
raylib at compile time: `raylib_lib.mc` (desktop: GL 3.3 + GLFW) on
windows/linux/macos, or `raylib_wasm_lib.mc` + `rcore_wasm_app.mc`
(web: WebGL2 + a JS-host platform backend) under `when os(wasm)`.
The desktop output is a self-contained native binary — only GLFW,
the OS C runtime, and OpenGL are external; the web output is a
freestanding `.wasm` driven by `lib/raylib_wasm_host.js`.

The `lib/raylib_lib.mc` / `lib/raylib_wasm_lib.mc` files are transpile
snapshots. Fix bugs by re-publishing from updated sources, not by
editing them by hand. Snapshot sources are listed in [`VERSION`](VERSION).

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
