import raylib;

i32 main() {
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [models] example - box collisions");

    // Define the camera to look into our 3d world
    Camera camera = Camera{};
    camera.position = Vector3{ 0.0f, 10.0f, 10.0f };
    camera.target = Vector3{ 0.0f, 0.0f, 0.0f };
    camera.up = Vector3{ 0.0f, 1.0f, 0.0f };
    camera.fovy = 45.0f;
    camera.projection = CAMERA_PERSPECTIVE;

    Vector3 playerPosition = Vector3{ 0.0f, 1.0f, 2.0f };
    Vector3 playerSize = Vector3{ 1.0f, 2.0f, 1.0f };
    Color playerColor = GREEN;

    Vector3 enemyBoxPos = Vector3{ -4.0f, 1.0f, 0.0f };
    Vector3 enemyBoxSize = Vector3{ 2.0f, 2.0f, 2.0f };

    Vector3 enemySpherePos = Vector3{ 4.0f, 0.0f, 0.0f };
    f32 enemySphereSize = 1.5f;

    bool collision = false;

    SetTargetFPS(60);

    // Main game loop
    while !WindowShouldClose() {
        // Update

        // Move player
        if IsKeyDown(KEY_RIGHT)     { playerPosition.x += 0.2f; }
        else if IsKeyDown(KEY_LEFT) { playerPosition.x -= 0.2f; }
        else if IsKeyDown(KEY_DOWN) { playerPosition.z += 0.2f; }
        else if IsKeyDown(KEY_UP)   { playerPosition.z -= 0.2f; }

        collision = false;

        // Player bounding box (used by both checks below)
        BoundingBox playerBox = BoundingBox{
            Vector3{ playerPosition.x - playerSize.x / 2.0f,
                     playerPosition.y - playerSize.y / 2.0f,
                     playerPosition.z - playerSize.z / 2.0f },
            Vector3{ playerPosition.x + playerSize.x / 2.0f,
                     playerPosition.y + playerSize.y / 2.0f,
                     playerPosition.z + playerSize.z / 2.0f } };

        // Player vs enemy-box
        BoundingBox enemyBox = BoundingBox{
            Vector3{ enemyBoxPos.x - enemyBoxSize.x / 2.0f,
                     enemyBoxPos.y - enemyBoxSize.y / 2.0f,
                     enemyBoxPos.z - enemyBoxSize.z / 2.0f },
            Vector3{ enemyBoxPos.x + enemyBoxSize.x / 2.0f,
                     enemyBoxPos.y + enemyBoxSize.y / 2.0f,
                     enemyBoxPos.z + enemyBoxSize.z / 2.0f } };
        if CheckCollisionBoxes(playerBox, enemyBox) { collision = true; }

        // Player vs enemy-sphere
        if CheckCollisionBoxSphere(playerBox, enemySpherePos, enemySphereSize) { collision = true; }

        if collision { playerColor = RED; }
        else { playerColor = GREEN; }

        // Draw
        BeginDrawing();
            ClearBackground(RAYWHITE);

            BeginMode3D(camera);
                // Enemy-box
                DrawCube(enemyBoxPos, enemyBoxSize.x, enemyBoxSize.y, enemyBoxSize.z, GRAY);
                DrawCubeWires(enemyBoxPos, enemyBoxSize.x, enemyBoxSize.y, enemyBoxSize.z, DARKGRAY);

                // Enemy-sphere
                DrawSphere(enemySpherePos, enemySphereSize, GRAY);
                DrawSphereWires(enemySpherePos, enemySphereSize, 16, 16, DARKGRAY);

                // Player
                DrawCubeV(playerPosition, playerSize, playerColor);

                DrawGrid(10, 1.0f);
            EndMode3D();

            DrawText("Move player with arrow keys to collide", 220, 40, 20, GRAY);

            DrawFPS(10, 10);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
