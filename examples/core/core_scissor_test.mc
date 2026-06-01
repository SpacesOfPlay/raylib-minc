import raylib;

i32 main() {
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - scissor test");

    Rectangle scissorArea = Rectangle{ 0.0f, 0.0f, 300.0f, 300.0f };
    bool scissorMode = true;

    SetTargetFPS(60);

    // Main game loop
    while !WindowShouldClose() {
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

    CloseWindow();
    return 0;
}
