import raylib;

private {
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    const i32 virtualScreenWidth = 160;
    const i32 virtualScreenHeight = 90;

    f32 virtualRatio;   // = screenWidth / virtualScreenWidth (set in main)

    Camera2D worldSpaceCamera;    // Game world camera
    Camera2D screenSpaceCamera;   // Smoothing camera

    // Render texture to draw all our objects into
    RenderTexture2D target;

    Rectangle rec01 = Rectangle{ 70.0f, 35.0f, 20.0f, 20.0f };
    Rectangle rec02 = Rectangle{ 90.0f, 55.0f, 30.0f, 10.0f };
    Rectangle rec03 = Rectangle{ 80.0f, 65.0f, 15.0f, 25.0f };

    // The target's height is flipped (negative source height) due to OpenGL
    Rectangle sourceRec;
    Rectangle destRec;

    Vector2 origin = Vector2{ 0.0f, 0.0f };

    f32 rotation = 0.0f;

    f32 cameraX = 0.0f;
    f32 cameraY = 0.0f;

    bool smoothOn = true;
    bool overscan = false;
}

void UpdateDrawFrame() {
        // Update
        rotation += 60.0f * GetFrameTime();   // 60 degrees per second

        // Move the camera to demonstrate the effect
        cameraX = sinf(cast(f32, GetTime())) * 50.0f - 10.0f;
        cameraY = cosf(cast(f32, GetTime())) * 30.0f;

        screenSpaceCamera.target = Vector2{ cameraX, cameraY };

        // Round worldSpace coords, keep decimals in screenSpace coords
        worldSpaceCamera.target.x = truncf(screenSpaceCamera.target.x);
        screenSpaceCamera.target.x -= worldSpaceCamera.target.x;
        screenSpaceCamera.target.x *= virtualRatio;

        worldSpaceCamera.target.y = truncf(screenSpaceCamera.target.y);
        screenSpaceCamera.target.y -= worldSpaceCamera.target.y;
        screenSpaceCamera.target.y *= virtualRatio;

        if IsKeyPressed(KEY_S) { smoothOn = !smoothOn; }
        if IsKeyPressed(KEY_O) { overscan = !overscan; }

        if overscan {
            destRec = Rectangle{ -virtualRatio, -virtualRatio,
                                 cast(f32, screenWidth) + virtualRatio * 2.0f,
                                 cast(f32, screenHeight) + virtualRatio * 2.0f };
        } else {
            destRec = Rectangle{ (cast(f32, screenWidth) - cast(f32, screenWidth) / 1.25f) / 2.0f,
                                 (cast(f32, screenHeight) - cast(f32, screenHeight) / 1.25f) / 2.0f,
                                 cast(f32, screenWidth) / 1.25f, cast(f32, screenHeight) / 1.25f };
        }

        // Draw
        BeginTextureMode(target);
            ClearBackground(RAYWHITE);

            BeginMode2D(worldSpaceCamera);
                DrawRectanglePro(rec01, origin, rotation, BLACK);
                DrawRectanglePro(rec02, origin, -rotation, RED);
                DrawRectanglePro(rec03, origin, rotation + 45.0f, BLUE);
            EndMode2D();
        EndTextureMode();

        BeginDrawing();
            ClearBackground(LIGHTGRAY);

            if smoothOn {
                BeginMode2D(screenSpaceCamera);
                    DrawTexturePro(target.texture, sourceRec, destRec, origin, 0.0f, WHITE);
                EndMode2D();
            } else {
                DrawTexturePro(target.texture, sourceRec, destRec, origin, 0.0f, WHITE);
            }

            DrawText(TextFormat("Screen resolution: %ix%i", screenWidth, screenHeight), 10, 10, 20, DARKBLUE);
            DrawText(TextFormat("World resolution: %ix%i", virtualScreenWidth, virtualScreenHeight), 10, 40, 20, DARKGREEN);
            DrawText(TextFormat("Smooth: %s", smoothOn ? "ON" : "OFF"), 10, screenHeight - 60, 20, RED);
            DrawText(TextFormat("Overscan: %s", overscan ? "ON" : "OFF"), 10, screenHeight - 30, 20, RED);
            DrawFPS(GetScreenWidth() - 95, 10);
        EndDrawing();
}

i32 main() {
    // Initialization
    virtualRatio = cast(f32, screenWidth) / cast(f32, virtualScreenWidth);

    InitWindow(screenWidth, screenHeight, "raylib [core] example - smooth pixelperfect");

    worldSpaceCamera = Camera2D{};   // Game world camera
    worldSpaceCamera.zoom = 1.0f;

    screenSpaceCamera = Camera2D{};   // Smoothing camera
    screenSpaceCamera.zoom = 1.0f;

    // Render texture to draw all our objects into
    target = LoadRenderTexture(virtualScreenWidth, virtualScreenHeight);

    // The target's height is flipped (negative source height) due to OpenGL
    sourceRec = Rectangle{ 0.0f, 0.0f,
                           cast(f32, target.texture.width),
                           -cast(f32, target.texture.height) };
    destRec = Rectangle{ (cast(f32, screenWidth) - cast(f32, screenWidth) / 1.25f) / 2.0f,
                         (cast(f32, screenHeight) - cast(f32, screenHeight) / 1.25f) / 2.0f,
                         cast(f32, screenWidth) / 1.25f, cast(f32, screenHeight) / 1.25f };

    SetTargetFPS(60);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        // Main game loop
        while !WindowShouldClose() { UpdateDrawFrame(); }
        // De-Initialization
        UnloadRenderTexture(target);
        CloseWindow();
    }
    return 0;
}
