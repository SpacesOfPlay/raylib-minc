import raylib;

private {
    i32 randValue;          // Random integer in [-8, 5] (inclusive)
    u32 framesCounter = 0;  // Counts frames
}

void UpdateDrawFrame() {
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

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - random values");

    // SetRandomSeed(0xaabbccff);   // Set a custom seed if desired; default: time(NULL)

    randValue = GetRandomValue(-8, 5);   // Random integer in [-8, 5] (inclusive)

    SetTargetFPS(60);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        // Main game loop
        while !WindowShouldClose() { UpdateDrawFrame(); }
        CloseWindow();
    }
    return 0;
}
