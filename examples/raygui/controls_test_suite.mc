import raylib;
import raygui;

i32 main() {
    // Initialization
    const i32 screenWidth = 960;
    const i32 screenHeight = 560;

    InitWindow(screenWidth, screenHeight, "raygui - controls test suite");
    SetExitKey(0);

    // GUI controls initialization
    i32 dropdownBox000Active = 0;
    bool dropDown000EditMode = false;

    i32 dropdownBox001Active = 0;
    bool dropDown001EditMode = false;

    i32 spinner001Value = 0;
    bool spinnerEditMode = false;

    i32 valueBox002Value = 0;
    bool valueBoxEditMode = false;

    u8[64] textBoxText;
    TextCopy(textBoxText, "Text box");
    bool textBoxEditMode = false;

    u8[1024] textBoxMultiText;
    TextCopy(textBoxMultiText, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\n\nThisisastringlongerthanexpectedwithoutspacestotestcharbreaksforthosecases,checkingifworkingasexpected.\n\nExcepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.");
    bool textBoxMultiEditMode = false;

    i32 listViewScrollIndex = 0;
    i32 listViewActive = -1;

    i32 listViewExScrollIndex = 0;
    i32 listViewExActive = 2;
    i32 listViewExFocus = -1;
    u8*[8] listViewExList = {"This", "is", "a", "list view", "with", "disable", "elements", "amazing!"};

    Color colorPickerValue = RED;

    f32 sliderValue = 50.0f;
    f32 sliderBarValue = 60.0f;
    f32 progressValue = 0.1f;

    bool forceSquaredChecked = false;

    f32 alphaValue = 0.5f;

    i32 visualStyleActive = 0;
    i32 prevVisualStyleActive = 0;

    i32 toggleGroupActive = 0;
    i32 toggleSliderActive = 0;

    Vector2 viewScroll = Vector2{ 0.0f, 0.0f };

    bool exitWindow = false;
    bool showMessageBox = false;

    u8[256] textInput;
    TextCopy(textInput, "");
    u8[256] textInputFileName;
    TextCopy(textInputFileName, "");
    bool showTextInputBox = false;

    f32 alpha = 1.0f;

    SetTargetFPS(60);

    // Main game loop
    while !exitWindow {    // Detect window close button or ESC key
        // Update
        exitWindow = WindowShouldClose();

        if IsKeyPressed(KEY_ESCAPE) { showMessageBox = !showMessageBox; }

        if IsKeyDown(KEY_LEFT_CONTROL) && IsKeyPressed(KEY_S) { showTextInputBox = true; }

        if alpha < 0.0f { alpha = 0.0f; }
        if IsKeyPressed(KEY_SPACE) { alpha = 1.0f; }

        GuiSetAlpha(alpha);

        if IsKeyPressed(KEY_LEFT) { progressValue -= 0.1f; }
        else if IsKeyPressed(KEY_RIGHT) { progressValue += 0.1f; }
        if progressValue > 1.0f { progressValue = 1.0f; }
        else if progressValue < 0.0f { progressValue = 0.0f; }

        if visualStyleActive != prevVisualStyleActive {
            // NOTE: upstream switches among 13 bundled styles here; this
            // port ships only the default style.
            GuiLoadStyleDefault();
            GuiSetStyle(LABEL, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT);
            prevVisualStyleActive = visualStyleActive;
        }

        // Draw
        BeginDrawing();

            ClearBackground(GetColor(cast(u32, GuiGetStyle(DEFAULT, BACKGROUND_COLOR))));

            // Check all possible events that require GuiLock
            if dropDown000EditMode || dropDown001EditMode { GuiLock(); }
            if showTextInputBox { GuiLock(); }

            // First GUI column
            GuiCheckBox(Rectangle{ 25.0f, 108.0f, 15.0f, 15.0f }, "FORCE CHECK!", &forceSquaredChecked);

            GuiSetStyle(TEXTBOX, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER);
            if GuiSpinner(Rectangle{ 25.0f, 135.0f, 125.0f, 30.0f }, null, &spinner001Value, 0, 100, spinnerEditMode) != 0 { spinnerEditMode = !spinnerEditMode; }
            if GuiValueBox(Rectangle{ 25.0f, 175.0f, 125.0f, 30.0f }, null, &valueBox002Value, 0, 100, valueBoxEditMode) != 0 { valueBoxEditMode = !valueBoxEditMode; }
            GuiSetStyle(TEXTBOX, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT);
            if GuiTextBox(Rectangle{ 25.0f, 215.0f, 125.0f, 30.0f }, textBoxText, 64, textBoxEditMode) != 0 { textBoxEditMode = !textBoxEditMode; }

            GuiSetStyle(BUTTON, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER);

            if GuiButton(Rectangle{ 25.0f, 255.0f, 125.0f, 30.0f }, GuiIconText(ICON_FILE_SAVE, "Save File")) != 0 { showTextInputBox = true; }

            GuiGroupBox(Rectangle{ 25.0f, 310.0f, 125.0f, 150.0f }, "STATES");
            GuiSetState(STATE_NORMAL); if GuiButton(Rectangle{ 30.0f, 320.0f, 115.0f, 30.0f }, "NORMAL") != 0 { }
            GuiSetState(STATE_FOCUSED); if GuiButton(Rectangle{ 30.0f, 355.0f, 115.0f, 30.0f }, "FOCUSED") != 0 { }
            GuiSetState(STATE_PRESSED); if GuiButton(Rectangle{ 30.0f, 390.0f, 115.0f, 30.0f }, "#15#PRESSED") != 0 { }
            GuiSetState(STATE_DISABLED); if GuiButton(Rectangle{ 30.0f, 425.0f, 115.0f, 30.0f }, "DISABLED") != 0 { }
            GuiSetState(STATE_NORMAL);

            GuiComboBox(Rectangle{ 25.0f, 480.0f, 125.0f, 30.0f },
                "default;Jungle;Lavanda;Dark;Bluish;Cyber;Terminal;Candy;Cherry;Ashes;Enefete;Sunny;Amber;Genesis", &visualStyleActive);

            // NOTE: GuiDropdownBox must draw after any other control that can be covered on unfolding
            if dropDown000EditMode || dropDown001EditMode { GuiUnlock(); }
            if showTextInputBox { GuiLock(); }

            GuiSetStyle(DROPDOWNBOX, TEXT_PADDING, 4);
            GuiSetStyle(DROPDOWNBOX, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT);
            if GuiDropdownBox(Rectangle{ 25.0f, 65.0f, 125.0f, 30.0f }, "#01#ONE;#02#TWO;#03#THREE;#04#FOUR", &dropdownBox001Active, dropDown001EditMode) != 0 { dropDown001EditMode = !dropDown001EditMode; }
            GuiSetStyle(DROPDOWNBOX, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER);
            GuiSetStyle(DROPDOWNBOX, TEXT_PADDING, 0);

            if GuiDropdownBox(Rectangle{ 25.0f, 25.0f, 125.0f, 30.0f }, "ONE;TWO;THREE", &dropdownBox000Active, dropDown000EditMode) != 0 { dropDown000EditMode = !dropDown000EditMode; }

            // Second GUI column
            GuiListView(Rectangle{ 165.0f, 25.0f, 140.0f, 124.0f }, "Charmander;Bulbasaur;#18#Squirtle;Pikachu;Eevee;Pidgey", &listViewScrollIndex, &listViewActive);
            GuiListViewEx(Rectangle{ 165.0f, 162.0f, 140.0f, 184.0f }, listViewExList, 8, &listViewExScrollIndex, &listViewExActive, &listViewExFocus);

            GuiToggleGroup(Rectangle{ 165.0f, 360.0f, 140.0f, 24.0f }, "#1#ONE\n#3#TWO\n#8#THREE\n#23#", &toggleGroupActive);
            GuiSetStyle(SLIDER, SLIDER_PADDING, 2);
            GuiToggleSlider(Rectangle{ 165.0f, 480.0f, 140.0f, 30.0f }, "ON;OFF", &toggleSliderActive);
            GuiSetStyle(SLIDER, SLIDER_PADDING, 0);

            // Third GUI column
            GuiPanel(Rectangle{ 320.0f, 25.0f, 225.0f, 140.0f }, "Panel Info");
            GuiColorPicker(Rectangle{ 320.0f, 185.0f, 196.0f, 192.0f }, null, &colorPickerValue);

            GuiSlider(Rectangle{ 355.0f, 400.0f, 165.0f, 20.0f }, "TEST", TextFormat("%2.2f", sliderValue), &sliderValue, -50.0f, 100.0f);
            GuiSliderBar(Rectangle{ 320.0f, 430.0f, 200.0f, 20.0f }, null, TextFormat("%i", cast(i32, sliderBarValue)), &sliderBarValue, 0.0f, 100.0f);

            GuiProgressBar(Rectangle{ 320.0f, 460.0f, 200.0f, 20.0f }, null, TextFormat("%i%%", cast(i32, progressValue * 100.0f)), &progressValue, 0.0f, 1.0f);
            GuiEnable();

            // NOTE: View rectangle could be used to perform some scissor test
            Rectangle view = Rectangle{};
            GuiScrollPanel(Rectangle{ 560.0f, 25.0f, 102.0f, 354.0f }, null, Rectangle{ 560.0f, 25.0f, 300.0f, 1200.0f }, &viewScroll, &view);

            Vector2 mouseCell = Vector2{};
            GuiGrid(Rectangle{ 560.0f, 25.0f + 180.0f + 195.0f, 100.0f, 120.0f }, null, 20.0f, 3, &mouseCell);

            GuiColorBarAlpha(Rectangle{ 320.0f, 490.0f, 200.0f, 30.0f }, null, &alphaValue);

            GuiSetStyle(DEFAULT, TEXT_ALIGNMENT_VERTICAL, TEXT_ALIGN_TOP);   // WARNING: Word-wrap does not work as expected in case of no-top alignment
            GuiSetStyle(DEFAULT, TEXT_WRAP_MODE, TEXT_WRAP_WORD);            // WARNING: If wrap mode enabled, text editing is not supported
            if GuiTextBox(Rectangle{ 678.0f, 25.0f, 258.0f, 492.0f }, textBoxMultiText, 1024, textBoxMultiEditMode) != 0 { textBoxMultiEditMode = !textBoxMultiEditMode; }
            GuiSetStyle(DEFAULT, TEXT_WRAP_MODE, TEXT_WRAP_NONE);
            GuiSetStyle(DEFAULT, TEXT_ALIGNMENT_VERTICAL, TEXT_ALIGN_MIDDLE);

            GuiSetStyle(DEFAULT, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT);
            GuiStatusBar(Rectangle{ 0.0f, cast(f32, GetScreenHeight()) - 20.0f, cast(f32, GetScreenWidth()), 20.0f }, "This is a status bar");
            GuiSetStyle(DEFAULT, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER);

            if showMessageBox {
                DrawRectangle(0, 0, GetScreenWidth(), GetScreenHeight(), Fade(RAYWHITE, 0.8f));
                i32 result = GuiMessageBox(Rectangle{ cast(f32, GetScreenWidth()) / 2.0f - 125.0f, cast(f32, GetScreenHeight()) / 2.0f - 50.0f, 250.0f, 100.0f }, GuiIconText(ICON_EXIT, "Close Window"), "Do you really want to exit?", "Yes;No");

                if result == 0 || result == 2 { showMessageBox = false; }
                else if result == 1 { exitWindow = true; }
            }

            if showTextInputBox {
                GuiUnlock();

                DrawRectangle(0, 0, GetScreenWidth(), GetScreenHeight(), Fade(RAYWHITE, 0.8f));
                i32 result = GuiTextInputBox(Rectangle{ cast(f32, GetScreenWidth()) / 2.0f - 120.0f, cast(f32, GetScreenHeight()) / 2.0f - 60.0f, 240.0f, 140.0f }, GuiIconText(ICON_FILE_SAVE, "Save file as..."), "Introduce output file name:", "Ok;Cancel", textInput, 255, null);

                if result == 1 {
                    TextCopy(textInputFileName, textInput);
                }

                if result == 0 || result == 1 || result == 2 {
                    showTextInputBox = false;
                    TextCopy(textInput, "");
                }
            }

        EndDrawing();
    }

    // De-Initialization
    CloseWindow();        // Close window and OpenGL context
    return 0;
}
