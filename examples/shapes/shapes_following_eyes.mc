import raylib;

private {
    Vector2 scleraLeftPosition;
    Vector2 scleraRightPosition;
    f32 scleraRadius = 80.0f;

    Vector2 irisLeftPosition;
    Vector2 irisRightPosition;
    f32 irisRadius = 24.0f;
}

void UpdateDrawFrame() {
    f32 angle = 0.0f;
    f32 dx = 0.0f;
    f32 dy = 0.0f;
    f32 dxx = 0.0f;
    f32 dyy = 0.0f;

    // Update
    irisLeftPosition = GetMousePosition();
    irisRightPosition = GetMousePosition();

    // Check not inside the left eye sclera
    if !CheckCollisionPointCircle(irisLeftPosition, scleraLeftPosition, scleraRadius - irisRadius) {
        dx = irisLeftPosition.x - scleraLeftPosition.x;
        dy = irisLeftPosition.y - scleraLeftPosition.y;

        angle = atan2f(dy, dx);

        dxx = (scleraRadius - irisRadius) * cosf(angle);
        dyy = (scleraRadius - irisRadius) * sinf(angle);

        irisLeftPosition.x = scleraLeftPosition.x + dxx;
        irisLeftPosition.y = scleraLeftPosition.y + dyy;
    }

    // Check not inside the right eye sclera
    if !CheckCollisionPointCircle(irisRightPosition, scleraRightPosition, scleraRadius - irisRadius) {
        dx = irisRightPosition.x - scleraRightPosition.x;
        dy = irisRightPosition.y - scleraRightPosition.y;

        angle = atan2f(dy, dx);

        dxx = (scleraRadius - irisRadius) * cosf(angle);
        dyy = (scleraRadius - irisRadius) * sinf(angle);

        irisRightPosition.x = scleraRightPosition.x + dxx;
        irisRightPosition.y = scleraRightPosition.y + dyy;
    }

    // Draw
    BeginDrawing();
        ClearBackground(RAYWHITE);

        DrawCircleV(scleraLeftPosition, scleraRadius, LIGHTGRAY);
        DrawCircleV(irisLeftPosition, irisRadius, BROWN);
        DrawCircleV(irisLeftPosition, 10.0f, BLACK);

        DrawCircleV(scleraRightPosition, scleraRadius, LIGHTGRAY);
        DrawCircleV(irisRightPosition, irisRadius, DARKGREEN);
        DrawCircleV(irisRightPosition, 10.0f, BLACK);

        DrawFPS(10, 10);
    EndDrawing();
}

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - following eyes");

    scleraLeftPosition = Vector2{ cast(f32, GetScreenWidth()) / 2.0f - 100.0f,
                                  cast(f32, GetScreenHeight()) / 2.0f };
    scleraRightPosition = Vector2{ cast(f32, GetScreenWidth()) / 2.0f + 100.0f,
                                   cast(f32, GetScreenHeight()) / 2.0f };

    irisLeftPosition = Vector2{ cast(f32, GetScreenWidth()) / 2.0f - 100.0f,
                                cast(f32, GetScreenHeight()) / 2.0f };
    irisRightPosition = Vector2{ cast(f32, GetScreenWidth()) / 2.0f + 100.0f,
                                 cast(f32, GetScreenHeight()) / 2.0f };

    SetTargetFPS(60);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        while !WindowShouldClose() { UpdateDrawFrame(); }
        CloseWindow();
    }
    return 0;
}
