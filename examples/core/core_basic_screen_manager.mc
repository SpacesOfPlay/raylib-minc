import raylib;

enum GameScreen {
    LOGO = 0,
    TITLE = 1,
    GAMEPLAY = 2,
    ENDING = 3,
}

i32 main() {
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - basic screen manager");

    i32 currentScreen = LOGO;

    i32 framesCounter = 0;          // Useful to count frames

    SetTargetFPS(60);

    // Main game loop
    while !WindowShouldClose() {
        // Update
        switch currentScreen {
            case LOGO: {
                framesCounter++;
                // Wait 2 seconds (120 frames) before jumping to TITLE
                if framesCounter > 120 { currentScreen = TITLE; }
                break case;
            }
            case TITLE: {
                // ENTER/tap to jump to GAMEPLAY
                if IsKeyPressed(KEY_ENTER) || IsGestureDetected(GESTURE_TAP) { currentScreen = GAMEPLAY; }
                break case;
            }
            case GAMEPLAY: {
                // ENTER/tap to jump to ENDING
                if IsKeyPressed(KEY_ENTER) || IsGestureDetected(GESTURE_TAP) { currentScreen = ENDING; }
                break case;
            }
            case ENDING: {
                // ENTER/tap to return to TITLE
                if IsKeyPressed(KEY_ENTER) || IsGestureDetected(GESTURE_TAP) { currentScreen = TITLE; }
                break case;
            }
            default: { break case; }
        }

        // Draw
        BeginDrawing();
            ClearBackground(RAYWHITE);

            switch currentScreen {
                case LOGO: {
                    DrawText("LOGO SCREEN", 20, 20, 40, LIGHTGRAY);
                    DrawText("WAIT for 2 SECONDS...", 290, 220, 20, GRAY);
                    break case;
                }
                case TITLE: {
                    DrawRectangle(0, 0, screenWidth, screenHeight, GREEN);
                    DrawText("TITLE SCREEN", 20, 20, 40, DARKGREEN);
                    DrawText("PRESS ENTER or TAP to JUMP to GAMEPLAY SCREEN", 120, 220, 20, DARKGREEN);
                    break case;
                }
                case GAMEPLAY: {
                    DrawRectangle(0, 0, screenWidth, screenHeight, PURPLE);
                    DrawText("GAMEPLAY SCREEN", 20, 20, 40, MAROON);
                    DrawText("PRESS ENTER or TAP to JUMP to ENDING SCREEN", 130, 220, 20, MAROON);
                    break case;
                }
                case ENDING: {
                    DrawRectangle(0, 0, screenWidth, screenHeight, BLUE);
                    DrawText("ENDING SCREEN", 20, 20, 40, DARKBLUE);
                    DrawText("PRESS ENTER or TAP to RETURN to TITLE SCREEN", 120, 220, 20, DARKBLUE);
                    break case;
                }
                default: { break case; }
            }
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
