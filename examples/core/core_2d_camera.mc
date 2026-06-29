import raylib;

const i32 MAX_BUILDINGS = 100;

const i32 screenWidth = 800;
const i32 screenHeight = 450;

private {
    Rectangle player = Rectangle{ 400, 280, 40, 40 };
    Rectangle[MAX_BUILDINGS] buildings;
    Color[MAX_BUILDINGS] buildColors;
    Camera2D camera;
}

void UpdateDrawFrame() {
    // Update

    // Player movement
    if IsKeyDown(KEY_RIGHT) { player.x += 2.0f; }
    else if IsKeyDown(KEY_LEFT) { player.x -= 2.0f; }

    // Camera target follows player
    camera.target = Vector2{ player.x + 20.0f, player.y + 20.0f };

    // Camera rotation controls
    if IsKeyDown(KEY_A) { camera.rotation -= 1.0f; }
    else if IsKeyDown(KEY_S) { camera.rotation += 1.0f; }

    // Limit camera rotation to 80 degrees (-40 to 40)
    if camera.rotation > 40.0f { camera.rotation = 40.0f; }
    else if camera.rotation < -40.0f { camera.rotation = -40.0f; }

    // Camera zoom controls — log scaling for consistent zoom speed
    camera.zoom = expf(logf(camera.zoom) + cast(f32, GetMouseWheelMove()) * 0.1f);

    if camera.zoom > 3.0f { camera.zoom = 3.0f; }
    else if camera.zoom < 0.1f { camera.zoom = 0.1f; }

    // Camera reset (zoom and rotation)
    if IsKeyPressed(KEY_R) {
        camera.zoom = 1.0f;
        camera.rotation = 0.0f;
    }

    // Draw
    BeginDrawing();
        ClearBackground(RAYWHITE);

        BeginMode2D(camera);
            DrawRectangle(-6000, 320, 13000, 8000, DARKGRAY);

            for i32 i = 0; i < MAX_BUILDINGS; i++ {
                DrawRectangleRec(buildings[i], buildColors[i]);
            }

            DrawRectangleRec(player, RED);

            DrawLine(cast(i32, camera.target.x), -screenHeight * 10,
                     cast(i32, camera.target.x), screenHeight * 10, GREEN);
            DrawLine(-screenWidth * 10, cast(i32, camera.target.y),
                     screenWidth * 10, cast(i32, camera.target.y), GREEN);
        EndMode2D();

        DrawText("SCREEN AREA", 640, 10, 20, RED);

        DrawRectangle(0, 0, screenWidth, 5, RED);
        DrawRectangle(0, 5, 5, screenHeight - 10, RED);
        DrawRectangle(screenWidth - 5, 5, 5, screenHeight - 10, RED);
        DrawRectangle(0, screenHeight - 5, screenWidth, 5, RED);

        DrawRectangle(10, 10, 250, 113, Fade(SKYBLUE, 0.5f));
        DrawRectangleLines(10, 10, 250, 113, BLUE);

        DrawText("Free 2D camera controls:", 20, 20, 10, BLACK);
        DrawText("- Right/Left to move player", 40, 40, 10, DARKGRAY);
        DrawText("- Mouse Wheel to Zoom in-out", 40, 60, 10, DARKGRAY);
        DrawText("- A / S to Rotate", 40, 80, 10, DARKGRAY);
        DrawText("- R to reset Zoom and Rotation", 40, 100, 10, DARKGRAY);
    EndDrawing();
}

i32 main() {
    when os(wasm) { SetConfigFlags(FLAG_WINDOW_HIGHDPI); }   // web: crisp shapes; native renders at native res (bitmap text stays crisp)
    // Initialization
    InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera");

    i32 spacing = 0;

    for i32 i = 0; i < MAX_BUILDINGS; i++ {
        buildings[i].width = cast(f32, GetRandomValue(50, 200));
        buildings[i].height = cast(f32, GetRandomValue(100, 800));
        buildings[i].y = cast(f32, screenHeight) - 130.0f - buildings[i].height;
        buildings[i].x = -6000.0f + cast(f32, spacing);

        spacing += cast(i32, buildings[i].width);

        buildColors[i] = Color{
            cast(u8, GetRandomValue(200, 240)),
            cast(u8, GetRandomValue(200, 240)),
            cast(u8, GetRandomValue(200, 250)),
            255 };
    }

    camera = Camera2D{};
    camera.target = Vector2{ player.x + 20.0f, player.y + 20.0f };
    camera.offset = Vector2{ cast(f32, screenWidth) / 2.0f, cast(f32, screenHeight) / 2.0f };
    camera.rotation = 0.0f;
    camera.zoom = 1.0f;

    SetTargetFPS(60);

    when os(wasm) {
        rl_web_set_main_loop(UpdateDrawFrame);
    } else {
        while !WindowShouldClose() { UpdateDrawFrame(); }
        CloseWindow();
    }
    return 0;
}
