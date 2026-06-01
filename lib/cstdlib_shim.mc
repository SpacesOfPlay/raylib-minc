// cstdlib_shim.mc - extern declarations for the libc surface
// (<stdio.h>/<ctype.h>/<math.h>/<string.h>/<stdlib.h>). Per-OS extern
// blocks point at the system C runtime (msvcrt + ucrtbase on Windows,
// libc.so.6 on Linux, libSystem.B.dylib on macOS).

when os(windows) {
    extern "msvcrt.dll" {
        i32 tolower(i32 c);
        i32 toupper(i32 c);
        i32 isalpha(i32 c);
        i32 isdigit(i32 c);
        i32 isspace(i32 c);
        i32 ispunct(i32 c);
        i32 isalnum(i32 c);
        i32 printf(u8* fmt, ...);
        i32 sprintf(u8* buf, u8* fmt, ...);
        i32 sscanf(u8* s, u8* fmt, ...);
        i32 strcmp(u8* a, u8* b);
        i32 strncmp(u8* a, u8* b, u64 n);
        i32 memcmp(void* a, void* b, u64 n);
        void* memchr(void* s, i32 c, u64 n);
        u64 strlen(u8* s);
        u8* strcpy(u8* dst, u8* src);
        u8* strncpy(u8* dst, u8* src, u64 n);
        i32 strncpy_s(u8* dst, i32 dst_size, u8* src, i32 count);
        u8* strchr(u8* s, i32 c);
        u8* strrchr(u8* s, i32 c);
        u8* strstr(u8* haystack, u8* needle);
        u8* strpbrk(u8* s, u8* accept);
        u8* strcat(u8* dst, u8* src);
        i32 puts(u8* s);
        i32 atoi(u8* s);
        i32 abs(i32 x);
        void srand(u32 seed);
        i32 rand();
        f64 atof(u8* s);
        f64 strtod(u8* s, u8** endptr);
        i64 strtol(u8* s, u8** endptr, i32 base);
        u64 strtoul(u8* s, u8** endptr, i32 base);
        f64 fabs(f64 x);
        f64 floor(f64 x);
        f64 ceil(f64 x);
        f64 sqrt(f64 x);
        f64 pow(f64 b, f64 e);
        f64 sin(f64 x);
        f64 cos(f64 x);
        f64 acos(f64 x);
        f64 asin(f64 x);
        f64 fmod(f64 x, f64 y);
        f64 tan(f64 x);
        f64 log(f64 x);
        f64 exp(f64 x);
        @must_use void* malloc(u64 size);
        void free(void* ptr);
        @must_use void* realloc(void* ptr, u64 size);
        @must_use void* calloc(u64 nmemb, u64 size);
        // MSVC's aligned-alloc pair. picotls compose mode reaches for
        // these in its `when os(windows)` arm; the POSIX path uses
        // posix_memalign + free instead. Only declared on Windows.
        @must_use void* _aligned_malloc(u64 size, u64 alignment);
        void _aligned_free(void* ptr);
        void abort();
        @must_use void* fopen(u8* path, u8* mode);
        i32 fclose(void* file);
        @must_use u8* fgets(u8* buf, i32 n, void* stream);
    }
    // C99 math (round/log2/f32 variants): UCRT, not legacy msvcrt.dll.
    extern "ucrtbase.dll" {
        i32 _isnan(f64 x);
        i32 _finite(f64 x);
        f64 round(f64 x);
        f64 log2(f64 x);
        f32 sinf(f32 x);
        f32 cosf(f32 x);
        f32 tanf(f32 x);
        f32 asinf(f32 x);
        f32 acosf(f32 x);
        f32 atanf(f32 x);
        f32 atan2f(f32 y, f32 x);
        f32 sqrtf(f32 x);
        f32 powf(f32 b, f32 e);
        f32 expf(f32 x);
        f32 logf(f32 x);
        f32 fabsf(f32 x);
        f32 floorf(f32 x);
        f32 ceilf(f32 x);
        f32 roundf(f32 x);
        f32 truncf(f32 x);
        f32 fmodf(f32 a, f32 b);
        f32 fminf(f32 a, f32 b);
        f32 fmaxf(f32 a, f32 b);
        f64 fmin(f64 a, f64 b);
        f64 fmax(f64 a, f64 b);
    }
    // isnan / isinf aliases over msvcrt's _isnan / _finite.
    bool isnan(f64 x) { return _isnan(x) != 0; }
    bool isinf(f64 x) { return _finite(x) == 0 && _isnan(x) == 0; }
    // MSVC intrinsic (not a DLL export): writes the index of the highest
    // set bit to *index; returns 0 if mask is 0.
    i32 _BitScanReverse(u32* index, u32 mask) {
        if mask == 0 { return 0; }
        i32 i = 31;
        while i >= 0 {
            if ((mask >> cast(u32, i)) & cast(u32, 1)) != 0 {
                *index = cast(u32, i);
                return 1;
            }
            i = i - 1;
        }
        return 0;
    }
    // Compose-mode overload: `unsigned long` in compose widens to u64,
    // so the bsr index slot is a u64*. Same scan, wider output type.
    i32 rl_BitScanReverse_u64(u64* index, u32 mask) {
        if mask == 0 { return 0; }
        i32 i = 31;
        while i >= 0 {
            if ((mask >> cast(u32, i)) & cast(u32, 1)) != 0 {
                *index = cast(u64, i);
                return 1;
            }
            i = i - 1;
        }
        return 0;
    }
    // POSIX stubs for compose-mode parse — actual calls live in
    // cfile_shim.mc's Linux/macOS arms; the dead Linux branch's
    // symbol lookup still has to resolve on Windows builds.
    i32 access(u8* path, i32 mode) { return 0 - 1; }
    u8* getcwd(u8* buf, u64 size) { return null; }
    i32 chdir(u8* path) { return 0 - 1; }
    i32 mkdir(u8* path, u32 mode) { return 0 - 1; }
    i64 readlink(u8* path, u8* buf, u64 bufsiz) { return 0 - 1; }
}
// Compose wrappers — declared universally so the dead Windows arm
// inside `when os(windows)` blocks still has a symbol on non-Windows
// builds. Body stubs on Linux/macOS; the Windows narrowing wrapper
// for Sleep lives in cfile_shim.mc (Sleep is declared there).
when os(linux) || os(macos) || os(ios) {
    i32 rl_BitScanReverse_u64(u64* index, u32 mask) { *index = 0; return 0; }
}
when os(linux) {
    extern "libc.so.6" {
        i32 tolower(i32 c);
        i32 toupper(i32 c);
        i32 isalpha(i32 c);
        i32 isdigit(i32 c);
        i32 isspace(i32 c);
        i32 ispunct(i32 c);
        i32 isalnum(i32 c);
        i32 printf(u8* fmt, ...);
        i32 sprintf(u8* buf, u8* fmt, ...);
        i32 sscanf(u8* s, u8* fmt, ...);
        i32 strcmp(u8* a, u8* b);
        i32 strncmp(u8* a, u8* b, u64 n);
        i32 memcmp(void* a, void* b, u64 n);
        void* memchr(void* s, i32 c, u64 n);
        u64 strlen(u8* s);
        u8* strcpy(u8* dst, u8* src);
        u8* strncpy(u8* dst, u8* src, u64 n);
        i32 strncpy_s(u8* dst, i32 dst_size, u8* src, i32 count);
        u8* strchr(u8* s, i32 c);
        u8* strrchr(u8* s, i32 c);
        u8* strstr(u8* haystack, u8* needle);
        u8* strpbrk(u8* s, u8* accept);
        u8* strcat(u8* dst, u8* src);
        i32 puts(u8* s);
        i32 atoi(u8* s);
        i32 abs(i32 x);
        void srand(u32 seed);
        i32 rand();
        f64 atof(u8* s);
        f64 strtod(u8* s, u8** endptr);
        i64 strtol(u8* s, u8** endptr, i32 base);
        u64 strtoul(u8* s, u8** endptr, i32 base);
        f64 fabs(f64 x);
        f64 floor(f64 x);
        f64 ceil(f64 x);
        f64 sqrt(f64 x);
        f64 pow(f64 b, f64 e);
        f64 sin(f64 x);
        f64 cos(f64 x);
        f64 acos(f64 x);
        f64 asin(f64 x);
        f64 fmod(f64 x, f64 y);
        f64 tan(f64 x);
        f64 log(f64 x);
        f64 exp(f64 x);
        f64 log2(f64 x);
        f64 round(f64 x);
        // f32 math
        f32 sinf(f32 x);
        f32 cosf(f32 x);
        f32 tanf(f32 x);
        f32 asinf(f32 x);
        f32 acosf(f32 x);
        f32 atanf(f32 x);
        f32 atan2f(f32 y, f32 x);
        f32 sqrtf(f32 x);
        f32 powf(f32 b, f32 e);
        f32 expf(f32 x);
        f32 logf(f32 x);
        f32 fabsf(f32 x);
        f32 floorf(f32 x);
        f32 ceilf(f32 x);
        f32 roundf(f32 x);
        f32 truncf(f32 x);
        f32 fmodf(f32 a, f32 b);
        f32 fminf(f32 a, f32 b);
        f32 fmaxf(f32 a, f32 b);
        f64 fmin(f64 a, f64 b);
        f64 fmax(f64 a, f64 b);
        @must_use void* malloc(u64 size);
        void free(void* ptr);
        @must_use void* realloc(void* ptr, u64 size);
        @must_use void* calloc(u64 nmemb, u64 size);
        void abort();
        @must_use void* fopen(u8* path, u8* mode);
        i32 fclose(void* file);
        @must_use u8* fgets(u8* buf, i32 n, void* stream);
        void* memmove(void* dst, void* src, u64 n);
        i32 posix_memalign(void** memptr, i32 alignment, u64 size);
    }
    extern "libm.so.6" {
        i32 isnan(f64 x);
        i32 isinf(f64 x);
    }
}
// Universal numeric constants for compose-mode parse — Windows
// `<windows.h>` and POSIX `<sys/stat.h>` aren't expanded; the
// raylib body references these directly. Values are stable
// across platforms / kernels.
const i32 MAX_PATH = 260;
const i32 S_IFMT = 0xF000;
const i32 S_IFREG = 0x8000;
const i32 S_IFDIR = 0x4000;

