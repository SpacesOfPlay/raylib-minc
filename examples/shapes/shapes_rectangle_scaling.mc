import raylib;

const f32 MOUSE_SCALE_MARK_SIZE = 12.0f;

private {
    Rectangle rec = Rectangle{ 100.0f, 100.0f, 200.0f, 80.0f };

    Vector2 mousePosition = Vector2{};

    bool mouseScaleReady = false;
    bool mouseScaleMode = false;
}

void UpdateDrawFrame() {
    // Update
    mousePosition = GetMousePosition();

    Rectangle handle = Rectangle{ rec.x + rec.width - MOUSE_SCALE_MARK_SIZE,
                                  rec.y + rec.height - MOUSE_SCALE_MARK_SIZE,
                                  MOUSE_SCALE_MARK_SIZE, MOUSE_SCALE_MARK_SIZE };
    if CheckCollisionPointRec(mousePosition, handle) {
        mouseScaleReady = true;
        if IsMouseButtonPressed(MOUSE_BUTTON_LEFT) { mouseScaleMode = true; }
    } else {
        mouseScaleReady = false;
    }

    if mouseScaleMode {
        mouseScaleReady = true;

        rec.width = mousePosition.x - rec.x;
        rec.height = mousePosition.y - rec.y;

        // Clamp to a minimum size
        if rec.width < MOUSE_SCALE_MARK_SIZE { rec.width = MOUSE_SCALE_MARK_SIZE; }
        if rec.height < MOUSE_SCALE_MARK_SIZE { rec.height = MOUSE_SCALE_MARK_SIZE; }

        // Clamp to the screen edges
        if rec.width > cast(f32, GetScreenWidth()) - rec.x { rec.width = cast(f32, GetScreenWidth()) - rec.x; }
        if rec.height > cast(f32, GetScreenHeight()) - rec.y { rec.height = cast(f32, GetScreenHeight()) - rec.y; }

        if IsMouseButtonReleased(MOUSE_BUTTON_LEFT) { mouseScaleMode = false; }
    }

    // Draw
    BeginDrawing();
        ClearBackground(RAYWHITE);

        DrawText("Scale rectangle dragging from bottom-right corner!", 10, 10, 20, GRAY);

        DrawRectangleRec(rec, Fade(GREEN, 0.5f));

        if mouseScaleReady {
            DrawRectangleLinesEx(rec, 1.0f, RED);
            DrawTriangle(Vector2{ rec.x + rec.width - MOUSE_SCALE_MARK_SIZE, rec.y + rec.height },
                         Vector2{ rec.x + rec.width, rec.y + rec.height },
                         Vector2{ rec.x + rec.width, rec.y + rec.height - MOUSE_SCALE_MARK_SIZE }, RED);
        }
    EndDrawing();
}

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - rectangle scaling");

    SetTargetFPS(60);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        while !WindowShouldClose() { UpdateDrawFrame(); }
        CloseWindow();
    }
    return 0;
}
