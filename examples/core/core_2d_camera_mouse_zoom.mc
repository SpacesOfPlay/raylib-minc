import raylib;

i32 main() {
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera mouse zoom");

    Camera2D camera = Camera2D{};
    camera.zoom = 1.0f;

    i32 zoomMode = 0;       // 0 - Mouse Wheel, 1 - Mouse Move

    SetTargetFPS(60);

    // Main game loop
    while !WindowShouldClose() {
        // Update
        if IsKeyPressed(KEY_ONE) { zoomMode = 0; }
        else if IsKeyPressed(KEY_TWO) { zoomMode = 1; }

        // Translate based on mouse left click
        if IsMouseButtonDown(MOUSE_BUTTON_LEFT) {
            Vector2 delta = GetMouseDelta();
            delta = Vector2Scale(delta, -1.0f / camera.zoom);
            camera.target = Vector2Add(camera.target, delta);
        }

        if zoomMode == 0 {
            // Zoom based on mouse wheel
            f32 wheel = GetMouseWheelMove();
            if wheel != 0.0f {
                // World point under the mouse
                Vector2 mouseWorldPos = GetScreenToWorld2D(GetMousePosition(), camera);

                // Offset to where the mouse is, target to match — keeps the
                // world point under the cursor fixed across zoom levels.
                camera.offset = GetMousePosition();
                camera.target = mouseWorldPos;

                // Log scaling for consistent zoom speed
                f32 scale = 0.2f * wheel;
                camera.zoom = Clamp(expf(logf(camera.zoom) + scale), 0.125f, 64.0f);
            }
        } else {
            // Zoom based on mouse right click
            if IsMouseButtonPressed(MOUSE_BUTTON_RIGHT) {
                Vector2 mouseWorldPos = GetScreenToWorld2D(GetMousePosition(), camera);
                camera.offset = GetMousePosition();
                camera.target = mouseWorldPos;
            }

            if IsMouseButtonDown(MOUSE_BUTTON_RIGHT) {
                f32 deltaX = GetMouseDelta().x;
                f32 scale = 0.005f * deltaX;
                camera.zoom = Clamp(expf(logf(camera.zoom) + scale), 0.125f, 64.0f);
            }
        }

        // Draw
        BeginDrawing();
            ClearBackground(RAYWHITE);

            BeginMode2D(camera);
                // Draw the grid, rotated into the XY plane, centered on 0,0
                rlPushMatrix();
                    rlTranslatef(0.0f, 25.0f * 50.0f, 0.0f);
                    rlRotatef(90.0f, 1.0f, 0.0f, 0.0f);
                    DrawGrid(100, 50.0f);
                rlPopMatrix();

                // Reference circle
                DrawCircle(GetScreenWidth() / 2, GetScreenHeight() / 2, 50.0f, MAROON);
            EndMode2D();

            // Mouse reference
            DrawCircleV(GetMousePosition(), 4.0f, DARKGRAY);
            DrawTextEx(GetFontDefault(),
                       TextFormat("[%i, %i]", GetMouseX(), GetMouseY()),
                       Vector2Add(GetMousePosition(), Vector2{ -44.0f, -24.0f }), 20.0f, 2.0f, BLACK);

            DrawText("[1][2] Select mouse zoom mode (Wheel or Move)", 20, 20, 20, DARKGRAY);
            if zoomMode == 0 {
                DrawText("Mouse left button drag to move, mouse wheel to zoom", 20, 50, 20, DARKGRAY);
            } else {
                DrawText("Mouse left button drag to move, mouse press and move to zoom", 20, 50, 20, DARKGRAY);
            }
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
