import raylib;

i32 main() {
    InitWindow(640, 480, "raylib-minc: 2D shapes");
    SetTargetFPS(60);

    while !WindowShouldClose() {
        BeginDrawing();
        ClearBackground(RAYWHITE);

        DrawRectangle(40, 60, 200, 120, BLUE);
        DrawCircle(500, 120, 60.0f, GREEN);
        DrawTriangle(Vector2{ 320, 250 },
                     Vector2{ 180, 440 },
                     Vector2{ 460, 440 }, RED);

        // A line, drawn thick enough to be visible against the BG.
        DrawLineEx(Vector2{ 40, 220 }, Vector2{ 240, 220 }, 4.0f, DARKBLUE);

        DrawText("2D shapes via rshapes", 40, 20, 20, BLACK);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
