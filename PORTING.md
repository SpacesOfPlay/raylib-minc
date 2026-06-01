# Porting C raylib code to minc raylib

The raylib API is identical — same names, structs, constants.
Only the host language changes. Most raylib C examples translate
line-for-line; the deltas below cover what's different.

## Type names

| C                | minc       | Note |
|------------------|------------|------|
| `int`            | `i32`      |  |
| `unsigned int`   | `u32`      |  |
| `long`           | `i64` (LP64) / `i32` (Windows) | Be explicit. Prefer `i32`/`i64`. |
| `unsigned`/`size_t` | `u64` for indexes, `u32` for counts |  |
| `char`           | `u8`       | C strings are `u8*`. |
| `float`          | `f32`      |  |
| `double`         | `f64`      |  |
| `bool`           | `bool`     | minc's `bool` is a first-class type. |

raylib types (`Color`, `Vector2`, `Texture2D`, …) keep their
exact names.

## Struct literals

C compound literals:

```c
DrawRectangle(40, 60, 200, 120, (Color){ 0, 121, 241, 255 });
```

minc struct literals (drop the `(T)` prefix):

```mc
DrawRectangle(40, 60, 200, 120, Color{ 0, 121, 241, 255 });
```

Named-field form also works: `Color{ .r = 0, .g = 121, .b = 241, .a = 255 }`.

## Null

C's `NULL` (or bare `0` for pointers) becomes `null`:

```c
SetWindowIcon((Image){ 0 });            // C
```
```mc
SetWindowIcon(Image{});                  // minc — zero-init via empty literal
```

For pointer compares: `if (ptr == null)`, not `if (ptr == NULL)`.

## Loops and conditions

Booleans don't auto-convert from int:

```c
if (count) { ... }              // C
```
```mc
if count != 0 { ... }           // minc
```

Parens around the condition are optional; braces are required.

## No preprocessor

minc has no `#include`, no `#define`, no `#ifdef`. Replacements:

| C                   | minc                                  |
|---------------------|---------------------------------------|
| `#include <stdio.h>` | nothing — the shims are already linked |
| `#define MAX 100`   | `const i32 MAX = 100;`                |
| `#ifdef WIN32 …`    | `when os(windows) { … }`              |
| `#define WHITE_HEX 0xFFFFFFFF` | `const u32 WHITE_HEX = 0xFFFFFFFF;` |

## Strings

raylib takes `u8*` (C strings). Literals coerce to `u8*`:

```mc
DrawText("hello", 40, 40, 20, BLACK);
```

For computed strings, `TextFormat` returns `u8*`:

```mc
DrawText(TextFormat("%d fps", GetFPS()), 40, 60, 20, GRAY);
```

minc's `str` / `string` types don't coerce — pass `.data` when
calling into raylib.

## Casts

Implicit narrowing is an error. Widening is fine; narrowing or
mixed-type math needs `cast(T, x)`.

```c
float angle = i * 0.5f;          // C
```
```mc
f32 angle = cast(f32, i) * 0.5f; // minc
```

## Color constants

`RAYWHITE`, `BLACK`, etc. are const globals — same names as the
C `#define`s.

```mc
ClearBackground(RAYWHITE);
DrawText("hi", 10, 10, 20, BLACK);
```

## What doesn't translate

- **File I/O** — use raylib's `LoadFileData` / `SaveFileData`. Raw
  stdio is partially shimmed but not recommended.
- **`printf %lld`/`%hhd`** — supported via `lib/cvararg_shim.mc`.
- **`memcpy`/`memset`/`malloc`** — provided by `lib/cstdlib_shim.mc`.

## See also

- https://minc.dev/
- https://minc.dev/docs/
- https://github.com/SpacesOfPlay/minc-dev/releases
