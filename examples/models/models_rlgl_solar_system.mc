import raylib;

i32 main() {
    // Initialization
    const i32 screenWidth = 800;
    const i32 screenHeight = 450;

    const f32 sunRadius = 4.0f;
    const f32 earthRadius = 0.6f;
    const f32 earthOrbitRadius = 8.0f;
    const f32 moonRadius = 0.16f;
    const f32 moonOrbitRadius = 1.5f;

    InitWindow(screenWidth, screenHeight, "raylib [models] example - rlgl solar system");

    // Define the camera to look into our 3d world
    Camera camera = Camera{};
    camera.position = Vector3{ 16.0f, 16.0f, 16.0f }; // Camera position
    camera.target = Vector3{ 0.0f, 0.0f, 0.0f };      // Camera looking at point
    camera.up = Vector3{ 0.0f, 1.0f, 0.0f };          // Camera up vector (rotation towards target)
    camera.fovy = 45.0f;                              // Camera field-of-view Y
    camera.projection = CAMERA_PERSPECTIVE;           // Camera projection type

    f32 rotationSpeed = 0.2f;         // General system rotation speed

    f32 earthRotation = 0.0f;         // Rotation of earth around itself (days) in degrees
    f32 earthOrbitRotation = 0.0f;    // Rotation of earth around the Sun (years) in degrees
    f32 moonRotation = 0.0f;          // Rotation of moon around itself
    f32 moonOrbitRotation = 0.0f;     // Rotation of moon around earth in degrees

    SetTargetFPS(60);                 // Set our game to run at 60 frames-per-second

    // Main game loop
    while !WindowShouldClose() {      // Detect window close button or ESC key
        // Update
        earthRotation += (5.0f * rotationSpeed);
        earthOrbitRotation += (365.0f / 360.0f * (5.0f * rotationSpeed) * rotationSpeed);
        moonRotation += (2.0f * rotationSpeed);
        moonOrbitRotation += (8.0f * rotationSpeed);

        // Draw
        BeginDrawing();

            ClearBackground(RAYWHITE);

            BeginMode3D(camera);

                rlPushMatrix();
                    rlScalef(sunRadius, sunRadius, sunRadius);          // Scale Sun
                    DrawSphereBasic(GOLD);                              // Draw the Sun
                rlPopMatrix();

                rlPushMatrix();
                    rlRotatef(earthOrbitRotation, 0.0f, 1.0f, 0.0f);    // Rotation for Earth orbit around Sun
                    rlTranslatef(earthOrbitRadius, 0.0f, 0.0f);         // Translation for Earth orbit

                    rlPushMatrix();
                        rlRotatef(earthRotation, 0.25f, 1.0f, 0.0f);    // Rotation for Earth itself
                        rlScalef(earthRadius, earthRadius, earthRadius);// Scale Earth

                        DrawSphereBasic(BLUE);                          // Draw the Earth
                    rlPopMatrix();

                    rlRotatef(moonOrbitRotation, 0.0f, 1.0f, 0.0f);     // Rotation for Moon orbit around Earth
                    rlTranslatef(moonOrbitRadius, 0.0f, 0.0f);          // Translation for Moon orbit
                    rlRotatef(moonRotation, 0.0f, 1.0f, 0.0f);          // Rotation for Moon itself
                    rlScalef(moonRadius, moonRadius, moonRadius);       // Scale Moon

                    DrawSphereBasic(LIGHTGRAY);                         // Draw the Moon
                rlPopMatrix();

                // Some reference elements (not affected by previous matrix transformations)
                DrawCircle3D(Vector3{ 0.0f, 0.0f, 0.0f }, earthOrbitRadius, Vector3{ 1.0f, 0.0f, 0.0f }, 90.0f, Fade(RED, 0.5f));
                DrawGrid(20, 1.0f);

            EndMode3D();

            DrawText("EARTH ORBITING AROUND THE SUN!", 400, 10, 20, MAROON);
            DrawFPS(10, 10);

        EndDrawing();
    }

    // De-Initialization
    CloseWindow();        // Close window and OpenGL context
    return 0;
}

// Draw sphere without any matrix transformation
// NOTE: Sphere is drawn in world position (0, 0, 0) with radius 1.0f
void DrawSphereBasic(Color color) {
    i32 rings = 16;
    i32 slices = 16;

    // Make sure there is enough space in the internal render batch
    // buffer to store all required vertex, batch is reset if required
    rlCheckRenderBatchLimit((rings + 2) * slices * 6);

    rlBegin(4);    // RL_TRIANGLES
        rlColor4ub(color.r, color.g, color.b, color.a);

        for i32 i = 0; i < (rings + 2); i++ {
            for i32 j = 0; j < slices; j++ {
                f32 ringStep = 180.0f / cast(f32, rings + 1);
                f32 rA = DEG2RAD * (270.0f + ringStep * cast(f32, i));
                f32 rB = DEG2RAD * (270.0f + ringStep * cast(f32, i + 1));
                f32 sA = DEG2RAD * (cast(f32, j) * 360.0f / cast(f32, slices));
                f32 sB = DEG2RAD * (cast(f32, j + 1) * 360.0f / cast(f32, slices));

                rlVertex3f(cosf(rA) * sinf(sA), sinf(rA), cosf(rA) * cosf(sA));
                rlVertex3f(cosf(rB) * sinf(sB), sinf(rB), cosf(rB) * cosf(sB));
                rlVertex3f(cosf(rB) * sinf(sA), sinf(rB), cosf(rB) * cosf(sA));

                rlVertex3f(cosf(rA) * sinf(sA), sinf(rA), cosf(rA) * cosf(sA));
                rlVertex3f(cosf(rA) * sinf(sB), sinf(rA), cosf(rA) * cosf(sB));
                rlVertex3f(cosf(rB) * sinf(sB), sinf(rB), cosf(rB) * cosf(sB));
            }
        }
    rlEnd();
}
