import raylib;

private {
    Rectangle scissorArea = Rectangle{ 0.0f, 0.0f, 300.0f, 300.0f };
    bool scissorMode = true;
}

void UpdateDrawFrame() {
    // Update
    if IsKeyPressed(KEY_S) { scissorMode = !scissorMode; }

    // Centre the scissor area around the mouse position
    scissorArea.x = cast(f32, GetMouseX()) - scissorArea.width / 2.0f;
    scissorArea.y = cast(f32, GetMouseY()) - scissorArea.height / 2.0f;

    // Draw
    BeginDrawing();
        ClearBackground(RAYWHITE);

        if scissorMode {
            BeginScissorMode(cast(i32, scissorArea.x), cast(i32, scissorArea.y),
                             cast(i32, scissorArea.width), cast(i32, scissorArea.height));
        }

        // Full-screen rectangle + text; only the scissor area renders
        DrawRectangle(0, 0, GetScreenWidth(), GetScreenHeight(), RED);
        DrawText("Move the mouse around to reveal this text!", 190, 200, 20, LIGHTGRAY);

        if scissorMode { EndScissorMode(); }

        DrawRectangleLinesEx(scissorArea, 1.0f, BLACK);
        DrawText("Press S to toggle scissor test", 10, 10, 20, BLACK);
    EndDrawing();
}

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - scissor test");

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
