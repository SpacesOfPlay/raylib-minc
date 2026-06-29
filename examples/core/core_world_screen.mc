import raylib;

private {
    Camera camera;
    Vector3 cubePosition = Vector3{ 0.0f, 0.0f, 0.0f };
    Vector2 cubeScreenPosition = Vector2{ 0.0f, 0.0f };
}

void UpdateDrawFrame() {
    // Update
    UpdateCamera(&camera, CAMERA_THIRD_PERSON);

    // Calculate cube screen space position (offset up a little to sit on top)
    cubeScreenPosition = GetWorldToScreen(
        Vector3{ cubePosition.x, cubePosition.y + 2.5f, cubePosition.z }, camera);

    // Draw
    BeginDrawing();
        ClearBackground(RAYWHITE);

        BeginMode3D(camera);
            DrawCube(cubePosition, 2.0f, 2.0f, 2.0f, RED);
            DrawCubeWires(cubePosition, 2.0f, 2.0f, 2.0f, MAROON);
            DrawGrid(10, 1.0f);
        EndMode3D();

        DrawText("Enemy: 100/100",
                 cast(i32, cubeScreenPosition.x) - MeasureText("Enemy: 100/100", 20) / 2,
                 cast(i32, cubeScreenPosition.y), 20, BLACK);

        DrawText(TextFormat("Cube position in screen space coordinates: [%i, %i]",
                            cast(i32, cubeScreenPosition.x), cast(i32, cubeScreenPosition.y)),
                 10, 10, 20, LIME);
        DrawText("Text 2d should be always on top of the cube", 10, 40, 20, GRAY);
    EndDrawing();
}

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - world screen");

    // Define the camera to look into our 3d world
    camera = Camera{};
    camera.position = Vector3{ 10.0f, 10.0f, 10.0f }; // Camera position
    camera.target = Vector3{ 0.0f, 0.0f, 0.0f };      // Camera looking at point
    camera.up = Vector3{ 0.0f, 1.0f, 0.0f };          // Camera up vector (toward target)
    camera.fovy = 45.0f;                              // Camera field-of-view Y
    camera.projection = CAMERA_PERSPECTIVE;           // Camera projection type

    DisableCursor();                    // Limit cursor to relative movement inside the window

    SetTargetFPS(60);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        // Main game loop
        while !WindowShouldClose() { UpdateDrawFrame(); }
        CloseWindow();
    }
    return 0;
}
