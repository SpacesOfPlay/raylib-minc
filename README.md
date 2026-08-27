# raylib-minc

A [minc](https://minc.dev)-language port of
[raylib](https://github.com/raysan5/raylib), transpiled from
raylib's C source.

All examples as wasm:
[web examples](https://spacesofplay.github.io/raylib-minc/).

## Quickstart (Windows)

```powershell
git clone https://github.com/SpacesOfPlay/raylib-minc
cd raylib-minc
powershell -c "irm minc.dev/install.ps1 | iex"    # install minc (see install_minc.md)
minc run                                          # builds + runs the default example
```

Opens a window saying "hello, raylib-minc". Close it with the X
button or ESC. The first native build fetches a pinned GLFW release
(SHA-256-verified) and drops `glfw3.dll` at the dist root; later
builds reuse it.

## Quickstart (Linux)

```sh
sudo apt install libglfw3 libglfw3-dev          # Debian/Ubuntu
# sudo dnf install glfw glfw-devel              # Fedora
# sudo pacman -S glfw                           # Arch
git clone https://github.com/SpacesOfPlay/raylib-minc
cd raylib-minc
curl -fsSL https://minc.dev/install | bash       # install minc (see install_minc.md)
minc run                                        # builds + runs the default example
```

## Quickstart (macOS)

```sh
git clone https://github.com/SpacesOfPlay/raylib-minc
cd raylib-minc
curl -fsSL https://minc.dev/install | bash       # install minc (see install_minc.md)
minc run                                        # builds + runs the default example
```

The first native build fetches a universal (arm64 + x86_64) GLFW
release (no Homebrew needed) and copies the dylib next to each
binary.

## Prerequisites

- **minc compiler** — the one-liner in
  [`install_minc.md`](install_minc.md) installs it from
  <https://minc.dev>. The build (`build.mc`, run by `minc run`)
  resolves minc from `$MINC`, then PATH, then next to the script.
  minc is separately licensed; see [`LICENSE.md`](LICENSE.md).
- **GLFW 3.x** — Windows + macOS fetch it automatically on the first
  native build. Linux installs via package manager.

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
minc run hello.mc
```

The examples tree mirrors [upstream raylib's `examples/`
layout](https://github.com/raysan5/raylib/tree/master/examples).

## Run in the browser (WebAssembly)

raylib-minc also targets the web. Compiled straight to WebAssembly
(WebGL2), no emscripten. The same source builds for desktop and web:

```
minc run examples/core/core_basic_window.mc     # desktop
minc wasm examples/core/core_basic_window.mc    # web
```

`minc wasm` compiles the example to `.wasm`, stages the JS host +
HTML harness (declared by `lib/rcore_wasm_app.mc`), serves it, and
opens a browser. Add `--no-run` to serve without auto-opening. Under
the hood it runs `minc run --target wasm <example>`. No GLFW needed.

One cross-platform main loop. A browser can't run a blocking 
`while (!WindowShouldClose())`, so a portable example puts its loop body in 
a shared `UpdateDrawFrame()` and branches once in `main` (exactly like upstream 
raylib's `PLATFORM_WEB` / `emscripten_set_main_loop` split):

```minc
when os(wasm) {
    rl_web_set_main_loop(UpdateDrawFrame);   // host requestAnimationFrame drives frames
} else {
    SetTargetFPS(60);
    while !WindowShouldClose() { UpdateDrawFrame(); }
    CloseWindow();
}
```

All bundled examples use this portable shape, so any of them runs on
the web: `minc wasm examples/shapes/shapes_bouncing_ball.mc`.

Asset loaders (`text_font_loading`, `textures_image_loading`,
`textures_logo_raylib`) just work: `minc wasm <example>` copies the
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

Assets: the page fetches an `assets.json` manifest — a JSON array of the
paths your example `LoadXxx()`es at runtime — and the host preloads those
files into an in-memory VFS before the module runs. `minc wasm`
writes it from the example's `resources/` dir; hand-write it for anything
loaded from elsewhere.

Audio and gamepad are not wired on the web target yet.

## Run every example (verification)

To walk the whole `examples/` tree one at a time:

```
minc run all                # native: build + run each example in turn
minc run all --start 10     # ... resume from example #10
minc run all --seconds 3    # ... unattended: each one closes itself
minc wasm all               # web: compile all + serve the gallery
minc wasm all --port 9000   # ... on another port
```

- **Native** builds and runs each example in turn. Close its window (or
  press Enter) to advance; at the prompt: `r` replays, `s` runs the rest
  back-to-back, `q` quits.
- **Web** compiles every example to `build/web_all/`, stages the
  [`live-demo/`](live-demo/) pages beside them and serves the gallery —
  click an example, view it, use the browser **Back** button to return.
  This is the published site, so it doubles as a check of it before you
  push.

## How it works

`lib/raylib.mc` imports the shims and picks the right transpiled
raylib at compile time: `raylib_lib.mc` (desktop: GL 3.3 + GLFW) on
windows/linux/macos, or `raylib_wasm_lib.mc` + `rcore_wasm_app.mc`
(web: WebGL2 + a JS-host platform backend) under `when os(wasm)`.
The desktop output is a self-contained native binary — only GLFW,
the OS C runtime, and OpenGL are external; the web output is a
freestanding `.wasm` driven by `lib/raylib_wasm_host.js`.

The `lib/raylib_lib.mc` / `lib/raylib_wasm_lib.mc` files are transpile
snapshots. Snapshot sources are listed in [`VERSION`](VERSION).

## Troubleshooting

- **"minc compiler not found"** — install minc (see
  [`install_minc.md`](install_minc.md)), put `minc` on PATH, or set
  `$MINC`.
- **GLFW download fails** (Windows/macOS) — fetch the pinned release
  from <https://github.com/glfw/glfw/releases> yourself and drop
  `glfw3.dll` (Windows) / `libglfw.3.dylib` (macOS) at the dist root.
- **"libglfw.so.3 not found"** (Linux) — install the runtime
  package (`libglfw3`), not just `-dev`.
- **"could not open import 'raylib'"** — run `minc run` from the
  dist root.
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
