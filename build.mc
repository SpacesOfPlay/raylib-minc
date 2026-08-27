// build.mc - build (and run) a raylib-minc example, native or web.
//
// Usage, from this folder:
//   minc run                     build + run examples/core/core_basic_window.mc
//   minc run <file.mc>           build + run any .mc file
//   minc run <x> --no-run        compile only
//   minc run all                 walk every example; close a window (or press
//                                Enter) for the next
//   minc run all --start 10      ... start from example #10
//   minc run all --seconds 3     ... close each one automatically
//   minc build [<file.mc>]       compile only
//   minc build all               compile every example
//   minc wasm <file.mc>          build + serve one example in the browser
//   minc wasm <x> --no-run       serve without opening the browser
//   minc wasm all                compile all examples + serve the gallery
//   minc wasm all --port 9000    ... on another port
//   minc clean
//
// Binaries are named after the .mc file's stem and run with build/ as
// the working directory; a `resources/` dir next to the .mc is
// mirrored there so relative loads resolve. Build from this folder so
// `import raylib;` resolves against lib/.
//
// GLFW: Windows and macOS fetch a pinned upstream release on the first
// native build (SHA-256 verified, kept at the dist root); Linux uses
// the system package. The web target needs none.
//
// The compiler is taken from MINC, then PATH, then this folder
// (install: https://minc.dev).

@minc_min_version "0.9.12"

// Older minc ignores the tag above; this forces an error instead.
when !defined(MINC_VERSION) || MINC_VERSION < 9012 {
    minc_0_9_12_or_newer_required please_update_minc;
}

import process;
import file;
import str;
import sha256;
import net;
import thread;

when os(windows) { str EXE_SUFFIX = ".exe"; }
when os(linux) || os(macos) { str EXE_SUFFIX = ""; }

str DEFAULT_EXAMPLE = "examples/core/core_basic_window.mc";

// Pinned upstream GLFW release. On a version bump the mismatch error
// prints the digest to pin.
str GLFW_VERSION = "3.4";
str GLFW_WIN_SHA256 = "54efa829400f2a0537f742b2b3bdd74e437bb4f2f048e4b7d3c5557d11a611e6";
str GLFW_MAC_SHA256 = "6775085bdae60312a3002bff2e39779a83bc72a7e1c810bd806fddb00cb35fd0";

string join_named(str dir, str name, str ext) {
    string base = str_concat(name, ext);
    defer free(base);
    return path_join(dir, base);
}

void die(str s) {
    eprint("{}\n", s);
    exit(1);
    return;
}

// MINC (install dir or binary), then PATH, then this folder.
string find_minc() {
    string env = env_get("MINC");
    if env.len > 0 {
        if path_is_dir(env) {
            string cand = join_named(env, "minc", EXE_SUFFIX);
            free(env);
            return cand;
        }
        return env;
    }
    free(env);

    string onpath = path_which("minc");
    if onpath.len > 0 { return onpath; }
    free(onpath);

    string local = str_concat("./minc", EXE_SUFFIX);
    if path_exists(local) { return local; }
    free(local);

    string none = { .data = null, .len = 0 };
    return none;
}

// Non-negative integer, or -1 if the argument is not one.
i32 str_to_i32(str s) {
    if s.len == 0 { return -1; }
    i32 v = 0;
    for i32 i = 0; i < s.len; i++ {
        u8 c = *(s.data + i);
        if c < '0' || c > '9' { return -1; }
        v = v * 10 + cast(i32, c - '0');
    }
    return v;
}

// --- the example list -----------------------------------------------

const i32 MAX_EXAMPLES = 512;

string[MAX_EXAMPLES] g_examples;   // paths relative to the dist root
i32 g_example_count;

// Depth-first over examples/: subdirs in sorted order, then files.
void collect_examples_in(str dir) {
    DirList subs = dir_list(dir, "", true);
    for i32 i = 0; i < subs.count; i++ {
        string sub = path_join(dir, subs.items[i]);
        collect_examples_in(sub);
        free(sub);
    }
    dir_list_free(&subs);
    DirList files = dir_list(dir, ".mc", false);
    for i32 i = 0; i < files.count; i++ {
        if g_example_count >= MAX_EXAMPLES { break; }
        g_examples[g_example_count] = path_join(dir, files.items[i]);
        g_example_count++;
    }
    dir_list_free(&files);
    return;
}

