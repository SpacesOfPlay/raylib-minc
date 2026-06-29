

when os(windows) {
    extern "msvcrt.dll" {
        i32 isspace(i32 c);
        i32 ispunct(i32 c);
        i32 printf(u8* fmt, ...);
        i32 sprintf(u8* buf, u8* fmt, ...);
        i32 fprintf(void* stream, u8* fmt, ...);
        // i32 _snprintf(u8* buf, u64 size, u8* fmt, ...);
        i32 sscanf(u8* s, u8* fmt, ...);
        i64 clock();
        i32 strcmp(u8* a, u8* b);
        u64 strlen(u8* s);
        u8* strcpy(u8* dst, u8* src);
        u8* strncpy(u8* dst, u8* src, u64 n);
        u8* strchr(u8* s, i32 c);
        u8* strrchr(u8* s, i32 c);
        u8* strstr(u8* haystack, u8* needle);
        u8* strpbrk(u8* s, u8* accept);
        u8* strcat(u8* dst, u8* src);
        i32 puts(u8* s);
        i32 abs(i32 x);
        // fabs, sqrt: provided by the runtime.
        f64 floor(f64 x);
        f64 ceil(f64 x);
        f64 pow(f64 b, f64 e);
        f64 sin(f64 x);
        f64 cos(f64 x);
        f64 acos(f64 x);
        f64 asin(f64 x);
        f64 fmod(f64 x, f64 y);
        f64 tan(f64 x);
        f64 log(f64 x);
        f64 exp(f64 x);
        @must_use void* fopen(u8* path, u8* mode);
        i32 fclose(void* file);
        @must_use u8* fgets(u8* buf, i32 n, void* stream);
    }
    // C99 math (round/log2/f32 variants) is in UCRT, not msvcrt.
    extern "ucrtbase.dll" {
        f64 round(f64 x);
        f64 log2(f64 x);
        f32 sinf(f32 x);
        f32 cosf(f32 x);
        f32 tanf(f32 x);
        f32 asinf(f32 x);
        f32 acosf(f32 x);
        f32 atanf(f32 x);
        f32 atan2f(f32 y, f32 x);
        // sqrtf: provided by the runtime.
        f32 powf(f32 b, f32 e);
        f32 expf(f32 x);
        f32 logf(f32 x);
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
    // MSVC FP-usage sentinel.
    i32 _fltused = 0x9875;
    // POSIX errno — a process-wide slot (not thread-local).
    i32 errno = 0;
    // Win32 high-resolution timer. void* params so LARGE_INTEGER need
    // not be in scope; callers pass a pointer to their own.
    extern "kernel32.dll" {
        i32 QueryPerformanceFrequency(void* p);
        i32 QueryPerformanceCounter(void* p);
    }
    // u64 variant of the above.
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
}
when os(linux) || os(macos) || os(ios) {
    i32 rl_BitScanReverse_u64(u64* index, u32 mask) { *index = 0; return 0; }
}
when os(linux) {
    extern "libc.so.6" {
        i32 isspace(i32 c);
        i32 ispunct(i32 c);
        i32 printf(u8* fmt, ...);
        i32 sprintf(u8* buf, u8* fmt, ...);
        i32 fprintf(void* stream, u8* fmt, ...);
        i32 sscanf(u8* s, u8* fmt, ...);
        i64 clock();
        i32 strcmp(u8* a, u8* b);
        u64 strlen(u8* s);
        u8* strcpy(u8* dst, u8* src);
        u8* strncpy(u8* dst, u8* src, u64 n);
        u8* strchr(u8* s, i32 c);
        u8* strrchr(u8* s, i32 c);
        u8* strstr(u8* haystack, u8* needle);
        u8* strpbrk(u8* s, u8* accept);
        u8* strcat(u8* dst, u8* src);
        i32 puts(u8* s);
        i32 abs(i32 x);
        @must_use void* fopen(u8* path, u8* mode);
        i32 fclose(void* file);
        @must_use u8* fgets(u8* buf, i32 n, void* stream);
    }
    // glibc keeps the math functions in libm.so.6, not libc.so.6 — binding
    // them here is what pulls libm into DT_NEEDED so they resolve at runtime.
    extern "libm.so.6" {
        // fabs, sqrt, fabsf, sqrtf: provided by the runtime.
        f64 floor(f64 x);
        f64 ceil(f64 x);
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
        f64 fmin(f64 a, f64 b);
        f64 fmax(f64 a, f64 b);
        // f32 math
        f32 sinf(f32 x);
        f32 cosf(f32 x);
        f32 tanf(f32 x);
        f32 asinf(f32 x);
        f32 acosf(f32 x);
        f32 atanf(f32 x);
        f32 atan2f(f32 y, f32 x);
        f32 powf(f32 b, f32 e);
        f32 expf(f32 x);
        f32 logf(f32 x);
        f32 floorf(f32 x);
        f32 ceilf(f32 x);
        f32 roundf(f32 x);
        f32 truncf(f32 x);
        f32 fmodf(f32 a, f32 b);
        f32 fminf(f32 a, f32 b);
        f32 fmaxf(f32 a, f32 b);
    }
}
when os(android) {
    // Android Bionic
    extern "libc.so" {
        i32 isspace(i32 c);
        i32 ispunct(i32 c);
        i32 printf(u8* fmt, ...);
        i32 sprintf(u8* buf, u8* fmt, ...);
        i32 fprintf(void* stream, u8* fmt, ...);
        i32 sscanf(u8* s, u8* fmt, ...);
        i64 clock();
        i32 strcmp(u8* a, u8* b);
        u64 strlen(u8* s);
        u8* strcpy(u8* dst, u8* src);
        u8* strncpy(u8* dst, u8* src, u64 n);
        u8* strchr(u8* s, i32 c);
        u8* strrchr(u8* s, i32 c);
        u8* strstr(u8* haystack, u8* needle);
        u8* strpbrk(u8* s, u8* accept);
        u8* strcat(u8* dst, u8* src);
        i32 puts(u8* s);
        i32 abs(i32 x);
        @must_use void* fopen(u8* path, u8* mode);
        i32 fclose(void* file);
        @must_use u8* fgets(u8* buf, i32 n, void* stream);
    }
    extern "libm.so" {
        f64 floor(f64 x);
        f64 ceil(f64 x);
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
        f32 sinf(f32 x);
        f32 cosf(f32 x);
        f32 tanf(f32 x);
        f32 asinf(f32 x);
        f32 acosf(f32 x);
        f32 atanf(f32 x);
        f32 atan2f(f32 y, f32 x);
        f32 powf(f32 b, f32 e);
        f32 expf(f32 x);
        f32 logf(f32 x);
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
}
// Numeric constants. Values are stable across platforms.
const i32 MAX_PATH = 260;
const i32 S_IFMT = 0xF000;
const i32 S_IFREG = 0x8000;
const i32 S_IFDIR = 0x4000;

// Count leading zeros (32-bit). Returns 32 on 0.
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
        i32 isspace(i32 c);
        i32 ispunct(i32 c);
        i32 printf(u8* fmt, ...);
        i32 sprintf(u8* buf, u8* fmt, ...);
        i32 fprintf(void* stream, u8* fmt, ...);
        i32 sscanf(u8* s, u8* fmt, ...);
        i64 clock();
        i32 strcmp(u8* a, u8* b);
        u64 strlen(u8* s);
        u8* strcpy(u8* dst, u8* src);
        u8* strncpy(u8* dst, u8* src, u64 n);
        u8* strchr(u8* s, i32 c);
        u8* strrchr(u8* s, i32 c);
        u8* strstr(u8* haystack, u8* needle);
        u8* strpbrk(u8* s, u8* accept);
        u8* strcat(u8* dst, u8* src);
        i32 puts(u8* s);
        i32 abs(i32 x);
        // fabs, sqrt: provided by the runtime.
        f64 floor(f64 x);
        f64 ceil(f64 x);
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
        // sqrtf: provided by the runtime.
        f32 powf(f32 b, f32 e);
        f32 expf(f32 x);
        f32 logf(f32 x);
        // fabsf: provided by the runtime.
        f32 floorf(f32 x);
        f32 ceilf(f32 x);
        f32 roundf(f32 x);
        f32 truncf(f32 x);
        f32 fmodf(f32 a, f32 b);
        f32 fminf(f32 a, f32 b);
        f32 fmaxf(f32 a, f32 b);
        f64 fmin(f64 a, f64 b);
        f64 fmax(f64 a, f64 b);
        @must_use void* fopen(u8* path, u8* mode);
        i32 fclose(void* file);
        @must_use u8* fgets(u8* buf, i32 n, void* stream);
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

// assert(cond): aborts on failure. Param is i64; nonzero = true.
void assert(i64 cond) {
    if cond == 0 {
        eprint("assertion failed\n");
        exit(1);
    }
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
i32 stat(u8* path, stat* st) { return 0 - 1; }

// POSIX <time.h>: timespec + clock_gettime. The real libc fn on
// linux/macos; on Windows (no libc clock_gettime) a monotonic
// implementation backed by the high-resolution performance counter.
struct timespec { i64 tv_sec; i64 tv_nsec; }
when os(windows) {
    i32 clock_gettime(i32 clk_id, timespec* tp) {
        i64 ticks = 0;
        i64 freq = 0;
        QueryPerformanceCounter(cast(void*, &ticks));
        QueryPerformanceFrequency(cast(void*, &freq));
        if freq == 0 { tp.tv_sec = 0; tp.tv_nsec = 0; return 0; }
        tp.tv_sec = ticks / freq;
        tp.tv_nsec = (ticks % freq) * 1000000000 / freq;
        return 0;
    }
} else when os(linux) {
    extern "libc.so.6" i32 clock_gettime(i32 clk_id, void* tp);
} else when os(macos) || os(ios) {
    extern "libSystem.B.dylib" i32 clock_gettime(i32 clk_id, void* tp);
}

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
        i32 rename(u8* a, u8* b);
        i64 time(i64* t);
    }
}
when os(linux) {
    extern "libc.so.6" {
        u64 fread(void* p, u64 sz, u64 n, void* f);
        u64 fwrite(void* p, u64 sz, u64 n, void* f);
        i32 fseek(void* f, i64 off, i32 whence);
        i64 ftell(void* f);
        i32 feof(void* f);
        i32 rename(u8* a, u8* b);
        i64 time(i64* t);
    }
}
when os(macos) || os(ios) {
    extern "libSystem.B.dylib" {
        u64 fread(void* p, u64 sz, u64 n, void* f);
        u64 fwrite(void* p, u64 sz, u64 n, void* f);
        i32 fseek(void* f, i64 off, i32 whence);
        i64 ftell(void* f);
        i32 feof(void* f);
        i32 rename(u8* a, u8* b);
        i64 time(i64* t);
    }
}


// --- wasm target ---
// On wasm there is no system libc, so the libc subset is provided here
// (over the builtin allocator) or as host imports.
when os(wasm) {
    // Math is owned by the `math` module: it *defines* sinf/cosf/etc. on wasm,
    // so our own `extern "math"` for them would collide with a user's
    // `import math` (and with imgui, which imports this shim). Pull just the
    // transcendentals selectively — the listed names only, so `min`/`max` and
    // friends don't leak into consumers, and dedup'd against a user's full
    // `import math`.
    import { sin, cos, tan, asin, acos, atan, atan2, exp, log, pow, fmod, floor,
             ceil, round, sinf, cosf, tanf, asinf, acosf, atanf, atan2f, expf,
             logf, powf, fmodf, floorf, ceilf, roundf } from math;

    // --- allocator ---
    void* malloc(u64 size)            { return alloc(cast(i64, size)); }

    // --- strings ---
    u64 strlen(u8* s) { u64 n = 0; while *(s + n) != 0 { n = n + 1; } return n; }
    i32 strcmp(u8* a, u8* b) {
        while *a != 0 && *a == *b { a = a + 1; b = b + 1; }
        return cast(i32, *a) - cast(i32, *b);
    }
    u8* strcpy(u8* dst, u8* src) {
        u64 i = 0;
        while *(src + i) != 0 { *(dst + i) = *(src + i); i = i + 1; }
        *(dst + i) = 0;
        return dst;
    }
    u8* strncpy(u8* dst, u8* src, u64 n) {
        for u64 i = 0; i < n; i = i + 1 {
            *(dst + i) = *(src + i);
            if *(src + i) == 0 {
                for u64 j = i + 1; j < n; j = j + 1 { *(dst + j) = 0; }
                return dst;
            }
        }
        return dst;
    }
    u8* strcat(u8* dst, u8* src) {
        u64 d = strlen(dst); u64 i = 0;
        while *(src + i) != 0 { *(dst + d + i) = *(src + i); i = i + 1; }
        *(dst + d + i) = 0;
        return dst;
    }
    u8* strchr(u8* s, i32 c) {
        u8 ch = cast(u8, c);
        while *s != 0 { if *s == ch { return s; } s = s + 1; }
        if ch == 0 { return s; }
        return null;
    }
    u8* strrchr(u8* s, i32 c) {
        u8 ch = cast(u8, c); u8* last = null;
        while *s != 0 { if *s == ch { last = s; } s = s + 1; }
        if ch == 0 { return s; }
        return last;
    }
    u8* strstr(u8* hay, u8* needle) {
        if *needle == 0 { return hay; }
        while *hay != 0 {
            u8* h = hay; u8* n = needle;
            while *h != 0 && *h == *n { h = h + 1; n = n + 1; }
            if *n == 0 { return hay; }
            hay = hay + 1;
        }
        return null;
    }
    u8* strpbrk(u8* s, u8* set) {
        while *s != 0 {
            u8* p = set;
            while *p != 0 { if *p == *s { return s; } p = p + 1; }
            s = s + 1;
        }
        return null;
    }
    i32 isspace(i32 c) { if c == 32 || (c >= 9 && c <= 13) { return 1; } return 0; }
    i32 ispunct(i32 c) {
        if (c >= 33 && c <= 47) || (c >= 58 && c <= 64) ||
           (c >= 91 && c <= 96) || (c >= 123 && c <= 126) { return 1; }
        return 0;
    }

    // --- time ---
    // Host monotonic clock in nanoseconds.
    extern "env" i64 clock();
    i32 clock_gettime(i32 clk_id, void* tp) {
        i64 ns = clock();
        i64* p = cast(i64*, tp);
        *p = ns / 1000000000;
        *(p + 1) = ns % 1000000000;
        return 0;
    }
    // No blocking sleep in the browser; nanosleep is a no-op.
    i32 nanosleep(void* req, void* rem) { ignore req; ignore rem; return 0; }
    i64 time(i64* t) {
        i64 s = clock() / 1000000000;
        if t != null { *t = s; }
        return s;
    }

    // --- stdio (console) ---
    // puts writes the string + a newline to stdout (fd 1).
    i32 puts(u8* s) {
        write(1, s, cast(i32, strlen(s)));
        u8 nl = 10;
        write(1, &nl, 1);
        return 0;
    }

    // --- stdlib numerics ---
    i32 abs(i32 x) { if x < 0 { return -x; } return x; }

    // sin/cos/tan/asin/acos/atan/atan2/exp/log/pow/fmod/floor/ceil (f32+f64)
    // come from the selective `import ... from math` at the top of this arm.
    // fmin/fmax families (not in the math module).
    f32 fminf(f32 a, f32 b) { if a < b { return a; } return b; }
    f32 fmaxf(f32 a, f32 b) { if a > b { return a; } return b; }
    f64 fmin(f64 a, f64 b) { if a < b { return a; } return b; }
    f64 fmax(f64 a, f64 b) { if a > b { return a; } return b; }
    // round/roundf come from the selective `import ... from math` (above).
    // truncate toward zero; |x| >= 2^23 (f32) / 2^52 (f64) is already
    // integral, so passing through avoids the i64-cast overflow + NaN.
    f32 truncf(f32 x) {
        if x != x { return x; }
        if x >= 8388608.0f || x <= -8388608.0f { return x; }
        return cast(f32, cast(i32, x));
    }

    // --- buffered file I/O over the host VFS ---
    // The host serves assets through env.open/read/close. A FILE* is a
    // small struct backed by the whole file read into memory on open;
    // seek/tell operate on that buffer. Read-only; writes are no-ops.
    struct __rl_file { u8* data; i64 size; i64 pos; }

    void* fopen(u8* path, u8* mode) {
        ignore mode;
        i64 fd = open(path, 0);
        if fd < 0 { return null; }
        i64 cap = 4096;
        u8* buf = cast(u8*, alloc(cap));
        i64 total = 0;
        while true {
            if total == cap {
                i64 ncap = cap * 2;
                u8* nb = cast(u8*, alloc(ncap));
                memcpy(cast(void*, nb), cast(void*, buf), cast(u64, total));
                free(cast(void*, buf));
                buf = nb;
                cap = ncap;
            }
            i32 n = read(fd, cast(void*, buf + total), cast(i32, cap - total));
            if n <= 0 { break; }
            total = total + cast(i64, n);
        }
        close(fd);
        __rl_file* f = new(__rl_file);
        f.data = buf;
        f.size = total;
        f.pos = 0;
        return cast(void*, f);
    }
    i32 fclose(void* stream) {
        if stream == null { return 0; }
        __rl_file* f = cast(__rl_file*, stream);
        free(cast(void*, f.data));
        free(stream);
        return 0;
    }
    u64 fread(void* p, u64 sz, u64 n, void* stream) {
        if stream == null || sz == 0 { return 0; }
        __rl_file* f = cast(__rl_file*, stream);
        i64 want = cast(i64, sz * n);
        i64 avail = f.size - f.pos;
        if want > avail { want = avail; }
        if want <= 0 { return 0; }
        memcpy(p, cast(void*, f.data + f.pos), cast(u64, want));
        f.pos = f.pos + want;
        return cast(u64, want) / sz;
    }
    u64 fwrite(void* p, u64 sz, u64 n, void* f) { ignore p; ignore sz; ignore n; ignore f; return 0; }
    i32 fseek(void* stream, i64 off, i32 whence) {
        if stream == null { return 0 - 1; }
        __rl_file* f = cast(__rl_file*, stream);
        if whence == 0 { f.pos = off; }                  // SEEK_SET
        else if whence == 1 { f.pos = f.pos + off; }     // SEEK_CUR
        else if whence == 2 { f.pos = f.size + off; }    // SEEK_END
        return 0;
    }
    i64 ftell(void* stream) {
        if stream == null { return 0 - 1; }
        __rl_file* f = cast(__rl_file*, stream);
        return f.pos;
    }
    i32 feof(void* stream) {
        if stream == null { return 1; }
        __rl_file* f = cast(__rl_file*, stream);
        if f.pos >= f.size { return 1; }
        return 0;
    }
    u8* fgets(u8* buf, i32 n, void* stream) {
        if stream == null || n <= 0 { return null; }
        __rl_file* f = cast(__rl_file*, stream);
        if f.pos >= f.size { return null; }
        i32 i = 0;
        while i < n - 1 && f.pos < f.size {
            u8 c = *(f.data + f.pos);
            f.pos = f.pos + 1;
            *(buf + i) = c;
            i = i + 1;
            if c == 10 { break; }
        }
        *(buf + i) = 0;
        return buf;
    }
    i32 rename(u8* a, u8* b) { ignore a; ignore b; return 0 - 1; }
}
