import raylib;

private {
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    Texture2D texture;
}

void UpdateDrawFrame() {
    // Draw
    BeginDrawing();
        ClearBackground(RAYWHITE);

        DrawTexture(texture,
                    screenWidth / 2 - texture.width / 2,
                    screenHeight / 2 - texture.height / 2, WHITE);

        DrawText("this IS a texture!", 360, 370, 10, GRAY);
    EndDrawing();
}

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    // Initialization
    InitWindow(screenWidth, screenHeight, "raylib [textures] example - logo raylib");

    // Textures MUST be loaded after window init (OpenGL context required).
    texture = LoadTexture("resources/raylib_logo.png");

    SetTargetFPS(60);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        // Main game loop
        while !WindowShouldClose() { UpdateDrawFrame(); }

        // De-Initialization
        UnloadTexture(texture);

        CloseWindow();
    }
    return 0;
}
