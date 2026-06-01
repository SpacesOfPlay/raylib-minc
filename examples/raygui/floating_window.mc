import raylib;
import raygui;

const i32 STATUSBAR_HEIGHT = 24;
const i32 CLOSEBUTTON_SIZE = 18;

void GuiWindowFloating(Vector2* position, Vector2* size, bool* minimized, bool* moving, bool* resizing,
                       fn(Vector2, Vector2): void drawContent, Vector2 contentSize, Vector2* scroll, u8* title) {
    const i32 closeTitleDeltaHalf = (STATUSBAR_HEIGHT - CLOSEBUTTON_SIZE) / 2;

    // window movement and resize input and collision check
    if IsMouseButtonPressed(MOUSE_BUTTON_LEFT) && !*moving && !*resizing {
        Vector2 mousePosition = GetMousePosition();

        Rectangle titleRect = Rectangle{ position.x, position.y, size.x - cast(f32, CLOSEBUTTON_SIZE + closeTitleDeltaHalf), cast(f32, STATUSBAR_HEIGHT) };
        Rectangle resizeRect = Rectangle{ position.x + size.x - 20.0f, position.y + size.y - 20.0f, 20.0f, 20.0f };

        if CheckCollisionPointRec(mousePosition, titleRect) {
            *moving = true;
        } else if !*minimized && CheckCollisionPointRec(mousePosition, resizeRect) {
            *resizing = true;
        }
    }

    // window movement and resize update
    if *moving {
        Vector2 mouseDelta = GetMouseDelta();
        position.x += mouseDelta.x;
        position.y += mouseDelta.y;

        if IsMouseButtonReleased(MOUSE_BUTTON_LEFT) {
            *moving = false;

            // clamp window position to keep it inside the application area
            if position.x < 0.0f { position.x = 0.0f; }
            else if position.x > cast(f32, GetScreenWidth()) - size.x { position.x = cast(f32, GetScreenWidth()) - size.x; }
            if position.y < 0.0f { position.y = 0.0f; }
            else if position.y > cast(f32, GetScreenHeight()) { position.y = cast(f32, GetScreenHeight()) - cast(f32, STATUSBAR_HEIGHT); }
        }
    } else if *resizing {
        Vector2 mouse = GetMousePosition();
        if mouse.x > position.x { size.x = mouse.x - position.x; }
        if mouse.y > position.y { size.y = mouse.y - position.y; }

        // clamp window size to a minimum and the screen size
        if size.x < 100.0f { size.x = 100.0f; }
        else if size.x > cast(f32, GetScreenWidth()) { size.x = cast(f32, GetScreenWidth()); }
        if size.y < 100.0f { size.y = 100.0f; }
        else if size.y > cast(f32, GetScreenHeight()) { size.y = cast(f32, GetScreenHeight()); }

        if IsMouseButtonReleased(MOUSE_BUTTON_LEFT) { *resizing = false; }
    }

    // window and content drawing with scissor and scroll area
    if *minimized {
        GuiStatusBar(Rectangle{ position.x, position.y, size.x, cast(f32, STATUSBAR_HEIGHT) }, title);

        if GuiButton(Rectangle{ position.x + size.x - cast(f32, CLOSEBUTTON_SIZE + closeTitleDeltaHalf),
                                position.y + cast(f32, closeTitleDeltaHalf),
                                cast(f32, CLOSEBUTTON_SIZE), cast(f32, CLOSEBUTTON_SIZE) }, "#120#") != 0 {
            *minimized = false;
        }
    } else {
        *minimized = GuiWindowBox(Rectangle{ position.x, position.y, size.x, size.y }, title) != 0;

        // scissor and draw content within a scroll panel
        if drawContent != null {
            Rectangle scissor = Rectangle{};
            GuiScrollPanel(Rectangle{ position.x, position.y + cast(f32, STATUSBAR_HEIGHT), size.x, size.y - cast(f32, STATUSBAR_HEIGHT) },
                           null,
                           Rectangle{ position.x, position.y, contentSize.x, contentSize.y },
                           scroll, &scissor);

            bool requireScissor = size.x < contentSize.x || size.y < contentSize.y;

            if requireScissor {
                BeginScissorMode(cast(i32, scissor.x), cast(i32, scissor.y), cast(i32, scissor.width), cast(i32, scissor.height));
            }

            drawContent(*position, *scroll);

            if requireScissor { EndScissorMode(); }
        }

        // draw the resize button/icon
        GuiDrawIcon(71, cast(i32, position.x + size.x - 20.0f), cast(i32, position.y + size.y - 20.0f), 1, WHITE);
    }
}

void DrawContent(Vector2 position, Vector2 scroll) {
    GuiButton(Rectangle{ position.x + 20.0f + scroll.x, position.y + 50.0f + scroll.y, 100.0f, 25.0f }, "Button 1");
    GuiButton(Rectangle{ position.x + 20.0f + scroll.x, position.y + 100.0f + scroll.y, 100.0f, 25.0f }, "Button 2");
    GuiButton(Rectangle{ position.x + 20.0f + scroll.x, position.y + 150.0f + scroll.y, 100.0f, 25.0f }, "Button 3");
    GuiLabel(Rectangle{ position.x + 20.0f + scroll.x, position.y + 200.0f + scroll.y, 250.0f, 25.0f }, "A Label");
    GuiLabel(Rectangle{ position.x + 20.0f + scroll.x, position.y + 250.0f + scroll.y, 250.0f, 25.0f }, "Another Label");
    GuiLabel(Rectangle{ position.x + 20.0f + scroll.x, position.y + 300.0f + scroll.y, 250.0f, 25.0f }, "Yet Another Label");
}

i32 main() {
    InitWindow(960, 560, "raygui - floating window example");
    SetTargetFPS(60);

    Vector2 window1Position = Vector2{ 10.0f, 10.0f };
    Vector2 window1Size = Vector2{ 200.0f, 400.0f };
    bool minimized1 = false;
    bool moving1 = false;
    bool resizing1 = false;
    Vector2 scroll1 = Vector2{};

    Vector2 window2Position = Vector2{ 250.0f, 10.0f };
    Vector2 window2Size = Vector2{ 200.0f, 400.0f };
    bool minimized2 = false;
    bool moving2 = false;
    bool resizing2 = false;
    Vector2 scroll2 = Vector2{};

    while !WindowShouldClose() {
        BeginDrawing();
            ClearBackground(DARKGREEN);
            GuiWindowFloating(&window1Position, &window1Size, &minimized1, &moving1, &resizing1, DrawContent, Vector2{ 140.0f, 320.0f }, &scroll1, "Movable & Scalable Window");
            GuiWindowFloating(&window2Position, &window2Size, &minimized2, &moving2, &resizing2, DrawContent, Vector2{ 140.0f, 320.0f }, &scroll2, "Another window");
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
