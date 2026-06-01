import raylib;

i32 main() {
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    SetConfigFlags(FLAG_MSAA_4X_HINT);
    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - bouncing ball");

    Vector2 ballPosition = Vector2{ cast(f32, GetScreenWidth()) / 2.0f,
                                    cast(f32, GetScreenHeight()) / 2.0f };
    Vector2 ballSpeed = Vector2{ 5.0f, 4.0f };
    i32 ballRadius = 20;
    f32 gravity = 0.2f;

    bool useGravity = true;
    bool pause = false;
    i32 framesCounter = 0;

    SetTargetFPS(60);

    // Main game loop
    while !WindowShouldClose() {
        // Update
        if IsKeyPressed(KEY_G)     { useGravity = !useGravity; }
        if IsKeyPressed(KEY_SPACE) { pause = !pause; }

        if !pause {
            ballPosition.x += ballSpeed.x;
            ballPosition.y += ballSpeed.y;

            if useGravity { ballSpeed.y += gravity; }

            // Check walls collision for bouncing
            if ballPosition.x >= cast(f32, GetScreenWidth() - ballRadius)
               || ballPosition.x <= cast(f32, ballRadius) {
                ballSpeed.x *= -1.0f;
            }
            if ballPosition.y >= cast(f32, GetScreenHeight() - ballRadius)
               || ballPosition.y <= cast(f32, ballRadius) {
                ballSpeed.y *= -0.95f;
            }
        } else {
            framesCounter++;
        }

        // Draw
        BeginDrawing();
            ClearBackground(RAYWHITE);

            DrawCircleV(ballPosition, cast(f32, ballRadius), MAROON);
            DrawText("PRESS SPACE to PAUSE BALL MOVEMENT",
                     10, GetScreenHeight() - 25, 20, LIGHTGRAY);

            if useGravity {
                DrawText("GRAVITY: ON (Press G to disable)",
                         10, GetScreenHeight() - 50, 20, DARKGREEN);
            } else {
                DrawText("GRAVITY: OFF (Press G to enable)",
                         10, GetScreenHeight() - 50, 20, RED);
            }

            // On pause, draw a blinking message
            if pause && (framesCounter / 30) % 2 != 0 {
                DrawText("PAUSED", 350, 200, 30, GRAY);
            }

            DrawFPS(10, 10);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
