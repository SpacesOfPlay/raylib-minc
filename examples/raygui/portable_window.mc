import raylib;
import raygui;

// NOTE: this example drags the OS window via SetWindowPosition. On the web
// there is a single fixed canvas (no OS window to move), so the drag is a
// no-op there; the title-bar grab and on-screen readouts still work.

const i32 screenWidth = 800;
const i32 screenHeight = 600;

// Control state (hoisted to module scope so UpdateDrawFrame can see it).
private {
    Vector2 mousePosition = Vector2{};
    Vector2 windowPosition = Vector2{ 500.0f, 200.0f };
    Vector2 panOffset = Vector2{};
    bool dragWindow = false;

    bool exitWindow = false;
}

void UpdateDrawFrame() {
    // Update
    mousePosition = GetMousePosition();

    if IsMouseButtonPressed(MOUSE_BUTTON_LEFT) && !dragWindow {
        if CheckCollisionPointRec(mousePosition, Rectangle{ 0.0f, 0.0f, cast(f32, screenWidth), 20.0f }) {
            windowPosition = GetWindowPosition();
            dragWindow = true;
            panOffset = mousePosition;
        }
    }

    if dragWindow {
        windowPosition.x += (mousePosition.x - panOffset.x);
        windowPosition.y += (mousePosition.y - panOffset.y);

        SetWindowPosition(cast(i32, windowPosition.x), cast(i32, windowPosition.y));

        if IsMouseButtonReleased(MOUSE_BUTTON_LEFT) { dragWindow = false; }
    }

    // Draw
    BeginDrawing();

        ClearBackground(RAYWHITE);

        exitWindow = GuiWindowBox(Rectangle{ 0.0f, 0.0f, cast(f32, screenWidth), cast(f32, screenHeight) }, "#198# PORTABLE WINDOW") != 0;

        DrawText(TextFormat("Mouse Position: [ %.0f, %.0f ]", mousePosition.x, mousePosition.y), 10, 40, 10, DARKGRAY);
        DrawText(TextFormat("Window Position: [ %.0f, %.0f ]", windowPosition.x, windowPosition.y), 10, 60, 10, DARKGRAY);

    EndDrawing();
}

i32 main() {
    // Initialization
    SetConfigFlags(cast(u32, FLAG_WINDOW_UNDECORATED));
    InitWindow(screenWidth, screenHeight, "raygui - portable window");

    panOffset = mousePosition;

    SetWindowPosition(cast(i32, windowPosition.x), cast(i32, windowPosition.y));

    SetTargetFPS(60);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        // Main game loop
        while !exitWindow && !WindowShouldClose() {    // Detect window close button or ESC key
            UpdateDrawFrame();
        }

        // De-Initialization
        CloseWindow();        // Close window and OpenGL context
    }
    return 0;
}
