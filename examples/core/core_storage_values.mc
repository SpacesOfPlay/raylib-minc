import raylib;

const u8* STORAGE_DATA_FILE = "storage.data";   // Storage file

// NOTE: Storage positions must start with 0, directly related to file memory layout
enum StorageData {
    STORAGE_POSITION_SCORE   = 0,
    STORAGE_POSITION_HISCORE = 1,
}

private {
    i32 score = 0;
    i32 hiscore = 0;
    i32 framesCounter = 0;
}

void UpdateDrawFrame() {
    // Update
    if IsKeyPressed(KEY_R) {
        score = GetRandomValue(1000, 2000);
        hiscore = GetRandomValue(2000, 4000);
    }

    if IsKeyPressed(KEY_ENTER) {
        SaveStorageValue(cast(u32, STORAGE_POSITION_SCORE), score);
        SaveStorageValue(cast(u32, STORAGE_POSITION_HISCORE), hiscore);
    } else if IsKeyPressed(KEY_SPACE) {
        // NOTE: If requested position could not be found, value 0 is returned
        score = LoadStorageValue(cast(u32, STORAGE_POSITION_SCORE));
        hiscore = LoadStorageValue(cast(u32, STORAGE_POSITION_HISCORE));
    }

    framesCounter++;

    // Draw
    BeginDrawing();
        ClearBackground(RAYWHITE);

        DrawText(TextFormat("SCORE: %i", score), 280, 130, 40, MAROON);
        DrawText(TextFormat("HI-SCORE: %i", hiscore), 210, 200, 50, BLACK);

        DrawText(TextFormat("frames: %i", framesCounter), 10, 10, 20, LIME);

        DrawText("Press R to generate random numbers", 220, 40, 20, LIGHTGRAY);
        DrawText("Press ENTER to SAVE values", 250, 310, 20, LIGHTGRAY);
        DrawText("Press SPACE to LOAD values", 252, 350, 20, LIGHTGRAY);
    EndDrawing();
}

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - storage values");

    SetTargetFPS(60);               // Set our game to run at 60 frames-per-second

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        // Main game loop
        while !WindowShouldClose() { UpdateDrawFrame(); }   // Detect window close button or ESC key
        // De-Initialization
        CloseWindow();        // Close window and OpenGL context
    }
    return 0;
}

// Save integer value to storage file (to defined position)
// NOTE: Storage positions is directly related to file memory layout (4 bytes each integer)
bool SaveStorageValue(u32 position, i32 value) {
    bool success = false;
    i32 dataSize = 0;
    u32 newDataSize = 0;
    u8* fileData = LoadFileData(STORAGE_DATA_FILE, &dataSize);
    u8* newFileData = null;

    if fileData != null {
        if cast(u32, dataSize) <= position * 4 {
            // Increase data size up to position and store value
            newDataSize = (position + 1) * 4;
            newFileData = cast(u8*, MemRealloc(cast(void*, fileData), newDataSize));

            if newFileData != null {
                // MemRealloc succeeded
                i32* dataPtr = cast(i32*, newFileData);
                dataPtr[position] = value;
            } else {
                // MemRealloc failed
                TraceLog(LOG_WARNING, "FILEIO: [%s] Failed to realloc data (%u), position in bytes (%u) bigger than actual file size", STORAGE_DATA_FILE, dataSize, position * 4);

                // We store the old size of the file
                newFileData = fileData;
                newDataSize = cast(u32, dataSize);
            }
        } else {
            // Store the old size of the file
            newFileData = fileData;
            newDataSize = cast(u32, dataSize);

            // Replace value on selected position
            i32* dataPtr = cast(i32*, newFileData);
            dataPtr[position] = value;
        }

        success = SaveFileData(STORAGE_DATA_FILE, cast(void*, newFileData), cast(i32, newDataSize));
        MemFree(cast(void*, newFileData));

        TraceLog(LOG_INFO, "FILEIO: [%s] Saved storage value: %i", STORAGE_DATA_FILE, value);
    } else {
        TraceLog(LOG_INFO, "FILEIO: [%s] File created successfully", STORAGE_DATA_FILE);

        dataSize = cast(i32, (position + 1) * 4);
        fileData = cast(u8*, MemAlloc(cast(u32, dataSize)));
        i32* dataPtr = cast(i32*, fileData);
        dataPtr[position] = value;

        success = SaveFileData(STORAGE_DATA_FILE, cast(void*, fileData), dataSize);
        UnloadFileData(fileData);

        TraceLog(LOG_INFO, "FILEIO: [%s] Saved storage value: %i", STORAGE_DATA_FILE, value);
    }

    return success;
}

// Load integer value from storage file (from defined position)
// NOTE: If requested position could not be found, value 0 is returned
i32 LoadStorageValue(u32 position) {
    i32 value = 0;
    i32 dataSize = 0;
    u8* fileData = LoadFileData(STORAGE_DATA_FILE, &dataSize);

    if fileData != null {
        if dataSize < cast(i32, position * 4) {
            TraceLog(LOG_WARNING, "FILEIO: [%s] Failed to find storage position: %i", STORAGE_DATA_FILE, position);
        } else {
            i32* dataPtr = cast(i32*, fileData);
            value = dataPtr[position];
        }

        UnloadFileData(fileData);

        TraceLog(LOG_INFO, "FILEIO: [%s] Loaded storage value: %i", STORAGE_DATA_FILE, value);
    }

    return value;
}