void collect_examples() {
    collect_examples_in("examples");
    if g_example_count == 0 { die("no examples found under examples/"); }
    return;
}

void list_other_examples() {
    collect_examples();
    for i32 i = 0; i < g_example_count; i++ {
        str rel = g_examples[i];
        if str_equal(rel, DEFAULT_EXAMPLE) { continue; }
        print("    minc run {}\n", rel);
    }
    return;
}

// --- GLFW acquisition -------------------------------------------------

// Fetch `url` to `dest`: curl, or PowerShell on a Windows box without
// it (TLS 1.2 forced; GitHub's CDN rejects the 1.0 default offer).
bool download(str url, str dest) {
    string curl = path_which("curl");
    if curl.len > 0 {
        ProcCmd c = { .args = {
            curl, "-fsSL",
            "--retry", "4", "--retry-delay", "1",
            "-o", dest, url
        } };
        ProcResult r = proc_run(&c);
        bool ok = r.spawned && r.exit_code == 0;
        proc_result_free(&r);
        free(curl);
        return ok && path_exists(dest);
    }
    free(curl);
    when os(windows) {
        string cmd = format("[Net.ServicePointManager]::SecurityProtocol=[Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-WebRequest -UseBasicParsing -Uri '{}' -OutFile '{}'",
                            url, dest);
        defer free(cmd);
        ProcCmd c = { .args = {
            "powershell", "-NoProfile", "-Command",
            cmd
        } };
        ProcResult r = proc_run(&c);
        bool ok = r.spawned && r.exit_code == 0;
        proc_result_free(&r);
        return ok && path_exists(dest);
    }
    return false;
}

// Lowercase hex SHA-256; empty on read failure. Caller frees.
string file_sha256_hex(str path) {
    string none = { .data = null, .len = 0 };
    FileData fd = file_read(path);
    if fd.data == null { return none; }
    defer free(fd.data);
    noinit u8[32] digest;
    sha256_oneshot(fd.data, cast(u64, fd.len), &digest[0]);
    str hexdigits = "0123456789abcdef";
    u8* hex = alloc<u8>(64);
    for i32 i = 0; i < 32; i++ {
        hex[i * 2] = hexdigits.data[digest[i] >> 4];
        hex[i * 2 + 1] = hexdigits.data[digest[i] & 15];
    }
    string s = { .data = hex, .len = 64 };
    return s;
}

// Download + verify one pinned archive to build/glfw.zip. curl's
// --retry does not cover connection resets, hence the attempts loop.
bool fetch_glfw_zip(str url, str pin) {
    ignore dir_create("build");
    str zip = "build/glfw.zip";
    print("downloading {}\n", url);
    bool got = false;
    for i32 attempt = 1; attempt <= 4 && !got; attempt++ {
        if attempt > 1 {
            print("  download failed (attempt {}/4), retrying...\n", attempt - 1);
            thread_sleep(300 * attempt);
        }
        ignore file_remove(zip);
        got = download(url, zip);
    }
    if !got {
        print("download failed - check your connection, or fetch GLFW by hand\n"
              "(see README.md).\n");
        return false;
    }
    string hex = file_sha256_hex(zip);
    defer free(hex);
    if !str_equal(hex, pin) {
        print("GLFW download SHA-256 mismatch. Expected {}, got {}.\n"
              "Refusing to proceed.\n", pin, hex);
        ignore file_remove(zip);
        return false;
    }
    return true;
}

