import raylib;

i32 main() {
    InitWindow(640, 480, "hello, raylib-minc");
    SetTargetFPS(60);

    while !WindowShouldClose() {
        BeginDrawing();
        ClearBackground(RAYWHITE);
        DrawText("hello, world", 40, 40, 20, BLACK);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
