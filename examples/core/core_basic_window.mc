// raylib [core] example — basic window. ONE source builds for desktop
// (windows/linux/macos) and the web (wasm).
//
// The only cross-platform seam is the main loop: a browser can't run a
// blocking `while (!WindowShouldClose())`, so on the web we hand the
// per-frame function to the JS host's requestAnimationFrame loop, and on
// desktop we run the classic blocking loop. This mirrors upstream
// raylib's PLATFORM_WEB / emscripten_set_main_loop split. The frame body
// (UpdateDrawFrame) is shared verbatim.
//
//   desktop:  ./build.sh                 (or build.ps1)
//   web:      minc run --target wasm examples/core/core_basic_window.mc
import raylib;

void UpdateDrawFrame() {
    BeginDrawing();
    ClearBackground(RAYWHITE);
    DrawText("hello, world", 40, 40, 20, BLACK);
    EndDrawing();
}

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    InitWindow(640, 480, "hello, raylib-minc");

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);   // host RAF drives frames
    } else {
        SetTargetFPS(60);
        while !WindowShouldClose() { UpdateDrawFrame(); }
        CloseWindow();
    }
    return 0;
}
