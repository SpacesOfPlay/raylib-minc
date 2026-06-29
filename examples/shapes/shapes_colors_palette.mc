import raylib;

const i32 MAX_COLORS_COUNT = 21;

private {
    Color[MAX_COLORS_COUNT] colors = {
        DARKGRAY, MAROON, ORANGE, DARKGREEN, DARKBLUE, DARKPURPLE, DARKBROWN,
        GRAY, RED, GOLD, LIME, BLUE, VIOLET, BROWN, LIGHTGRAY, PINK, YELLOW,
        GREEN, SKYBLUE, PURPLE, BEIGE };

    u8*[MAX_COLORS_COUNT] colorNames = {
        "DARKGRAY", "MAROON", "ORANGE", "DARKGREEN", "DARKBLUE", "DARKPURPLE",
        "DARKBROWN", "GRAY", "RED", "GOLD", "LIME", "BLUE", "VIOLET", "BROWN",
        "LIGHTGRAY", "PINK", "YELLOW", "GREEN", "SKYBLUE", "PURPLE", "BEIGE" };

    Rectangle[MAX_COLORS_COUNT] colorsRecs;     // Rectangles array

    i32[MAX_COLORS_COUNT] colorState;            // Color state: 0-DEFAULT, 1-MOUSE_HOVER

    Vector2 mousePoint = Vector2{ 0.0f, 0.0f };
}

void UpdateDrawFrame() {
    // Update
    mousePoint = GetMousePosition();

    for i32 i = 0; i < MAX_COLORS_COUNT; i++ {
        if CheckCollisionPointRec(mousePoint, colorsRecs[i]) { colorState[i] = 1; }
        else { colorState[i] = 0; }
    }

    // Draw
    BeginDrawing();
        ClearBackground(RAYWHITE);

        DrawText("raylib colors palette", 28, 42, 20, BLACK);
        DrawText("press SPACE to see all colors",
                 GetScreenWidth() - 180, GetScreenHeight() - 40, 10, GRAY);

        for i32 i = 0; i < MAX_COLORS_COUNT; i++ {
            DrawRectangleRec(colorsRecs[i],
                             Fade(colors[i], colorState[i] != 0 ? 0.6f : 1.0f));

            if IsKeyDown(KEY_SPACE) || colorState[i] != 0 {
                DrawRectangle(cast(i32, colorsRecs[i].x),
                              cast(i32, colorsRecs[i].y + colorsRecs[i].height - 26.0f),
                              cast(i32, colorsRecs[i].width), 20, BLACK);
                DrawRectangleLinesEx(colorsRecs[i], 6.0f, Fade(BLACK, 0.3f));
                DrawText(colorNames[i],
                         cast(i32, colorsRecs[i].x + colorsRecs[i].width
                                   - cast(f32, MeasureText(colorNames[i], 10)) - 12.0f),
                         cast(i32, colorsRecs[i].y + colorsRecs[i].height - 20.0f),
                         10, colors[i]);
            }
        }
    EndDrawing();
}

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - colors palette");

    // Fills colorsRecs data (for every rectangle)
    for i32 i = 0; i < MAX_COLORS_COUNT; i++ {
        colorsRecs[i].x = 20.0f + 100.0f * cast(f32, i % 7) + 10.0f * cast(f32, i % 7);
        colorsRecs[i].y = 80.0f + 100.0f * cast(f32, i / 7) + 10.0f * cast(f32, i / 7);
        colorsRecs[i].width = 100.0f;
        colorsRecs[i].height = 100.0f;
    }

    SetTargetFPS(60);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        while !WindowShouldClose() { UpdateDrawFrame(); }
        CloseWindow();
    }
    return 0;
}
