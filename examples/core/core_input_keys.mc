import raylib;

private {
    Vector2 ballPosition;
}

void UpdateDrawFrame() {
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

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - input keys");

    ballPosition = Vector2{ cast(f32, screenWidth) / 2.0f,
                            cast(f32, screenHeight) / 2.0f };

    SetTargetFPS(60);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        while !WindowShouldClose() { UpdateDrawFrame(); }
        CloseWindow();
    }
    return 0;
}
