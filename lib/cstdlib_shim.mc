// libc subset: <stdio.h>/<ctype.h>/<math.h>/<string.h>/<stdlib.h>, per OS.
//
// math, ctype, str*/mem*, qsort, rand and the number parsers come from
// the math module, which implements them in minc. Results are identical
// on every target.
//
import math;

when os(windows) {
    extern "msvcrt.dll" {
        // i32 _snprintf(u8* buf, u64 size, u8* fmt, ...);
        i32 sscanf(u8* s, u8* fmt, ...);
        i64 clock();
        i32 puts(u8* s);
        @must_use void* fopen(u8* path, u8* mode);
        i32 fclose(void* file);
        @must_use u8* fgets(u8* buf, i32 n, void* stream);
    }
    // MSVC FP-usage sentinel.
    i32 _fltused = 0x9875;
    // POSIX errno; a process-wide slot (not thread-local).
    i32 errno = 0;
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
when os(linux) {
    extern "libc.so.6" {
        i32 sscanf(u8* s, u8* fmt, ...);
        i64 clock();
        i32 puts(u8* s);
        // malloc, calloc, realloc, free: provided by the runtime allocator.
        @must_use void* fopen(u8* path, u8* mode);
        i32 fclose(void* file);
        @must_use u8* fgets(u8* buf, i32 n, void* stream);
    }
}
when os(android) {
    // Android Bionic
    extern "libc.so" {
        i32 sscanf(u8* s, u8* fmt, ...);
        i64 clock();
        i32 puts(u8* s);
        @must_use void* fopen(u8* path, u8* mode);
        i32 fclose(void* file);
        @must_use u8* fgets(u8* buf, i32 n, void* stream);
    }
}
// Numeric constants. Values are stable across platforms.
const i32 MAX_PATH = 260;
const i32 S_IFMT = 0xF000;
const i32 S_IFREG = 0x8000;
const i32 S_IFDIR = 0x4000;

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
        i32 sscanf(u8* s, u8* fmt, ...);
        i64 clock();
        i32 puts(u8* s);
        // fabs, sqrt, fabsf, sqrtf: provided by the runtime.
        // malloc, calloc, realloc, free: provided by the runtime allocator.
        @must_use void* fopen(u8* path, u8* mode);
        i32 fclose(void* file);
        @must_use u8* fgets(u8* buf, i32 n, void* stream);
    }
}

// <float.h> limits + <stdlib.h> RAND_MAX, as constants.
// rand() comes from the math module and RAND_MAX is 2^31-1.
const i32 RAND_MAX = 0x7FFFFFFF;

const f32 FLT_MAX = 3.40282347e38f;
const f32 FLT_MIN = 1.17549435e-38f;
const f32 FLT_EPSILON = 1.19209290e-7f;
const f64 DBL_MAX = 1.7976931348623157e308;
const f64 DBL_MIN = 2.2250738585072014e-308;
const f64 DBL_EPSILON = 2.2204460492503131e-16;

// <math.h> NAN / INFINITY as f32 constants.
const f32 NAN = 0.0f / 0.0f;
const f32 INFINITY = 1.0f / 0.0f;

// isnan / isinf / isfinite and copysign / ldexp / frexp / hypot come
// from the math module, as f32 and f64 overloads.

// assert(cond): aborts on failure. Param is i64; nonzero = true.
void assert(i64 cond) {
    if cond == 0 {
        eprint("assertion failed\n");
        exit(1);
    }
}
i32 __builtin_clz(u32 x) {
    if x == 0 { return 32; }
    return clz(cast(i32, x));
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

// POSIX <time.h>: timespec + clock_gettime.
struct timespec { i64 tv_sec; i64 tv_nsec; }
when os(windows) {
    i32 clock_gettime(i32 clk_id, timespec* tp) {
        i64 ticks = qpc();
        i64 freq = qpf();
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

// <stdio.h> file I/O. SEEK_* standard ANSI values.
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
when os(android) {
    extern "libc.so" {
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
// libc subset for wasm.
when os(wasm) {

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
    // puts writes the string + a newline to stdout.
    i32 puts(u8* s) {
        str line = { .data = s, .len = cast(i32, strlen(s)) };
        print("{}\n", line);
        return 0;
    }

    // --- buffered file I/O over the host VFS ---
    struct __rl_file { u8* data; i64 size; i64 pos; i32 err; }

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
                free(buf);
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
        f.err = 0;
        return f;
    }
    i32 fclose(void* stream) {
        if stream == null { return 0; }
        __rl_file* f = cast(__rl_file*, stream);
        free(f.data);
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
    // The host VFS is read-only. Set err and return zero.
    u64 fwrite(void* p, u64 sz, u64 n, void* stream) {
        ignore p; ignore sz; ignore n;
        if stream != null {
            __rl_file* f = cast(__rl_file*, stream);
            f.err = 1;
        }
        return 0;
    }
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
