import raylib;

i32 main() {
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - random values");

    // SetRandomSeed(0xaabbccff);   // Set a custom seed if desired; default: time(NULL)

    i32 randValue = GetRandomValue(-8, 5);   // Random integer in [-8, 5] (inclusive)

    u32 framesCounter = 0;          // Counts frames

    SetTargetFPS(60);

    // Main game loop
    while !WindowShouldClose() {
        // Update
        framesCounter++;

        // Every two seconds (120 frames) a new random value is generated
        if (framesCounter / 120) % 2 == 1 {
            randValue = GetRandomValue(-8, 5);
            framesCounter = 0;
        }

        // Draw
        BeginDrawing();
            ClearBackground(RAYWHITE);

            DrawText("Every 2 seconds a new random value is generated:", 130, 100, 20, MAROON);
            DrawText(TextFormat("%i", randValue), 360, 180, 80, LIGHTGRAY);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
