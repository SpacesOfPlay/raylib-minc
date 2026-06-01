import raylib;

i32 main() {
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [text] example - rectangle bounds");

    u8* text = "Text cannot escape\tthis container\t...word wrap also works when active so here's a long text for testing.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Nec ullamcorper sit amet risus nullam eget felis eget.";

    bool resizing = false;
    bool wordWrap = true;

    Rectangle container = Rectangle{ 25.0f, 25.0f, cast(f32, screenWidth) - 50.0f, cast(f32, screenHeight) - 250.0f };
    Rectangle resizer = Rectangle{ container.x + container.width - 17.0f, container.y + container.height - 17.0f, 14.0f, 14.0f };

    // Minimum width and height for the container rectangle
    const f32 minWidth = 60.0f;
    const f32 minHeight = 60.0f;
    const f32 maxWidth = cast(f32, screenWidth) - 50.0f;
    const f32 maxHeight = cast(f32, screenHeight) - 160.0f;

    Vector2 lastMouse = Vector2{ 0.0f, 0.0f }; // Stores last mouse coordinates
    Color borderColor = MAROON;                // Container border color
    Font font = GetFontDefault();              // Get default system font

    SetTargetFPS(60);                          // Set our game to run at 60 frames-per-second

    // Main game loop
    while !WindowShouldClose() {               // Detect window close button or ESC key
        // Update
        if IsKeyPressed(KEY_SPACE) { wordWrap = !wordWrap; }

        Vector2 mouse = GetMousePosition();

        // Check if the mouse is inside the container and toggle border color
        if CheckCollisionPointRec(mouse, container) { borderColor = Fade(MAROON, 0.4f); }
        else if !resizing { borderColor = MAROON; }

        // Container resizing logic
        if resizing {
            if IsMouseButtonReleased(MOUSE_BUTTON_LEFT) { resizing = false; }

            f32 width = container.width + (mouse.x - lastMouse.x);
            if width > minWidth {
                if width < maxWidth { container.width = width; } else { container.width = maxWidth; }
            } else { container.width = minWidth; }

            f32 height = container.height + (mouse.y - lastMouse.y);
            if height > minHeight {
                if height < maxHeight { container.height = height; } else { container.height = maxHeight; }
            } else { container.height = minHeight; }
        } else {
            // Check if we're resizing
            if IsMouseButtonDown(MOUSE_BUTTON_LEFT) && CheckCollisionPointRec(mouse, resizer) { resizing = true; }
        }

        // Move resizer rectangle properly
        resizer.x = container.x + container.width - 17.0f;
        resizer.y = container.y + container.height - 17.0f;

        lastMouse = mouse; // Update mouse

        // Draw
        BeginDrawing();

            ClearBackground(RAYWHITE);

            DrawRectangleLinesEx(container, 3.0f, borderColor);    // Draw container border

            // Draw text in container (add some padding)
            DrawTextBoxed(font, text, Rectangle{ container.x + 4.0f, container.y + 4.0f, container.width - 4.0f, container.height - 4.0f }, 20.0f, 2.0f, wordWrap, GRAY);

            DrawRectangleRec(resizer, borderColor);                // Draw the resize box

            // Draw bottom info
            DrawRectangle(0, screenHeight - 54, screenWidth, 54, GRAY);
            DrawRectangleRec(Rectangle{ 382.0f, cast(f32, screenHeight) - 34.0f, 12.0f, 12.0f }, MAROON);

            DrawText("Word Wrap: ", 313, screenHeight - 115, 20, BLACK);
            if wordWrap { DrawText("ON", 447, screenHeight - 115, 20, RED); }
            else { DrawText("OFF", 447, screenHeight - 115, 20, BLACK); }

            DrawText("Press [SPACE] to toggle word wrap", 218, screenHeight - 86, 20, GRAY);

            DrawText("Click hold & drag the    to resize the container", 155, screenHeight - 38, 20, RAYWHITE);

        EndDrawing();
    }

    // De-Initialization
    CloseWindow();        // Close window and OpenGL context
    return 0;
}

// Draw text using font inside rectangle limits
void DrawTextBoxed(Font font, u8* text, Rectangle rec, f32 fontSize, f32 spacing, bool wordWrap, Color tint) {
    DrawTextBoxedSelectable(font, text, rec, fontSize, spacing, wordWrap, tint, 0, 0, WHITE, WHITE);
}

