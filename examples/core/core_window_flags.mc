import raylib;

private {
    Vector2 ballPosition;
    Vector2 ballSpeed = Vector2{ 5.0f, 4.0f };
    f32 ballRadius = 20.0f;
    i32 framesCounter = 0;
}

void UpdateDrawFrame() {
        // Update
        if IsKeyPressed(KEY_F) { ToggleFullscreen(); }  // modifies window size when scaling!

        if IsKeyPressed(KEY_R) {
            if IsWindowState(cast(u32, FLAG_WINDOW_RESIZABLE)) { ClearWindowState(cast(u32, FLAG_WINDOW_RESIZABLE)); }
            else { SetWindowState(cast(u32, FLAG_WINDOW_RESIZABLE)); }
        }

        if IsKeyPressed(KEY_D) {
            if IsWindowState(cast(u32, FLAG_WINDOW_UNDECORATED)) { ClearWindowState(cast(u32, FLAG_WINDOW_UNDECORATED)); }
            else { SetWindowState(cast(u32, FLAG_WINDOW_UNDECORATED)); }
        }

        if IsKeyPressed(KEY_H) {
            if !IsWindowState(cast(u32, FLAG_WINDOW_HIDDEN)) { SetWindowState(cast(u32, FLAG_WINDOW_HIDDEN)); }
            framesCounter = 0;
        }

        if IsWindowState(cast(u32, FLAG_WINDOW_HIDDEN)) {
            framesCounter++;
            if framesCounter >= 240 { ClearWindowState(cast(u32, FLAG_WINDOW_HIDDEN)); }  // Show window after 3 seconds
        }

        if IsKeyPressed(KEY_N) {
            if !IsWindowState(cast(u32, FLAG_WINDOW_MINIMIZED)) { MinimizeWindow(); }
            framesCounter = 0;
        }

        if IsWindowState(cast(u32, FLAG_WINDOW_MINIMIZED)) {
            framesCounter++;
            if framesCounter >= 240 {
                RestoreWindow();  // Restore window after 3 seconds
                framesCounter = 0;
            }
        }

        if IsKeyPressed(KEY_M) {
            // NOTE: Requires FLAG_WINDOW_RESIZABLE enabled!
            if IsWindowState(cast(u32, FLAG_WINDOW_MAXIMIZED)) { RestoreWindow(); }
            else { MaximizeWindow(); }
        }

        if IsKeyPressed(KEY_U) {
            if IsWindowState(cast(u32, FLAG_WINDOW_UNFOCUSED)) { ClearWindowState(cast(u32, FLAG_WINDOW_UNFOCUSED)); }
            else { SetWindowState(cast(u32, FLAG_WINDOW_UNFOCUSED)); }
        }

        if IsKeyPressed(KEY_T) {
            if IsWindowState(cast(u32, FLAG_WINDOW_TOPMOST)) { ClearWindowState(cast(u32, FLAG_WINDOW_TOPMOST)); }
            else { SetWindowState(cast(u32, FLAG_WINDOW_TOPMOST)); }
        }

        if IsKeyPressed(KEY_A) {
            if IsWindowState(cast(u32, FLAG_WINDOW_ALWAYS_RUN)) { ClearWindowState(cast(u32, FLAG_WINDOW_ALWAYS_RUN)); }
            else { SetWindowState(cast(u32, FLAG_WINDOW_ALWAYS_RUN)); }
        }

        if IsKeyPressed(KEY_V) {
            if IsWindowState(cast(u32, FLAG_VSYNC_HINT)) { ClearWindowState(cast(u32, FLAG_VSYNC_HINT)); }
            else { SetWindowState(cast(u32, FLAG_VSYNC_HINT)); }
        }

        if IsKeyPressed(KEY_B) { ToggleBorderlessWindowed(); }

        // Bouncing ball logic
        ballPosition.x += ballSpeed.x;
        ballPosition.y += ballSpeed.y;
        if (ballPosition.x >= (cast(f32, GetScreenWidth()) - ballRadius)) || (ballPosition.x <= ballRadius) { ballSpeed.x *= -1.0f; }
        if (ballPosition.y >= (cast(f32, GetScreenHeight()) - ballRadius)) || (ballPosition.y <= ballRadius) { ballSpeed.y *= -1.0f; }

        // Draw
        BeginDrawing();

        if IsWindowState(cast(u32, FLAG_WINDOW_TRANSPARENT)) { ClearBackground(BLANK); }
        else { ClearBackground(RAYWHITE); }

        DrawCircleV(ballPosition, ballRadius, MAROON);
        DrawRectangleLinesEx(Rectangle{ 0.0f, 0.0f, cast(f32, GetScreenWidth()), cast(f32, GetScreenHeight()) }, 4.0f, RAYWHITE);

        DrawCircleV(GetMousePosition(), 10.0f, DARKBLUE);

        DrawFPS(10, 10);

        DrawText(TextFormat("Screen Size: [%i, %i]", GetScreenWidth(), GetScreenHeight()), 10, 40, 10, GREEN);

        // Draw window state info
        DrawText("Following flags can be set after window creation:", 10, 60, 10, GRAY);
        if IsWindowState(cast(u32, FLAG_FULLSCREEN_MODE)) { DrawText("[F] FLAG_FULLSCREEN_MODE: on", 10, 80, 10, LIME); }
        else { DrawText("[F] FLAG_FULLSCREEN_MODE: off", 10, 80, 10, MAROON); }
        if IsWindowState(cast(u32, FLAG_WINDOW_RESIZABLE)) { DrawText("[R] FLAG_WINDOW_RESIZABLE: on", 10, 100, 10, LIME); }
        else { DrawText("[R] FLAG_WINDOW_RESIZABLE: off", 10, 100, 10, MAROON); }
        if IsWindowState(cast(u32, FLAG_WINDOW_UNDECORATED)) { DrawText("[D] FLAG_WINDOW_UNDECORATED: on", 10, 120, 10, LIME); }
        else { DrawText("[D] FLAG_WINDOW_UNDECORATED: off", 10, 120, 10, MAROON); }
        if IsWindowState(cast(u32, FLAG_WINDOW_HIDDEN)) { DrawText("[H] FLAG_WINDOW_HIDDEN: on", 10, 140, 10, LIME); }
        else { DrawText("[H] FLAG_WINDOW_HIDDEN: off (hides for 3 seconds)", 10, 140, 10, MAROON); }
        if IsWindowState(cast(u32, FLAG_WINDOW_MINIMIZED)) { DrawText("[N] FLAG_WINDOW_MINIMIZED: on", 10, 160, 10, LIME); }
        else { DrawText("[N] FLAG_WINDOW_MINIMIZED: off (restores after 3 seconds)", 10, 160, 10, MAROON); }
        if IsWindowState(cast(u32, FLAG_WINDOW_MAXIMIZED)) { DrawText("[M] FLAG_WINDOW_MAXIMIZED: on", 10, 180, 10, LIME); }
        else { DrawText("[M] FLAG_WINDOW_MAXIMIZED: off", 10, 180, 10, MAROON); }
        if IsWindowState(cast(u32, FLAG_WINDOW_UNFOCUSED)) { DrawText("[G] FLAG_WINDOW_UNFOCUSED: on", 10, 200, 10, LIME); }
        else { DrawText("[U] FLAG_WINDOW_UNFOCUSED: off", 10, 200, 10, MAROON); }
        if IsWindowState(cast(u32, FLAG_WINDOW_TOPMOST)) { DrawText("[T] FLAG_WINDOW_TOPMOST: on", 10, 220, 10, LIME); }
        else { DrawText("[T] FLAG_WINDOW_TOPMOST: off", 10, 220, 10, MAROON); }
        if IsWindowState(cast(u32, FLAG_WINDOW_ALWAYS_RUN)) { DrawText("[A] FLAG_WINDOW_ALWAYS_RUN: on", 10, 240, 10, LIME); }
        else { DrawText("[A] FLAG_WINDOW_ALWAYS_RUN: off", 10, 240, 10, MAROON); }
        if IsWindowState(cast(u32, FLAG_VSYNC_HINT)) { DrawText("[V] FLAG_VSYNC_HINT: on", 10, 260, 10, LIME); }
        else { DrawText("[V] FLAG_VSYNC_HINT: off", 10, 260, 10, MAROON); }
        if IsWindowState(cast(u32, FLAG_BORDERLESS_WINDOWED_MODE)) { DrawText("[B] FLAG_BORDERLESS_WINDOWED_MODE: on", 10, 280, 10, LIME); }
        else { DrawText("[B] FLAG_BORDERLESS_WINDOWED_MODE: off", 10, 280, 10, MAROON); }

        DrawText("Following flags can only be set before window creation:", 10, 320, 10, GRAY);
        if IsWindowState(cast(u32, FLAG_WINDOW_HIGHDPI)) { DrawText("FLAG_WINDOW_HIGHDPI: on", 10, 340, 10, LIME); }
        else { DrawText("FLAG_WINDOW_HIGHDPI: off", 10, 340, 10, MAROON); }
        if IsWindowState(cast(u32, FLAG_WINDOW_TRANSPARENT)) { DrawText("FLAG_WINDOW_TRANSPARENT: on", 10, 360, 10, LIME); }
        else { DrawText("FLAG_WINDOW_TRANSPARENT: off", 10, 360, 10, MAROON); }
        if IsWindowState(cast(u32, FLAG_MSAA_4X_HINT)) { DrawText("FLAG_MSAA_4X_HINT: on", 10, 380, 10, LIME); }
        else { DrawText("FLAG_MSAA_4X_HINT: off", 10, 380, 10, MAROON); }

        EndDrawing();
}

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    // Possible window flags:
    //   FLAG_VSYNC_HINT, FLAG_FULLSCREEN_MODE, FLAG_WINDOW_RESIZABLE,
    //   FLAG_WINDOW_UNDECORATED, FLAG_WINDOW_TRANSPARENT, FLAG_WINDOW_HIDDEN,
    //   FLAG_WINDOW_MINIMIZED, FLAG_WINDOW_MAXIMIZED, FLAG_WINDOW_UNFOCUSED,
    //   FLAG_WINDOW_TOPMOST, FLAG_WINDOW_HIGHDPI, FLAG_WINDOW_ALWAYS_RUN,
    //   FLAG_MSAA_4X_HINT

    // Set configuration flags for window creation
    //SetConfigFlags(FLAG_VSYNC_HINT | FLAG_MSAA_4X_HINT | FLAG_WINDOW_HIGHDPI);
    InitWindow(screenWidth, screenHeight, "raylib [core] example - window flags");

    ballPosition = Vector2{ cast(f32, GetScreenWidth()) / 2.0f, cast(f32, GetScreenHeight()) / 2.0f };

    SetTargetFPS(60);               // Set our game to run at 60 frames-per-second

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        // Main game loop
        while !WindowShouldClose() { UpdateDrawFrame(); }   // Detect window close button or ESC key
        // De-Initialization
        CloseWindow();        // Close window and OpenGL context
    }
    return 0;
}
