import raylib;

i32 main() {
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - collision area");

    // Box A: moving box
    Rectangle boxA = Rectangle{ 10.0f, cast(f32, GetScreenHeight()) / 2.0f - 50.0f, 200.0f, 100.0f };
    i32 boxASpeedX = 4;

    // Box B: mouse-controlled box
    Rectangle boxB = Rectangle{ cast(f32, GetScreenWidth()) / 2.0f - 30.0f,
                                cast(f32, GetScreenHeight()) / 2.0f - 30.0f, 60.0f, 60.0f };

    Rectangle boxCollision = Rectangle{};   // Collision rectangle

    i32 screenUpperLimit = 40;      // Top menu limit

    bool pause = false;             // Movement pause
    bool collision = false;         // Collision detection

    SetTargetFPS(60);

    // Main game loop
    while !WindowShouldClose() {
        // Update

        // Move box if not paused
        if !pause { boxA.x += cast(f32, boxASpeedX); }

        // Bounce box on x screen limits
        if boxA.x + boxA.width >= cast(f32, GetScreenWidth()) || boxA.x <= 0.0f {
            boxASpeedX *= -1;
        }

        // Update player-controlled box (box B)
        boxB.x = cast(f32, GetMouseX()) - boxB.width / 2.0f;
        boxB.y = cast(f32, GetMouseY()) - boxB.height / 2.0f;

        // Keep box B inside the move area
        if boxB.x + boxB.width >= cast(f32, GetScreenWidth()) { boxB.x = cast(f32, GetScreenWidth()) - boxB.width; }
        else if boxB.x <= 0.0f { boxB.x = 0.0f; }

        if boxB.y + boxB.height >= cast(f32, GetScreenHeight()) { boxB.y = cast(f32, GetScreenHeight()) - boxB.height; }
        else if boxB.y <= cast(f32, screenUpperLimit) { boxB.y = cast(f32, screenUpperLimit); }

        // Check box collision
        collision = CheckCollisionRecs(boxA, boxB);

        // Get collision rectangle (only on collision)
        if collision { boxCollision = GetCollisionRec(boxA, boxB); }

        // Pause box A movement
        if IsKeyPressed(KEY_SPACE) { pause = !pause; }

        // Draw
        BeginDrawing();
            ClearBackground(RAYWHITE);

            DrawRectangle(0, 0, screenWidth, screenUpperLimit, collision ? RED : BLACK);

            DrawRectangleRec(boxA, GOLD);
            DrawRectangleRec(boxB, BLUE);

            if collision {
                // Draw collision area
                DrawRectangleRec(boxCollision, LIME);

                // Draw collision message
                DrawText("COLLISION!",
                         GetScreenWidth() / 2 - MeasureText("COLLISION!", 20) / 2,
                         screenUpperLimit / 2 - 10, 20, BLACK);

                // Draw collision area size
                DrawText(TextFormat("Collision Area: %i",
                                    cast(i32, boxCollision.width) * cast(i32, boxCollision.height)),
                         GetScreenWidth() / 2 - 100, screenUpperLimit + 10, 20, BLACK);
            }

            // Help instructions
            DrawText("Press SPACE to PAUSE/RESUME", 20, screenHeight - 35, 20, LIGHTGRAY);

            DrawFPS(10, 10);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
