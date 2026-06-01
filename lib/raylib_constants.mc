// Imports added on export so this module resolves standalone (LSP).
import raylib_lib;

// raylib_constants.mc — named colors + math constants.
// raylib.h defines these as object-like macros; the transpile
// expands them inline, so they are re-surfaced here as real
// minc constants for user code. Imported by raylib.mc.
// Colors generated from raylib.h at publish time.

// --- raylib named-color constants ---
const Color LIGHTGRAY = Color{ 200, 200, 200, 255 };
const Color GRAY = Color{ 130, 130, 130, 255 };
const Color DARKGRAY = Color{ 80, 80, 80, 255 };
const Color YELLOW = Color{ 253, 249, 0, 255 };
const Color GOLD = Color{ 255, 203, 0, 255 };
const Color ORANGE = Color{ 255, 161, 0, 255 };
const Color PINK = Color{ 255, 109, 194, 255 };
const Color RED = Color{ 230, 41, 55, 255 };
const Color MAROON = Color{ 190, 33, 55, 255 };
const Color GREEN = Color{ 0, 228, 48, 255 };
const Color LIME = Color{ 0, 158, 47, 255 };
const Color DARKGREEN = Color{ 0, 117, 44, 255 };
const Color SKYBLUE = Color{ 102, 191, 255, 255 };
const Color BLUE = Color{ 0, 121, 241, 255 };
const Color DARKBLUE = Color{ 0, 82, 172, 255 };
const Color PURPLE = Color{ 200, 122, 255, 255 };
const Color VIOLET = Color{ 135, 60, 190, 255 };
const Color DARKPURPLE = Color{ 112, 31, 126, 255 };
const Color BEIGE = Color{ 211, 176, 131, 255 };
const Color BROWN = Color{ 127, 106, 79, 255 };
const Color DARKBROWN = Color{ 76, 63, 47, 255 };
const Color WHITE = Color{ 255, 255, 255, 255 };
const Color BLACK = Color{ 0, 0, 0, 255 };
const Color BLANK = Color{ 0, 0, 0, 0 };
const Color MAGENTA = Color{ 255, 0, 255, 255 };
const Color RAYWHITE = Color{ 245, 245, 245, 255 };

// --- raylib math constants ---
const f32 PI = 3.14159265358979323846f;
const f32 DEG2RAD = 3.14159265358979323846f / 180.0f;
const f32 RAD2DEG = 180.0f / 3.14159265358979323846f;
