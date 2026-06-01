import raylib;

i32 main() {
    InitWindow(640, 480, "raylib-minc: PNG textures");
    SetTargetFPS(60);

    Image img = LoadImage("resources/raylib_logo.png");
    Texture2D tex = LoadTextureFromImage(img);
    UnloadImage(img);

    while !WindowShouldClose() {
        BeginDrawing();
        ClearBackground(RAYWHITE);
        DrawTexture(tex, 272, 160, WHITE);
        DrawText("LoadImage(\"resources/raylib_logo.png\")", 130, 280, 20, DARKGRAY);
        DrawText("PNG codec works!", 200, 320, 22, BLACK);
        EndDrawing();
    }

    UnloadTexture(tex);
    CloseWindow();
    return 0;
}
