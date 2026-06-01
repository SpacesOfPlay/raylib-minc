import raylib;

i32 main() {
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - input keys");

    Vector2 ballPosition = Vector2{ cast(f32, screenWidth) / 2.0f,
                                    cast(f32, screenHeight) / 2.0f };

    SetTargetFPS(60);

    // Main game loop
    while !WindowShouldClose() {
        // Update
        if IsKeyDown(KEY_RIGHT) { ballPosition.x += 2.0f; }
        if IsKeyDown(KEY_LEFT)  { ballPosition.x -= 2.0f; }
        if IsKeyDown(KEY_UP)    { ballPosition.y -= 2.0f; }
        if IsKeyDown(KEY_DOWN)  { ballPosition.y += 2.0f; }

        // Draw
        BeginDrawing();
            ClearBackground(RAYWHITE);
            DrawText("move the ball with arrow keys", 10, 10, 20, DARKGRAY);
            DrawCircleV(ballPosition, 50.0f, MAROON);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
