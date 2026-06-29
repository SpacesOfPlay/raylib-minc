import raylib;

private {
    // Initialize the camera
    Camera3D camera;

    // Specify the amount of blocks in each direction
    const i32 numBlocks = 15;
}

void UpdateDrawFrame() {
    // Update
    f64 time = GetTime();

    // Calculate time scale for cube position and size
    f32 scale = (2.0f + sinf(cast(f32, time))) * 0.7f;

    // Move camera around the scene
    f64 cameraTime = time * 0.3;
    camera.position.x = cosf(cast(f32, cameraTime)) * 40.0f;
    camera.position.z = sinf(cast(f32, cameraTime)) * 40.0f;

    // Draw
    BeginDrawing();

        ClearBackground(RAYWHITE);

        BeginMode3D(camera);

            DrawGrid(10, 5.0f);

            for i32 x = 0; x < numBlocks; x++ {
                for i32 y = 0; y < numBlocks; y++ {
                    for i32 z = 0; z < numBlocks; z++ {
                        // Scale of the blocks depends on x/y/z positions
                        f32 blockScale = cast(f32, x + y + z) / 30.0f;

                        // Scatter makes the waving effect by adding blockScale over time
                        f32 scatter = sinf(blockScale * 20.0f + cast(f32, time * 4.0));

                        // Calculate the cube position
                        Vector3 cubePos = Vector3{
                            (cast(f32, x) - cast(f32, numBlocks) / 2.0f) * (scale * 3.0f) + scatter,
                            (cast(f32, y) - cast(f32, numBlocks) / 2.0f) * (scale * 2.0f) + scatter,
                            (cast(f32, z) - cast(f32, numBlocks) / 2.0f) * (scale * 3.0f) + scatter
                        };

                        // Pick a color with a hue depending on cube position for the rainbow color effect
                        // NOTE: This function is quite costly to be done per cube and frame,
                        // pre-catching the results into a separate array could improve performance
                        Color cubeColor = ColorFromHSV(cast(f32, ((x + y + z) * 18) % 360), 0.75f, 0.9f);

                        // Calculate cube size
                        f32 cubeSize = (2.4f - scale) * blockScale;

                        // And finally, draw the cube!
                        DrawCube(cubePos, cubeSize, cubeSize, cubeSize, cubeColor);
                    }
                }
            }

        EndMode3D();

        DrawFPS(10, 10);

    EndDrawing();
}

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [models] example - waving cubes");

    // Initialize the camera
    camera = Camera3D{};
    camera.position = Vector3{ 30.0f, 20.0f, 30.0f };   // Camera position
    camera.target = Vector3{ 0.0f, 0.0f, 0.0f };        // Camera looking at point
    camera.up = Vector3{ 0.0f, 1.0f, 0.0f };            // Camera up vector (rotation towards target)
    camera.fovy = 70.0f;                                // Camera field-of-view Y
    camera.projection = CAMERA_PERSPECTIVE;             // Camera projection type

    SetTargetFPS(60);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        // Main game loop
        while !WindowShouldClose() { UpdateDrawFrame(); }  // Detect window close button or ESC key
        // De-Initialization
        CloseWindow();        // Close window and OpenGL context
    }
    return 0;
}
