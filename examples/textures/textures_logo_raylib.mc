import raylib;

i32 main() {
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [textures] example - logo raylib");

    // Textures MUST be loaded after window init (OpenGL context required).
    Texture2D texture = LoadTexture("resources/raylib_logo.png");

    SetTargetFPS(60);

    // Main game loop
    while !WindowShouldClose() {
        // Draw
        BeginDrawing();
            ClearBackground(RAYWHITE);

            DrawTexture(texture,
                        screenWidth / 2 - texture.width / 2,
                        screenHeight / 2 - texture.height / 2, WHITE);

            DrawText("this IS a texture!", 360, 370, 10, GRAY);
        EndDrawing();
    }

    // De-Initialization
    UnloadTexture(texture);

    CloseWindow();
    return 0;
}
