// Imports added on export so this module resolves standalone (LSP).
import cstdlib_shim;

// cfile_shim.mc - C file/directory/stat surface: directory iteration,
// access/cwd/mkdir, system(), fprintf streams, per-OS sleep/clock.
// Buffered I/O (fread/fwrite/fseek/ftell) lives in cstdlib_shim.
// Windows uses the _-prefixed msvcrt names; POSIX uses plain libc.

when os(windows) {
    extern "msvcrt.dll" {
        i64 _findfirst(u8* spec, void* finddata);   // intptr_t handle
        i32 _findnext(i64 handle, void* finddata);
        i32 _findclose(i64 handle);
        i32 _access(u8* path, i32 mode);
        i32 _chdir(u8* path);
        i32 _mkdir(u8* path);
        u8* _getcwd(u8* buf, i32 size);
        i32 fprintf(void* stream, u8* fmt, ...);
        i32 system(u8* cmd);
    }
    extern "kernel32.dll" {
        void Sleep(u32 ms);                          // frame wait (WaitTime)
        u32 GetModuleFileNameA(void* mod, u8* name, u32 size);  // exe path
    }
    extern "winmm.dll" {
        // High-resolution timer: timeBeginPeriod(1) → ~1ms Sleep granularity.
        u32 timeBeginPeriod(u32 uPeriod);
        u32 timeEndPeriod(u32 uPeriod);
    }
    // Compose-mode narrowing wrapper. `unsigned long` widens to u64
    // in compose; Sleep wants DWORD (u32). Bind via -D Sleep=rl_sleep_u64.
    void rl_sleep_u64(u64 ms) { Sleep(cast(u32, ms)); }
}
when os(linux) || os(macos) || os(ios) {
    // Stub on non-Windows so the dead Windows arm parses.
    void rl_sleep_u64(u64 ms) { }
}
// timespec/dirent/DIR are passed as void* so the shim is import-order
// independent; call sites use the real types (implicit ptr conversion).
when os(linux) {
    extern "libc.so.6" {
        i32 access(u8* path, i32 mode);
        i32 chdir(u8* path);
        i32 mkdir(u8* path, u32 mode);
        u8* getcwd(u8* buf, u64 size);
        i32 fprintf(void* stream, u8* fmt, ...);
        i32 system(u8* cmd);
        // <time.h>: sleep + clock.
        i32 nanosleep(void* req, void* rem);
        i32 clock_gettime(i32 clk_id, void* tp);
        // <unistd.h>: readlink (exe path via /proc/self/exe).
        i64 readlink(u8* path, u8* buf, u64 bufsiz);
        // <dirent.h>
        void* opendir(u8* name);
        void* readdir(void* dir);
        i32 closedir(void* dir);
    }
}
when os(macos) || os(ios) {
    extern "libSystem.B.dylib" {
        i32 access(u8* path, i32 mode);
        i32 chdir(u8* path);
        i32 mkdir(u8* path, u32 mode);
        u8* getcwd(u8* buf, u64 size);
        i32 fprintf(void* stream, u8* fmt, ...);
        i32 system(u8* cmd);
        i32 nanosleep(void* req, void* rem);
        i32 clock_gettime(i32 clk_id, void* tp);
        // macOS sleep path (Linux uses nanosleep).
        i32 usleep(u32 usec);
        i64 readlink(u8* path, u8* buf, u64 bufsiz);
        // <mach-o/dyld.h>: exe path (no /proc/self/exe on macOS).
        i32 _NSGetExecutablePath(u8* buf, u32* bufsize);
        void* opendir(u8* name);
        void* readdir(void* dir);
        i32 closedir(void* dir);
    }
    // usleep wrapper: the arg arrives as f64 (no <unistd.h> prototype to
    // coerce it), so spell out the cast. Bound via -D "usleep(us)=rl_usleep(us)".
    void rl_usleep(f64 us) { usleep(cast(u32, us)); }
}
// Compose-mode readdir wrapper. Under compose, raylib's struct
// dirent is the Windows pointer form `{ char *d_name }` (from
// raylib's external/dirent.h). The real POSIX readdir() returns
// a system dirent where d_name is an embedded char[] at a
// per-platform offset, so the raylib code reading entry->d_name
// would read d_ino instead. Bind via `-D readdir(d)=rl_readdir(d)`;
// the wrapper sets d_name to point at the POSIX struct's name
// field via the right offset. minc accepts the duplicate `struct
// dirent` decl as long as the shape is identical to the one in
// raylib_lib.mc / cfile_shim_posix.h.
when os(linux) || os(macos) || os(ios) {
    struct dirent {
        u8* d_name;
    }
    // Per-call slot — raylib's LoadDirectoryFiles consumes each
    // result before the next call, so a single static slot is safe.
    private { dirent rl_readdir_slot; }
}
when os(linux) {
    // glibc layout: d_ino(8) + d_off(8) + d_reclen(2) + d_type(1)
    // then d_name at offset 19.
    dirent* rl_readdir(void* dir) {
        void* p = readdir(dir);
        if p == null { return null; }
        rl_readdir_slot.d_name = cast(u8*, p) + cast(u64, 19);
        return &rl_readdir_slot;
    }
}
when os(macos) || os(ios) {
    // Darwin 64-bit-inode layout (default since 10.6):
    // d_ino(8) + d_seekoff(8) + d_reclen(2) + d_namlen(2) +
    // d_type(1), then d_name at offset 21.
    dirent* rl_readdir(void* dir) {
        void* p = readdir(dir);
        if p == null { return null; }
        rl_readdir_slot.d_name = cast(u8*, p) + cast(u64, 21);
        return &rl_readdir_slot;
    }
}
// On Windows the -D `readdir(d)=rl_readdir(d)` rewrite renames
// raylib's external/dirent.h `readdir` function (and its callers)
// to `rl_readdir`, so the Windows arm already provides the symbol
// — no stub needed here.

// <sys/stat.h> file-type macros as functions (S_IFREG / S_IFDIR).
bool S_ISREG(i32 mode) { return (mode & 0xF000) == 0x8000; }
bool S_ISDIR(i32 mode) { return (mode & 0xF000) == 0x4000; }

// stat() the function collides with `struct stat` (minc shares one
// namespace). Callers rename the call form via -D "stat(p,b)=rl_fstat(p,b)".
// Stub: reports "not a regular file".
i32 rl_fstat(u8* path, void* buf) { return 0 - 1; }

// errno: a plain global (real msvcrt errno is the per-thread *_errno()).
i32 errno = 0;

// stdout/stderr: null sentinels for fflush(stdout) (a real FILE* needs
// __acrt_iob_func). Output still reaches the console; the flush is a no-op.
void* stdout = null;
void* stderr = null;