when os(windows) {

// glfw3.dll at the dist root, mirrored into build/ next to each exe.
bool ensure_glfw() {
    if path_exists("glfw3.dll") { return true; }
    string url = format("https://github.com/glfw/glfw/releases/download/{}/glfw-{}.bin.WIN64.zip",
                        GLFW_VERSION, GLFW_VERSION);
    defer free(url);
    if !fetch_glfw_zip(url, GLFW_WIN_SHA256) { return false; }
    // tar.exe on older setups may be GNU tar, which cannot read zip.
    ProcCmd c = { .args = {
        "powershell", "-NoProfile", "-Command",
        "Expand-Archive -LiteralPath 'build/glfw.zip' -DestinationPath 'build/glfw_unzip' -Force"
    } };
    ProcResult r = proc_run(&c);
    bool ok = r.spawned && r.exit_code == 0;
    proc_result_free(&r);
    if ok {
        string dll = format("build/glfw_unzip/glfw-{}.bin.WIN64/lib-vc2022/glfw3.dll",
                            GLFW_VERSION);
        defer free(dll);
        ok = file_copy(dll, "glfw3.dll");
    }
    ignore dir_remove("build/glfw_unzip");
    ignore file_remove("build/glfw.zip");
    if !ok {
        print("could not extract glfw3.dll from the GLFW archive.\n");
        return false;
    }
    print("OK - glfw3.dll at the dist root.\n");
    return true;
}

}

when os(macos) {

// libglfw.3.dylib (universal) at the dist root. minc bakes an
// @loader_path reference, so each build copies it next to the binary.
bool ensure_glfw() {
    if path_exists("libglfw.3.dylib") { return true; }
    string url = format("https://github.com/glfw/glfw/releases/download/{}/glfw-{}.bin.MACOS.zip",
                        GLFW_VERSION, GLFW_VERSION);
    defer free(url);
    if !fetch_glfw_zip(url, GLFW_MAC_SHA256) { return false; }
    string member = format("glfw-{}.bin.MACOS/lib-universal/libglfw.3.dylib", GLFW_VERSION);
    defer free(member);
    ProcCmd c = { .args = {
        "unzip", "-o", "-j", "build/glfw.zip",
        member, "-d", "."
    } };
    c.capture = true;
    ProcResult r = proc_run(&c);
    bool ok = r.spawned && r.exit_code == 0;
    proc_result_free(&r);
    ignore file_remove("build/glfw.zip");
    if !ok || !path_exists("libglfw.3.dylib") {
        print("could not extract libglfw.3.dylib from the GLFW archive.\n");
        return false;
    }
    print("OK - libglfw.3.dylib at the dist root.\n");
    return true;
}

}

when os(linux) {

// GLFW comes from the system package. minc links by soname, so probe
// the linker cache and the standard libdirs; pkg-config is a fallback.
bool ensure_glfw() {
    ProcCmd c = { .args = { "ldconfig", "-p" }, .capture = true };
    ProcResult r = proc_run(&c);
    bool found = r.spawned && r.exit_code == 0
              && str_find(r.out, "libglfw.so.3") >= 0;
    proc_result_free(&r);
    if found { return true; }
    str[6] dirs = {
        "/usr/lib/libglfw.so.3",
        "/usr/lib/x86_64-linux-gnu/libglfw.so.3",
        "/usr/lib64/libglfw.so.3",
        "/lib/libglfw.so.3",
        "/lib/x86_64-linux-gnu/libglfw.so.3",
        "/usr/local/lib/libglfw.so.3"
    };
    for i32 i = 0; i < 6; i++ {
        if path_exists(dirs[i]) { return true; }
    }
    ProcCmd pc = { .args = { "pkg-config", "--exists", "glfw3" }, .capture = true };
    ProcResult pr = proc_run(&pc);
    bool via_pc = pr.spawned && pr.exit_code == 0;
    proc_result_free(&pr);
    if via_pc { return true; }
    print("GLFW not detected. Install via your package manager, e.g.:\n"
          "  Debian/Ubuntu:  sudo apt install libglfw3 libglfw3-dev\n"
          "  Fedora:         sudo dnf install glfw glfw-devel\n"
          "  Arch:           sudo pacman -S glfw\n");
    return false;
}

}

