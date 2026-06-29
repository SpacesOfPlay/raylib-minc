import raylib;

private {
    i32 logoPositionX = 800 / 2 - 128;
    i32 logoPositionY = 450 / 2 - 128;

    i32 framesCounter = 0;
    i32 lettersCount = 0;

    i32 topSideRecWidth = 16;
    i32 leftSideRecHeight = 16;

    i32 bottomSideRecWidth = 16;
    i32 rightSideRecHeight = 16;

    i32 state = 0;                  // Tracking animation states (State Machine)
    f32 alpha = 1.0f;               // Useful for fading
}

void UpdateDrawFrame() {
    // Update
    if state == 0 {                          // State 0: Small box blinking
        framesCounter++;
        if framesCounter == 120 {
            state = 1;
            framesCounter = 0;
        }
    } else if state == 1 {                   // State 1: Top and left bars growing
        topSideRecWidth += 4;
        leftSideRecHeight += 4;
        if topSideRecWidth == 256 { state = 2; }
    } else if state == 2 {                   // State 2: Bottom and right bars growing
        bottomSideRecWidth += 4;
        rightSideRecHeight += 4;
        if bottomSideRecWidth == 256 { state = 3; }
    } else if state == 3 {                   // State 3: Letters appearing (one by one)
        framesCounter++;
        if framesCounter / 12 != 0 {         // Every 12 frames, one more letter!
            lettersCount++;
            framesCounter = 0;
        }
        if lettersCount >= 10 {              // When all letters have appeared, fade out
            alpha -= 0.02f;
            if alpha <= 0.0f {
                alpha = 0.0f;
                state = 4;
            }
        }
    } else if state == 4 {                   // State 4: Reset and Replay
        if IsKeyPressed(KEY_R) {
            framesCounter = 0;
            lettersCount = 0;
            topSideRecWidth = 16;
            leftSideRecHeight = 16;
            bottomSideRecWidth = 16;
            rightSideRecHeight = 16;
            alpha = 1.0f;
            state = 0;
        }
    }

    // Draw
    BeginDrawing();
        ClearBackground(RAYWHITE);

        if state == 0 {
            if (framesCounter / 15) % 2 != 0 {
                DrawRectangle(logoPositionX, logoPositionY, 16, 16, BLACK);
            }
        } else if state == 1 {
            DrawRectangle(logoPositionX, logoPositionY, topSideRecWidth, 16, BLACK);
            DrawRectangle(logoPositionX, logoPositionY, 16, leftSideRecHeight, BLACK);
        } else if state == 2 {
            DrawRectangle(logoPositionX, logoPositionY, topSideRecWidth, 16, BLACK);
            DrawRectangle(logoPositionX, logoPositionY, 16, leftSideRecHeight, BLACK);
            DrawRectangle(logoPositionX + 240, logoPositionY, 16, rightSideRecHeight, BLACK);
            DrawRectangle(logoPositionX, logoPositionY + 240, bottomSideRecWidth, 16, BLACK);
        } else if state == 3 {
            DrawRectangle(logoPositionX, logoPositionY, topSideRecWidth, 16, Fade(BLACK, alpha));
            DrawRectangle(logoPositionX, logoPositionY + 16, 16, leftSideRecHeight - 32, Fade(BLACK, alpha));
            DrawRectangle(logoPositionX + 240, logoPositionY + 16, 16, rightSideRecHeight - 32, Fade(BLACK, alpha));
            DrawRectangle(logoPositionX, logoPositionY + 240, bottomSideRecWidth, 16, Fade(BLACK, alpha));
            DrawRectangle(GetScreenWidth() / 2 - 112, GetScreenHeight() / 2 - 112, 224, 224, Fade(RAYWHITE, alpha));
            DrawText(TextSubtext("raylib", 0, lettersCount),
                     GetScreenWidth() / 2 - 44, GetScreenHeight() / 2 + 48, 50, Fade(BLACK, alpha));
        } else if state == 4 {
            DrawText("[R] REPLAY", 340, 200, 20, GRAY);
        }
    EndDrawing();
}

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [shapes] example - logo raylib anim");

    SetTargetFPS(60);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        while !WindowShouldClose() { UpdateDrawFrame(); }
        CloseWindow();
    }
    return 0;
}
