import raylib;

const i32 MAX_INPUT_CHARS = 9;

i32 main() {
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [text] example - input box");

    u8[MAX_INPUT_CHARS + 1] name;   // one extra byte for the null terminator
    name[0] = 0;
    i32 letterCount = 0;

    Rectangle textBox = Rectangle{ cast(f32, screenWidth) / 2.0f - 100.0f, 180.0f, 225.0f, 50.0f };
    bool mouseOnText = false;

    i32 framesCounter = 0;

    SetTargetFPS(60);

    // Main game loop
    while !WindowShouldClose() {
        // Update
        if CheckCollisionPointRec(GetMousePosition(), textBox) { mouseOnText = true; }
        else { mouseOnText = false; }

        if mouseOnText {
            // Set the window's cursor to the I-Beam
            SetMouseCursor(MOUSE_CURSOR_IBEAM);

            // Get char pressed (unicode character) on the queue
            i32 key = GetCharPressed();

            // Check if more characters have been pressed on the same frame
            while key > 0 {
                // Only allow keys in range [32..125]
                if key >= 32 && key <= 125 && letterCount < MAX_INPUT_CHARS {
                    name[letterCount] = cast(u8, key);
                    name[letterCount + 1] = 0;   // null-terminate
                    letterCount++;
                }
                key = GetCharPressed();  // next character in the queue
            }

            if IsKeyPressed(KEY_BACKSPACE) {
                letterCount--;
                if letterCount < 0 { letterCount = 0; }
                name[letterCount] = 0;
            }
        } else {
            SetMouseCursor(MOUSE_CURSOR_DEFAULT);
        }

        if mouseOnText { framesCounter++; }
        else { framesCounter = 0; }

        // Draw
        BeginDrawing();
            ClearBackground(RAYWHITE);

            DrawText("PLACE MOUSE OVER INPUT BOX!", 240, 140, 20, GRAY);

            DrawRectangleRec(textBox, LIGHTGRAY);
            if mouseOnText {
                DrawRectangleLines(cast(i32, textBox.x), cast(i32, textBox.y),
                                   cast(i32, textBox.width), cast(i32, textBox.height), RED);
            } else {
                DrawRectangleLines(cast(i32, textBox.x), cast(i32, textBox.y),
                                   cast(i32, textBox.width), cast(i32, textBox.height), DARKGRAY);
            }

            DrawText(name, cast(i32, textBox.x) + 5, cast(i32, textBox.y) + 8, 40, MAROON);

            DrawText(TextFormat("INPUT CHARS: %i/%i", letterCount, MAX_INPUT_CHARS), 315, 250, 20, DARKGRAY);

            if mouseOnText {
                if letterCount < MAX_INPUT_CHARS {
                    // Draw blinking underscore char
                    if (framesCounter / 20) % 2 == 0 {
                        DrawText("_", cast(i32, textBox.x) + 8 + MeasureText(name, 40),
                                 cast(i32, textBox.y) + 12, 40, MAROON);
                    }
                } else {
                    DrawText("Press BACKSPACE to delete chars...", 230, 300, 20, GRAY);
                }
            }
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