// Copy the fetched GLFW library next to the binaries in build/.
void stage_glfw_runtime() {
    when os(windows) {
        ignore file_copy("glfw3.dll", "build/glfw3.dll");
    }
    when os(macos) {
        if path_exists("libglfw.3.dylib") {
            ignore file_copy("libglfw.3.dylib", "build/libglfw.3.dylib");
        }
    }
    return;
}

// --- resources + the wasm asset manifest ------------------------------

void copy_tree(str src, str dst) {
    ignore dir_create(dst);
    DirList files = dir_list(src, "", false);
    for i32 i = 0; i < files.count; i++ {
        string s = path_join(src, files.items[i]);
        defer free(s);
        string d = path_join(dst, files.items[i]);
        defer free(d);
        ignore file_copy(s, d);
    }
    dir_list_free(&files);
    DirList subs = dir_list(src, "", true);
    for i32 i = 0; i < subs.count; i++ {
        string s = path_join(src, subs.items[i]);
        defer free(s);
        string d = path_join(dst, subs.items[i]);
        defer free(d);
        copy_tree(s, d);
    }
    dir_list_free(&subs);
    return;
}

const i32 MAX_ASSETS = 1024;

// "resources/<...>" paths under `dir`, appended to items, deduped.
// Returns the new count.
i32 collect_assets(str dir, str prefix, string* items, i32 count) {
    DirList files = dir_list(dir, "", false);
    for i32 i = 0; i < files.count; i++ {
        if count >= MAX_ASSETS { break; }
        string rel = path_join(prefix, files.items[i]);
        bool dup = false;
        for i32 j = 0; j < count; j++ {
            if str_equal(items[j], rel) { dup = true; break; }
        }
        if dup { free(rel); }
        else {
            items[count] = rel;
            count++;
        }
    }
    dir_list_free(&files);
    DirList subs = dir_list(dir, "", true);
    for i32 i = 0; i < subs.count; i++ {
        string d = path_join(dir, subs.items[i]);
        defer free(d);
        string p = path_join(prefix, subs.items[i]);
        defer free(p);
        count = collect_assets(d, p,
                               items, count);
    }
    dir_list_free(&subs);
    return count;
}

// assets.json: the sorted file list the wasm harness preloads, so
// LoadImage("resources/...") resolves in the browser.
void write_assets_json(str web_dir, string* items, i32 count) {
    if count == 0 { return; }
    // Sort an index array; the items stay owned in place.
    noinit i32[MAX_ASSETS] order;
    for i32 i = 0; i < count; i++ { order[i] = i; }
    for i32 i = 1; i < count; i++ {
        i32 key = order[i];
        str keyp = items[key];
        i32 j = i - 1;
        while j >= 0 && str_compare(items[order[j]],
                                    keyp) > 0 {
            order[j + 1] = order[j];
            j = j - 1;
        }
        order[j + 1] = key;
    }
    str_buf sb;
    str_buf_init(&sb);
    str_buf_add_byte(&sb, '[');
    for i32 i = 0; i < count; i++ {
        if i > 0 { str_buf_add_byte(&sb, ','); }
        str_buf_add_byte(&sb, '"');
        str_buf_add(&sb, items[order[i]]);
        str_buf_add_byte(&sb, '"');
    }
    str_buf_add_byte(&sb, ']');
    string p = path_join(web_dir, "assets.json");
    defer free(p);
    ignore file_write_str(p, str_buf_to_str(&sb));
    str_buf_free(&sb);
    return;
}

// The example's resources/, if any, staged into `web_dir` with a
// manifest.
void stage_web_resources(str src_dir, str web_dir) {
    string res = path_join(src_dir, "resources");
    defer free(res);
    if !path_is_dir(res) { return; }
    string dst = path_join(web_dir, "resources");
    defer free(dst);
    copy_tree(res, dst);
    string[MAX_ASSETS] items;
    i32 n = collect_assets(res, "resources", &items[0], 0);
    write_assets_json(web_dir, &items[0], n);
    for i32 i = 0; i < n; i++ { free(items[i]); }
    return;
}

// --- native build + run -----------------------------------------------

