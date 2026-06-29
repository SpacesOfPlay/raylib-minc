import raylib;

private {
    i32 score = 100020;
    i32 hiscore = 200450;
    i32 lives = 5;
}

void UpdateDrawFrame() {
    // Update — nothing to do this frame.

    // Draw
    BeginDrawing();
        ClearBackground(RAYWHITE);

        DrawText(TextFormat("Score: %08i", score), 200, 80, 20, RED);
        DrawText(TextFormat("HiScore: %08i", hiscore), 200, 120, 20, GREEN);
        DrawText(TextFormat("Lives: %02i", lives), 200, 160, 40, BLUE);
        DrawText(TextFormat("Elapsed Time: %02.02f ms",
                            cast(f64, GetFrameTime()) * 1000.0), 200, 220, 20, BLACK);
    EndDrawing();
}

i32 main() {
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [text] example - format text");

    SetTargetFPS(60);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        // Main game loop
        while !WindowShouldClose() { UpdateDrawFrame(); }
        CloseWindow();
    }
    return 0;
}
