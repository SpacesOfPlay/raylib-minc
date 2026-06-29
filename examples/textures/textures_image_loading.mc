import raylib;

private {
    Texture2D tex;
}

void UpdateDrawFrame() {
    BeginDrawing();
    ClearBackground(RAYWHITE);
    DrawTexture(tex, 272, 160, WHITE);
    DrawText("LoadImage(\"resources/raylib_logo.png\")", 130, 280, 20, DARKGRAY);
    DrawText("PNG codec works!", 200, 320, 22, BLACK);
    EndDrawing();
}

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    InitWindow(640, 480, "raylib-minc: PNG textures");
    SetTargetFPS(60);

    Image img = LoadImage("resources/raylib_logo.png");
    tex = LoadTextureFromImage(img);
    UnloadImage(img);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        while !WindowShouldClose() { UpdateDrawFrame(); }
        UnloadTexture(tex);
        CloseWindow();
    }
    return 0;
}
