import raylib;

private {
    Vector2 ballPosition = Vector2{ -100.0f, -100.0f };
    Color ballColor;
}

void UpdateDrawFrame() {
    // Update
    if IsKeyPressed(KEY_H) {
        if IsCursorHidden() { ShowCursor(); }
        else { HideCursor(); }
    }

    ballPosition = GetMousePosition();

    if IsMouseButtonPressed(MOUSE_BUTTON_LEFT)         { ballColor = MAROON; }
    else if IsMouseButtonPressed(MOUSE_BUTTON_MIDDLE)  { ballColor = LIME; }
    else if IsMouseButtonPressed(MOUSE_BUTTON_RIGHT)   { ballColor = DARKBLUE; }
    else if IsMouseButtonPressed(MOUSE_BUTTON_SIDE)    { ballColor = PURPLE; }
    else if IsMouseButtonPressed(MOUSE_BUTTON_EXTRA)   { ballColor = YELLOW; }
    else if IsMouseButtonPressed(MOUSE_BUTTON_FORWARD) { ballColor = ORANGE; }
    else if IsMouseButtonPressed(MOUSE_BUTTON_BACK)    { ballColor = BEIGE; }

    // Draw
    BeginDrawing();
        ClearBackground(RAYWHITE);

        DrawCircleV(ballPosition, 40.0f, ballColor);

        DrawText("move ball with mouse and click mouse button to change color", 10, 10, 20, DARKGRAY);
        DrawText("Press 'H' to toggle cursor visibility", 10, 30, 20, DARKGRAY);

        if IsCursorHidden() { DrawText("CURSOR HIDDEN", 20, 60, 20, RED); }
        else { DrawText("CURSOR VISIBLE", 20, 60, 20, LIME); }
    EndDrawing();
}

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - input mouse");

    ballColor = DARKBLUE;

    SetTargetFPS(60);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        while !WindowShouldClose() { UpdateDrawFrame(); }
        CloseWindow();
    }
    return 0;
}
