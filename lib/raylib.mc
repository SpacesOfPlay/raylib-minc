// raylib — main module. Imports the shims, the composed raylib
// library, and the platform/GL bindings. See README.md for the build flow.
//
// Desktop (windows/linux/macos) and wasm are separate transpiles (GL 3.3
// + GLFW vs GLES3/WebGL2 + a JS-host platform backend), so the router
// picks the right library + backend per target. The shims (cstdlib /
// cfile / cvararg), the canonical GL binding, and the named constants are
// shared — each carries its own `when os(...)` arms.

@gui    // no console window alongside the app (desktop; harmless on web)

import cstdlib_shim;
import cfile_shim;
import cvararg_shim;
import gl_core33;
import raylib_constants;

when os(wasm) {
    // Web: the GLES3 transpile + the rcore wasm platform backend (canvas
    // + WebGL2 + input via the JS host, driven by requestAnimationFrame).
    // rcore_wasm_app declares the @wasm_host JS + harness, so
    // `minc run --target wasm your_app.mc` stages and serves them.
    import raylib_wasm_lib;
    import rcore_wasm_app;
} else {
    // Desktop: the GL 3.3 transpile + the GLFW window/context backend.
    import raylib_lib;
    import glad_compat;
    import glfw3;
}