// A directory means "<dir>/main.mc"; anything else is taken as given.
string resolve_source(str arg) {
    if path_is_dir(arg) { return path_join(arg, "main.mc"); }
    return string(arg);
}

// Compile `srcp` to build/<name><EXE_SUFFIX>; stage the GLFW runtime
// and the example's resources/ next to it. quiet: print the compiler
// output only on failure.
i32 build_native(str cc, str srcp, str name, bool quiet) {
    ignore dir_create("build");
    string exe = join_named("build", name, EXE_SUFFIX);
    defer free(exe);
    ProcCmd c = { .args = { cc, srcp, "-o", exe } };
    if quiet { c.capture = true; }
    ProcResult r = proc_run(&c);
    i32 rc = r.exit_code;
    if quiet && rc != 0 && r.out.len > 0 { print("{}", r.out); }
    proc_result_free(&r);
    if rc != 0 || !path_exists(exe) { return 1; }
    stage_glfw_runtime();
    str src_dir = path_dirname(srcp);
    string res = path_join(src_dir, "resources");
    defer free(res);
    if path_is_dir(res) {
        ignore dir_remove("build/resources");
        copy_tree(res, "build/resources");
    }
    return 0;
}

// Run build/<name> with build/ as the working directory. Windows
// resolves a relative program path against the parent's directory,
// POSIX against the child's. seconds > 0: a timeout counts as
// success, not failure.
i32 run_native(str name, i32 seconds) {
    string from_root = join_named("build", name, EXE_SUFFIX);
    defer free(from_root);
    string from_dir = str_concat("./", name);
    defer free(from_dir);
    ProcCmd c = { .cwd = "build" };
    when os(windows) { c.args[0] = from_root; }
    when os(linux) || os(macos) { c.args[0] = from_dir; }
    if seconds > 0 { c.timeout_ms = seconds * 1000; }
    ProcResult r = proc_run(&c);
    i32 rc = r.exit_code;
    if r.timed_out { rc = 0; }
    if !r.spawned { rc = 1; }
    proc_result_free(&r);
    return rc;
}

// --- `run all` / `build all`: walk every example ----------------------

i32 run_all(str cc, bool build_only, i32 start, i32 seconds) {
    collect_examples();
    i32 n = g_example_count;
    if start < 1 { start = 1; }
    if build_only {
        i32 fails = 0;
        for i32 i = start - 1; i < n; i++ {
            str rel = g_examples[i];
            str name = path_stem(rel);
            print("  [{}/{}] {}", i + 1, n, name);
            if build_native(cc, rel, name, true) != 0 {
                print("  FAILED\n");
                fails++;
            } else {
                print("\n");
            }
        }
        if fails > 0 {
            print("{} of {} example(s) failed to build\n", fails, n);
            return 1;
        }
        print("all {} example(s) built.\n", n);
        return 0;
    }

    print("native run - {} examples. Close each window (or press Enter) for the next.\n", n);
    bool auto_advance = seconds > 0;
    i32 i = start;
    while i <= n {
        str rel = g_examples[i - 1];
        str name = path_stem(rel);
        print("\n===== [{}/{}] {} =====\n", i, n, rel);
        bool ok = build_native(cc, rel, name, false) == 0;
        if ok { ok = run_native(name, seconds) == 0; }
        if !ok {
            print("(build/run failed for {})\n", rel);
        }
        if auto_advance { i++; continue; }
        bool advance = true;
        print("[Enter]=next  r=replay  s=skip-prompts  q=quit: ");
        noinit u8[64] line;
        i32 got = read(stdin(), &line[0], 63);
        if got > 0 {
            u8 k = line[0];
            if k == 'q' { print("bye\n"); return 0; }
            if k == 'r' { advance = false; }
            if k == 's' { auto_advance = true; }
        }
        if advance { i++; }
    }
    print("done.\n");
    return 0;
}

// --- `wasm all`: the live-demo gallery, served locally ----------------

str g_web_root = "build/web_all";

