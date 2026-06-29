import raylib;

void UpdateDrawFrame() {
    BeginDrawing();
    ClearBackground(RAYWHITE);

    DrawRectangle(40, 60, 200, 120, BLUE);
    DrawCircle(500, 120, 60.0f, GREEN);
    DrawTriangle(Vector2{ 320, 250 },
                 Vector2{ 180, 440 },
                 Vector2{ 460, 440 }, RED);

    // A line, drawn thick enough to be visible against the BG.
    DrawLineEx(Vector2{ 40, 220 }, Vector2{ 240, 220 }, 4.0f, DARKBLUE);

    DrawText("2D shapes via rshapes", 40, 20, 20, BLACK);
    EndDrawing();
}

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    InitWindow(640, 480, "raylib-minc: 2D shapes");
    SetTargetFPS(60);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        while !WindowShouldClose() { UpdateDrawFrame(); }
        CloseWindow();
    }
    return 0;
}
