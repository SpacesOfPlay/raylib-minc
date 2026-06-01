import raylib;

const i32 MAX_COLUMNS = 20;

i32 main() {
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera first person");

    // Define the camera to look into our 3d world (position, target, up vector)
    Camera camera = Camera{};
    camera.position = Vector3{ 0.0f, 2.0f, 4.0f };
    camera.target = Vector3{ 0.0f, 2.0f, 0.0f };
    camera.up = Vector3{ 0.0f, 1.0f, 0.0f };
    camera.fovy = 60.0f;
    camera.projection = CAMERA_PERSPECTIVE;

    i32 cameraMode = CAMERA_FIRST_PERSON;

    // Generate some random columns
    f32[MAX_COLUMNS] heights;
    Vector3[MAX_COLUMNS] positions;
    Color[MAX_COLUMNS] colors;

    for i32 i = 0; i < MAX_COLUMNS; i++ {
        heights[i] = cast(f32, GetRandomValue(1, 12));
        positions[i] = Vector3{ cast(f32, GetRandomValue(-15, 15)),
                                heights[i] / 2.0f,
                                cast(f32, GetRandomValue(-15, 15)) };
        colors[i] = Color{ cast(u8, GetRandomValue(20, 255)),
                           cast(u8, GetRandomValue(10, 55)), 30, 255 };
    }

    DisableCursor();                    // Limit cursor to relative movement inside the window

    SetTargetFPS(60);

    // Main game loop
    while !WindowShouldClose() {
        // Update

        // Switch camera mode
        if IsKeyPressed(KEY_ONE)   { cameraMode = CAMERA_FREE;         camera.up = Vector3{ 0.0f, 1.0f, 0.0f }; }
        if IsKeyPressed(KEY_TWO)   { cameraMode = CAMERA_FIRST_PERSON; camera.up = Vector3{ 0.0f, 1.0f, 0.0f }; }
        if IsKeyPressed(KEY_THREE) { cameraMode = CAMERA_THIRD_PERSON; camera.up = Vector3{ 0.0f, 1.0f, 0.0f }; }
        if IsKeyPressed(KEY_FOUR)  { cameraMode = CAMERA_ORBITAL;      camera.up = Vector3{ 0.0f, 1.0f, 0.0f }; }

        // Switch camera projection
        if IsKeyPressed(KEY_P) {
            if camera.projection == CAMERA_PERSPECTIVE {
                // Create isometric view
                cameraMode = CAMERA_THIRD_PERSON;
                camera.position = Vector3{ 0.0f, 2.0f, -100.0f };
                camera.target = Vector3{ 0.0f, 2.0f, 0.0f };
                camera.up = Vector3{ 0.0f, 1.0f, 0.0f };
                camera.projection = CAMERA_ORTHOGRAPHIC;
                camera.fovy = 20.0f;   // near-plane width in CAMERA_ORTHOGRAPHIC
                CameraYaw(&camera, -135.0f * DEG2RAD, true);
                CameraPitch(&camera, -45.0f * DEG2RAD, true, true, false);
            } else if camera.projection == CAMERA_ORTHOGRAPHIC {
                // Reset to default view
                cameraMode = CAMERA_THIRD_PERSON;
                camera.position = Vector3{ 0.0f, 2.0f, 10.0f };
                camera.target = Vector3{ 0.0f, 2.0f, 0.0f };
                camera.up = Vector3{ 0.0f, 1.0f, 0.0f };
                camera.projection = CAMERA_PERSPECTIVE;
                camera.fovy = 60.0f;
            }
        }

        // UpdateCamera computes movement internally depending on the mode.
        // (Upstream also shows an UpdateCameraPro variant for manual control.)
        UpdateCamera(&camera, cameraMode);

        // Draw
        BeginDrawing();
            ClearBackground(RAYWHITE);

            BeginMode3D(camera);
                DrawPlane(Vector3{ 0.0f, 0.0f, 0.0f }, Vector2{ 32.0f, 32.0f }, LIGHTGRAY); // ground
                DrawCube(Vector3{ -16.0f, 2.5f, 0.0f }, 1.0f, 5.0f, 32.0f, BLUE);   // blue wall
                DrawCube(Vector3{ 16.0f, 2.5f, 0.0f }, 1.0f, 5.0f, 32.0f, LIME);    // green wall
                DrawCube(Vector3{ 0.0f, 2.5f, 16.0f }, 32.0f, 5.0f, 1.0f, GOLD);    // yellow wall

                // Draw some cubes around
                for i32 i = 0; i < MAX_COLUMNS; i++ {
                    DrawCube(positions[i], 2.0f, heights[i], 2.0f, colors[i]);
                    DrawCubeWires(positions[i], 2.0f, heights[i], 2.0f, MAROON);
                }

                // Draw player cube (third-person only)
                if cameraMode == CAMERA_THIRD_PERSON {
                    DrawCube(camera.target, 0.5f, 0.5f, 0.5f, PURPLE);
                    DrawCubeWires(camera.target, 0.5f, 0.5f, 0.5f, DARKPURPLE);
                }
            EndMode3D();

            // Info boxes
            DrawRectangle(5, 5, 330, 100, Fade(SKYBLUE, 0.5f));
            DrawRectangleLines(5, 5, 330, 100, BLUE);

            DrawText("Camera controls:", 15, 15, 10, BLACK);
            DrawText("- Move keys: W, A, S, D, Space, Left-Ctrl", 15, 30, 10, BLACK);
            DrawText("- Look around: arrow keys or mouse", 15, 45, 10, BLACK);
            DrawText("- Camera mode keys: 1, 2, 3, 4", 15, 60, 10, BLACK);
            DrawText("- Zoom keys: num-plus, num-minus or mouse scroll", 15, 75, 10, BLACK);
            DrawText("- Camera projection key: P", 15, 90, 10, BLACK);

            DrawRectangle(600, 5, 195, 100, Fade(SKYBLUE, 0.5f));
            DrawRectangleLines(600, 5, 195, 100, BLUE);

            DrawText("Camera status:", 610, 15, 10, BLACK);
            DrawText(TextFormat("- Mode: %s",
                cameraMode == CAMERA_FREE ? "FREE" :
                cameraMode == CAMERA_FIRST_PERSON ? "FIRST_PERSON" :
                cameraMode == CAMERA_THIRD_PERSON ? "THIRD_PERSON" :
                cameraMode == CAMERA_ORBITAL ? "ORBITAL" : "CUSTOM"), 610, 30, 10, BLACK);
            DrawText(TextFormat("- Projection: %s",
                camera.projection == CAMERA_PERSPECTIVE ? "PERSPECTIVE" :
                camera.projection == CAMERA_ORTHOGRAPHIC ? "ORTHOGRAPHIC" : "CUSTOM"), 610, 45, 10, BLACK);
            DrawText(TextFormat("- Position: (%06.3f, %06.3f, %06.3f)",
                cast(f64, camera.position.x), cast(f64, camera.position.y), cast(f64, camera.position.z)), 610, 60, 10, BLACK);
            DrawText(TextFormat("- Target: (%06.3f, %06.3f, %06.3f)",
                cast(f64, camera.target.x), cast(f64, camera.target.y), cast(f64, camera.target.z)), 610, 75, 10, BLACK);
            DrawText(TextFormat("- Up: (%06.3f, %06.3f, %06.3f)",
                cast(f64, camera.up.x), cast(f64, camera.up.y), cast(f64, camera.up.z)), 610, 90, 10, BLACK);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
