import raylib_wasm_lib;
import gl_core33;
import cstdlib_shim;

// rcore_wasm_app.mc — raylib rcore platform backend for the wasm target.
//
// raylib's rcore.c selects a platform backend (rcore_desktop_glfw.c,
// rcore_web.c = emscripten, ...) by PLATFORM_* define and #includes it.
// The wasm dist transpiles lib.c with NO PLATFORM define, so rcore.c
// emits none of them and its platform-interface functions (InitPlatform,
// WindowShouldClose, GetTime, SwapScreenBuffer, the window/monitor/cursor
// surface, ...) are left undefined. This file supplies them, concatenated
// after the transpiled raylib so it sees the (non-private) `CORE` global,
// the rlgl entry points, and raylib's types. It is the raylib analogue of
// ../lang/lib/sokol_wasm_app.mc.
//
// The browser owns the loop: the JS host (raylib_wasm_host.js) creates the
// canvas + WebGL2 context and drives frames via requestAnimationFrame. The
// GL calls rlgl makes resolve against the `gl` import module (gl_core33.mc
// wasm arm). Window management / monitors / clipboard / gamepad are mostly
// no-ops or sensible defaults in a single-canvas web context.

when os(wasm) {

    // JS host + harness staged by `minc run --target wasm` (resolved next
    // to this file → dist lib/ → <minc>/lib/wasm/). The host owns the
    // canvas + WebGL2 context and drives frames via requestAnimationFrame;
    // @wasm_requires_export turns a missing frame() into a clear error
    // instead of a blank canvas (the example must expose `frame`).
    @wasm_host "raylib_wasm_host.js"
    @wasm_html "raylib_wasm_harness.html"
    @wasm_requires_export "frame"

    // --- host helpers (provided by raylib_wasm_host.js, module "app") ---
    extern "app" i32 rl_host_width();
    extern "app" i32 rl_host_height();
    // window.devicePixelRatio × 1000 (integer to avoid float marshalling).
    extern "app" i32 rl_host_dpi_x1000();
    // Request/release pointer lock (DisableCursor/EnableCursor → first-person
    // camera). The host can only grab the lock on a user gesture, so it
    // arms on this call and locks on the next canvas click.
    extern "app" void rl_host_set_cursor_lock(i32 lock);

    private { f32 __rl_dpi = 1.0f; }

    // The render size raylib settled on (physical pixels). The JS host
    // sizes the canvas DRAWING BUFFER to this and the CSS display size to
    // the logical screen size below — so under HiDPI 1 buffer pixel == 1
    // device pixel (crisp) and otherwise the buffer fills the canvas
    // (no bottom-left-corner viewport mismatch; GL origin is bottom-left).
    export i32 rl_render_width()  { return CORE.Window.render.width; }
    export i32 rl_render_height() { return CORE.Window.render.height; }
    // Logical (CSS) size — what InitWindow asked for. The host sets the
    // canvas element's CSS width/height to this so the physical-resolution
    // backbuffer is displayed at the intended on-page size.
    export i32 rl_screen_width()  { return CORE.Window.screen.width; }
    export i32 rl_screen_height() { return CORE.Window.screen.height; }
    // env.clock (nanoseconds) is declared in cstdlib_shim's wasm arm.

    // --- timing ---
    // Seconds since InitTimer set CORE.Time.base (mirrors the desktop
    // GetTime() contract: elapsed monotonic time as f64 seconds).
    f64 GetTime() {
        i64 ns = clock();
        return cast(f64, ns - cast(i64, CORE.Time.base)) / 1000000000.0;
    }

    // --- web main loop (the emscripten_set_main_loop analog) ---
    // Browsers can't run a blocking `while (!WindowShouldClose())`
    // (minc has no wasm stack-switching), so a portable example registers
    // its per-frame function here under `when os(wasm)` and lets the JS
    // host's requestAnimationFrame loop drive it — exactly like upstream
    // raylib's PLATFORM_WEB branch. `frame()` (exported, called by the
    // host) dispatches to the registered callback.
    private { fn(): void __rl_frame_cb = null; }
    private { f64 __rl_last_frame = 0.0; }

    void rl_web_set_main_loop(fn(): void cb) {
        __rl_frame_cb = cb;
        // RAF paces frames; disable raylib's WaitTime busy-wait (it would
        // hang the tab). SetTargetFPS on the web is a no-op in effect.
        CORE.Time.target = 0.0;
    }

    export void frame() {
        if __rl_frame_cb == null { return; }
        __rl_frame_cb();
        // Overwrite the compute-only frame time with the real wall-clock
        // delta across RAF calls, so GetFrameTime()/dt is correct on the
        // web (EndDrawing alone misses the inter-frame idle gap).
        f64 now = GetTime();
        if __rl_last_frame > 0.0 { CORE.Time.frame = now - __rl_last_frame; }
        __rl_last_frame = now;
    }

    // The host checks this each RAF; on true it stops the loop and calls
    // cleanup() — so SetExitKey/Escape and CloseWindow()-on-quit work.
    export i32 rl_should_close() {
        if CORE.Window.shouldClose { return 1; }
        return 0;
    }
    export void cleanup() { CloseWindow(); }

    // --- window lifecycle ---
    i32 InitPlatform() {
        i32 w = rl_host_width();
        i32 h = rl_host_height();

        if CORE.Window.screen.width == 0 { CORE.Window.screen.width = w; }
        if CORE.Window.screen.height == 0 { CORE.Window.screen.height = h; }

        CORE.Window.display.width = w;
        CORE.Window.display.height = h;

        // HiDPI is opt-in via FLAG_WINDOW_HIGHDPI, same as native/upstream.
        // ON  → render at device-pixel resolution (screen * dpr); crisp
        //       shapes/edges, but the low-res default/raygui BITMAP font is
        //       magnified by screenScale (blurry, esp. at non-integer dpr).
        //       Best for shape/image/3D scenes.
        // OFF → render at logical size; the browser upscales the canvas on
        //       HiDPI displays (uniformly soft, crisp at dpr=1) but the
        //       bitmap font isn't double-scaled. Best for text/UI (raygui).
        __rl_dpi = cast(f32, rl_host_dpi_x1000()) / 1000.0f;
        bool highdpi = (CORE.Window.flags & cast(u32, FLAG_WINDOW_HIGHDPI)) == cast(u32, FLAG_WINDOW_HIGHDPI);
        if highdpi {
            CORE.Window.render.width = cast(i32, cast(f32, CORE.Window.screen.width) * __rl_dpi);
            CORE.Window.render.height = cast(i32, cast(f32, CORE.Window.screen.height) * __rl_dpi);
            CORE.Window.screenScale = MatrixScale(__rl_dpi, __rl_dpi, 1.0f);
            SetMouseScale(1.0f / __rl_dpi, 1.0f / __rl_dpi);
        } else {
            CORE.Window.render.width = CORE.Window.screen.width;
            CORE.Window.render.height = CORE.Window.screen.height;
        }
        CORE.Window.currentFbo = CORE.Window.render;

        CORE.Window.ready = true;

        // Load GL extension flags (RLGL.ExtSupported.vao etc.). The loader
        // arg is unused on wasm — the gl_core33 wasm arm imports every
        // entry point directly. Must run before rlglInit (called next by
        // InitWindow) so the core-profile batch takes the VAO path.
        rlLoadExtensions(null);

        // Timing + storage base path.
        InitTimer();
        CORE.Storage.basePath = cast(u8*, "");

        return 0;
    }

    void ClosePlatform() { return; }

    bool WindowShouldClose() {
        if CORE.Window.ready { return CORE.Window.shouldClose; }
        return true;
    }

    // Present is implicit in the browser — the canvas is composited after
    // the RAF callback returns; nothing to swap.
    void SwapScreenBuffer() { return; }

    // Per-frame input bookkeeping (raylib's desktop PollInputEvents, minus
    // gamepad/gesture polling). The JS host pushes DOM events asynchronously
    // into the rl_wasm_event_* exports below, which write the *current*
    // state; here we roll current → previous so IsKeyPressed / IsKeyDown /
    // mouse-delta work. MAX_* are rcore.c #defines (inlined there): 512
    // keys, 8 mouse buttons, 8 touch points.
    void PollInputEvents() {
        CORE.Input.Keyboard.keyPressedQueueCount = 0;
        CORE.Input.Keyboard.charPressedQueueCount = 0;
        for i32 i = 0; i < 512; i++ {
            CORE.Input.Keyboard.previousKeyState[i] = CORE.Input.Keyboard.currentKeyState[i];
            CORE.Input.Keyboard.keyRepeatInFrame[i] = 0;
        }
        for i32 i = 0; i < 8; i++ {
            CORE.Input.Mouse.previousButtonState[i] = CORE.Input.Mouse.currentButtonState[i];
        }
        CORE.Input.Mouse.previousWheelMove = CORE.Input.Mouse.currentWheelMove;
        CORE.Input.Mouse.currentWheelMove.x = 0.0f;
        CORE.Input.Mouse.currentWheelMove.y = 0.0f;
        CORE.Input.Mouse.previousPosition = CORE.Input.Mouse.currentPosition;
        for i32 i = 0; i < 8; i++ {
            CORE.Input.Touch.previousTouchState[i] = CORE.Input.Touch.currentTouchState[i];
        }
        CORE.Input.Touch.position[0] = CORE.Input.Mouse.currentPosition;
    }

    // --- DOM event entry points (called by the JS host) ---
    // Mirror rcore_desktop_glfw.c's GLFW callbacks. `key` is a raylib
    // KeyboardKey (== GLFW keycode); the host maps DOM event.code → it.
    export void rl_wasm_key(i32 key, i32 down) {
        if key < 0 || key >= 512 { return; }
        if down != 0 { CORE.Input.Keyboard.currentKeyState[key] = 1; }
        else { CORE.Input.Keyboard.currentKeyState[key] = 0; }
        if down != 0 && CORE.Input.Keyboard.keyPressedQueueCount < 16 {
            CORE.Input.Keyboard.keyPressedQueue[CORE.Input.Keyboard.keyPressedQueueCount] = key;
            CORE.Input.Keyboard.keyPressedQueueCount = CORE.Input.Keyboard.keyPressedQueueCount + 1;
        }
        if key == CORE.Input.Keyboard.exitKey && down != 0 { CORE.Window.shouldClose = true; }
    }
    // codepoint is i32 (not u32): minc widens a u32 export parameter to i64,
    // which the JS host would have to pass as a BigInt — instead it passes a
    // plain number, so the call would throw and no text would ever arrive.
    // i32 holds every Unicode scalar (max 0x10FFFF) fine.
    export void rl_wasm_char(i32 codepoint) {
        if CORE.Input.Keyboard.charPressedQueueCount < 16 {
            CORE.Input.Keyboard.charPressedQueue[CORE.Input.Keyboard.charPressedQueueCount] = codepoint;
            CORE.Input.Keyboard.charPressedQueueCount = CORE.Input.Keyboard.charPressedQueueCount + 1;
        }
    }
    export void rl_wasm_mouse_button(i32 button, i32 down) {
        if button < 0 || button >= 8 { return; }
        CORE.Input.Mouse.currentButtonState[button] = cast(u8, down);
        CORE.Input.Touch.currentTouchState[button] = cast(u8, down);
    }
    export void rl_wasm_mouse_pos(f32 x, f32 y) {
        CORE.Input.Mouse.currentPosition.x = x;
        CORE.Input.Mouse.currentPosition.y = y;
        CORE.Input.Touch.position[0] = CORE.Input.Mouse.currentPosition;
    }
    // Relative motion under pointer lock (first-person cameras read
    // GetMouseDelta = current - previous). The host feeds movementX/Y here
    // while the pointer is locked; absolute position is meaningless then.
    export void rl_wasm_mouse_delta(f32 dx, f32 dy) {
        CORE.Input.Mouse.currentPosition.x = CORE.Input.Mouse.currentPosition.x + dx;
        CORE.Input.Mouse.currentPosition.y = CORE.Input.Mouse.currentPosition.y + dy;
    }
    export void rl_wasm_mouse_wheel(f32 x, f32 y) {
        CORE.Input.Mouse.currentWheelMove.x = x;
        CORE.Input.Mouse.currentWheelMove.y = y;
    }
    export void rl_wasm_cursor_enter(i32 enter) {
        CORE.Input.Mouse.cursorOnScreen = enter != 0;
    }

    // --- window management (single-canvas web context: mostly no-ops) ---
    void ToggleFullscreen() { return; }
    void ToggleBorderlessWindowed() { return; }
    void MaximizeWindow() { return; }
    void MinimizeWindow() { return; }
    void RestoreWindow() { return; }
    void SetWindowState(u32 flags) { ignore flags; }
    void ClearWindowState(u32 flags) { ignore flags; }
    void SetWindowIcon(Image image) { ignore image; }
    void SetWindowIcons(Image* images, i32 count) { ignore images; ignore count; }
    void SetWindowTitle(u8* title) { ignore title; }
    void SetWindowPosition(i32 x, i32 y) { ignore x; ignore y; }
    void SetWindowMonitor(i32 monitor) { ignore monitor; }
    void SetWindowMinSize(i32 width, i32 height) { ignore width; ignore height; }
    void SetWindowMaxSize(i32 width, i32 height) { ignore width; ignore height; }
    void SetWindowSize(i32 width, i32 height) {
        CORE.Window.screen.width = width;
        CORE.Window.screen.height = height;
    }
    void SetWindowOpacity(f32 opacity) { ignore opacity; }
    void SetWindowFocused() { return; }
    void* GetWindowHandle() { return null; }

    // --- monitors (one virtual monitor = the canvas) ---
    i32 GetMonitorCount() { return 1; }
    i32 GetCurrentMonitor() { return 0; }
    Vector2 GetMonitorPosition(i32 monitor) {
        ignore monitor;
        Vector2 r; r.x = 0.0f; r.y = 0.0f; return r;
    }
    i32 GetMonitorWidth(i32 monitor) { ignore monitor; return CORE.Window.display.width; }
    i32 GetMonitorHeight(i32 monitor) { ignore monitor; return CORE.Window.display.height; }
    i32 GetMonitorPhysicalWidth(i32 monitor) { ignore monitor; return 0; }
    i32 GetMonitorPhysicalHeight(i32 monitor) { ignore monitor; return 0; }
    i32 GetMonitorRefreshRate(i32 monitor) { ignore monitor; return 60; }
    u8* GetMonitorName(i32 monitor) { ignore monitor; return cast(u8*, "WEB"); }

    Vector2 GetWindowPosition() {
        Vector2 r; r.x = 0.0f; r.y = 0.0f; return r;
    }
    Vector2 GetWindowScaleDPI() {
        Vector2 r; r.x = __rl_dpi; r.y = __rl_dpi; return r;
    }

    // --- clipboard ---
    void SetClipboardText(u8* text) { ignore text; }
    u8* GetClipboardText() { return cast(u8*, ""); }
    Image GetClipboardImage() {
        Image r;
        r.data = null; r.width = 0; r.height = 0; r.mipmaps = 0; r.format = 0;
        return r;
    }

    // --- cursor ---
    void ShowCursor() { CORE.Input.Mouse.cursorHidden = false; }
    void HideCursor() { CORE.Input.Mouse.cursorHidden = true; }
    void EnableCursor() { CORE.Input.Mouse.cursorHidden = false; rl_host_set_cursor_lock(0); }
    void DisableCursor() { CORE.Input.Mouse.cursorHidden = true; rl_host_set_cursor_lock(1); }
    void SetMouseCursor(i32 cursor) { CORE.Input.Mouse.cursor = cursor; }
    void SetMousePosition(i32 x, i32 y) {
        CORE.Input.Mouse.currentPosition.x = cast(f32, x);
        CORE.Input.Mouse.currentPosition.y = cast(f32, y);
        CORE.Input.Mouse.previousPosition = CORE.Input.Mouse.currentPosition;
    }

    // --- misc ---
    void OpenURL(u8* url) { ignore url; }
    i32 SetGamepadMappings(u8* mappings) { ignore mappings; return 0; }
    void SetGamepadVibration(i32 gamepad, f32 leftMotor, f32 rightMotor, f32 duration) {
        ignore gamepad; ignore leftMotor; ignore rightMotor; ignore duration;
    }
    u8* GetKeyName(i32 key) { ignore key; return cast(u8*, ""); }
}
