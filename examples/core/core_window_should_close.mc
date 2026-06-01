import raylib;

i32 main() {
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - window should close");

    SetExitKey(KEY_NULL);       // Disable ESC-to-close; the X button still works

    bool exitWindowRequested = false;   // A close has been requested
    bool exitWindow = false;            // Actually exit

    SetTargetFPS(60);

    // Main game loop
    while !exitWindow {
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
                DrawRectangle(0, 100, screenWidth, 200, BLACK);
                DrawText("Are you sure you want to exit program? [Y/N]", 40, 180, 30, WHITE);
            } else {
                DrawText("Try to close the window to get confirmation message!", 120, 200, 20, LIGHTGRAY);
            }
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
