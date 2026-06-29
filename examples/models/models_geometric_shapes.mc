import raylib;

private {
    // Define the camera to look into our 3d world
    Camera camera;
}

void UpdateDrawFrame() {
    // Draw
    BeginDrawing();
        ClearBackground(RAYWHITE);

        BeginMode3D(camera);
            DrawCube(Vector3{ -4.0f, 0.0f, 2.0f }, 2.0f, 5.0f, 2.0f, RED);
            DrawCubeWires(Vector3{ -4.0f, 0.0f, 2.0f }, 2.0f, 5.0f, 2.0f, GOLD);
            DrawCubeWires(Vector3{ -4.0f, 0.0f, -2.0f }, 3.0f, 6.0f, 2.0f, MAROON);

            DrawSphere(Vector3{ -1.0f, 0.0f, -2.0f }, 1.0f, GREEN);
            DrawSphereWires(Vector3{ 1.0f, 0.0f, 2.0f }, 2.0f, 16, 16, LIME);

            DrawCylinder(Vector3{ 4.0f, 0.0f, -2.0f }, 1.0f, 2.0f, 3.0f, 4, SKYBLUE);
            DrawCylinderWires(Vector3{ 4.0f, 0.0f, -2.0f }, 1.0f, 2.0f, 3.0f, 4, DARKBLUE);
            DrawCylinderWires(Vector3{ 4.5f, -1.0f, 2.0f }, 1.0f, 1.0f, 2.0f, 6, BROWN);

            DrawCylinder(Vector3{ 1.0f, 0.0f, -4.0f }, 0.0f, 1.5f, 3.0f, 8, GOLD);
            DrawCylinderWires(Vector3{ 1.0f, 0.0f, -4.0f }, 0.0f, 1.5f, 3.0f, 8, PINK);

            DrawCapsule(Vector3{ -3.0f, 1.5f, -4.0f }, Vector3{ -4.0f, -1.0f, -4.0f }, 1.2f, 8, 8, VIOLET);
            DrawCapsuleWires(Vector3{ -3.0f, 1.5f, -4.0f }, Vector3{ -4.0f, -1.0f, -4.0f }, 1.2f, 8, 8, PURPLE);

            DrawGrid(10, 1.0f);
        EndMode3D();

        DrawFPS(10, 10);
    EndDrawing();
}

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [models] example - geometric shapes");

    // Define the camera to look into our 3d world
    camera = Camera{};
    camera.position = Vector3{ 0.0f, 10.0f, 10.0f };
    camera.target = Vector3{ 0.0f, 0.0f, 0.0f };
    camera.up = Vector3{ 0.0f, 1.0f, 0.0f };
    camera.fovy = 45.0f;
    camera.projection = CAMERA_PERSPECTIVE;

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
