import raylib;
import raygui;

// Control state (hoisted to module scope so UpdateDrawFrame can see it).
private {
    Rectangle panelRec = Rectangle{ 20.0f, 40.0f, 200.0f, 150.0f };
    Rectangle panelContentRec = Rectangle{ 0.0f, 0.0f, 340.0f, 340.0f };
    Rectangle panelView = Rectangle{};
    Vector2 panelScroll = Vector2{ 99.0f, -20.0f };

    bool showContentArea = true;
}

void UpdateDrawFrame() {
    // Draw
    BeginDrawing();

        ClearBackground(RAYWHITE);

        DrawText(TextFormat("[%f, %f]", panelScroll.x, panelScroll.y), 4, 4, 20, RED);

        GuiScrollPanel(panelRec, null, panelContentRec, &panelScroll, &panelView);

        BeginScissorMode(cast(i32, panelView.x), cast(i32, panelView.y), cast(i32, panelView.width), cast(i32, panelView.height));
            GuiGrid(Rectangle{ panelRec.x + panelScroll.x, panelRec.y + panelScroll.y, panelContentRec.width, panelContentRec.height }, null, 16.0f, 3, null);
        EndScissorMode();

        if showContentArea {
            DrawRectangle(cast(i32, panelRec.x + panelScroll.x), cast(i32, panelRec.y + panelScroll.y), cast(i32, panelContentRec.width), cast(i32, panelContentRec.height), Fade(RED, 0.1f));
        }

        DrawStyleEditControls();

        GuiCheckBox(Rectangle{ 565.0f, 80.0f, 20.0f, 20.0f }, "SHOW CONTENT AREA", &showContentArea);

        GuiSliderBar(Rectangle{ 590.0f, 385.0f, 145.0f, 15.0f }, "WIDTH", TextFormat("%i", cast(i32, panelContentRec.width)), &panelContentRec.width, 1.0f, 600.0f);
        GuiSliderBar(Rectangle{ 590.0f, 410.0f, 145.0f, 15.0f }, "HEIGHT", TextFormat("%i", cast(i32, panelContentRec.height)), &panelContentRec.height, 1.0f, 400.0f);

    EndDrawing();
}

i32 main() {
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raygui - GuiScrollPanel()");

    SetTargetFPS(60);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        // Main game loop
        while !WindowShouldClose() { UpdateDrawFrame(); }

        // De-Initialization
        CloseWindow();        // Close window and OpenGL context
    }
    return 0;
}

// Draw and process scroll bar style edition controls
void DrawStyleEditControls() {
    // ScrollPanel style controls
    GuiGroupBox(Rectangle{ 550.0f, 170.0f, 220.0f, 205.0f }, "SCROLLBAR STYLE");

    i32 style = GuiGetStyle(SCROLLBAR, BORDER_WIDTH);
    GuiLabel(Rectangle{ 555.0f, 195.0f, 110.0f, 10.0f }, "BORDER_WIDTH");
    GuiSpinner(Rectangle{ 670.0f, 190.0f, 90.0f, 20.0f }, null, &style, 0, 6, false);
    GuiSetStyle(SCROLLBAR, BORDER_WIDTH, style);

    style = GuiGetStyle(SCROLLBAR, ARROWS_SIZE);
    GuiLabel(Rectangle{ 555.0f, 220.0f, 110.0f, 10.0f }, "ARROWS_SIZE");
    GuiSpinner(Rectangle{ 670.0f, 215.0f, 90.0f, 20.0f }, null, &style, 4, 14, false);
    GuiSetStyle(SCROLLBAR, ARROWS_SIZE, style);

    style = GuiGetStyle(SCROLLBAR, SLIDER_PADDING);
    GuiLabel(Rectangle{ 555.0f, 245.0f, 110.0f, 10.0f }, "SLIDER_PADDING");
    GuiSpinner(Rectangle{ 670.0f, 240.0f, 90.0f, 20.0f }, null, &style, 0, 14, false);
    GuiSetStyle(SCROLLBAR, SLIDER_PADDING, style);

    bool scrollBarArrows = GuiGetStyle(SCROLLBAR, ARROWS_VISIBLE) != 0;
    GuiCheckBox(Rectangle{ 565.0f, 280.0f, 20.0f, 20.0f }, "ARROWS_VISIBLE", &scrollBarArrows);
    GuiSetStyle(SCROLLBAR, ARROWS_VISIBLE, cast(i32, scrollBarArrows));

    style = GuiGetStyle(SCROLLBAR, SLIDER_PADDING);
    GuiLabel(Rectangle{ 555.0f, 325.0f, 110.0f, 10.0f }, "SLIDER_PADDING");
    GuiSpinner(Rectangle{ 670.0f, 320.0f, 90.0f, 20.0f }, null, &style, 0, 14, false);
    GuiSetStyle(SCROLLBAR, SLIDER_PADDING, style);

    style = GuiGetStyle(SCROLLBAR, SLIDER_WIDTH);
    GuiLabel(Rectangle{ 555.0f, 350.0f, 110.0f, 10.0f }, "SLIDER_WIDTH");
    GuiSpinner(Rectangle{ 670.0f, 345.0f, 90.0f, 20.0f }, null, &style, 2, 100, false);
    GuiSetStyle(SCROLLBAR, SLIDER_WIDTH, style);

    // SCROLLBAR_LEFT_SIDE == 0 (a raygui #define; #defines don't cross
    // minc import boundaries, so use the literal here).
    u8* text = GuiGetStyle(LISTVIEW, SCROLLBAR_SIDE) == 0 ? "SCROLLBAR: LEFT" : "SCROLLBAR: RIGHT";
    bool toggleScrollBarSide = GuiGetStyle(LISTVIEW, SCROLLBAR_SIDE) != 0;
    GuiToggle(Rectangle{ 560.0f, 110.0f, 200.0f, 35.0f }, text, &toggleScrollBarSide);
    GuiSetStyle(LISTVIEW, SCROLLBAR_SIDE, cast(i32, toggleScrollBarSide));

    // ScrollBar style controls
    GuiGroupBox(Rectangle{ 550.0f, 20.0f, 220.0f, 135.0f }, "SCROLLPANEL STYLE");

    style = GuiGetStyle(LISTVIEW, SCROLLBAR_WIDTH);
    GuiLabel(Rectangle{ 555.0f, 35.0f, 110.0f, 10.0f }, "SCROLLBAR_WIDTH");
    GuiSpinner(Rectangle{ 670.0f, 30.0f, 90.0f, 20.0f }, null, &style, 6, 30, false);
    GuiSetStyle(LISTVIEW, SCROLLBAR_WIDTH, style);

    style = GuiGetStyle(DEFAULT, BORDER_WIDTH);
    GuiLabel(Rectangle{ 555.0f, 60.0f, 110.0f, 10.0f }, "BORDER_WIDTH");
    GuiSpinner(Rectangle{ 670.0f, 55.0f, 90.0f, 20.0f }, null, &style, 0, 20, false);
    GuiSetStyle(DEFAULT, BORDER_WIDTH, style);
}
