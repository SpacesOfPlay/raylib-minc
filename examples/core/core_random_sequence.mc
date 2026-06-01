import raylib;

struct ColorRect {
    Color color;
    Rectangle rect;
}

Color GenerateRandomColor() {
    return Color{ cast(u8, GetRandomValue(0, 255)),
                  cast(u8, GetRandomValue(0, 255)),
                  cast(u8, GetRandomValue(0, 255)),
                  255 };
}

ColorRect* GenerateRandomColorRectSequence(f32 rectCount, f32 rectWidth, f32 screenWidth, f32 screenHeight) {
    i32 n = cast(i32, rectCount);
    ColorRect* rectangles = cast(ColorRect*, MemAlloc(cast(u32, n * cast(i32, sizeof(ColorRect)))));

    i32* seq = LoadRandomSequence(cast(u32, rectCount), 0, n - 1);
    f32 rectSeqWidth = rectCount * rectWidth;
    f32 startX = (screenWidth - rectSeqWidth) * 0.5f;

    for i32 i = 0; i < n; i++ {
        i32 rectHeight = cast(i32, Remap(cast(f32, seq[i]), 0.0f, rectCount - 1.0f, 0.0f, screenHeight));

        rectangles[i].color = GenerateRandomColor();
        rectangles[i].rect = Rectangle{ startX + cast(f32, i) * rectWidth,
                                        screenHeight - cast(f32, rectHeight),
                                        rectWidth, cast(f32, rectHeight) };
    }

    UnloadRandomSequence(seq);
    return rectangles;
}

void ShuffleColorRectSequence(ColorRect* rectangles, i32 rectCount) {
    i32* seq = LoadRandomSequence(cast(u32, rectCount), 0, rectCount - 1);

    for i32 i1 = 0; i1 < rectCount; i1++ {
        ColorRect* r1 = &rectangles[i1];
        ColorRect* r2 = &rectangles[seq[i1]];

        // Swap only color + height
        ColorRect tmp = *r1;
        r1.color = r2.color;
        r1.rect.height = r2.rect.height;
        r1.rect.y = r2.rect.y;
        r2.color = tmp.color;
        r2.rect.height = tmp.rect.height;
        r2.rect.y = tmp.rect.y;
    }

    UnloadRandomSequence(seq);
}

i32 main() {
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - random sequence");

    i32 rectCount = 20;
    f32 rectSize = cast(f32, screenWidth) / cast(f32, rectCount);
    ColorRect* rectangles = GenerateRandomColorRectSequence(cast(f32, rectCount), rectSize,
                                                            cast(f32, screenWidth), 0.75f * cast(f32, screenHeight));

    SetTargetFPS(60);

    // Main game loop
    while !WindowShouldClose() {
        // Update
        if IsKeyPressed(KEY_SPACE) { ShuffleColorRectSequence(rectangles, rectCount); }

        if IsKeyPressed(KEY_UP) {
            rectCount++;
            rectSize = cast(f32, screenWidth) / cast(f32, rectCount);
            MemFree(rectangles);
            rectangles = GenerateRandomColorRectSequence(cast(f32, rectCount), rectSize,
                                                         cast(f32, screenWidth), 0.75f * cast(f32, screenHeight));
        }

        if IsKeyPressed(KEY_DOWN) {
            if rectCount >= 4 {
                rectCount--;
                rectSize = cast(f32, screenWidth) / cast(f32, rectCount);
                MemFree(rectangles);
                rectangles = GenerateRandomColorRectSequence(cast(f32, rectCount), rectSize,
                                                             cast(f32, screenWidth), 0.75f * cast(f32, screenHeight));
            }
        }

        // Draw
        BeginDrawing();
            ClearBackground(RAYWHITE);

            for i32 i = 0; i < rectCount; i++ {
                DrawRectangleRec(rectangles[i].rect, rectangles[i].color);

                DrawText("Press SPACE to shuffle the current sequence", 10, screenHeight - 96, 20, BLACK);
                DrawText("Press UP to add a rectangle and generate a new sequence", 10, screenHeight - 64, 20, BLACK);
                DrawText("Press DOWN to remove a rectangle and generate a new sequence", 10, screenHeight - 32, 20, BLACK);
            }

            DrawText(TextFormat("Count: %d rectangles", rectCount), 10, 10, 20, MAROON);

            DrawFPS(screenWidth - 80, 10);
        EndDrawing();
    }

    // De-Initialization
    MemFree(rectangles);
    CloseWindow();
    return 0;
}
