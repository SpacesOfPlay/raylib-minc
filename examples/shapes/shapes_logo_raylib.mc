import raylib;

private {
    i32 screenWidth = 800;
    i32 screenHeight = 450;
}

void UpdateDrawFrame() {
    // Draw
    BeginDrawing();
        ClearBackground(RAYWHITE);

        DrawRectangle(screenWidth / 2 - 128, screenHeight / 2 - 128, 256, 256, BLACK);
        DrawRectangle(screenWidth / 2 - 112, screenHeight / 2 - 112, 224, 224, RAYWHITE);
        DrawText("raylib", screenWidth / 2 - 44, screenHeight / 2 + 48, 50, BLACK);

        DrawText("this is NOT a texture!", 350, 370, 10, GRAY);
    EndDrawing();
}

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    // Initialization
    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - logo raylib");

    SetTargetFPS(60);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        while !WindowShouldClose() { UpdateDrawFrame(); }
        CloseWindow();
    }
    return 0;
}