// GCC/Clang __builtin_clz / __builtin_clzl, minc-native.
// Universal — compose-mode raylib references __builtin_clzl from
// the GCC arm of sinfl.h on every platform.
// Count leading zeros (32-bit). Returns 32 on 0 (GCC's is UB there).
i32 __builtin_clz(u32 x) {
    if x == 0 { return 32; }
    i32 n = 0;
    while (x & (cast(u32, 1) << 31)) == 0 {
        n = n + 1;
        x = x << 1;
    }
    return n;
}
// Count leading zeros (64-bit).
i32 __builtin_clzl(u64 x) {
    if x == 0 { return 64; }
    i32 n = 0;
    while (x & (cast(u64, 1) << 63)) == 0 {
        n = n + 1;
        x = x << 1;
    }
    return n;
}
when os(macos) || os(ios) {
    // On macOS, libSystem.B.dylib provides both libc and libm.
    extern "libSystem.B.dylib" {
        i32 tolower(i32 c);
        i32 toupper(i32 c);
        i32 isalpha(i32 c);
        i32 isdigit(i32 c);
        i32 isspace(i32 c);
        i32 ispunct(i32 c);
        i32 isalnum(i32 c);
        i32 printf(u8* fmt, ...);
        i32 sprintf(u8* buf, u8* fmt, ...);
        i32 sscanf(u8* s, u8* fmt, ...);
        i32 strcmp(u8* a, u8* b);
        i32 strncmp(u8* a, u8* b, u64 n);
        i32 memcmp(void* a, void* b, u64 n);
        void* memchr(void* s, i32 c, u64 n);
        u64 strlen(u8* s);
        u8* strcpy(u8* dst, u8* src);
        u8* strncpy(u8* dst, u8* src, u64 n);
        i32 strncpy_s(u8* dst, i32 dst_size, u8* src, i32 count);
        u8* strchr(u8* s, i32 c);
        u8* strrchr(u8* s, i32 c);
        u8* strstr(u8* haystack, u8* needle);
        u8* strpbrk(u8* s, u8* accept);
        u8* strcat(u8* dst, u8* src);
        i32 puts(u8* s);
        i32 atoi(u8* s);
        i32 abs(i32 x);
        void srand(u32 seed);
        i32 rand();
        f64 atof(u8* s);
        f64 strtod(u8* s, u8** endptr);
        i64 strtol(u8* s, u8** endptr, i32 base);
        u64 strtoul(u8* s, u8** endptr, i32 base);
        f64 fabs(f64 x);
        f64 floor(f64 x);
        f64 ceil(f64 x);
        f64 sqrt(f64 x);
        f64 pow(f64 b, f64 e);
        f64 sin(f64 x);
        f64 cos(f64 x);
        f64 acos(f64 x);
        f64 asin(f64 x);
        f64 fmod(f64 x, f64 y);
        f64 tan(f64 x);
        f64 log(f64 x);
        f64 exp(f64 x);
        f64 log2(f64 x);
        f64 round(f64 x);
        // f32 math
        f32 sinf(f32 x);
        f32 cosf(f32 x);
        f32 tanf(f32 x);
        f32 asinf(f32 x);
        f32 acosf(f32 x);
        f32 atanf(f32 x);
        f32 atan2f(f32 y, f32 x);
        f32 sqrtf(f32 x);
        f32 powf(f32 b, f32 e);
        f32 expf(f32 x);
        f32 logf(f32 x);
        f32 fabsf(f32 x);
        f32 floorf(f32 x);
        f32 ceilf(f32 x);
        f32 roundf(f32 x);
        f32 truncf(f32 x);
        f32 fmodf(f32 a, f32 b);
        f32 fminf(f32 a, f32 b);
        f32 fmaxf(f32 a, f32 b);
        f64 fmin(f64 a, f64 b);
        f64 fmax(f64 a, f64 b);
        @must_use void* malloc(u64 size);
        void free(void* ptr);
        @must_use void* realloc(void* ptr, u64 size);
        @must_use void* calloc(u64 nmemb, u64 size);
        void abort();
        @must_use void* fopen(u8* path, u8* mode);
        i32 fclose(void* file);
        @must_use u8* fgets(u8* buf, i32 n, void* stream);
        i32 isnan(f64 x);
        i32 isinf(f64 x);
        void* memmove(void* dst, void* src, u64 n);
        i32 posix_memalign(void** memptr, i32 alignment, u64 size);
    }
}