// Draw text using font inside rectangle limits with support for text selection
void DrawTextBoxedSelectable(Font font, u8* text, Rectangle rec, f32 fontSize, f32 spacing, bool wordWrap, Color tint, i32 selectStart, i32 selectLength, Color selectTint, Color selectBackTint) {
    i32 length = cast(i32, TextLength(text));  // Total length in bytes of the text, scanned by codepoints in loop

    f32 textOffsetY = 0.0f;          // Offset between lines (on line break '\n')
    f32 textOffsetX = 0.0f;          // Offset X to next character to draw

    f32 scaleFactor = fontSize / cast(f32, font.baseSize);     // Character rectangle scaling factor

    // Word/character wrapping mechanism variables
    const i32 MEASURE_STATE = 0;
    const i32 DRAW_STATE = 1;
    i32 state = DRAW_STATE;
    if wordWrap { state = MEASURE_STATE; }

    i32 startLine = -1;         // Index where to begin drawing (where a line begins)
    i32 endLine = -1;           // Index where to stop drawing (where a line ends)
    i32 lastk = -1;             // Holds last value of the character position

    i32 i = 0;
    i32 k = 0;
    while i < length {
        // Get next codepoint from byte string and glyph index in font
        i32 codepointByteCount = 0;
        i32 codepoint = GetCodepoint(&text[i], &codepointByteCount);
        i32 index = GetGlyphIndex(font, codepoint);

        // NOTE: Normally we exit the decoding sequence as soon as a bad byte is found (and return 0x3f)
        // but we need to draw all of the bad bytes using the '?' symbol moving one byte
        if codepoint == 0x3f { codepointByteCount = 1; }
        i += (codepointByteCount - 1);

        f32 glyphWidth = 0.0f;
        if codepoint != '\n' {
            if font.glyphs[index].advanceX == 0 { glyphWidth = font.recs[index].width * scaleFactor; }
            else { glyphWidth = cast(f32, font.glyphs[index].advanceX) * scaleFactor; }

            if i + 1 < length { glyphWidth = glyphWidth + spacing; }
        }

        // NOTE: When wordWrap is ON we first measure how much of the text we can draw before going outside of the rec container.
        // We store this info in startLine and endLine, then we change states, draw the text between those two variables
        // and change states again and again recursively until the end of the text (or until we get outside of the container).
        // When wordWrap is OFF we don't need the measure state so we go to the drawing state immediately
        // and begin drawing on the next line before we can get outside the container.
        if state == MEASURE_STATE {
            // TODO: There are multiple types of spaces in UNICODE, maybe it's a good idea to add support for more.
            if (codepoint == ' ') || (codepoint == '\t') || (codepoint == '\n') { endLine = i; }

            if (textOffsetX + glyphWidth) > rec.width {
                if endLine < 1 { endLine = i; }
                if i == endLine { endLine -= codepointByteCount; }
                if (startLine + codepointByteCount) == endLine { endLine = (i - codepointByteCount); }

                state = 1 - state;
            } else if (i + 1) == length {
                endLine = i;
                state = 1 - state;
            } else if codepoint == '\n' { state = 1 - state; }

            if state == DRAW_STATE {
                textOffsetX = 0.0f;
                i = startLine;
                glyphWidth = 0.0f;

                // Save character position when we switch states
                i32 tmp = lastk;
                lastk = k - 1;
                k = tmp;
            }
        } else {
            if codepoint == '\n' {
                if !wordWrap {
                    textOffsetY += (cast(f32, font.baseSize) + cast(f32, font.baseSize) / 2.0f) * scaleFactor;
                    textOffsetX = 0.0f;
                }
            } else {
                if !wordWrap && ((textOffsetX + glyphWidth) > rec.width) {
                    textOffsetY += (cast(f32, font.baseSize) + cast(f32, font.baseSize) / 2.0f) * scaleFactor;
                    textOffsetX = 0.0f;
                }

                // When text overflows rectangle height limit, just stop drawing
                if (textOffsetY + cast(f32, font.baseSize) * scaleFactor) > rec.height { break; }

                // Draw selection background
                bool isGlyphSelected = false;
                if (selectStart >= 0) && (k >= selectStart) && (k < (selectStart + selectLength)) {
                    DrawRectangleRec(Rectangle{ rec.x + textOffsetX - 1.0f, rec.y + textOffsetY, glyphWidth, cast(f32, font.baseSize) * scaleFactor }, selectBackTint);
                    isGlyphSelected = true;
                }

                // Draw current character glyph
                if (codepoint != ' ') && (codepoint != '\t') {
                    Color glyphTint = tint;
                    if isGlyphSelected { glyphTint = selectTint; }
                    DrawTextCodepoint(font, codepoint, Vector2{ rec.x + textOffsetX, rec.y + textOffsetY }, fontSize, glyphTint);
                }
            }

            if wordWrap && (i == endLine) {
                textOffsetY += (cast(f32, font.baseSize) + cast(f32, font.baseSize) / 2.0f) * scaleFactor;
                textOffsetX = 0.0f;
                startLine = endLine;
                endLine = -1;
                glyphWidth = 0.0f;
                selectStart += lastk - k;
                k = lastk;

                state = 1 - state;
            }
        }

        if (textOffsetX != 0.0f) || (codepoint != ' ') { textOffsetX += glyphWidth; }  // avoid leading spaces

        i++;
        k++;
    }
}
