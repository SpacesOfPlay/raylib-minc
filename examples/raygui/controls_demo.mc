import raylib;
import raygui;

i32 main() {
    // Initialization
    const i32 screenWidth = 460;
    const i32 screenHeight = 360;

    InitWindow(screenWidth, screenHeight, "raygui - controls demo");

    // Control state
    i32 clicks = 0;
    bool toggleActive = false;
    bool checkboxChecked = false;
    f32 sliderValue = 0.5f;
    f32 sliderBarValue = 30.0f;
    f32 progress = 0.0f;

    SetTargetFPS(60);

    // Main game loop
    while !WindowShouldClose() {
        // Update
        progress += 0.005f;
        if progress > 1.0f { progress = 0.0f; }

        // Draw
        BeginDrawing();

            ClearBackground(GetColor(cast(u32, GuiGetStyle(DEFAULT, BACKGROUND_COLOR))));

            GuiGroupBox(Rectangle{ 15.0f, 15.0f, 430.0f, 330.0f }, "raygui on transpiled raylib");

            GuiLabel(Rectangle{ 30.0f, 35.0f, 400.0f, 24.0f }, TextFormat("Button clicks: %d", clicks));
            if GuiButton(Rectangle{ 30.0f, 65.0f, 400.0f, 32.0f }, "Click me") { clicks++; }

            GuiToggle(Rectangle{ 30.0f, 110.0f, 195.0f, 28.0f }, "Toggle", &toggleActive);
            GuiCheckBox(Rectangle{ 245.0f, 113.0f, 22.0f, 22.0f }, "CheckBox", &checkboxChecked);

            GuiLabel(Rectangle{ 30.0f, 150.0f, 400.0f, 20.0f }, TextFormat("Slider: %.2f", sliderValue));
            GuiSlider(Rectangle{ 90.0f, 175.0f, 300.0f, 22.0f }, "0.0", "1.0", &sliderValue, 0.0f, 1.0f);

            GuiLabel(Rectangle{ 30.0f, 205.0f, 400.0f, 20.0f }, TextFormat("SliderBar: %.0f", sliderBarValue));
            GuiSliderBar(Rectangle{ 90.0f, 230.0f, 300.0f, 22.0f }, "0", "100", &sliderBarValue, 0.0f, 100.0f);

            GuiLabel(Rectangle{ 30.0f, 262.0f, 400.0f, 20.0f }, "Progress (auto):");
            GuiProgressBar(Rectangle{ 30.0f, 285.0f, 400.0f, 24.0f }, "", "", &progress, 0.0f, 1.0f);

            GuiLine(Rectangle{ 30.0f, 315.0f, 400.0f, 12.0f }, "");
            GuiLabel(Rectangle{ 30.0f, 322.0f, 400.0f, 18.0f }, "Drag the sliders, toggle the controls.");

        EndDrawing();
    }

    // De-Initialization
    CloseWindow();        // Close window and OpenGL context
    return 0;
}
