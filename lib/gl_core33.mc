// gl_core33.mc — cross-platform GL 3.3-core binding.
// Call gl_load_all_fns() once after the GL context is current.
// raylib's rlgl handles this in InitWindow.

// --- constants ----------------------------------------------
const u32 GL_ALWAYS = 519;
const u32 GL_ARRAY_BUFFER = 34962;
const u32 GL_BACK = 1029;
const u32 GL_BLEND = 3042;
const u32 GL_BYTE = 5120;
const u32 GL_CCW = 2305;
const u32 GL_CLAMP_TO_BORDER = 33069;
const u32 GL_CLAMP_TO_EDGE = 33071;
const u32 GL_COLOR = 6144;
const u32 GL_COLOR_ATTACHMENT0 = 36064;
const u32 GL_COLOR_BUFFER_BIT = 16384;
const u32 GL_COMPILE_STATUS = 35713;
const u32 GL_COMPRESSED_RED_GREEN_RGTC2 = 36285;
const u32 GL_COMPRESSED_RED_RGTC1 = 36283;
const u32 GL_COMPRESSED_RG11_EAC = 37490;
const u32 GL_COMPRESSED_RGB8_ETC2 = 37492;
const u32 GL_COMPRESSED_RGB8_PUNCHTHROUGH_ALPHA1_ETC2 = 37494;
const u32 GL_COMPRESSED_RGBA8_ETC2_EAC = 37496;
const u32 GL_COMPRESSED_RGBA_BPTC_UNORM_ARB = 36492;
const u32 GL_COMPRESSED_RGBA_S3TC_DXT1_EXT = 33777;
const u32 GL_COMPRESSED_RGBA_S3TC_DXT3_EXT = 33778;
const u32 GL_COMPRESSED_RGBA_S3TC_DXT5_EXT = 33779;
const u32 GL_COMPRESSED_RGB_BPTC_SIGNED_FLOAT_ARB = 36494;
const u32 GL_COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT_ARB = 36495;
const u32 GL_COMPRESSED_SIGNED_RED_GREEN_RGTC2 = 36286;
const u32 GL_COMPRESSED_SIGNED_RED_RGTC1 = 36284;
const u32 GL_COMPRESSED_SIGNED_RG11_EAC = 37491;
const u32 GL_COMPRESSED_SRGB_ALPHA_BPTC_UNORM_ARB = 36493;
const u32 GL_CONSTANT_ALPHA = 32771;
const u32 GL_CONSTANT_COLOR = 32769;
const u32 GL_CULL_FACE = 2884;
const u32 GL_CURRENT_PROGRAM = 35725;
const u32 GL_CW = 2304;
const u32 GL_DECR = 7683;
const u32 GL_DECR_WRAP = 34056;
const u32 GL_DEPTH = 6145;
const u32 GL_DEPTH24_STENCIL8 = 35056;
const u32 GL_DEPTH_ATTACHMENT = 36096;
const u32 GL_DEPTH_COMPONENT = 6402;
const u32 GL_DEPTH_STENCIL = 34041;
const u32 GL_DEPTH_TEST = 2929;
const u32 GL_DITHER = 3024;
const u32 GL_DRAW_FRAMEBUFFER = 36009;
const u32 GL_DST_ALPHA = 772;
const u32 GL_DST_COLOR = 774;
const u32 GL_DYNAMIC_DRAW = 35048;
const u32 GL_ELEMENT_ARRAY_BUFFER = 34963;
const u32 GL_EQUAL = 514;
const u32 GL_EXTENSIONS = 7939;
const u32 GL_FLOAT = 5126;
const u32 GL_FRAGMENT_SHADER = 35632;
const u32 GL_FRAMEBUFFER = 36160;
const i32 GL_FRAMEBUFFER_BINDING = 36006;
const u32 GL_FRAMEBUFFER_COMPLETE = 36053;
const u32 GL_FRONT = 1028;
const u32 GL_FUNC_ADD = 32774;
const u32 GL_FUNC_REVERSE_SUBTRACT = 32779;
const u32 GL_FUNC_SUBTRACT = 32778;
const u32 GL_GEQUAL = 518;
const u32 GL_GREATER = 516;
const u32 GL_HALF_FLOAT = 5131;
const u32 GL_INCR = 7682;
const u32 GL_INCR_WRAP = 34055;
const u32 GL_INFO_LOG_LENGTH = 35716;
const u32 GL_INT = 5124;
const u32 GL_INVERT = 5386;
const u32 GL_KEEP = 7680;
const u32 GL_LEQUAL = 515;
const u32 GL_LESS = 513;
const u32 GL_LINEAR = 9729;
const u32 GL_LINEAR_MIPMAP_LINEAR = 9987;
const u32 GL_LINEAR_MIPMAP_NEAREST = 9985;
const u32 GL_LINES = 1;
const u32 GL_LINE_STRIP = 3;
const u32 GL_LINK_STATUS = 35714;
const u32 GL_MAX_3D_TEXTURE_SIZE = 32883;
const u32 GL_MAX_ARRAY_TEXTURE_LAYERS = 35071;
const u32 GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS = 35661;
const u32 GL_MAX_CUBE_MAP_TEXTURE_SIZE = 34076;
const u32 GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT = 34047;
const u32 GL_MAX_TEXTURE_SIZE = 3379;
const u32 GL_MAX_VERTEX_ATTRIBS = 34921;
const u32 GL_MIRRORED_REPEAT = 33648;
const u32 GL_MULTISAMPLE = 32925;
const u32 GL_NEAREST = 9728;
const u32 GL_NEAREST_MIPMAP_LINEAR = 9986;
const u32 GL_NEAREST_MIPMAP_NEAREST = 9984;
const u32 GL_NEVER = 512;
const u32 GL_NOTEQUAL = 517;
const i32 GL_NUM_EXTENSIONS = 33309;
const u32 GL_ONE_MINUS_CONSTANT_ALPHA = 32772;
const u32 GL_ONE_MINUS_CONSTANT_COLOR = 32770;
const u32 GL_ONE_MINUS_DST_ALPHA = 773;
const u32 GL_ONE_MINUS_DST_COLOR = 775;
const u32 GL_ONE_MINUS_SRC_ALPHA = 771;
const u32 GL_ONE_MINUS_SRC_COLOR = 769;
const u32 GL_POINTS = 0;
const u32 GL_POLYGON_OFFSET_FILL = 32823;
const u32 GL_PROGRAM_POINT_SIZE = 34370;
const u32 GL_R11F_G11F_B10F = 35898;
const u32 GL_R16 = 33322;
const u32 GL_R16F = 33325;
const u32 GL_R16I = 33331;
const u32 GL_R16UI = 33332;
const u32 GL_R16_SNORM = 36760;
const u32 GL_R32F = 33326;
const u32 GL_R32I = 33333;
const u32 GL_R32UI = 33334;
const u32 GL_R8 = 33321;
const u32 GL_R8I = 33329;
const u32 GL_R8UI = 33330;
const u32 GL_R8_SNORM = 36756;
const u32 GL_READ_FRAMEBUFFER = 36008;
const u32 GL_RED = 6403;
const u32 GL_RED_INTEGER = 36244;
const u32 GL_RENDERBUFFER = 36161;
const u32 GL_REPEAT = 10497;
const u32 GL_REPLACE = 7681;
const u32 GL_RG = 33319;
const u32 GL_RG16 = 33324;
const u32 GL_RG16F = 33327;
const u32 GL_RG16I = 33337;
const u32 GL_RG16UI = 33338;
const u32 GL_RG16_SNORM = 36761;
const u32 GL_RG32F = 33328;
const u32 GL_RG32I = 33339;
const u32 GL_RG32UI = 33340;
const u32 GL_RG8 = 33323;
const u32 GL_RG8I = 33335;
const u32 GL_RG8UI = 33336;
const u32 GL_RG8_SNORM = 36757;
const u32 GL_RGB = 6407;
const u32 GL_RGB10_A2 = 32857;
const u32 GL_RGBA = 6408;
const u32 GL_RGBA16 = 32859;
const u32 GL_RGBA16F = 34842;
const u32 GL_RGBA16I = 36232;
const u32 GL_RGBA16UI = 36214;
const u32 GL_RGBA16_SNORM = 36763;
const u32 GL_RGBA32F = 34836;
const u32 GL_RGBA32I = 36226;
const u32 GL_RGBA32UI = 36208;
const u32 GL_RGBA8 = 32856;
const u32 GL_RGBA8I = 36238;
const u32 GL_RGBA8UI = 36220;
const u32 GL_RGBA8_SNORM = 36759;
const u32 GL_RGBA_INTEGER = 36249;
const u32 GL_RG_INTEGER = 33320;
const u32 GL_SAMPLE_ALPHA_TO_COVERAGE = 32926;
const u32 GL_SCISSOR_TEST = 3089;
const u32 GL_SHORT = 5122;
const u32 GL_SRC_ALPHA = 770;
const u32 GL_SRC_ALPHA_SATURATE = 776;
const u32 GL_SRC_COLOR = 768;
const u32 GL_STATIC_DRAW = 35044;
const u32 GL_STENCIL = 6146;
const u32 GL_STENCIL_ATTACHMENT = 36128;
const u32 GL_STENCIL_TEST = 2960;
const u32 GL_STREAM_DRAW = 35040;
const u32 GL_TEXTURE0 = 33984;
const u32 GL_TEXTURE_2D = 3553;
const u32 GL_TEXTURE_2D_ARRAY = 35866;
const u32 GL_TEXTURE_3D = 32879;
const u32 GL_TEXTURE_BORDER_COLOR = 4100;
const u32 GL_TEXTURE_CUBE_MAP = 34067;
const u32 GL_TEXTURE_CUBE_MAP_NEGATIVE_X = 34070;
const u32 GL_TEXTURE_CUBE_MAP_NEGATIVE_Y = 34072;
const u32 GL_TEXTURE_CUBE_MAP_NEGATIVE_Z = 34074;
const u32 GL_TEXTURE_CUBE_MAP_POSITIVE_X = 34069;
const u32 GL_TEXTURE_CUBE_MAP_POSITIVE_Y = 34071;
const u32 GL_TEXTURE_CUBE_MAP_POSITIVE_Z = 34073;
const u32 GL_TEXTURE_MAG_FILTER = 10240;
const u32 GL_TEXTURE_MAX_ANISOTROPY_EXT = 34046;
const u32 GL_TEXTURE_MAX_LOD = 33083;
const u32 GL_TEXTURE_MIN_FILTER = 10241;
const u32 GL_TEXTURE_MIN_LOD = 33082;
const u32 GL_TEXTURE_WRAP_R = 32882;
const u32 GL_TEXTURE_WRAP_S = 10242;
const u32 GL_TEXTURE_WRAP_T = 10243;
const u32 GL_TRIANGLES = 4;
const u32 GL_TRIANGLE_STRIP = 5;
const u32 GL_UNSIGNED_BYTE = 5121;
const u32 GL_UNSIGNED_INT = 5125;
const u32 GL_UNSIGNED_INT_10F_11F_11F_REV = 35899;
const u32 GL_UNSIGNED_INT_24_8 = 34042;
const u32 GL_UNSIGNED_INT_2_10_10_10_REV = 33640;
const u32 GL_UNSIGNED_SHORT = 5123;
const u32 GL_VERTEX_SHADER = 35633;
const u32 GL_FALSE = 0;
const u32 GL_TRUE = 1;
const u32 GL_ZERO = 0;
const u32 GL_ONE = 1;
const u32 GL_NO_ERROR = 0;
const u32 GL_DEPTH_BUFFER_BIT = 256;
const u32 GL_STENCIL_BUFFER_BIT = 1024;
const u32 GL_COLOR_ATTACHMENT1 = 36065;
const u32 GL_COLOR_ATTACHMENT2 = 36066;
const u32 GL_COLOR_ATTACHMENT3 = 36067;
const u32 GL_DEPTH_COMPONENT16 = 33189;
const u32 GL_LUMINANCE = 6409;
const u32 GL_COMPRESSED_RGB_PVRTC_4BPPV1_IMG = 35840;
const u32 GL_COMPRESSED_RGB_PVRTC_2BPPV1_IMG = 35841;
const u32 GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG = 35842;
const u32 GL_COMPRESSED_RGBA_PVRTC_2BPPV1_IMG = 35843;
const u32 GL_COLOR_ATTACHMENT4 = 0x8CE4;
const u32 GL_COLOR_ATTACHMENT5 = 0x8CE5;
const u32 GL_COLOR_ATTACHMENT6 = 0x8CE6;
const u32 GL_COLOR_ATTACHMENT7 = 0x8CE7;
const u32 GL_COMPRESSED_RGB_S3TC_DXT1_EXT = 0x83F0;
const u32 GL_COMPRESSED_RGBA_ASTC_4x4_KHR = 0x93B0;
const u32 GL_COMPRESSED_RGBA_ASTC_8x8_KHR = 0x93B7;
const u32 GL_COMPUTE_SHADER = 0x91B9;
const u32 GL_DEPTH_COMPONENT24 = 0x81A6;
const u32 GL_DEPTH_COMPONENT24_OES = 0x81A6;
const u32 GL_DEPTH_COMPONENT32_OES = 0x81A7;
const u32 GL_DRAW_FRAMEBUFFER_BINDING = 0x8CA6;
const u32 GL_ETC1_RGB8_OES = 0x8D64;
const u32 GL_FILL = 0x1B02;
const u32 GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = 0x8CD1;
const u32 GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = 0x8CD0;
const u32 GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT = 0x8CD6;
const u32 GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = 0x8CD7;
const u32 GL_FRAMEBUFFER_UNSUPPORTED = 0x8CDD;
const u32 GL_FRONT_AND_BACK = 0x0408;
const u32 GL_GREEN = 0x1904;
const u32 GL_LINE = 0x1B01;
const u32 GL_LINE_SMOOTH = 0x0B20;
const u32 GL_LINE_WIDTH = 0x0B21;
const u32 GL_PACK_ALIGNMENT = 0x0D05;
const u32 GL_POINT = 0x1B00;
const u32 GL_RGB16F = 0x881B;
const u32 GL_RGB32F = 0x8815;
const u32 GL_RGB5_A1 = 0x8057;
const u32 GL_RGB565 = 0x8D62;
const u32 GL_RGB8 = 0x8051;
const u32 GL_RGBA4 = 0x8056;
const u32 GL_SHADING_LANGUAGE_VERSION = 0x8B8C;
const u32 GL_TEXTURE = 0x1702;
const u32 GL_TEXTURE_BASE_LEVEL = 0x813C;
const u32 GL_TEXTURE_CUBE_MAP_SEAMLESS = 0x884F;
const u32 GL_TEXTURE_LOD_BIAS = 0x8501;
const u32 GL_TEXTURE_MAX_LEVEL = 0x813D;
const u32 GL_TEXTURE_SWIZZLE_RGBA = 0x8E46;
const u32 GL_UNPACK_ALIGNMENT = 0x0CF5;
const u32 GL_UNSIGNED_SHORT_4_4_4_4 = 0x8033;
const u32 GL_UNSIGNED_SHORT_5_5_5_1 = 0x8034;
const u32 GL_UNSIGNED_SHORT_5_6_5 = 0x8363;

