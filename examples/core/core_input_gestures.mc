import raylib;

const i32 MAX_GESTURE_STRINGS = 20;

// minc has no 2D array type, so the upstream `char gestureStrings[20][32]`
// becomes an array of a 32-byte string element.
type GestureStr = u8[32];

i32 main() {
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - input gestures");

    Vector2 touchPosition = Vector2{ 0.0f, 0.0f };
    Rectangle touchArea = Rectangle{ 220.0f, 10.0f, cast(f32, screenWidth) - 230.0f, cast(f32, screenHeight) - 20.0f };

    i32 gesturesCount = 0;
    GestureStr[MAX_GESTURE_STRINGS] gestureStrings;

    i32 currentGesture = GESTURE_NONE;
    i32 lastGesture = GESTURE_NONE;

    SetTargetFPS(60);

    // Main game loop
    while !WindowShouldClose() {
        // Update
        lastGesture = currentGesture;
        currentGesture = GetGestureDetected();
        touchPosition = GetTouchPosition(0);

        if CheckCollisionPointRec(touchPosition, touchArea) && currentGesture != GESTURE_NONE {
            if currentGesture != lastGesture {
                // Store gesture string
                switch currentGesture {
                    case GESTURE_TAP:         { TextCopy(gestureStrings[gesturesCount], "GESTURE TAP"); break case; }
                    case GESTURE_DOUBLETAP:   { TextCopy(gestureStrings[gesturesCount], "GESTURE DOUBLETAP"); break case; }
                    case GESTURE_HOLD:        { TextCopy(gestureStrings[gesturesCount], "GESTURE HOLD"); break case; }
                    case GESTURE_DRAG:        { TextCopy(gestureStrings[gesturesCount], "GESTURE DRAG"); break case; }
                    case GESTURE_SWIPE_RIGHT: { TextCopy(gestureStrings[gesturesCount], "GESTURE SWIPE RIGHT"); break case; }
                    case GESTURE_SWIPE_LEFT:  { TextCopy(gestureStrings[gesturesCount], "GESTURE SWIPE LEFT"); break case; }
                    case GESTURE_SWIPE_UP:    { TextCopy(gestureStrings[gesturesCount], "GESTURE SWIPE UP"); break case; }
                    case GESTURE_SWIPE_DOWN:  { TextCopy(gestureStrings[gesturesCount], "GESTURE SWIPE DOWN"); break case; }
                    case GESTURE_PINCH_IN:    { TextCopy(gestureStrings[gesturesCount], "GESTURE PINCH IN"); break case; }
                    case GESTURE_PINCH_OUT:   { TextCopy(gestureStrings[gesturesCount], "GESTURE PINCH OUT"); break case; }
                    default: { break case; }
                }

                gesturesCount++;

                // Reset gesture strings
                if gesturesCount >= MAX_GESTURE_STRINGS {
                    for i32 i = 0; i < MAX_GESTURE_STRINGS; i++ { gestureStrings[i][0] = 0; }
                    gesturesCount = 0;
                }
            }
        }

        // Draw
        BeginDrawing();
            ClearBackground(RAYWHITE);

            DrawRectangleRec(touchArea, GRAY);
            DrawRectangle(225, 15, screenWidth - 240, screenHeight - 30, RAYWHITE);

            DrawText("GESTURES TEST AREA", screenWidth - 270, screenHeight - 40, 20, Fade(GRAY, 0.5f));

            for i32 i = 0; i < gesturesCount; i++ {
                if i % 2 == 0 { DrawRectangle(10, 30 + 20 * i, 200, 20, Fade(LIGHTGRAY, 0.5f)); }
                else { DrawRectangle(10, 30 + 20 * i, 200, 20, Fade(LIGHTGRAY, 0.3f)); }

                if i < gesturesCount - 1 { DrawText(gestureStrings[i], 35, 36 + 20 * i, 10, DARKGRAY); }
                else { DrawText(gestureStrings[i], 35, 36 + 20 * i, 10, MAROON); }
            }

            DrawRectangleLines(10, 29, 200, screenHeight - 50, GRAY);
            DrawText("DETECTED GESTURES", 50, 15, 10, GRAY);

            if currentGesture != GESTURE_NONE { DrawCircleV(touchPosition, 30.0f, MAROON); }
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