str content_type_for(str path) {
    i32 dot = -1;
    for i32 i = path.len - 1; i >= 0; i-- {
        if path.data[i] == '.' { dot = i; break; }
        if path.data[i] == '/' { break; }
    }
    if dot < 0 { return "application/octet-stream"; }
    str ext = str_slice(path, dot, path.len);
    if str_equal(ext, ".html") { return "text/html; charset=utf-8"; }
    if str_equal(ext, ".js")   { return "application/javascript; charset=utf-8"; }
    if str_equal(ext, ".css")  { return "text/css; charset=utf-8"; }
    if str_equal(ext, ".json") { return "application/json"; }
    if str_equal(ext, ".wasm") { return "application/wasm"; }
    if str_equal(ext, ".png")  { return "image/png"; }
    if str_equal(ext, ".jpg")  { return "image/jpeg"; }
    if str_equal(ext, ".jpeg") { return "image/jpeg"; }
    if str_equal(ext, ".gif")  { return "image/gif"; }
    if str_equal(ext, ".svg")  { return "image/svg+xml"; }
    if str_equal(ext, ".ico")  { return "image/x-icon"; }
    if str_equal(ext, ".txt")  { return "text/plain; charset=utf-8"; }
    if str_equal(ext, ".wav")  { return "audio/wav"; }
    if str_equal(ext, ".ogg")  { return "audio/ogg"; }
    if str_equal(ext, ".mp3")  { return "audio/mpeg"; }
    return "application/octet-stream";
}

// Reject anything that could escape the web root.
bool url_path_is_safe(str path) {
    if path.len < 1 || path.data[0] != '/' { return false; }
    if path.len >= 2 && path.data[1] == '/' { return false; }
    for i32 i = 0; i < path.len - 1; i++ {
        if path.data[i] == '.' && path.data[i + 1] == '.' { return false; }
    }
    return true;
}

bool send_response(Socket c, str status, str content_type, str body) {
    // no-store: never serve a stale host .js or .wasm. HTTP/1.0 +
    // close keeps one tab from starving the next request.
    string header = format(
        "HTTP/1.0 {}\r\nContent-Type: {}\r\nContent-Length: {}\r\nCache-Control: no-store\r\nConnection: close\r\n\r\n",
        status, content_type, body.len);
    defer free(header);
    if !net_send_all(c, header.data, header.len) { return false; }
    if body.len > 0 && !net_send_all(c, body.data, body.len) { return false; }
    return true;
}

void handle_connection(Socket c) {
    noinit u8[4096] buf;
    i32 n = net_recv(c, &buf[0], 4096);
    if n <= 0 { return; }
    str req = str_from(&buf[0], n);
    i32 line_end = str_find(req, "\r\n");
    if line_end < 0 { return; }
    str line = str_slice(req, 0, line_end);
    i32 sp1 = str_find_byte(line, ' ');
    if sp1 < 0 { return; }
    str rest = str_slice(line, sp1 + 1, line.len);
    i32 sp2 = str_find_byte(rest, ' ');
    if sp2 < 0 { return; }
    str method = str_slice(line, 0, sp1);
    str path = str_slice(rest, 0, sp2);
    i32 q = str_find_byte(path, '?');
    if q >= 0 { path = str_slice(path, 0, q); }
    if !str_equal(method, "GET") {
        send_response(c, "405 Method Not Allowed", "text/plain; charset=utf-8", "GET only\n");
        return;
    }
    if !url_path_is_safe(path) {
        send_response(c, "400 Bad Request", "text/plain; charset=utf-8", "Invalid path\n");
        return;
    }
    if path.len == 1 { path = "/index.html"; }
    string fpath = str_concat(g_web_root, path);
    defer free(fpath);
    FileData fd = file_read(fpath);
    if fd.data == null {
        send_response(c, "404 Not Found", "text/plain; charset=utf-8", "Not Found\n");
        return;
    }
    defer free(fd.data);
    send_response(c, "200 OK", content_type_for(path), str_from(fd.data, fd.len));
    return;
}