// <float.h> limits + <stdlib.h> RAND_MAX, as constants.
const i32 RAND_MAX = 32767;

const f32 FLT_MAX = 3.40282347e38f;
const f32 FLT_MIN = 1.17549435e-38f;
const f32 FLT_EPSILON = 1.19209290e-7f;
const f64 DBL_MAX = 1.7976931348623157e308;
const f64 DBL_MIN = 2.2250738585072014e-308;
const f64 DBL_EPSILON = 2.2204460492503131e-16;

// <math.h> NAN / INFINITY as f32 constants.
const f32 NAN = 0.0f / 0.0f;
const f32 INFINITY = 1.0f / 0.0f;

// assert(cond): aborts on failure. Param is i64 (not bool) so transpiled
// C ints/pointers pass without a bool conversion (nonzero = true).
void assert(i64 cond) {
    if cond == 0 {
        eprint("assertion failed\n");
        exit(1);
    }
}

// GCC/clang count-trailing-zeros intrinsic, minc-native.
i32 __builtin_ctzl(u64 x) {
    if x == 0 { return 64; }
    i32 c = 0;
    while (x & cast(u64, 1)) == 0 {
        x = x >> cast(u64, 1);
        c = c + 1;
    }
    return c;
}

// GCC/clang byte-swap intrinsics, minc-native (open-coded shifts).
u32 __builtin_bswap32(u32 x) {
    return ((x & cast(u32, 255)) << 24)
         | ((x & cast(u32, 65280)) << 8)
         | ((x & cast(u32, 16711680)) >> 8)
         | ((x & cast(u32, 4278190080)) >> 24);
}
u64 __builtin_bswap64(u64 x) {
    u64 lo = cast(u64, __builtin_bswap32(cast(u32, x & cast(u64, 4294967295))));
    u64 hi = cast(u64, __builtin_bswap32(cast(u32, x >> 32)));
    return (lo << 32) | hi;
}
u16 __builtin_bswap16(u16 x) {
    return cast(u16, ((cast(i32, x) & 255) << 8) | ((cast(i32, x) & 65280) >> 8));
}