when os(windows) {
    extern "opengl32.dll" void* wglGetProcAddress(u8* name);
    extern "kernel32.dll" void* LoadLibraryA(u8* name);
    extern "kernel32.dll" void* GetProcAddress(void* mod, u8* name);

    void* _glptr_glActiveTexture = null;
    void* _glptr_glAttachShader = null;
    void* _glptr_glBindAttribLocation = null;
    void* _glptr_glBindBuffer = null;
    void* _glptr_glBindFramebuffer = null;
    void* _glptr_glBindRenderbuffer = null;
    void* _glptr_glBindTexture = null;
    void* _glptr_glBindVertexArray = null;
    void* _glptr_glBlendColor = null;
    void* _glptr_glBlendEquation = null;
    void* _glptr_glBlendEquationSeparate = null;
    void* _glptr_glBlendFunc = null;
    void* _glptr_glBlendFuncSeparate = null;
    void* _glptr_glBlitFramebuffer = null;
    void* _glptr_glBufferData = null;
    void* _glptr_glBufferSubData = null;
    void* _glptr_glCheckFramebufferStatus = null;
    void* _glptr_glClear = null;
    void* _glptr_glClearBufferfi = null;
    void* _glptr_glClearBufferfv = null;
    void* _glptr_glClearBufferuiv = null;
    void* _glptr_glClearColor = null;
    void* _glptr_glClearDepth = null;
    void* _glptr_glClearStencil = null;
    void* _glptr_glColorMask = null;
    void* _glptr_glCompileShader = null;
    void* _glptr_glCompressedTexImage2D = null;
    void* _glptr_glCompressedTexImage3D = null;
    void* _glptr_glCreateProgram = null;
    void* _glptr_glCreateShader = null;
    void* _glptr_glCullFace = null;
    void* _glptr_glDeleteBuffers = null;
    void* _glptr_glDeleteFramebuffers = null;
    void* _glptr_glDeleteProgram = null;
    void* _glptr_glDeleteRenderbuffers = null;
    void* _glptr_glDeleteShader = null;
    void* _glptr_glDeleteTextures = null;
    void* _glptr_glDeleteVertexArrays = null;
    void* _glptr_glDepthFunc = null;
    void* _glptr_glDepthMask = null;
    void* _glptr_glDetachShader = null;
    void* _glptr_glDisable = null;
    void* _glptr_glDisableVertexAttribArray = null;
    void* _glptr_glDrawArrays = null;
    void* _glptr_glDrawArraysInstanced = null;
    void* _glptr_glDrawBuffers = null;
    void* _glptr_glDrawElements = null;
    void* _glptr_glDrawElementsInstanced = null;
    void* _glptr_glEnable = null;
    void* _glptr_glEnableVertexAttribArray = null;
    void* _glptr_glFramebufferRenderbuffer = null;
    void* _glptr_glFramebufferTexture2D = null;
    void* _glptr_glFramebufferTextureLayer = null;
    void* _glptr_glFrontFace = null;
    void* _glptr_glGenBuffers = null;
    void* _glptr_glGenFramebuffers = null;
    void* _glptr_glGenRenderbuffers = null;
    void* _glptr_glGenTextures = null;
    void* _glptr_glGenVertexArrays = null;
    void* _glptr_glGenerateMipmap = null;
    void* _glptr_glGetAttribLocation = null;
    void* _glptr_glGetError = null;
    void* _glptr_glGetFloatv = null;
    void* _glptr_glGetFramebufferAttachmentParameteriv = null;
    void* _glptr_glGetIntegerv = null;
    void* _glptr_glGetProgramInfoLog = null;
    void* _glptr_glGetProgramiv = null;
    void* _glptr_glGetShaderInfoLog = null;
    void* _glptr_glGetShaderiv = null;
    void* _glptr_glGetString = null;
    void* _glptr_glGetStringi = null;
    void* _glptr_glGetTexImage = null;
    void* _glptr_glGetUniformLocation = null;
    void* _glptr_glLineWidth = null;
    void* _glptr_glLinkProgram = null;
    void* _glptr_glPixelStorei = null;
    void* _glptr_glPolygonMode = null;
    void* _glptr_glPolygonOffset = null;
    void* _glptr_glReadBuffer = null;
    void* _glptr_glReadPixels = null;
    void* _glptr_glRenderbufferStorage = null;
    void* _glptr_glRenderbufferStorageMultisample = null;
    void* _glptr_glScissor = null;
    void* _glptr_glShaderSource = null;
    void* _glptr_glStencilFunc = null;
    void* _glptr_glStencilFuncSeparate = null;
    void* _glptr_glStencilMask = null;
    void* _glptr_glStencilOp = null;
    void* _glptr_glStencilOpSeparate = null;
    void* _glptr_glTexImage2D = null;
    void* _glptr_glTexImage3D = null;
    void* _glptr_glTexParameterf = null;
    void* _glptr_glTexParameterfv = null;
    void* _glptr_glTexParameteri = null;
    void* _glptr_glTexParameteriv = null;
    void* _glptr_glTexSubImage2D = null;
    void* _glptr_glTexSubImage3D = null;
    void* _glptr_glUniform1fv = null;
    void* _glptr_glUniform1i = null;
    void* _glptr_glUniform1iv = null;
    void* _glptr_glUniform1uiv = null;
    void* _glptr_glUniform2fv = null;
    void* _glptr_glUniform2iv = null;
    void* _glptr_glUniform2uiv = null;
    void* _glptr_glUniform3fv = null;
    void* _glptr_glUniform3iv = null;
    void* _glptr_glUniform3uiv = null;
    void* _glptr_glUniform4f = null;
    void* _glptr_glUniform4fv = null;
    void* _glptr_glUniform4iv = null;
    void* _glptr_glUniform4uiv = null;
    void* _glptr_glUniformMatrix4fv = null;
    void* _glptr_glUseProgram = null;
    void* _glptr_glVertexAttrib1fv = null;
    void* _glptr_glVertexAttrib2fv = null;
    void* _glptr_glVertexAttrib3fv = null;
    void* _glptr_glVertexAttrib4fv = null;
    void* _glptr_glVertexAttribDivisor = null;
    void* _glptr_glVertexAttribPointer = null;
    void* _glptr_glViewport = null;

    void glActiveTexture(u32 texture) { cast(fn(u32): void, _glptr_glActiveTexture)(texture); }
    void glAttachShader(u32 program, u32 shader) { cast(fn(u32, u32): void, _glptr_glAttachShader)(program, shader); }
    void glBindAttribLocation(u32 program, u32 index, u8* name) { cast(fn(u32, u32, u8*): void, _glptr_glBindAttribLocation)(program, index, name); }
    void glBindBuffer(u32 target, u32 buffer) { cast(fn(u32, u32): void, _glptr_glBindBuffer)(target, buffer); }
    void glBindFramebuffer(u32 target, u32 framebuffer) { cast(fn(u32, u32): void, _glptr_glBindFramebuffer)(target, framebuffer); }
    void glBindRenderbuffer(u32 target, u32 renderbuffer) { cast(fn(u32, u32): void, _glptr_glBindRenderbuffer)(target, renderbuffer); }
    void glBindTexture(u32 target, u32 texture) { cast(fn(u32, u32): void, _glptr_glBindTexture)(target, texture); }
    void glBindVertexArray(u32 array) { cast(fn(u32): void, _glptr_glBindVertexArray)(array); }
    void glBlendColor(f32 r, f32 g, f32 b, f32 a) { cast(fn(f32, f32, f32, f32): void, _glptr_glBlendColor)(r, g, b, a); }
    void glBlendEquation(u32 mode) { cast(fn(u32): void, _glptr_glBlendEquation)(mode); }
    void glBlendEquationSeparate(u32 modeRGB, u32 modeAlpha) { cast(fn(u32, u32): void, _glptr_glBlendEquationSeparate)(modeRGB, modeAlpha); }
    void glBlendFunc(u32 sfactor, u32 dfactor) { cast(fn(u32, u32): void, _glptr_glBlendFunc)(sfactor, dfactor); }
    void glBlendFuncSeparate(u32 srcRGB, u32 dstRGB, u32 srcAlpha, u32 dstAlpha) { cast(fn(u32, u32, u32, u32): void, _glptr_glBlendFuncSeparate)(srcRGB, dstRGB, srcAlpha, dstAlpha); }
    void glBlitFramebuffer(i32 srcX0, i32 srcY0, i32 srcX1, i32 srcY1, i32 dstX0, i32 dstY0, i32 dstX1, i32 dstY1, u32 mask, u32 filter) { cast(fn(i32, i32, i32, i32, i32, i32, i32, i32, u32, u32): void, _glptr_glBlitFramebuffer)(srcX0, srcY0, srcX1, srcY1, dstX0, dstY0, dstX1, dstY1, mask, filter); }
    void glBufferData(u32 target, i64 size, void* data, u32 usage) { cast(fn(u32, i64, void*, u32): void, _glptr_glBufferData)(target, size, data, usage); }
    void glBufferSubData(u32 target, i64 offset, i64 size, void* data) { cast(fn(u32, i64, i64, void*): void, _glptr_glBufferSubData)(target, offset, size, data); }
    u32 glCheckFramebufferStatus(u32 target) { return cast(fn(u32): u32, _glptr_glCheckFramebufferStatus)(target); }
    void glClear(u32 mask) { cast(fn(u32): void, _glptr_glClear)(mask); }
    void glClearBufferfi(u32 buffer, i32 drawbuffer, f32 depth, i32 stencil) { cast(fn(u32, i32, f32, i32): void, _glptr_glClearBufferfi)(buffer, drawbuffer, depth, stencil); }
    void glClearBufferfv(u32 buffer, i32 drawbuffer, f32* value) { cast(fn(u32, i32, f32*): void, _glptr_glClearBufferfv)(buffer, drawbuffer, value); }
    void glClearBufferuiv(u32 buffer, i32 drawbuffer, u32* value) { cast(fn(u32, i32, u32*): void, _glptr_glClearBufferuiv)(buffer, drawbuffer, value); }
    void glClearColor(f32 r, f32 g, f32 b, f32 a) { cast(fn(f32, f32, f32, f32): void, _glptr_glClearColor)(r, g, b, a); }
    void glClearDepth(f64 depth) { cast(fn(f64): void, _glptr_glClearDepth)(depth); }
    void glClearStencil(i32 s) { cast(fn(i32): void, _glptr_glClearStencil)(s); }
    void glColorMask(u8 r, u8 g, u8 b, u8 a) { cast(fn(u8, u8, u8, u8): void, _glptr_glColorMask)(r, g, b, a); }
    void glCompileShader(u32 shader) { cast(fn(u32): void, _glptr_glCompileShader)(shader); }
    void glCompressedTexImage2D(u32 target, i32 level, u32 internalformat, i32 width, i32 height, i32 border, i32 imageSize, void* data) { cast(fn(u32, i32, u32, i32, i32, i32, i32, void*): void, _glptr_glCompressedTexImage2D)(target, level, internalformat, width, height, border, imageSize, data); }
    void glCompressedTexImage3D(u32 target, i32 level, u32 internalformat, i32 width, i32 height, i32 depth, i32 border, i32 imageSize, void* data) { cast(fn(u32, i32, u32, i32, i32, i32, i32, i32, void*): void, _glptr_glCompressedTexImage3D)(target, level, internalformat, width, height, depth, border, imageSize, data); }
    u32 glCreateProgram() { return cast(fn(): u32, _glptr_glCreateProgram)(); }
    u32 glCreateShader(u32 type) { return cast(fn(u32): u32, _glptr_glCreateShader)(type); }
    void glCullFace(u32 mode) { cast(fn(u32): void, _glptr_glCullFace)(mode); }
    void glDeleteBuffers(i32 n, u32* buffers) { cast(fn(i32, u32*): void, _glptr_glDeleteBuffers)(n, buffers); }
    void glDeleteFramebuffers(i32 n, u32* framebuffers) { cast(fn(i32, u32*): void, _glptr_glDeleteFramebuffers)(n, framebuffers); }
    void glDeleteProgram(u32 program) { cast(fn(u32): void, _glptr_glDeleteProgram)(program); }
    void glDeleteRenderbuffers(i32 n, u32* renderbuffers) { cast(fn(i32, u32*): void, _glptr_glDeleteRenderbuffers)(n, renderbuffers); }
    void glDeleteShader(u32 shader) { cast(fn(u32): void, _glptr_glDeleteShader)(shader); }
    void glDeleteTextures(i32 n, u32* textures) { cast(fn(i32, u32*): void, _glptr_glDeleteTextures)(n, textures); }
    void glDeleteVertexArrays(i32 n, u32* arrays) { cast(fn(i32, u32*): void, _glptr_glDeleteVertexArrays)(n, arrays); }
    void glDepthFunc(u32 func) { cast(fn(u32): void, _glptr_glDepthFunc)(func); }
    void glDepthMask(u8 flag) { cast(fn(u8): void, _glptr_glDepthMask)(flag); }
    void glDetachShader(u32 program, u32 shader) { cast(fn(u32, u32): void, _glptr_glDetachShader)(program, shader); }
    void glDisable(u32 cap) { cast(fn(u32): void, _glptr_glDisable)(cap); }
    void glDisableVertexAttribArray(u32 index) { cast(fn(u32): void, _glptr_glDisableVertexAttribArray)(index); }
    void glDrawArrays(u32 mode, i32 first, i32 count) { cast(fn(u32, i32, i32): void, _glptr_glDrawArrays)(mode, first, count); }
    void glDrawArraysInstanced(u32 mode, i32 first, i32 count, i32 instancecount) { cast(fn(u32, i32, i32, i32): void, _glptr_glDrawArraysInstanced)(mode, first, count, instancecount); }
    void glDrawBuffers(i32 n, u32* bufs) { cast(fn(i32, u32*): void, _glptr_glDrawBuffers)(n, bufs); }
    void glDrawElements(u32 mode, i32 count, u32 type, void* indices) { cast(fn(u32, i32, u32, void*): void, _glptr_glDrawElements)(mode, count, type, indices); }
    void glDrawElementsInstanced(u32 mode, i32 count, u32 type, void* indices, i32 instancecount) { cast(fn(u32, i32, u32, void*, i32): void, _glptr_glDrawElementsInstanced)(mode, count, type, indices, instancecount); }
    void glEnable(u32 cap) { cast(fn(u32): void, _glptr_glEnable)(cap); }
    void glEnableVertexAttribArray(u32 index) { cast(fn(u32): void, _glptr_glEnableVertexAttribArray)(index); }
    void glFramebufferRenderbuffer(u32 target, u32 attachment, u32 renderbuffertarget, u32 renderbuffer) { cast(fn(u32, u32, u32, u32): void, _glptr_glFramebufferRenderbuffer)(target, attachment, renderbuffertarget, renderbuffer); }
    void glFramebufferTexture2D(u32 target, u32 attachment, u32 textarget, u32 texture, i32 level) { cast(fn(u32, u32, u32, u32, i32): void, _glptr_glFramebufferTexture2D)(target, attachment, textarget, texture, level); }
    void glFramebufferTextureLayer(u32 target, u32 attachment, u32 texture, i32 level, i32 layer) { cast(fn(u32, u32, u32, i32, i32): void, _glptr_glFramebufferTextureLayer)(target, attachment, texture, level, layer); }
    void glFrontFace(u32 mode) { cast(fn(u32): void, _glptr_glFrontFace)(mode); }
    void glGenBuffers(i32 n, u32* buffers) { cast(fn(i32, u32*): void, _glptr_glGenBuffers)(n, buffers); }
    void glGenFramebuffers(i32 n, u32* framebuffers) { cast(fn(i32, u32*): void, _glptr_glGenFramebuffers)(n, framebuffers); }
    void glGenRenderbuffers(i32 n, u32* renderbuffers) { cast(fn(i32, u32*): void, _glptr_glGenRenderbuffers)(n, renderbuffers); }
    void glGenTextures(i32 n, u32* textures) { cast(fn(i32, u32*): void, _glptr_glGenTextures)(n, textures); }
    void glGenVertexArrays(i32 n, u32* arrays) { cast(fn(i32, u32*): void, _glptr_glGenVertexArrays)(n, arrays); }
    void glGenerateMipmap(u32 target) { cast(fn(u32): void, _glptr_glGenerateMipmap)(target); }
    i32 glGetAttribLocation(u32 program, u8* name) { return cast(fn(u32, u8*): i32, _glptr_glGetAttribLocation)(program, name); }
    u32 glGetError() { return cast(fn(): u32, _glptr_glGetError)(); }
    void glGetFloatv(u32 pname, f32* params) { cast(fn(u32, f32*): void, _glptr_glGetFloatv)(pname, params); }
    void glGetFramebufferAttachmentParameteriv(u32 target, u32 attachment, u32 pname, i32* params) { cast(fn(u32, u32, u32, i32*): void, _glptr_glGetFramebufferAttachmentParameteriv)(target, attachment, pname, params); }
    void glGetIntegerv(u32 pname, i32* params) { cast(fn(u32, i32*): void, _glptr_glGetIntegerv)(pname, params); }
    void glGetProgramInfoLog(u32 program, i32 bufSize, i32* length, u8* infoLog) { cast(fn(u32, i32, i32*, u8*): void, _glptr_glGetProgramInfoLog)(program, bufSize, length, infoLog); }
    void glGetProgramiv(u32 program, u32 pname, i32* params) { cast(fn(u32, u32, i32*): void, _glptr_glGetProgramiv)(program, pname, params); }
    void glGetShaderInfoLog(u32 shader, i32 bufSize, i32* length, u8* infoLog) { cast(fn(u32, i32, i32*, u8*): void, _glptr_glGetShaderInfoLog)(shader, bufSize, length, infoLog); }
    void glGetShaderiv(u32 shader, u32 pname, i32* params) { cast(fn(u32, u32, i32*): void, _glptr_glGetShaderiv)(shader, pname, params); }
    u8* glGetString(u32 name) { return cast(fn(u32): u8*, _glptr_glGetString)(name); }
    u8* glGetStringi(u32 name, u32 index) { return cast(fn(u32, u32): u8*, _glptr_glGetStringi)(name, index); }
    void glGetTexImage(u32 target, i32 level, u32 format, u32 type, void* pixels) { cast(fn(u32, i32, u32, u32, void*): void, _glptr_glGetTexImage)(target, level, format, type, pixels); }
    i32 glGetUniformLocation(u32 program, u8* name) { return cast(fn(u32, u8*): i32, _glptr_glGetUniformLocation)(program, name); }
    void glLineWidth(f32 width) { cast(fn(f32): void, _glptr_glLineWidth)(width); }
    void glLinkProgram(u32 program) { cast(fn(u32): void, _glptr_glLinkProgram)(program); }
    void glPixelStorei(u32 pname, i32 param) { cast(fn(u32, i32): void, _glptr_glPixelStorei)(pname, param); }
    void glPolygonMode(u32 face, u32 mode) { cast(fn(u32, u32): void, _glptr_glPolygonMode)(face, mode); }
    void glPolygonOffset(f32 factor, f32 units) { cast(fn(f32, f32): void, _glptr_glPolygonOffset)(factor, units); }
    void glReadBuffer(u32 mode) { cast(fn(u32): void, _glptr_glReadBuffer)(mode); }
    void glReadPixels(i32 x, i32 y, i32 width, i32 height, u32 format, u32 type, void* data) { cast(fn(i32, i32, i32, i32, u32, u32, void*): void, _glptr_glReadPixels)(x, y, width, height, format, type, data); }
    void glRenderbufferStorage(u32 target, u32 internalformat, i32 width, i32 height) { cast(fn(u32, u32, i32, i32): void, _glptr_glRenderbufferStorage)(target, internalformat, width, height); }
    void glRenderbufferStorageMultisample(u32 target, i32 samples, u32 internalformat, i32 width, i32 height) { cast(fn(u32, i32, u32, i32, i32): void, _glptr_glRenderbufferStorageMultisample)(target, samples, internalformat, width, height); }
    void glScissor(i32 x, i32 y, i32 width, i32 height) { cast(fn(i32, i32, i32, i32): void, _glptr_glScissor)(x, y, width, height); }
    void glShaderSource(u32 shader, i32 count, u8** string, i32* length) { cast(fn(u32, i32, u8**, i32*): void, _glptr_glShaderSource)(shader, count, string, length); }
    void glStencilFunc(u32 func, i32 ref, u32 mask) { cast(fn(u32, i32, u32): void, _glptr_glStencilFunc)(func, ref, mask); }
    void glStencilFuncSeparate(u32 face, u32 func, i32 ref, u32 mask) { cast(fn(u32, u32, i32, u32): void, _glptr_glStencilFuncSeparate)(face, func, ref, mask); }
    void glStencilMask(u32 mask) { cast(fn(u32): void, _glptr_glStencilMask)(mask); }
    void glStencilOp(u32 sfail, u32 dpfail, u32 dppass) { cast(fn(u32, u32, u32): void, _glptr_glStencilOp)(sfail, dpfail, dppass); }
    void glStencilOpSeparate(u32 face, u32 sfail, u32 dpfail, u32 dppass) { cast(fn(u32, u32, u32, u32): void, _glptr_glStencilOpSeparate)(face, sfail, dpfail, dppass); }
    void glTexImage2D(u32 target, i32 level, i32 internalformat, i32 width, i32 height, i32 border, u32 format, u32 type, void* pixels) { cast(fn(u32, i32, i32, i32, i32, i32, u32, u32, void*): void, _glptr_glTexImage2D)(target, level, internalformat, width, height, border, format, type, pixels); }
    void glTexImage3D(u32 target, i32 level, i32 internalformat, i32 width, i32 height, i32 depth, i32 border, u32 format, u32 type, void* pixels) { cast(fn(u32, i32, i32, i32, i32, i32, i32, u32, u32, void*): void, _glptr_glTexImage3D)(target, level, internalformat, width, height, depth, border, format, type, pixels); }
    void glTexParameterf(u32 target, u32 pname, f32 param) { cast(fn(u32, u32, f32): void, _glptr_glTexParameterf)(target, pname, param); }
    void glTexParameterfv(u32 target, u32 pname, f32* params) { cast(fn(u32, u32, f32*): void, _glptr_glTexParameterfv)(target, pname, params); }
    void glTexParameteri(u32 target, u32 pname, i32 param) { cast(fn(u32, u32, i32): void, _glptr_glTexParameteri)(target, pname, param); }
    void glTexParameteriv(u32 target, u32 pname, i32* params) { cast(fn(u32, u32, i32*): void, _glptr_glTexParameteriv)(target, pname, params); }
    void glTexSubImage2D(u32 target, i32 level, i32 xoffset, i32 yoffset, i32 width, i32 height, u32 format, u32 type, void* pixels) { cast(fn(u32, i32, i32, i32, i32, i32, u32, u32, void*): void, _glptr_glTexSubImage2D)(target, level, xoffset, yoffset, width, height, format, type, pixels); }
    void glTexSubImage3D(u32 target, i32 level, i32 xoffset, i32 yoffset, i32 zoffset, i32 width, i32 height, i32 depth, u32 format, u32 type, void* pixels) { cast(fn(u32, i32, i32, i32, i32, i32, i32, i32, u32, u32, void*): void, _glptr_glTexSubImage3D)(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, pixels); }
    void glUniform1fv(i32 location, i32 count, f32* value) { cast(fn(i32, i32, f32*): void, _glptr_glUniform1fv)(location, count, value); }
    void glUniform1i(i32 location, i32 v0) { cast(fn(i32, i32): void, _glptr_glUniform1i)(location, v0); }
    void glUniform1iv(i32 location, i32 count, i32* value) { cast(fn(i32, i32, i32*): void, _glptr_glUniform1iv)(location, count, value); }
    void glUniform1uiv(i32 location, i32 count, u32* value) { cast(fn(i32, i32, u32*): void, _glptr_glUniform1uiv)(location, count, value); }
    void glUniform2fv(i32 location, i32 count, f32* value) { cast(fn(i32, i32, f32*): void, _glptr_glUniform2fv)(location, count, value); }
    void glUniform2iv(i32 location, i32 count, i32* value) { cast(fn(i32, i32, i32*): void, _glptr_glUniform2iv)(location, count, value); }
    void glUniform2uiv(i32 location, i32 count, u32* value) { cast(fn(i32, i32, u32*): void, _glptr_glUniform2uiv)(location, count, value); }
    void glUniform3fv(i32 location, i32 count, f32* value) { cast(fn(i32, i32, f32*): void, _glptr_glUniform3fv)(location, count, value); }
    void glUniform3iv(i32 location, i32 count, i32* value) { cast(fn(i32, i32, i32*): void, _glptr_glUniform3iv)(location, count, value); }
    void glUniform3uiv(i32 location, i32 count, u32* value) { cast(fn(i32, i32, u32*): void, _glptr_glUniform3uiv)(location, count, value); }
    void glUniform4f(i32 location, f32 v0, f32 v1, f32 v2, f32 v3) { cast(fn(i32, f32, f32, f32, f32): void, _glptr_glUniform4f)(location, v0, v1, v2, v3); }
    void glUniform4fv(i32 location, i32 count, f32* value) { cast(fn(i32, i32, f32*): void, _glptr_glUniform4fv)(location, count, value); }
    void glUniform4iv(i32 location, i32 count, i32* value) { cast(fn(i32, i32, i32*): void, _glptr_glUniform4iv)(location, count, value); }
    void glUniform4uiv(i32 location, i32 count, u32* value) { cast(fn(i32, i32, u32*): void, _glptr_glUniform4uiv)(location, count, value); }
    void glUniformMatrix4fv(i32 location, i32 count, u8 transpose, f32* value) { cast(fn(i32, i32, u8, f32*): void, _glptr_glUniformMatrix4fv)(location, count, transpose, value); }
    void glUseProgram(u32 program) { cast(fn(u32): void, _glptr_glUseProgram)(program); }
    void glVertexAttrib1fv(u32 index, f32* v) { cast(fn(u32, f32*): void, _glptr_glVertexAttrib1fv)(index, v); }
    void glVertexAttrib2fv(u32 index, f32* v) { cast(fn(u32, f32*): void, _glptr_glVertexAttrib2fv)(index, v); }
    void glVertexAttrib3fv(u32 index, f32* v) { cast(fn(u32, f32*): void, _glptr_glVertexAttrib3fv)(index, v); }
    void glVertexAttrib4fv(u32 index, f32* v) { cast(fn(u32, f32*): void, _glptr_glVertexAttrib4fv)(index, v); }
    void glVertexAttribDivisor(u32 index, u32 divisor) { cast(fn(u32, u32): void, _glptr_glVertexAttribDivisor)(index, divisor); }
    void glVertexAttribPointer(u32 index, i32 size, u32 type, u8 normalized, i32 stride, void* pointer) { cast(fn(u32, i32, u32, u8, i32, void*): void, _glptr_glVertexAttribPointer)(index, size, type, normalized, stride, pointer); }
    void glViewport(i32 x, i32 y, i32 width, i32 height) { cast(fn(i32, i32, i32, i32): void, _glptr_glViewport)(x, y, width, height); }

    // Load each entry point via opengl32 (GL 1.1) then wgl (GL 2.0+).
    bool gl_load_all_fns() {
        void* opengl32 = LoadLibraryA(cast(u8*, "opengl32.dll"));
        bool ok = true;
        _glptr_glActiveTexture = GetProcAddress(opengl32, cast(u8*, "glActiveTexture"));
        if _glptr_glActiveTexture == null { _glptr_glActiveTexture = wglGetProcAddress(cast(u8*, "glActiveTexture")); }
        if _glptr_glActiveTexture == null { ok = false; }
        _glptr_glAttachShader = GetProcAddress(opengl32, cast(u8*, "glAttachShader"));
        if _glptr_glAttachShader == null { _glptr_glAttachShader = wglGetProcAddress(cast(u8*, "glAttachShader")); }
        if _glptr_glAttachShader == null { ok = false; }
        _glptr_glBindAttribLocation = GetProcAddress(opengl32, cast(u8*, "glBindAttribLocation"));
        if _glptr_glBindAttribLocation == null { _glptr_glBindAttribLocation = wglGetProcAddress(cast(u8*, "glBindAttribLocation")); }
        if _glptr_glBindAttribLocation == null { ok = false; }
        _glptr_glBindBuffer = GetProcAddress(opengl32, cast(u8*, "glBindBuffer"));
        if _glptr_glBindBuffer == null { _glptr_glBindBuffer = wglGetProcAddress(cast(u8*, "glBindBuffer")); }
        if _glptr_glBindBuffer == null { ok = false; }
        _glptr_glBindFramebuffer = GetProcAddress(opengl32, cast(u8*, "glBindFramebuffer"));
        if _glptr_glBindFramebuffer == null { _glptr_glBindFramebuffer = wglGetProcAddress(cast(u8*, "glBindFramebuffer")); }
        if _glptr_glBindFramebuffer == null { ok = false; }
        _glptr_glBindRenderbuffer = GetProcAddress(opengl32, cast(u8*, "glBindRenderbuffer"));
        if _glptr_glBindRenderbuffer == null { _glptr_glBindRenderbuffer = wglGetProcAddress(cast(u8*, "glBindRenderbuffer")); }
        if _glptr_glBindRenderbuffer == null { ok = false; }
        _glptr_glBindTexture = GetProcAddress(opengl32, cast(u8*, "glBindTexture"));
        if _glptr_glBindTexture == null { _glptr_glBindTexture = wglGetProcAddress(cast(u8*, "glBindTexture")); }
        if _glptr_glBindTexture == null { ok = false; }
        _glptr_glBindVertexArray = GetProcAddress(opengl32, cast(u8*, "glBindVertexArray"));
        if _glptr_glBindVertexArray == null { _glptr_glBindVertexArray = wglGetProcAddress(cast(u8*, "glBindVertexArray")); }
        if _glptr_glBindVertexArray == null { ok = false; }
        _glptr_glBlendColor = GetProcAddress(opengl32, cast(u8*, "glBlendColor"));
        if _glptr_glBlendColor == null { _glptr_glBlendColor = wglGetProcAddress(cast(u8*, "glBlendColor")); }
        if _glptr_glBlendColor == null { ok = false; }
        _glptr_glBlendEquation = GetProcAddress(opengl32, cast(u8*, "glBlendEquation"));
        if _glptr_glBlendEquation == null { _glptr_glBlendEquation = wglGetProcAddress(cast(u8*, "glBlendEquation")); }
        if _glptr_glBlendEquation == null { ok = false; }
        _glptr_glBlendEquationSeparate = GetProcAddress(opengl32, cast(u8*, "glBlendEquationSeparate"));
        if _glptr_glBlendEquationSeparate == null { _glptr_glBlendEquationSeparate = wglGetProcAddress(cast(u8*, "glBlendEquationSeparate")); }
        if _glptr_glBlendEquationSeparate == null { ok = false; }
        _glptr_glBlendFunc = GetProcAddress(opengl32, cast(u8*, "glBlendFunc"));
        if _glptr_glBlendFunc == null { _glptr_glBlendFunc = wglGetProcAddress(cast(u8*, "glBlendFunc")); }
        if _glptr_glBlendFunc == null { ok = false; }
        _glptr_glBlendFuncSeparate = GetProcAddress(opengl32, cast(u8*, "glBlendFuncSeparate"));
        if _glptr_glBlendFuncSeparate == null { _glptr_glBlendFuncSeparate = wglGetProcAddress(cast(u8*, "glBlendFuncSeparate")); }
        if _glptr_glBlendFuncSeparate == null { ok = false; }
        _glptr_glBlitFramebuffer = GetProcAddress(opengl32, cast(u8*, "glBlitFramebuffer"));
        if _glptr_glBlitFramebuffer == null { _glptr_glBlitFramebuffer = wglGetProcAddress(cast(u8*, "glBlitFramebuffer")); }
        if _glptr_glBlitFramebuffer == null { ok = false; }
        _glptr_glBufferData = GetProcAddress(opengl32, cast(u8*, "glBufferData"));
        if _glptr_glBufferData == null { _glptr_glBufferData = wglGetProcAddress(cast(u8*, "glBufferData")); }
        if _glptr_glBufferData == null { ok = false; }
        _glptr_glBufferSubData = GetProcAddress(opengl32, cast(u8*, "glBufferSubData"));
        if _glptr_glBufferSubData == null { _glptr_glBufferSubData = wglGetProcAddress(cast(u8*, "glBufferSubData")); }
        if _glptr_glBufferSubData == null { ok = false; }
        _glptr_glCheckFramebufferStatus = GetProcAddress(opengl32, cast(u8*, "glCheckFramebufferStatus"));
        if _glptr_glCheckFramebufferStatus == null { _glptr_glCheckFramebufferStatus = wglGetProcAddress(cast(u8*, "glCheckFramebufferStatus")); }
        if _glptr_glCheckFramebufferStatus == null { ok = false; }
        _glptr_glClear = GetProcAddress(opengl32, cast(u8*, "glClear"));
        if _glptr_glClear == null { _glptr_glClear = wglGetProcAddress(cast(u8*, "glClear")); }
        if _glptr_glClear == null { ok = false; }
        _glptr_glClearBufferfi = GetProcAddress(opengl32, cast(u8*, "glClearBufferfi"));
        if _glptr_glClearBufferfi == null { _glptr_glClearBufferfi = wglGetProcAddress(cast(u8*, "glClearBufferfi")); }
        if _glptr_glClearBufferfi == null { ok = false; }
        _glptr_glClearBufferfv = GetProcAddress(opengl32, cast(u8*, "glClearBufferfv"));
        if _glptr_glClearBufferfv == null { _glptr_glClearBufferfv = wglGetProcAddress(cast(u8*, "glClearBufferfv")); }
        if _glptr_glClearBufferfv == null { ok = false; }
        _glptr_glClearBufferuiv = GetProcAddress(opengl32, cast(u8*, "glClearBufferuiv"));
        if _glptr_glClearBufferuiv == null { _glptr_glClearBufferuiv = wglGetProcAddress(cast(u8*, "glClearBufferuiv")); }
        if _glptr_glClearBufferuiv == null { ok = false; }
        _glptr_glClearColor = GetProcAddress(opengl32, cast(u8*, "glClearColor"));
        if _glptr_glClearColor == null { _glptr_glClearColor = wglGetProcAddress(cast(u8*, "glClearColor")); }
        if _glptr_glClearColor == null { ok = false; }
        _glptr_glClearDepth = GetProcAddress(opengl32, cast(u8*, "glClearDepth"));
        if _glptr_glClearDepth == null { _glptr_glClearDepth = wglGetProcAddress(cast(u8*, "glClearDepth")); }
        if _glptr_glClearDepth == null { ok = false; }
        _glptr_glClearStencil = GetProcAddress(opengl32, cast(u8*, "glClearStencil"));
        if _glptr_glClearStencil == null { _glptr_glClearStencil = wglGetProcAddress(cast(u8*, "glClearStencil")); }
        if _glptr_glClearStencil == null { ok = false; }
        _glptr_glColorMask = GetProcAddress(opengl32, cast(u8*, "glColorMask"));
        if _glptr_glColorMask == null { _glptr_glColorMask = wglGetProcAddress(cast(u8*, "glColorMask")); }
        if _glptr_glColorMask == null { ok = false; }
        _glptr_glCompileShader = GetProcAddress(opengl32, cast(u8*, "glCompileShader"));
        if _glptr_glCompileShader == null { _glptr_glCompileShader = wglGetProcAddress(cast(u8*, "glCompileShader")); }
        if _glptr_glCompileShader == null { ok = false; }
        _glptr_glCompressedTexImage2D = GetProcAddress(opengl32, cast(u8*, "glCompressedTexImage2D"));
        if _glptr_glCompressedTexImage2D == null { _glptr_glCompressedTexImage2D = wglGetProcAddress(cast(u8*, "glCompressedTexImage2D")); }
        if _glptr_glCompressedTexImage2D == null { ok = false; }
        _glptr_glCompressedTexImage3D = GetProcAddress(opengl32, cast(u8*, "glCompressedTexImage3D"));
        if _glptr_glCompressedTexImage3D == null { _glptr_glCompressedTexImage3D = wglGetProcAddress(cast(u8*, "glCompressedTexImage3D")); }
        if _glptr_glCompressedTexImage3D == null { ok = false; }
        _glptr_glCreateProgram = GetProcAddress(opengl32, cast(u8*, "glCreateProgram"));
        if _glptr_glCreateProgram == null { _glptr_glCreateProgram = wglGetProcAddress(cast(u8*, "glCreateProgram")); }
        if _glptr_glCreateProgram == null { ok = false; }
        _glptr_glCreateShader = GetProcAddress(opengl32, cast(u8*, "glCreateShader"));
        if _glptr_glCreateShader == null { _glptr_glCreateShader = wglGetProcAddress(cast(u8*, "glCreateShader")); }
        if _glptr_glCreateShader == null { ok = false; }
        _glptr_glCullFace = GetProcAddress(opengl32, cast(u8*, "glCullFace"));
        if _glptr_glCullFace == null { _glptr_glCullFace = wglGetProcAddress(cast(u8*, "glCullFace")); }
        if _glptr_glCullFace == null { ok = false; }
        _glptr_glDeleteBuffers = GetProcAddress(opengl32, cast(u8*, "glDeleteBuffers"));
        if _glptr_glDeleteBuffers == null { _glptr_glDeleteBuffers = wglGetProcAddress(cast(u8*, "glDeleteBuffers")); }
        if _glptr_glDeleteBuffers == null { ok = false; }
        _glptr_glDeleteFramebuffers = GetProcAddress(opengl32, cast(u8*, "glDeleteFramebuffers"));
        if _glptr_glDeleteFramebuffers == null { _glptr_glDeleteFramebuffers = wglGetProcAddress(cast(u8*, "glDeleteFramebuffers")); }
        if _glptr_glDeleteFramebuffers == null { ok = false; }
        _glptr_glDeleteProgram = GetProcAddress(opengl32, cast(u8*, "glDeleteProgram"));
        if _glptr_glDeleteProgram == null { _glptr_glDeleteProgram = wglGetProcAddress(cast(u8*, "glDeleteProgram")); }
        if _glptr_glDeleteProgram == null { ok = false; }
        _glptr_glDeleteRenderbuffers = GetProcAddress(opengl32, cast(u8*, "glDeleteRenderbuffers"));
        if _glptr_glDeleteRenderbuffers == null { _glptr_glDeleteRenderbuffers = wglGetProcAddress(cast(u8*, "glDeleteRenderbuffers")); }
        if _glptr_glDeleteRenderbuffers == null { ok = false; }
        _glptr_glDeleteShader = GetProcAddress(opengl32, cast(u8*, "glDeleteShader"));
        if _glptr_glDeleteShader == null { _glptr_glDeleteShader = wglGetProcAddress(cast(u8*, "glDeleteShader")); }
        if _glptr_glDeleteShader == null { ok = false; }
        _glptr_glDeleteTextures = GetProcAddress(opengl32, cast(u8*, "glDeleteTextures"));
        if _glptr_glDeleteTextures == null { _glptr_glDeleteTextures = wglGetProcAddress(cast(u8*, "glDeleteTextures")); }
        if _glptr_glDeleteTextures == null { ok = false; }
        _glptr_glDeleteVertexArrays = GetProcAddress(opengl32, cast(u8*, "glDeleteVertexArrays"));
        if _glptr_glDeleteVertexArrays == null { _glptr_glDeleteVertexArrays = wglGetProcAddress(cast(u8*, "glDeleteVertexArrays")); }
        if _glptr_glDeleteVertexArrays == null { ok = false; }
        _glptr_glDepthFunc = GetProcAddress(opengl32, cast(u8*, "glDepthFunc"));
        if _glptr_glDepthFunc == null { _glptr_glDepthFunc = wglGetProcAddress(cast(u8*, "glDepthFunc")); }
        if _glptr_glDepthFunc == null { ok = false; }
        _glptr_glDepthMask = GetProcAddress(opengl32, cast(u8*, "glDepthMask"));
        if _glptr_glDepthMask == null { _glptr_glDepthMask = wglGetProcAddress(cast(u8*, "glDepthMask")); }
        if _glptr_glDepthMask == null { ok = false; }
        _glptr_glDetachShader = GetProcAddress(opengl32, cast(u8*, "glDetachShader"));
        if _glptr_glDetachShader == null { _glptr_glDetachShader = wglGetProcAddress(cast(u8*, "glDetachShader")); }
        if _glptr_glDetachShader == null { ok = false; }
        _glptr_glDisable = GetProcAddress(opengl32, cast(u8*, "glDisable"));
        if _glptr_glDisable == null { _glptr_glDisable = wglGetProcAddress(cast(u8*, "glDisable")); }
        if _glptr_glDisable == null { ok = false; }
        _glptr_glDisableVertexAttribArray = GetProcAddress(opengl32, cast(u8*, "glDisableVertexAttribArray"));
        if _glptr_glDisableVertexAttribArray == null { _glptr_glDisableVertexAttribArray = wglGetProcAddress(cast(u8*, "glDisableVertexAttribArray")); }
        if _glptr_glDisableVertexAttribArray == null { ok = false; }
        _glptr_glDrawArrays = GetProcAddress(opengl32, cast(u8*, "glDrawArrays"));
        if _glptr_glDrawArrays == null { _glptr_glDrawArrays = wglGetProcAddress(cast(u8*, "glDrawArrays")); }
        if _glptr_glDrawArrays == null { ok = false; }
        _glptr_glDrawArraysInstanced = GetProcAddress(opengl32, cast(u8*, "glDrawArraysInstanced"));
        if _glptr_glDrawArraysInstanced == null { _glptr_glDrawArraysInstanced = wglGetProcAddress(cast(u8*, "glDrawArraysInstanced")); }
        if _glptr_glDrawArraysInstanced == null { ok = false; }
        _glptr_glDrawBuffers = GetProcAddress(opengl32, cast(u8*, "glDrawBuffers"));
        if _glptr_glDrawBuffers == null { _glptr_glDrawBuffers = wglGetProcAddress(cast(u8*, "glDrawBuffers")); }
        if _glptr_glDrawBuffers == null { ok = false; }
        _glptr_glDrawElements = GetProcAddress(opengl32, cast(u8*, "glDrawElements"));
        if _glptr_glDrawElements == null { _glptr_glDrawElements = wglGetProcAddress(cast(u8*, "glDrawElements")); }
        if _glptr_glDrawElements == null { ok = false; }
        _glptr_glDrawElementsInstanced = GetProcAddress(opengl32, cast(u8*, "glDrawElementsInstanced"));
        if _glptr_glDrawElementsInstanced == null { _glptr_glDrawElementsInstanced = wglGetProcAddress(cast(u8*, "glDrawElementsInstanced")); }
        if _glptr_glDrawElementsInstanced == null { ok = false; }
        _glptr_glEnable = GetProcAddress(opengl32, cast(u8*, "glEnable"));
        if _glptr_glEnable == null { _glptr_glEnable = wglGetProcAddress(cast(u8*, "glEnable")); }
        if _glptr_glEnable == null { ok = false; }
        _glptr_glEnableVertexAttribArray = GetProcAddress(opengl32, cast(u8*, "glEnableVertexAttribArray"));
        if _glptr_glEnableVertexAttribArray == null { _glptr_glEnableVertexAttribArray = wglGetProcAddress(cast(u8*, "glEnableVertexAttribArray")); }
        if _glptr_glEnableVertexAttribArray == null { ok = false; }
        _glptr_glFramebufferRenderbuffer = GetProcAddress(opengl32, cast(u8*, "glFramebufferRenderbuffer"));
        if _glptr_glFramebufferRenderbuffer == null { _glptr_glFramebufferRenderbuffer = wglGetProcAddress(cast(u8*, "glFramebufferRenderbuffer")); }
        if _glptr_glFramebufferRenderbuffer == null { ok = false; }
        _glptr_glFramebufferTexture2D = GetProcAddress(opengl32, cast(u8*, "glFramebufferTexture2D"));
        if _glptr_glFramebufferTexture2D == null { _glptr_glFramebufferTexture2D = wglGetProcAddress(cast(u8*, "glFramebufferTexture2D")); }
        if _glptr_glFramebufferTexture2D == null { ok = false; }
        _glptr_glFramebufferTextureLayer = GetProcAddress(opengl32, cast(u8*, "glFramebufferTextureLayer"));
        if _glptr_glFramebufferTextureLayer == null { _glptr_glFramebufferTextureLayer = wglGetProcAddress(cast(u8*, "glFramebufferTextureLayer")); }
        if _glptr_glFramebufferTextureLayer == null { ok = false; }
        _glptr_glFrontFace = GetProcAddress(opengl32, cast(u8*, "glFrontFace"));
        if _glptr_glFrontFace == null { _glptr_glFrontFace = wglGetProcAddress(cast(u8*, "glFrontFace")); }
        if _glptr_glFrontFace == null { ok = false; }
        _glptr_glGenBuffers = GetProcAddress(opengl32, cast(u8*, "glGenBuffers"));
        if _glptr_glGenBuffers == null { _glptr_glGenBuffers = wglGetProcAddress(cast(u8*, "glGenBuffers")); }
        if _glptr_glGenBuffers == null { ok = false; }
        _glptr_glGenFramebuffers = GetProcAddress(opengl32, cast(u8*, "glGenFramebuffers"));
        if _glptr_glGenFramebuffers == null { _glptr_glGenFramebuffers = wglGetProcAddress(cast(u8*, "glGenFramebuffers")); }
        if _glptr_glGenFramebuffers == null { ok = false; }
        _glptr_glGenRenderbuffers = GetProcAddress(opengl32, cast(u8*, "glGenRenderbuffers"));
        if _glptr_glGenRenderbuffers == null { _glptr_glGenRenderbuffers = wglGetProcAddress(cast(u8*, "glGenRenderbuffers")); }
        if _glptr_glGenRenderbuffers == null { ok = false; }
        _glptr_glGenTextures = GetProcAddress(opengl32, cast(u8*, "glGenTextures"));
        if _glptr_glGenTextures == null { _glptr_glGenTextures = wglGetProcAddress(cast(u8*, "glGenTextures")); }
        if _glptr_glGenTextures == null { ok = false; }
        _glptr_glGenVertexArrays = GetProcAddress(opengl32, cast(u8*, "glGenVertexArrays"));
        if _glptr_glGenVertexArrays == null { _glptr_glGenVertexArrays = wglGetProcAddress(cast(u8*, "glGenVertexArrays")); }
        if _glptr_glGenVertexArrays == null { ok = false; }
        _glptr_glGenerateMipmap = GetProcAddress(opengl32, cast(u8*, "glGenerateMipmap"));
        if _glptr_glGenerateMipmap == null { _glptr_glGenerateMipmap = wglGetProcAddress(cast(u8*, "glGenerateMipmap")); }
        if _glptr_glGenerateMipmap == null { ok = false; }
        _glptr_glGetAttribLocation = GetProcAddress(opengl32, cast(u8*, "glGetAttribLocation"));
        if _glptr_glGetAttribLocation == null { _glptr_glGetAttribLocation = wglGetProcAddress(cast(u8*, "glGetAttribLocation")); }
        if _glptr_glGetAttribLocation == null { ok = false; }
        _glptr_glGetError = GetProcAddress(opengl32, cast(u8*, "glGetError"));
        if _glptr_glGetError == null { _glptr_glGetError = wglGetProcAddress(cast(u8*, "glGetError")); }
        if _glptr_glGetError == null { ok = false; }
        _glptr_glGetFloatv = GetProcAddress(opengl32, cast(u8*, "glGetFloatv"));
        if _glptr_glGetFloatv == null { _glptr_glGetFloatv = wglGetProcAddress(cast(u8*, "glGetFloatv")); }
        if _glptr_glGetFloatv == null { ok = false; }
        _glptr_glGetFramebufferAttachmentParameteriv = GetProcAddress(opengl32, cast(u8*, "glGetFramebufferAttachmentParameteriv"));
        if _glptr_glGetFramebufferAttachmentParameteriv == null { _glptr_glGetFramebufferAttachmentParameteriv = wglGetProcAddress(cast(u8*, "glGetFramebufferAttachmentParameteriv")); }
        if _glptr_glGetFramebufferAttachmentParameteriv == null { ok = false; }
        _glptr_glGetIntegerv = GetProcAddress(opengl32, cast(u8*, "glGetIntegerv"));
        if _glptr_glGetIntegerv == null { _glptr_glGetIntegerv = wglGetProcAddress(cast(u8*, "glGetIntegerv")); }
        if _glptr_glGetIntegerv == null { ok = false; }
        _glptr_glGetProgramInfoLog = GetProcAddress(opengl32, cast(u8*, "glGetProgramInfoLog"));
        if _glptr_glGetProgramInfoLog == null { _glptr_glGetProgramInfoLog = wglGetProcAddress(cast(u8*, "glGetProgramInfoLog")); }
        if _glptr_glGetProgramInfoLog == null { ok = false; }
        _glptr_glGetProgramiv = GetProcAddress(opengl32, cast(u8*, "glGetProgramiv"));
        if _glptr_glGetProgramiv == null { _glptr_glGetProgramiv = wglGetProcAddress(cast(u8*, "glGetProgramiv")); }
        if _glptr_glGetProgramiv == null { ok = false; }
        _glptr_glGetShaderInfoLog = GetProcAddress(opengl32, cast(u8*, "glGetShaderInfoLog"));
        if _glptr_glGetShaderInfoLog == null { _glptr_glGetShaderInfoLog = wglGetProcAddress(cast(u8*, "glGetShaderInfoLog")); }
        if _glptr_glGetShaderInfoLog == null { ok = false; }
        _glptr_glGetShaderiv = GetProcAddress(opengl32, cast(u8*, "glGetShaderiv"));
        if _glptr_glGetShaderiv == null { _glptr_glGetShaderiv = wglGetProcAddress(cast(u8*, "glGetShaderiv")); }
        if _glptr_glGetShaderiv == null { ok = false; }
        _glptr_glGetString = GetProcAddress(opengl32, cast(u8*, "glGetString"));
        if _glptr_glGetString == null { _glptr_glGetString = wglGetProcAddress(cast(u8*, "glGetString")); }
        if _glptr_glGetString == null { ok = false; }
        _glptr_glGetStringi = GetProcAddress(opengl32, cast(u8*, "glGetStringi"));
        if _glptr_glGetStringi == null { _glptr_glGetStringi = wglGetProcAddress(cast(u8*, "glGetStringi")); }
        if _glptr_glGetStringi == null { ok = false; }
        _glptr_glGetTexImage = GetProcAddress(opengl32, cast(u8*, "glGetTexImage"));
        if _glptr_glGetTexImage == null { _glptr_glGetTexImage = wglGetProcAddress(cast(u8*, "glGetTexImage")); }
        if _glptr_glGetTexImage == null { ok = false; }
        _glptr_glGetUniformLocation = GetProcAddress(opengl32, cast(u8*, "glGetUniformLocation"));
        if _glptr_glGetUniformLocation == null { _glptr_glGetUniformLocation = wglGetProcAddress(cast(u8*, "glGetUniformLocation")); }
        if _glptr_glGetUniformLocation == null { ok = false; }
        _glptr_glLineWidth = GetProcAddress(opengl32, cast(u8*, "glLineWidth"));
        if _glptr_glLineWidth == null { _glptr_glLineWidth = wglGetProcAddress(cast(u8*, "glLineWidth")); }
        if _glptr_glLineWidth == null { ok = false; }
        _glptr_glLinkProgram = GetProcAddress(opengl32, cast(u8*, "glLinkProgram"));
        if _glptr_glLinkProgram == null { _glptr_glLinkProgram = wglGetProcAddress(cast(u8*, "glLinkProgram")); }
        if _glptr_glLinkProgram == null { ok = false; }
        _glptr_glPixelStorei = GetProcAddress(opengl32, cast(u8*, "glPixelStorei"));
        if _glptr_glPixelStorei == null { _glptr_glPixelStorei = wglGetProcAddress(cast(u8*, "glPixelStorei")); }
        if _glptr_glPixelStorei == null { ok = false; }
        _glptr_glPolygonMode = GetProcAddress(opengl32, cast(u8*, "glPolygonMode"));
        if _glptr_glPolygonMode == null { _glptr_glPolygonMode = wglGetProcAddress(cast(u8*, "glPolygonMode")); }
        if _glptr_glPolygonMode == null { ok = false; }
        _glptr_glPolygonOffset = GetProcAddress(opengl32, cast(u8*, "glPolygonOffset"));
        if _glptr_glPolygonOffset == null { _glptr_glPolygonOffset = wglGetProcAddress(cast(u8*, "glPolygonOffset")); }
        if _glptr_glPolygonOffset == null { ok = false; }
        _glptr_glReadBuffer = GetProcAddress(opengl32, cast(u8*, "glReadBuffer"));
        if _glptr_glReadBuffer == null { _glptr_glReadBuffer = wglGetProcAddress(cast(u8*, "glReadBuffer")); }
        if _glptr_glReadBuffer == null { ok = false; }
        _glptr_glReadPixels = GetProcAddress(opengl32, cast(u8*, "glReadPixels"));
        if _glptr_glReadPixels == null { _glptr_glReadPixels = wglGetProcAddress(cast(u8*, "glReadPixels")); }
        if _glptr_glReadPixels == null { ok = false; }
        _glptr_glRenderbufferStorage = GetProcAddress(opengl32, cast(u8*, "glRenderbufferStorage"));
        if _glptr_glRenderbufferStorage == null { _glptr_glRenderbufferStorage = wglGetProcAddress(cast(u8*, "glRenderbufferStorage")); }
        if _glptr_glRenderbufferStorage == null { ok = false; }
        _glptr_glRenderbufferStorageMultisample = GetProcAddress(opengl32, cast(u8*, "glRenderbufferStorageMultisample"));
        if _glptr_glRenderbufferStorageMultisample == null { _glptr_glRenderbufferStorageMultisample = wglGetProcAddress(cast(u8*, "glRenderbufferStorageMultisample")); }
        if _glptr_glRenderbufferStorageMultisample == null { ok = false; }
        _glptr_glScissor = GetProcAddress(opengl32, cast(u8*, "glScissor"));
        if _glptr_glScissor == null { _glptr_glScissor = wglGetProcAddress(cast(u8*, "glScissor")); }
        if _glptr_glScissor == null { ok = false; }
        _glptr_glShaderSource = GetProcAddress(opengl32, cast(u8*, "glShaderSource"));
        if _glptr_glShaderSource == null { _glptr_glShaderSource = wglGetProcAddress(cast(u8*, "glShaderSource")); }
        if _glptr_glShaderSource == null { ok = false; }
        _glptr_glStencilFunc = GetProcAddress(opengl32, cast(u8*, "glStencilFunc"));
        if _glptr_glStencilFunc == null { _glptr_glStencilFunc = wglGetProcAddress(cast(u8*, "glStencilFunc")); }
        if _glptr_glStencilFunc == null { ok = false; }
        _glptr_glStencilFuncSeparate = GetProcAddress(opengl32, cast(u8*, "glStencilFuncSeparate"));
        if _glptr_glStencilFuncSeparate == null { _glptr_glStencilFuncSeparate = wglGetProcAddress(cast(u8*, "glStencilFuncSeparate")); }
        if _glptr_glStencilFuncSeparate == null { ok = false; }
        _glptr_glStencilMask = GetProcAddress(opengl32, cast(u8*, "glStencilMask"));
        if _glptr_glStencilMask == null { _glptr_glStencilMask = wglGetProcAddress(cast(u8*, "glStencilMask")); }
        if _glptr_glStencilMask == null { ok = false; }
        _glptr_glStencilOp = GetProcAddress(opengl32, cast(u8*, "glStencilOp"));
        if _glptr_glStencilOp == null { _glptr_glStencilOp = wglGetProcAddress(cast(u8*, "glStencilOp")); }
        if _glptr_glStencilOp == null { ok = false; }
        _glptr_glStencilOpSeparate = GetProcAddress(opengl32, cast(u8*, "glStencilOpSeparate"));
        if _glptr_glStencilOpSeparate == null { _glptr_glStencilOpSeparate = wglGetProcAddress(cast(u8*, "glStencilOpSeparate")); }
        if _glptr_glStencilOpSeparate == null { ok = false; }
        _glptr_glTexImage2D = GetProcAddress(opengl32, cast(u8*, "glTexImage2D"));
        if _glptr_glTexImage2D == null { _glptr_glTexImage2D = wglGetProcAddress(cast(u8*, "glTexImage2D")); }
        if _glptr_glTexImage2D == null { ok = false; }
        _glptr_glTexImage3D = GetProcAddress(opengl32, cast(u8*, "glTexImage3D"));
        if _glptr_glTexImage3D == null { _glptr_glTexImage3D = wglGetProcAddress(cast(u8*, "glTexImage3D")); }
        if _glptr_glTexImage3D == null { ok = false; }
        _glptr_glTexParameterf = GetProcAddress(opengl32, cast(u8*, "glTexParameterf"));
        if _glptr_glTexParameterf == null { _glptr_glTexParameterf = wglGetProcAddress(cast(u8*, "glTexParameterf")); }
        if _glptr_glTexParameterf == null { ok = false; }
        _glptr_glTexParameterfv = GetProcAddress(opengl32, cast(u8*, "glTexParameterfv"));
        if _glptr_glTexParameterfv == null { _glptr_glTexParameterfv = wglGetProcAddress(cast(u8*, "glTexParameterfv")); }
        if _glptr_glTexParameterfv == null { ok = false; }
        _glptr_glTexParameteri = GetProcAddress(opengl32, cast(u8*, "glTexParameteri"));
        if _glptr_glTexParameteri == null { _glptr_glTexParameteri = wglGetProcAddress(cast(u8*, "glTexParameteri")); }
        if _glptr_glTexParameteri == null { ok = false; }
        _glptr_glTexParameteriv = GetProcAddress(opengl32, cast(u8*, "glTexParameteriv"));
        if _glptr_glTexParameteriv == null { _glptr_glTexParameteriv = wglGetProcAddress(cast(u8*, "glTexParameteriv")); }
        if _glptr_glTexParameteriv == null { ok = false; }
        _glptr_glTexSubImage2D = GetProcAddress(opengl32, cast(u8*, "glTexSubImage2D"));
        if _glptr_glTexSubImage2D == null { _glptr_glTexSubImage2D = wglGetProcAddress(cast(u8*, "glTexSubImage2D")); }
        if _glptr_glTexSubImage2D == null { ok = false; }
        _glptr_glTexSubImage3D = GetProcAddress(opengl32, cast(u8*, "glTexSubImage3D"));
        if _glptr_glTexSubImage3D == null { _glptr_glTexSubImage3D = wglGetProcAddress(cast(u8*, "glTexSubImage3D")); }
        if _glptr_glTexSubImage3D == null { ok = false; }
        _glptr_glUniform1fv = GetProcAddress(opengl32, cast(u8*, "glUniform1fv"));
        if _glptr_glUniform1fv == null { _glptr_glUniform1fv = wglGetProcAddress(cast(u8*, "glUniform1fv")); }
        if _glptr_glUniform1fv == null { ok = false; }
        _glptr_glUniform1i = GetProcAddress(opengl32, cast(u8*, "glUniform1i"));
        if _glptr_glUniform1i == null { _glptr_glUniform1i = wglGetProcAddress(cast(u8*, "glUniform1i")); }
        if _glptr_glUniform1i == null { ok = false; }
        _glptr_glUniform1iv = GetProcAddress(opengl32, cast(u8*, "glUniform1iv"));
        if _glptr_glUniform1iv == null { _glptr_glUniform1iv = wglGetProcAddress(cast(u8*, "glUniform1iv")); }
        if _glptr_glUniform1iv == null { ok = false; }
        _glptr_glUniform1uiv = GetProcAddress(opengl32, cast(u8*, "glUniform1uiv"));
        if _glptr_glUniform1uiv == null { _glptr_glUniform1uiv = wglGetProcAddress(cast(u8*, "glUniform1uiv")); }
        if _glptr_glUniform1uiv == null { ok = false; }
        _glptr_glUniform2fv = GetProcAddress(opengl32, cast(u8*, "glUniform2fv"));
        if _glptr_glUniform2fv == null { _glptr_glUniform2fv = wglGetProcAddress(cast(u8*, "glUniform2fv")); }
        if _glptr_glUniform2fv == null { ok = false; }
        _glptr_glUniform2iv = GetProcAddress(opengl32, cast(u8*, "glUniform2iv"));
        if _glptr_glUniform2iv == null { _glptr_glUniform2iv = wglGetProcAddress(cast(u8*, "glUniform2iv")); }
        if _glptr_glUniform2iv == null { ok = false; }
        _glptr_glUniform2uiv = GetProcAddress(opengl32, cast(u8*, "glUniform2uiv"));
        if _glptr_glUniform2uiv == null { _glptr_glUniform2uiv = wglGetProcAddress(cast(u8*, "glUniform2uiv")); }
        if _glptr_glUniform2uiv == null { ok = false; }
        _glptr_glUniform3fv = GetProcAddress(opengl32, cast(u8*, "glUniform3fv"));
        if _glptr_glUniform3fv == null { _glptr_glUniform3fv = wglGetProcAddress(cast(u8*, "glUniform3fv")); }
        if _glptr_glUniform3fv == null { ok = false; }
        _glptr_glUniform3iv = GetProcAddress(opengl32, cast(u8*, "glUniform3iv"));
        if _glptr_glUniform3iv == null { _glptr_glUniform3iv = wglGetProcAddress(cast(u8*, "glUniform3iv")); }
        if _glptr_glUniform3iv == null { ok = false; }
        _glptr_glUniform3uiv = GetProcAddress(opengl32, cast(u8*, "glUniform3uiv"));
        if _glptr_glUniform3uiv == null { _glptr_glUniform3uiv = wglGetProcAddress(cast(u8*, "glUniform3uiv")); }
        if _glptr_glUniform3uiv == null { ok = false; }
        _glptr_glUniform4f = GetProcAddress(opengl32, cast(u8*, "glUniform4f"));
        if _glptr_glUniform4f == null { _glptr_glUniform4f = wglGetProcAddress(cast(u8*, "glUniform4f")); }
        if _glptr_glUniform4f == null { ok = false; }
        _glptr_glUniform4fv = GetProcAddress(opengl32, cast(u8*, "glUniform4fv"));
        if _glptr_glUniform4fv == null { _glptr_glUniform4fv = wglGetProcAddress(cast(u8*, "glUniform4fv")); }
        if _glptr_glUniform4fv == null { ok = false; }
        _glptr_glUniform4iv = GetProcAddress(opengl32, cast(u8*, "glUniform4iv"));
        if _glptr_glUniform4iv == null { _glptr_glUniform4iv = wglGetProcAddress(cast(u8*, "glUniform4iv")); }
        if _glptr_glUniform4iv == null { ok = false; }
        _glptr_glUniform4uiv = GetProcAddress(opengl32, cast(u8*, "glUniform4uiv"));
        if _glptr_glUniform4uiv == null { _glptr_glUniform4uiv = wglGetProcAddress(cast(u8*, "glUniform4uiv")); }
        if _glptr_glUniform4uiv == null { ok = false; }
        _glptr_glUniformMatrix4fv = GetProcAddress(opengl32, cast(u8*, "glUniformMatrix4fv"));
        if _glptr_glUniformMatrix4fv == null { _glptr_glUniformMatrix4fv = wglGetProcAddress(cast(u8*, "glUniformMatrix4fv")); }
        if _glptr_glUniformMatrix4fv == null { ok = false; }
        _glptr_glUseProgram = GetProcAddress(opengl32, cast(u8*, "glUseProgram"));
        if _glptr_glUseProgram == null { _glptr_glUseProgram = wglGetProcAddress(cast(u8*, "glUseProgram")); }
        if _glptr_glUseProgram == null { ok = false; }
        _glptr_glVertexAttrib1fv = GetProcAddress(opengl32, cast(u8*, "glVertexAttrib1fv"));
        if _glptr_glVertexAttrib1fv == null { _glptr_glVertexAttrib1fv = wglGetProcAddress(cast(u8*, "glVertexAttrib1fv")); }
        if _glptr_glVertexAttrib1fv == null { ok = false; }
        _glptr_glVertexAttrib2fv = GetProcAddress(opengl32, cast(u8*, "glVertexAttrib2fv"));
        if _glptr_glVertexAttrib2fv == null { _glptr_glVertexAttrib2fv = wglGetProcAddress(cast(u8*, "glVertexAttrib2fv")); }
        if _glptr_glVertexAttrib2fv == null { ok = false; }
        _glptr_glVertexAttrib3fv = GetProcAddress(opengl32, cast(u8*, "glVertexAttrib3fv"));
        if _glptr_glVertexAttrib3fv == null { _glptr_glVertexAttrib3fv = wglGetProcAddress(cast(u8*, "glVertexAttrib3fv")); }
        if _glptr_glVertexAttrib3fv == null { ok = false; }
        _glptr_glVertexAttrib4fv = GetProcAddress(opengl32, cast(u8*, "glVertexAttrib4fv"));
        if _glptr_glVertexAttrib4fv == null { _glptr_glVertexAttrib4fv = wglGetProcAddress(cast(u8*, "glVertexAttrib4fv")); }
        if _glptr_glVertexAttrib4fv == null { ok = false; }
        _glptr_glVertexAttribDivisor = GetProcAddress(opengl32, cast(u8*, "glVertexAttribDivisor"));
        if _glptr_glVertexAttribDivisor == null { _glptr_glVertexAttribDivisor = wglGetProcAddress(cast(u8*, "glVertexAttribDivisor")); }
        if _glptr_glVertexAttribDivisor == null { ok = false; }
        _glptr_glVertexAttribPointer = GetProcAddress(opengl32, cast(u8*, "glVertexAttribPointer"));
        if _glptr_glVertexAttribPointer == null { _glptr_glVertexAttribPointer = wglGetProcAddress(cast(u8*, "glVertexAttribPointer")); }
        if _glptr_glVertexAttribPointer == null { ok = false; }
        _glptr_glViewport = GetProcAddress(opengl32, cast(u8*, "glViewport"));
        if _glptr_glViewport == null { _glptr_glViewport = wglGetProcAddress(cast(u8*, "glViewport")); }
        if _glptr_glViewport == null { ok = false; }
        return ok;
    }
}
else when os(linux) {
    extern "libGL.so.1" {
        void glActiveTexture(u32 texture);
        void glAttachShader(u32 program, u32 shader);
        void glBindAttribLocation(u32 program, u32 index, u8* name);
        void glBindBuffer(u32 target, u32 buffer);
        void glBindFramebuffer(u32 target, u32 framebuffer);
        void glBindRenderbuffer(u32 target, u32 renderbuffer);
        void glBindTexture(u32 target, u32 texture);
        void glBindVertexArray(u32 array);
        void glBlendColor(f32 r, f32 g, f32 b, f32 a);
        void glBlendEquation(u32 mode);
        void glBlendEquationSeparate(u32 modeRGB, u32 modeAlpha);
        void glBlendFunc(u32 sfactor, u32 dfactor);
        void glBlendFuncSeparate(u32 srcRGB, u32 dstRGB, u32 srcAlpha, u32 dstAlpha);
        void glBlitFramebuffer(i32 srcX0, i32 srcY0, i32 srcX1, i32 srcY1, i32 dstX0, i32 dstY0, i32 dstX1, i32 dstY1, u32 mask, u32 filter);
        void glBufferData(u32 target, i64 size, void* data, u32 usage);
        void glBufferSubData(u32 target, i64 offset, i64 size, void* data);
        u32 glCheckFramebufferStatus(u32 target);
        void glClear(u32 mask);
        void glClearBufferfi(u32 buffer, i32 drawbuffer, f32 depth, i32 stencil);
        void glClearBufferfv(u32 buffer, i32 drawbuffer, f32* value);
        void glClearBufferuiv(u32 buffer, i32 drawbuffer, u32* value);
        void glClearColor(f32 r, f32 g, f32 b, f32 a);
        void glClearDepth(f64 depth);
        void glClearStencil(i32 s);
        void glColorMask(u8 r, u8 g, u8 b, u8 a);
        void glCompileShader(u32 shader);
        void glCompressedTexImage2D(u32 target, i32 level, u32 internalformat, i32 width, i32 height, i32 border, i32 imageSize, void* data);
        void glCompressedTexImage3D(u32 target, i32 level, u32 internalformat, i32 width, i32 height, i32 depth, i32 border, i32 imageSize, void* data);
        u32 glCreateProgram();
        u32 glCreateShader(u32 type);
        void glCullFace(u32 mode);
        void glDeleteBuffers(i32 n, u32* buffers);
        void glDeleteFramebuffers(i32 n, u32* framebuffers);
        void glDeleteProgram(u32 program);
        void glDeleteRenderbuffers(i32 n, u32* renderbuffers);
        void glDeleteShader(u32 shader);
        void glDeleteTextures(i32 n, u32* textures);
        void glDeleteVertexArrays(i32 n, u32* arrays);
        void glDepthFunc(u32 func);
        void glDepthMask(u8 flag);
        void glDetachShader(u32 program, u32 shader);
        void glDisable(u32 cap);
        void glDisableVertexAttribArray(u32 index);
        void glDrawArrays(u32 mode, i32 first, i32 count);
        void glDrawArraysInstanced(u32 mode, i32 first, i32 count, i32 instancecount);
        void glDrawBuffers(i32 n, u32* bufs);
        void glDrawElements(u32 mode, i32 count, u32 type, void* indices);
        void glDrawElementsInstanced(u32 mode, i32 count, u32 type, void* indices, i32 instancecount);
        void glEnable(u32 cap);
        void glEnableVertexAttribArray(u32 index);
        void glFramebufferRenderbuffer(u32 target, u32 attachment, u32 renderbuffertarget, u32 renderbuffer);
        void glFramebufferTexture2D(u32 target, u32 attachment, u32 textarget, u32 texture, i32 level);
        void glFramebufferTextureLayer(u32 target, u32 attachment, u32 texture, i32 level, i32 layer);
        void glFrontFace(u32 mode);
        void glGenBuffers(i32 n, u32* buffers);
        void glGenFramebuffers(i32 n, u32* framebuffers);
        void glGenRenderbuffers(i32 n, u32* renderbuffers);
        void glGenTextures(i32 n, u32* textures);
        void glGenVertexArrays(i32 n, u32* arrays);
        void glGenerateMipmap(u32 target);
        i32 glGetAttribLocation(u32 program, u8* name);
        u32 glGetError();
        void glGetFloatv(u32 pname, f32* params);
        void glGetFramebufferAttachmentParameteriv(u32 target, u32 attachment, u32 pname, i32* params);
        void glGetIntegerv(u32 pname, i32* params);
        void glGetProgramInfoLog(u32 program, i32 bufSize, i32* length, u8* infoLog);
        void glGetProgramiv(u32 program, u32 pname, i32* params);
        void glGetShaderInfoLog(u32 shader, i32 bufSize, i32* length, u8* infoLog);
        void glGetShaderiv(u32 shader, u32 pname, i32* params);
        u8* glGetString(u32 name);
        u8* glGetStringi(u32 name, u32 index);
        void glGetTexImage(u32 target, i32 level, u32 format, u32 type, void* pixels);
        i32 glGetUniformLocation(u32 program, u8* name);
        void glLineWidth(f32 width);
        void glLinkProgram(u32 program);
        void glPixelStorei(u32 pname, i32 param);
        void glPolygonMode(u32 face, u32 mode);
        void glPolygonOffset(f32 factor, f32 units);
        void glReadBuffer(u32 mode);
        void glReadPixels(i32 x, i32 y, i32 width, i32 height, u32 format, u32 type, void* data);
        void glRenderbufferStorage(u32 target, u32 internalformat, i32 width, i32 height);
        void glRenderbufferStorageMultisample(u32 target, i32 samples, u32 internalformat, i32 width, i32 height);
        void glScissor(i32 x, i32 y, i32 width, i32 height);
        void glShaderSource(u32 shader, i32 count, u8** string, i32* length);
        void glStencilFunc(u32 func, i32 ref, u32 mask);
        void glStencilFuncSeparate(u32 face, u32 func, i32 ref, u32 mask);
        void glStencilMask(u32 mask);
        void glStencilOp(u32 sfail, u32 dpfail, u32 dppass);
        void glStencilOpSeparate(u32 face, u32 sfail, u32 dpfail, u32 dppass);
        void glTexImage2D(u32 target, i32 level, i32 internalformat, i32 width, i32 height, i32 border, u32 format, u32 type, void* pixels);
        void glTexImage3D(u32 target, i32 level, i32 internalformat, i32 width, i32 height, i32 depth, i32 border, u32 format, u32 type, void* pixels);
        void glTexParameterf(u32 target, u32 pname, f32 param);
        void glTexParameterfv(u32 target, u32 pname, f32* params);
        void glTexParameteri(u32 target, u32 pname, i32 param);
        void glTexParameteriv(u32 target, u32 pname, i32* params);
        void glTexSubImage2D(u32 target, i32 level, i32 xoffset, i32 yoffset, i32 width, i32 height, u32 format, u32 type, void* pixels);
        void glTexSubImage3D(u32 target, i32 level, i32 xoffset, i32 yoffset, i32 zoffset, i32 width, i32 height, i32 depth, u32 format, u32 type, void* pixels);
        void glUniform1fv(i32 location, i32 count, f32* value);
        void glUniform1i(i32 location, i32 v0);
        void glUniform1iv(i32 location, i32 count, i32* value);
        void glUniform1uiv(i32 location, i32 count, u32* value);
        void glUniform2fv(i32 location, i32 count, f32* value);
        void glUniform2iv(i32 location, i32 count, i32* value);
        void glUniform2uiv(i32 location, i32 count, u32* value);
        void glUniform3fv(i32 location, i32 count, f32* value);
        void glUniform3iv(i32 location, i32 count, i32* value);
        void glUniform3uiv(i32 location, i32 count, u32* value);
        void glUniform4f(i32 location, f32 v0, f32 v1, f32 v2, f32 v3);
        void glUniform4fv(i32 location, i32 count, f32* value);
        void glUniform4iv(i32 location, i32 count, i32* value);
        void glUniform4uiv(i32 location, i32 count, u32* value);
        void glUniformMatrix4fv(i32 location, i32 count, u8 transpose, f32* value);
        void glUseProgram(u32 program);
        void glVertexAttrib1fv(u32 index, f32* v);
        void glVertexAttrib2fv(u32 index, f32* v);
        void glVertexAttrib3fv(u32 index, f32* v);
        void glVertexAttrib4fv(u32 index, f32* v);
        void glVertexAttribDivisor(u32 index, u32 divisor);
        void glVertexAttribPointer(u32 index, i32 size, u32 type, u8 normalized, i32 stride, void* pointer);
        void glViewport(i32 x, i32 y, i32 width, i32 height);
    }
    bool gl_load_all_fns() { return true; }
}
else when os(macos) {
    extern "/System/Library/Frameworks/OpenGL.framework/OpenGL" {
        void glActiveTexture(u32 texture);
        void glAttachShader(u32 program, u32 shader);
        void glBindAttribLocation(u32 program, u32 index, u8* name);
        void glBindBuffer(u32 target, u32 buffer);
        void glBindFramebuffer(u32 target, u32 framebuffer);
        void glBindRenderbuffer(u32 target, u32 renderbuffer);
        void glBindTexture(u32 target, u32 texture);
        void glBindVertexArray(u32 array);
        void glBlendColor(f32 r, f32 g, f32 b, f32 a);
        void glBlendEquation(u32 mode);
        void glBlendEquationSeparate(u32 modeRGB, u32 modeAlpha);
        void glBlendFunc(u32 sfactor, u32 dfactor);
        void glBlendFuncSeparate(u32 srcRGB, u32 dstRGB, u32 srcAlpha, u32 dstAlpha);
        void glBlitFramebuffer(i32 srcX0, i32 srcY0, i32 srcX1, i32 srcY1, i32 dstX0, i32 dstY0, i32 dstX1, i32 dstY1, u32 mask, u32 filter);
        void glBufferData(u32 target, i64 size, void* data, u32 usage);
        void glBufferSubData(u32 target, i64 offset, i64 size, void* data);
        u32 glCheckFramebufferStatus(u32 target);
        void glClear(u32 mask);
        void glClearBufferfi(u32 buffer, i32 drawbuffer, f32 depth, i32 stencil);
        void glClearBufferfv(u32 buffer, i32 drawbuffer, f32* value);
        void glClearBufferuiv(u32 buffer, i32 drawbuffer, u32* value);
        void glClearColor(f32 r, f32 g, f32 b, f32 a);
        void glClearDepth(f64 depth);
        void glClearStencil(i32 s);
        void glColorMask(u8 r, u8 g, u8 b, u8 a);
        void glCompileShader(u32 shader);
        void glCompressedTexImage2D(u32 target, i32 level, u32 internalformat, i32 width, i32 height, i32 border, i32 imageSize, void* data);
        void glCompressedTexImage3D(u32 target, i32 level, u32 internalformat, i32 width, i32 height, i32 depth, i32 border, i32 imageSize, void* data);
        u32 glCreateProgram();
        u32 glCreateShader(u32 type);
        void glCullFace(u32 mode);
        void glDeleteBuffers(i32 n, u32* buffers);
        void glDeleteFramebuffers(i32 n, u32* framebuffers);
        void glDeleteProgram(u32 program);
        void glDeleteRenderbuffers(i32 n, u32* renderbuffers);
        void glDeleteShader(u32 shader);
        void glDeleteTextures(i32 n, u32* textures);
        void glDeleteVertexArrays(i32 n, u32* arrays);
        void glDepthFunc(u32 func);
        void glDepthMask(u8 flag);
        void glDetachShader(u32 program, u32 shader);
        void glDisable(u32 cap);
        void glDisableVertexAttribArray(u32 index);
        void glDrawArrays(u32 mode, i32 first, i32 count);
        void glDrawArraysInstanced(u32 mode, i32 first, i32 count, i32 instancecount);
        void glDrawBuffers(i32 n, u32* bufs);
        void glDrawElements(u32 mode, i32 count, u32 type, void* indices);
        void glDrawElementsInstanced(u32 mode, i32 count, u32 type, void* indices, i32 instancecount);
        void glEnable(u32 cap);
        void glEnableVertexAttribArray(u32 index);
        void glFramebufferRenderbuffer(u32 target, u32 attachment, u32 renderbuffertarget, u32 renderbuffer);
        void glFramebufferTexture2D(u32 target, u32 attachment, u32 textarget, u32 texture, i32 level);
        void glFramebufferTextureLayer(u32 target, u32 attachment, u32 texture, i32 level, i32 layer);
        void glFrontFace(u32 mode);
        void glGenBuffers(i32 n, u32* buffers);
        void glGenFramebuffers(i32 n, u32* framebuffers);
        void glGenRenderbuffers(i32 n, u32* renderbuffers);
        void glGenTextures(i32 n, u32* textures);
        void glGenVertexArrays(i32 n, u32* arrays);
        void glGenerateMipmap(u32 target);
        i32 glGetAttribLocation(u32 program, u8* name);
        u32 glGetError();
        void glGetFloatv(u32 pname, f32* params);
        void glGetFramebufferAttachmentParameteriv(u32 target, u32 attachment, u32 pname, i32* params);
        void glGetIntegerv(u32 pname, i32* params);
        void glGetProgramInfoLog(u32 program, i32 bufSize, i32* length, u8* infoLog);
        void glGetProgramiv(u32 program, u32 pname, i32* params);
        void glGetShaderInfoLog(u32 shader, i32 bufSize, i32* length, u8* infoLog);
        void glGetShaderiv(u32 shader, u32 pname, i32* params);
        u8* glGetString(u32 name);
        u8* glGetStringi(u32 name, u32 index);
        void glGetTexImage(u32 target, i32 level, u32 format, u32 type, void* pixels);
        i32 glGetUniformLocation(u32 program, u8* name);
        void glLineWidth(f32 width);
        void glLinkProgram(u32 program);
        void glPixelStorei(u32 pname, i32 param);
        void glPolygonMode(u32 face, u32 mode);
        void glPolygonOffset(f32 factor, f32 units);
        void glReadBuffer(u32 mode);
        void glReadPixels(i32 x, i32 y, i32 width, i32 height, u32 format, u32 type, void* data);
        void glRenderbufferStorage(u32 target, u32 internalformat, i32 width, i32 height);
        void glRenderbufferStorageMultisample(u32 target, i32 samples, u32 internalformat, i32 width, i32 height);
        void glScissor(i32 x, i32 y, i32 width, i32 height);
        void glShaderSource(u32 shader, i32 count, u8** string, i32* length);
        void glStencilFunc(u32 func, i32 ref, u32 mask);
        void glStencilFuncSeparate(u32 face, u32 func, i32 ref, u32 mask);
        void glStencilMask(u32 mask);
        void glStencilOp(u32 sfail, u32 dpfail, u32 dppass);
        void glStencilOpSeparate(u32 face, u32 sfail, u32 dpfail, u32 dppass);
        void glTexImage2D(u32 target, i32 level, i32 internalformat, i32 width, i32 height, i32 border, u32 format, u32 type, void* pixels);
        void glTexImage3D(u32 target, i32 level, i32 internalformat, i32 width, i32 height, i32 depth, i32 border, u32 format, u32 type, void* pixels);
        void glTexParameterf(u32 target, u32 pname, f32 param);
        void glTexParameterfv(u32 target, u32 pname, f32* params);
        void glTexParameteri(u32 target, u32 pname, i32 param);
        void glTexParameteriv(u32 target, u32 pname, i32* params);
        void glTexSubImage2D(u32 target, i32 level, i32 xoffset, i32 yoffset, i32 width, i32 height, u32 format, u32 type, void* pixels);
        void glTexSubImage3D(u32 target, i32 level, i32 xoffset, i32 yoffset, i32 zoffset, i32 width, i32 height, i32 depth, u32 format, u32 type, void* pixels);
        void glUniform1fv(i32 location, i32 count, f32* value);
        void glUniform1i(i32 location, i32 v0);
        void glUniform1iv(i32 location, i32 count, i32* value);
        void glUniform1uiv(i32 location, i32 count, u32* value);
        void glUniform2fv(i32 location, i32 count, f32* value);
        void glUniform2iv(i32 location, i32 count, i32* value);
        void glUniform2uiv(i32 location, i32 count, u32* value);
        void glUniform3fv(i32 location, i32 count, f32* value);
        void glUniform3iv(i32 location, i32 count, i32* value);
        void glUniform3uiv(i32 location, i32 count, u32* value);
        void glUniform4f(i32 location, f32 v0, f32 v1, f32 v2, f32 v3);
        void glUniform4fv(i32 location, i32 count, f32* value);
        void glUniform4iv(i32 location, i32 count, i32* value);
        void glUniform4uiv(i32 location, i32 count, u32* value);
        void glUniformMatrix4fv(i32 location, i32 count, u8 transpose, f32* value);
        void glUseProgram(u32 program);
        void glVertexAttrib1fv(u32 index, f32* v);
        void glVertexAttrib2fv(u32 index, f32* v);
        void glVertexAttrib3fv(u32 index, f32* v);
        void glVertexAttrib4fv(u32 index, f32* v);
        void glVertexAttribDivisor(u32 index, u32 divisor);
        void glVertexAttribPointer(u32 index, i32 size, u32 type, u8 normalized, i32 stride, void* pointer);
        void glViewport(i32 x, i32 y, i32 width, i32 height);
    }
    bool gl_load_all_fns() { return true; }
}