void open_browser(str url) {
    when os(windows) {
        ProcCmd c = { .args = { "cmd", "/c", "start", "", url } };
        ProcResult r = proc_run(&c);
        proc_result_free(&r);
    }
    when os(macos) {
        ProcCmd c = { .args = { "open", url } };
        ProcResult r = proc_run(&c);
        proc_result_free(&r);
    }
    when os(linux) {
        ProcCmd c = { .args = { "xdg-open", url } };
        ProcResult r = proc_run(&c);
        proc_result_free(&r);
    }
    return;
}

i32 wasm_all(str cc, i32 port, bool no_run) {
    collect_examples();
    i32 n = g_example_count;
    ignore dir_remove(g_web_root);
    ignore dir_create(g_web_root);
    ignore file_copy("lib/raylib_wasm_host.js", "build/web_all/raylib_wasm_host.js");
    ignore file_copy("live-demo/index.html", "build/web_all/index.html");
    ignore file_copy("live-demo/run.html", "build/web_all/run.html");

    // Merge every example's resources/ into one dir + one manifest.
    // Every app preloads all of them; same-named files collide.
    string[MAX_ASSETS] items;
    i32 asset_count = 0;
    bool any_res = false;
    for i32 i = 0; i < n; i++ {
        str src_dir = path_dirname(g_examples[i]);
        string res = path_join(src_dir, "resources");
        defer free(res);
        if !path_is_dir(res) { continue; }
        any_res = true;
        copy_tree(res, "build/web_all/resources");
        asset_count = collect_assets(res, "resources", &items[0], asset_count);
    }
    if any_res { write_assets_json(g_web_root, &items[0], asset_count); }
    for i32 i = 0; i < asset_count; i++ { free(items[i]); }

    i32 ok = 0;
    str_buf fails;
    str_buf_init(&fails);
    for i32 i = 0; i < n; i++ {
        str rel = g_examples[i];
        str name = path_stem(rel);
        print("  [{}/{}] {}", i + 1, n, name);
        string wasm_out = join_named(g_web_root, name, ".wasm");
        defer free(wasm_out);
        ProcCmd c = { .args = {
            cc, rel, "--target", "wasm",
            "-o", wasm_out
        } };
        c.capture = true;
        ProcResult r = proc_run(&c);
        i32 rc = r.exit_code;
        proc_result_free(&r);
        if rc == 0 {
            ok++;
            print(" ok\n");
        } else {
            print(" FAIL\n");
            str_buf_add_byte(&fails, ' ');
            str_buf_add(&fails, name);
        }
    }
    print("\ncompiled {}/{} examples -> {}\n", ok, n, g_web_root);
    if fails.len > 0 {
        print("FAILED to compile:{}\n", str_buf_to_str(&fails));
    }
    str_buf_free(&fails);

    if !net_init() { die("net_init failed"); }
    Socket srv = net_listen_tcp_loopback(cast(u16, port));
    if !srv.valid {
        print("listen on port {} failed (already in use?)\n", port);
        net_shutdown();
        return 1;
    }
    string url = format("http://localhost:{}/index.html", port);
    defer free(url);
    print("serving at {}  (Ctrl+C to stop)\n", url);
    if !no_run { open_browser(url); }
    while true {
        Socket conn = net_accept(srv);
        if !conn.valid { continue; }
        handle_connection(conn);
        net_close(conn);
    }
    net_close(srv);
    net_shutdown();
    return 0;
}

// --- entry -------------------------------------------------------------

void usage() {
    print("usage: minc <run|build|wasm|clean> [<file.mc>|all] [options]\n"
          "  minc run [<file.mc>]       build + run (default: the hello-window example)\n"
          "  minc run all               walk every example (--start N, --seconds N)\n"
          "  minc build [<file.mc>|all] compile only\n"
          "  minc wasm <file.mc>        build + serve one example in the browser\n"
          "  minc wasm all              compile all + serve the live-demo gallery (--port N)\n"
          "  minc clean                 remove build/\n");
    return;
}

