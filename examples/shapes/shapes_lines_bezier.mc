import raylib;

private {
    Vector2 startPoint = Vector2{ 30.0f, 30.0f };
    Vector2 endPoint = Vector2{ 800.0f - 30.0f, 450.0f - 30.0f };
    bool moveStartPoint = false;
    bool moveEndPoint = false;
}

void UpdateDrawFrame() {
    // Update
    Vector2 mouse = GetMousePosition();

    if CheckCollisionPointCircle(mouse, startPoint, 10.0f) && IsMouseButtonDown(MOUSE_BUTTON_LEFT) {
        moveStartPoint = true;
    } else if CheckCollisionPointCircle(mouse, endPoint, 10.0f) && IsMouseButtonDown(MOUSE_BUTTON_LEFT) {
        moveEndPoint = true;
    }

    if moveStartPoint {
        startPoint = mouse;
        if IsMouseButtonReleased(MOUSE_BUTTON_LEFT) { moveStartPoint = false; }
    }

    if moveEndPoint {
        endPoint = mouse;
        if IsMouseButtonReleased(MOUSE_BUTTON_LEFT) { moveEndPoint = false; }
    }

    // Draw
    BeginDrawing();
        ClearBackground(RAYWHITE);

        DrawText("MOVE START-END POINTS WITH MOUSE", 15, 20, 20, GRAY);

        // Cubic Bezier line, in-out interpolation, no control points
        DrawLineBezier(startPoint, endPoint, 4.0f, BLUE);

        // Start/end handles, enlarged on hover, red while dragging
        DrawCircleV(startPoint, CheckCollisionPointCircle(mouse, startPoint, 10.0f) ? 14.0f : 8.0f,
                    moveStartPoint ? RED : BLUE);
        DrawCircleV(endPoint, CheckCollisionPointCircle(mouse, endPoint, 10.0f) ? 14.0f : 8.0f,
                    moveEndPoint ? RED : BLUE);
    EndDrawing();
}

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    SetConfigFlags(FLAG_MSAA_4X_HINT);
    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - lines bezier");

    SetTargetFPS(60);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        while !WindowShouldClose() { UpdateDrawFrame(); }
        CloseWindow();
    }
    return 0;
}
