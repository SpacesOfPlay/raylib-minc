# live-demo

Every example compiled to wasm, as a static page.

| file | source |
| --- | --- |
| `index.html` (gallery), `run.html` (runner) | this directory |
| `raylib_wasm_host.js` | copied from `lib/` by the build — gitignored |
| `resources/`, `assets.json` | merged from the examples' `resources/` dirs — gitignored |
| `*.wasm` | built by `.github/workflows/pages.yml` — gitignored |

`index.html` lists the examples by category; `run.html?app=<name>` loads
`<name>.wasm` through the JS host. The runner is the same bootstrap as
`lib/raylib_wasm_harness.html` (what `minc run --target wasm` stages for a
single example) plus a back link and an error surface.

raylib's wasm target is single-threaded.

## Build and run it locally

    ./run_examples.sh wasm         # Linux/macOS
    ./run_examples.ps1 wasm        # Windows

That compiles every example into `build/web_all/`, stages these pages
beside them, serves the directory and opens the gallery. A `file://` open
will not work.

## Assets

The examples that load files (`text`, `textures`) keep them in
`examples/<cat>/resources/`. The build merges those into one
`resources/` dir here and writes `assets.json`, a manifest the runner
preloads into the host's VFS before `run()`. Every app preloads the whole
manifest — it is a few KB. Same-named files across categories would
collide.
