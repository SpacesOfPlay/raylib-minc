// Imports added on export so this module resolves standalone (LSP).
import gl_core33;

// glad_compat.mc — routes glad's loader API to gl_core33.

// Returns nonzero on success.
i32 gladLoadGL(GLADloadfunc load) {
    if gl_load_all_fns() { return 1; }
    return 0;
}

// Per-extension flags. Defaults match a GL 3.3 core context — core
// features available, optional compressed/anisotropic extensions off.
bool GLAD_GL_ARB_vertex_array_object = true;
bool GLAD_GL_ARB_texture_non_power_of_two = true;
bool GLAD_GL_ARB_texture_float = true;
bool GLAD_GL_ARB_depth_texture = true;
bool GLAD_GL_ARB_instanced_arrays = true;
bool GLAD_GL_ARB_ES3_compatibility = true;
bool GLAD_GL_EXT_draw_instanced = true;
bool GLAD_GL_ARB_compute_shader = false;
bool GLAD_GL_ARB_shader_storage_buffer_object = false;
bool GLAD_GL_EXT_texture_compression_s3tc = false;
bool GLAD_GL_EXT_texture_filter_anisotropic = false;
bool GLAD_GL_EXT_texture_mirror_clamp = false;
bool GLAD_GL_KHR_texture_compression_astc_hdr = false;
bool GLAD_GL_KHR_texture_compression_astc_ldr = false;
