// Imports added on export so this module resolves standalone (LSP).
import cstdlib_shim;

// cvararg_shim — printf-family in pure minc. Used by TextFormat
// and TraceLog. Supports %d %i %u %x %X %c %s %f %p %%, l/ll/z
// length modifiers, field width, zero-pad, float precision.

i32 _vp(u8* buf, u64 cap, i32 pos, u8 c) {
    if pos >= 0 && cap > 0 && cast(u64, pos) < cap - 1 { *(buf + pos) = c; }
    return pos + 1;
}

i32 _vp_uint(u8* buf, u64 cap, i32 pos, u64 v, i32 base, bool upper, i32 width, bool zero) {
    u8[24] tmp;
    i32 n = 0;
    if v == 0 { tmp[0] = 48; n = 1; }
    while v > 0 {
        u64 d = v % cast(u64, base);
        if d < 10 { tmp[n] = cast(u8, 48 + d); }
        else { tmp[n] = cast(u8, (upper ? 65 : 97) + cast(i32, d - 10)); }
        n = n + 1;
        v = v / cast(u64, base);
    }
    while n < width { pos = _vp(buf, cap, pos, cast(u8, zero ? 48 : 32)); width = width - 1; }
    for i32 i = n - 1; i >= 0; i = i - 1 { pos = _vp(buf, cap, pos, tmp[i]); }
    return pos;
}

i32 _vp_int(u8* buf, u64 cap, i32 pos, i64 v, i32 width, bool zero) {
    if v < 0 {
        pos = _vp(buf, cap, pos, 45);
        v = 0 - v;
        if width > 0 { width = width - 1; }
    }
    return _vp_uint(buf, cap, pos, cast(u64, v), 10, false, width, zero);
}

i32 _vp_str(u8* buf, u64 cap, i32 pos, u8* s) {
    if s == null { s = "(null)"; }
    i32 i = 0;
    while *(s + i) != 0 { pos = _vp(buf, cap, pos, *(s + i)); i = i + 1; }
    return pos;
}

i32 _vp_f64(u8* buf, u64 cap, i32 pos, f64 v, i32 prec) {
    if prec < 0 { prec = 6; }
    if v < 0.0 { pos = _vp(buf, cap, pos, 45); v = 0.0 - v; }
    i64 ip = cast(i64, v);
    pos = _vp_uint(buf, cap, pos, cast(u64, ip), 10, false, 0, false);
    if prec > 0 {
        pos = _vp(buf, cap, pos, 46);
        f64 frac = v - cast(f64, ip);
        for i32 i = 0; i < prec; i = i + 1 {
            frac = frac * 10.0;
            i32 dig = cast(i32, frac);
            pos = _vp(buf, cap, pos, cast(u8, 48 + dig));
            frac = frac - cast(f64, dig);
        }
    }
    return pos;
}

i32 __minc_vfmt(u8* buf, u64 cap, u8* fmt, &... ap) {
    i32 pos = 0;
    i32 i = 0;
    while *(fmt + i) != 0 {
        u8 c = *(fmt + i);
        if c != 37 { pos = _vp(buf, cap, pos, c); i = i + 1; continue; }
        i = i + 1;
        bool zero = false;
        while *(fmt + i) == 48 || *(fmt + i) == 45 || *(fmt + i) == 43 || *(fmt + i) == 32 {
            if *(fmt + i) == 48 { zero = true; }
            i = i + 1;
        }
        i32 width = 0;
        while *(fmt + i) >= 48 && *(fmt + i) <= 57 { width = width * 10 + cast(i32, *(fmt + i) - 48); i = i + 1; }
        i32 prec = 0 - 1;
        if *(fmt + i) == 46 {
            i = i + 1; prec = 0;
            while *(fmt + i) >= 48 && *(fmt + i) <= 57 { prec = prec * 10 + cast(i32, *(fmt + i) - 48); i = i + 1; }
        }
        bool islong = false;
        while *(fmt + i) == 108 || *(fmt + i) == 104 || *(fmt + i) == 122 || *(fmt + i) == 106 || *(fmt + i) == 116 {
            if *(fmt + i) == 108 || *(fmt + i) == 122 || *(fmt + i) == 106 { islong = true; }
            i = i + 1;
        }
        u8 conv = *(fmt + i);
        i = i + 1;
        if conv == 100 || conv == 105 {
            if islong { pos = _vp_int(buf, cap, pos, arg_read_i64(ap), width, zero); }
            else { pos = _vp_int(buf, cap, pos, cast(i64, arg_read_i32(ap)), width, zero); }
        } else if conv == 117 {
            if islong { pos = _vp_uint(buf, cap, pos, cast(u64, arg_read_i64(ap)), 10, false, width, zero); }
            else { pos = _vp_uint(buf, cap, pos, cast(u64, cast(u32, arg_read_i32(ap))), 10, false, width, zero); }
        } else if conv == 120 || conv == 88 {
            if islong { pos = _vp_uint(buf, cap, pos, cast(u64, arg_read_i64(ap)), 16, conv == 88, width, zero); }
            else { pos = _vp_uint(buf, cap, pos, cast(u64, cast(u32, arg_read_i32(ap))), 16, conv == 88, width, zero); }
        } else if conv == 102 || conv == 70 {
            pos = _vp_f64(buf, cap, pos, arg_read_f64(ap), prec);
        } else if conv == 115 {
            pos = _vp_str(buf, cap, pos, arg_read_ptr(ap));
        } else if conv == 99 {
            pos = _vp(buf, cap, pos, cast(u8, arg_read_i32(ap)));
        } else if conv == 112 {
            pos = _vp(buf, cap, pos, 48); pos = _vp(buf, cap, pos, 120);
            pos = _vp_uint(buf, cap, pos, cast(u64, arg_read_ptr(ap)), 16, false, 0, false);
        } else if conv == 37 {
            pos = _vp(buf, cap, pos, 37);
        } else {
            pos = _vp(buf, cap, pos, 37); pos = _vp(buf, cap, pos, conv);
        }
    }
    if cap > 0 {
        i32 t = pos;
        if cast(u64, t) >= cap { t = cast(i32, cap - 1); }
        *(buf + t) = 0;
    }
    return pos;
}

i32 vsnprintf(u8* buf, u64 size, u8* fmt, &... ap) { return __minc_vfmt(buf, size, fmt, ap); }
// snprintf is minc-native (msvcrt.dll only ships _snprintf).
i32 snprintf(u8* buf, u64 size, u8* fmt, ...) { return __minc_vfmt(buf, size, fmt, &...); }
i32 vsprintf(u8* buf, u8* fmt, &... ap) { return __minc_vfmt(buf, cast(u64, 2147483647), fmt, ap); }
i32 vprintf(u8* fmt, &... ap) {
    u8[1024] line;
    i32 n = __minc_vfmt(cast(u8*, &line), 1024, fmt, ap);
    puts(cast(u8*, &line));
    return n;
}
