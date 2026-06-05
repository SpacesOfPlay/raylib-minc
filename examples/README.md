# raylib-minc examples

Mirrors [upstream raylib's
`examples/`](https://github.com/raysan5/raylib/tree/master/examples)
tree — same folders, same filenames (`.c` → `.mc`).

Each `.mc` is a single-file program. Assets sit in the category's
`resources/` subdir.

## Ported

### core
- `core_basic_window.mc`
- `core_input_keys.mc`
- `core_input_mouse.mc`
- `core_input_mouse_wheel.mc`
- `core_2d_camera.mc`
- `core_2d_camera_mouse_zoom.mc`
- `core_3d_camera_first_person.mc`
- `core_3d_camera_free.mc`
- `core_world_screen.mc`
- `core_random_values.mc`
- `core_random_sequence.mc`
- `core_input_gestures.mc`
- `core_scissor_test.mc`
- `core_smooth_pixelperfect.mc`
- `core_window_should_close.mc`
- `core_basic_screen_manager.mc`
- `core_storage_values.mc`
- `core_window_flags.mc`

### shapes
- `shapes_basic_shapes.mc`
- `shapes_logo_raylib.mc`
- `shapes_logo_raylib_anim.mc`
- `shapes_colors_palette.mc`
- `shapes_bouncing_ball.mc`
- `shapes_following_eyes.mc`
- `shapes_collision_area.mc`
- `shapes_lines_bezier.mc`
- `shapes_rectangle_scaling.mc`

### textures
- `textures_image_loading.mc`  (PNG)
- `textures_logo_raylib.mc`

### text
- `text_font_loading.mc`  (TTF + BMFont)
- `text_format_text.mc`
- `text_input_box.mc`
- `text_writing_anim.mc`
- `text_rectangle_bounds.mc`

### models
- `models_geometric_shapes.mc`
- `models_box_collisions.mc`
- `models_waving_cubes.mc`
- `models_rlgl_solar_system.mc`

### raygui
- `controls_demo.mc`
- `portable_window.mc`
- `scroll_panel.mc`
- `floating_window.mc`
- `controls_test_suite.mc`

## Not ported yet

Upstream has ~150 examples. Most that only use rcore / rshapes /
rtextures (PNG) / rtext should work today — PRs welcome.

Categories needing bring-up first:

- **models** — primitives work; OBJ/glTF loaders don't.
- **audio** — miniaudio not wired.
- **shaders** — `LoadShader` not validated.
- **network**, **others/rlgl** — later.
