import raylib;

const i32 screenWidth = 800;
const i32 screenHeight = 450;

private {
    i32 boxPositionY = screenHeight / 2 - 40;
    i32 scrollSpeed = 4;            // Scrolling speed in pixels
}

void UpdateDrawFrame() {
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

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    // Initialization
    InitWindow(screenWidth, screenHeight, "raylib [core] example - input mouse wheel");

    SetTargetFPS(60);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        while !WindowShouldClose() { UpdateDrawFrame(); }
        CloseWindow();
    }
    return 0;
}