// <time.h> / <sys/stat.h> / <utime.h> placeholder types + stubs — not
// bound to platform libc. Bind mktime/localtime/stat/utime if needed.
// struct tm is the standard 9-int layout.
struct tm {
    i32 tm_sec;
    i32 tm_min;
    i32 tm_hour;
    i32 tm_mday;
    i32 tm_mon;
    i32 tm_year;
    i32 tm_wday;
    i32 tm_yday;
    i32 tm_isdst;
}
struct stat {
    i64 st_dev;
    i64 st_ino;
    i32 st_mode;
    i32 st_nlink;
    i32 st_uid;
    i32 st_gid;
    i64 st_rdev;
    i64 st_size;
    i64 st_atime;
    i64 st_mtime;
    i64 st_ctime;
}
struct utimbuf {
    i64 actime;
    i64 modtime;
}

i64 mktime(tm* t) { return 0; }
tm* localtime(i64* t) { return null; }
i32 stat(u8* path, stat* st) { return 0 - 1; }
i32 utime(u8* path, utimbuf* t) { return 0 - 1; }

// POSIX `<time.h>` surface — sokol's non-apple/win timing path calls
// `clock_gettime(CLOCK_MONOTONIC, &ts)` and reads tv_sec/tv_nsec. Lives
// in the universal cstdlib shim (rather than the Linux-only x11glx
// shim) so compose-mode targets that PARSE the Linux arm — Windows is
// the visible one — see the type at module scope. minc parses every
// when-arm regardless of --target, only the matching arm type-checks.
struct timespec { i64 tv_sec; i64 tv_nsec; }
i32 clock_gettime(i32 clk_id, timespec* tp) { return 0; }

