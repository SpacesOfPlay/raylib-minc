import raylib;

i32 main() {
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - input mouse wheel");

    i32 boxPositionY = screenHeight / 2 - 40;
    i32 scrollSpeed = 4;            // Scrolling speed in pixels

    SetTargetFPS(60);

    // Main game loop
    while !WindowShouldClose() {
        // Update
        boxPositionY -= cast(i32, GetMouseWheelMove() * cast(f32, scrollSpeed));

        // Draw
        BeginDrawing();
            ClearBackground(RAYWHITE);

            DrawRectangle(screenWidth / 2 - 40, boxPositionY, 80, 80, MAROON);

            DrawText("Use mouse wheel to move the cube up and down!", 10, 10, 20, GRAY);
            DrawText(TextFormat("Box position Y: %03i", boxPositionY), 10, 40, 20, LIGHTGRAY);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
