import raylib;

i32 main() {
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [text] example - writing anim");

    u8* message = "This sample illustrates a text writing\nanimation effect! Check it out! ;)";

    i32 framesCounter = 0;

    SetTargetFPS(60);

    // Main game loop
    while !WindowShouldClose() {
        // Update
        if IsKeyDown(KEY_SPACE) { framesCounter += 8; }
        else { framesCounter++; }

        if IsKeyPressed(KEY_ENTER) { framesCounter = 0; }

        // Draw
        BeginDrawing();
            ClearBackground(RAYWHITE);

            DrawText(TextSubtext(message, 0, framesCounter / 10), 210, 160, 20, MAROON);

            DrawText("PRESS [ENTER] to RESTART!", 240, 260, 20, LIGHTGRAY);
            DrawText("HOLD [SPACE] to SPEED UP!", 239, 300, 20, LIGHTGRAY);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