i32 main() {
    i32 argc = get_argc();
    str verb = "run";
    str target = "";
    bool no_run = false;
    i32 start = 1;
    i32 seconds = 0;
    i32 port = 8080;

    for i32 i = 1; i < argc; i++ {
        str a = str_from_cstr(get_arg(i));
        if str_equal(a, "--no-run") { no_run = true; }
        else if str_equal(a, "--start") && i + 1 < argc {
            i++;
            i32 v = str_to_i32(str_from_cstr(get_arg(i)));
            if v < 1 { die("--start wants a positive number"); }
            start = v;
        }
        else if str_equal(a, "--seconds") && i + 1 < argc {
            i++;
            i32 v = str_to_i32(str_from_cstr(get_arg(i)));
            if v < 0 { die("--seconds wants a number"); }
            seconds = v;
        }
        else if str_equal(a, "--port") && i + 1 < argc {
            i++;
            i32 v = str_to_i32(str_from_cstr(get_arg(i)));
            if v < 1 || v > 65535 { die("--port wants 1..65535"); }
            port = v;
        }
        else if i == 1 {
            // A .mc path in the verb slot means "run this".
            if str_ends_with(a, ".mc") { target = a; }
            else { verb = a; }
        } else if target.len == 0 { target = a; }
    }

    if str_equal(verb, "clean") {
        ignore dir_remove("build");
        print("clean.\n");
        return 0;
    }
    if !str_equal(verb, "run") && !str_equal(verb, "build") && !str_equal(verb, "wasm") {
        usage();
        return 1;
    }

    string minc = find_minc();
    defer free(minc);
    if minc.len == 0 {
        print("\nminc compiler not found.\n"
              "Install it:  powershell -c \"irm minc.dev/install.ps1 | iex\"\n"
              "or set MINC (see install_minc.md).\n");
        die("See README.md (Quickstart) and LICENSE.md.");
    }

    if !path_exists("lib/raylib.mc") {
        die("missing lib/raylib.mc - dist is incomplete");
    }

    // Web target: hand off to `minc run --target wasm`, which stages
    // the JS host + HTML harness, serves them, and opens the browser.
    if str_equal(verb, "wasm") {
        if target.len == 0 {
            print("pick an example, e.g.:  minc wasm examples/core/core_basic_window.mc\n"
                  "or serve them all:      minc wasm all\n");
            return 1;
        }
        if str_equal(target, "all") { return wasm_all(minc, port, no_run); }
        string src = resolve_source(target);
        defer free(src);
        if !path_exists(src) {
            eprint("no such file: {}\n", src);
            exit(1);
        }
        str name = path_stem(src);
        ignore dir_remove("build/web");
        ignore dir_create("build/web");
        str src_dir = path_dirname(src);
        stage_web_resources(src_dir, "build/web");
        print("building + serving {} for the web (wasm)...\n", name);
        string wasm_out = join_named("build/web", name, ".wasm");
        defer free(wasm_out);
        ProcCmd c = { .args = {
            minc, "run", src, "--target", "wasm",
            "-o", wasm_out
        } };
        if no_run { proc_arg(&c, "--no-browser"); }
        ProcResult r = proc_run(&c);
        i32 rc = r.exit_code;
        proc_result_free(&r);
        return rc;
    }

    // Native targets need the GLFW runtime.
    if !ensure_glfw() {
        die("GLFW is required for native builds - see above.");
    }

    if str_equal(target, "all") {
        return run_all(minc, str_equal(verb, "build") || no_run, start, seconds);
    }

    if target.len == 0 {
        target = DEFAULT_EXAMPLE;
        print("no source given - using default example: {}\n  other examples:\n", target);
        list_other_examples();
        print("\n");
    }
    string src = resolve_source(target);
    defer free(src);
    if !path_exists(src) {
        eprint("no such file: {}\n", src);
        exit(1);
    }
    str name = path_stem(src);

    print("compiling {}\n", name);
    if build_native(minc, src, name, false) != 0 { die("minc compile failed"); }
    string exe = join_named("build", name, EXE_SUFFIX);
    defer free(exe);
    print("built {}\n", exe);

    i32 rc = 0;
    if str_equal(verb, "run") && !no_run {
        print("running...\n");
        rc = run_native(name, seconds);
    }
    return rc;
}
