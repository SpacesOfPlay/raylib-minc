import raylib;

private {
    bool exitWindowRequested = false;   // A close has been requested
    bool exitWindow = false;            // Actually exit
}

void UpdateDrawFrame() {
    // Update
    // Detect X-button or ESC to request a close
    if WindowShouldClose() || IsKeyPressed(KEY_ESCAPE) { exitWindowRequested = true; }

    if exitWindowRequested {
        // Close requested — here you could save data first, or just
        // confirm. Y exits, N cancels.
        if IsKeyPressed(KEY_Y) { exitWindow = true; }
        else if IsKeyPressed(KEY_N) { exitWindowRequested = false; }
    }

    // Draw
    BeginDrawing();
        ClearBackground(RAYWHITE);

        if exitWindowRequested {
            DrawRectangle(0, 100, 800, 200, BLACK);
            DrawText("Are you sure you want to exit program? [Y/N]", 40, 180, 30, WHITE);
        } else {
            DrawText("Try to close the window to get confirmation message!", 120, 200, 20, LIGHTGRAY);
        }
    EndDrawing();
}

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - window should close");

    SetExitKey(KEY_NULL);       // Disable ESC-to-close; the X button still works

    SetTargetFPS(60);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        // Main game loop
        while !exitWindow { UpdateDrawFrame(); }
        CloseWindow();
    }
    return 0;
}