// <stdio.h> file I/O. SEEK_* are the standard ANSI values.
const i32 SEEK_SET = 0;
const i32 SEEK_CUR = 1;
const i32 SEEK_END = 2;
when os(windows) {
    extern "msvcrt.dll" {
        u64 fread(void* p, u64 sz, u64 n, void* f);
        u64 fwrite(void* p, u64 sz, u64 n, void* f);
        i32 fseek(void* f, i64 off, i32 whence);
        i64 ftell(void* f);
        i32 feof(void* f);
        i32 ferror(void* f);
        i32 fflush(void* f);
        void rewind(void* f);
        i32 remove(u8* path);
        i32 rename(u8* a, u8* b);
        @must_use void* freopen(u8* path, u8* mode, void* stream);
        i64 time(i64* t);
    }
    // POSIX large-file names (msvcrt has _ftelli64/_fseeki64); stubs.
    i64 ftello(void* f) { return 0; }
    i32 fseeko(void* f, i64 off, i32 whence) { return 0; }
}
when os(linux) {
    extern "libc.so.6" {
        u64 fread(void* p, u64 sz, u64 n, void* f);
        u64 fwrite(void* p, u64 sz, u64 n, void* f);
        i32 fseek(void* f, i64 off, i32 whence);
        i64 ftell(void* f);
        i64 ftello(void* f);
        i32 fseeko(void* f, i64 off, i32 whence);
        i32 feof(void* f);
        i32 ferror(void* f);
        i32 fflush(void* f);
        void rewind(void* f);
        i32 remove(u8* path);
        i32 rename(u8* a, u8* b);
        @must_use void* freopen(u8* path, u8* mode, void* stream);
        i64 time(i64* t);
    }
}
when os(macos) || os(ios) {
    extern "libSystem.B.dylib" {
        u64 fread(void* p, u64 sz, u64 n, void* f);
        u64 fwrite(void* p, u64 sz, u64 n, void* f);
        i32 fseek(void* f, i64 off, i32 whence);
        i64 ftell(void* f);
        i64 ftello(void* f);
        i32 fseeko(void* f, i64 off, i32 whence);
        i32 feof(void* f);
        i32 ferror(void* f);
        i32 fflush(void* f);
        void rewind(void* f);
        i32 remove(u8* path);
        i32 rename(u8* a, u8* b);
        @must_use void* freopen(u8* path, u8* mode, void* stream);
        i64 time(i64* t);
    }
}


// --- runtime helpers ---
// __wide_literal(s) — widen a narrow string to a u16* buffer for L"…"
// literals. Allocates per call; lifetime is owned by the program.
u16* __wide_literal(u8* s) {
    if s == null { return null; }
    i32 n = 0;
    while *(s + n) != 0 { n = n + 1; }
    u16* buf = alloc<u16>(n + 1);
    for i32 i = 0; i < n; i = i + 1 {
        *(buf + i) = cast(u16, *(s + i));
    }
    *(buf + n) = 0;
    return buf;
}
