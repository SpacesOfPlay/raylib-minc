import cstdlib_shim;

// printf-family formatting (%d %i %u %x %X %c %s %f %p %%) in pure minc.
// Supports l/ll/z length modifiers, field width, zero-pad, float precision.

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
i32 snprintf(u8* buf, u64 size, u8* fmt, ...) { return __minc_vfmt(buf, size, fmt, &...); }
i32 vsprintf(u8* buf, u8* fmt, &... ap) { return __minc_vfmt(buf, cast(u64, 2147483647), fmt, ap); }
i32 vprintf(u8* fmt, &... ap) {
    u8[1024] line;
    i32 n = __minc_vfmt(cast(u8*, &line), 1024, fmt, ap);
    puts(cast(u8*, &line));
    return n;
}
when os(wasm) {
    // unbounded
    i32 sprintf(u8* buf, u8* fmt, ...) { return __minc_vfmt(buf, cast(u64, 2147483647), fmt, &...); }
    // printf / fprintf format into a scratch buffer and emit via the
    // wasm `write` host import.
    i32 printf(u8* fmt, ...) {
        u8[1024] line;
        i32 n = __minc_vfmt(cast(u8*, &line), 1024, fmt, &...);
        write(1, cast(u8*, &line), n);
        return n;
    }
    i32 fprintf(void* stream, u8* fmt, ...) {
        ignore stream;
        u8[1024] line;
        i32 n = __minc_vfmt(cast(u8*, &line), 1024, fmt, &...);
        write(2, cast(u8*, &line), n);
        return n;
    }
    // sscanf sub-set: %i/%d/%u (decimal int), %f (float), %s
    // (non-whitespace token), %[^c]/%[c] single-char scanset with optional
    // width (e.g. %128[^"]), %% , literal chars, and whitespace-skips.
    // no Hex/%x and multi-char scansets.
    private bool __sc_ws(u8 c) { return c == 32 || c == 9 || c == 10 || c == 13 || c == 11 || c == 12; }
    private f32 __sc_atof(u8* s, i32 len) {
        f32 result = 0.0f;
        f32 sign = 1.0f;
        i32 i = 0;
        if i < len && *(s + i) == 45 { sign = 0.0f - 1.0f; i = i + 1; }
        else if i < len && *(s + i) == 43 { i = i + 1; }
        while i < len && *(s + i) >= 48 && *(s + i) <= 57 {
            result = result * 10.0f + cast(f32, *(s + i) - 48);
            i = i + 1;
        }
        if i < len && *(s + i) == 46 {
            i = i + 1;
            f32 frac = 0.1f;
            while i < len && *(s + i) >= 48 && *(s + i) <= 57 {
                result = result + cast(f32, *(s + i) - 48) * frac;
                frac = frac * 0.1f;
                i = i + 1;
            }
        }
        return result * sign;
    }

    i32 __minc_vsscanf(u8* s, u8* fmt, &... ap) {
        i32 si = 0;
        i32 fi = 0;
        i32 count = 0;
        while *(fmt + fi) != 0 {
            u8 fc = *(fmt + fi);
            if __sc_ws(fc) {
                while __sc_ws(*(s + si)) { si = si + 1; }
                fi = fi + 1;
            } else if fc != 37 {
                if *(s + si) != fc { break; }
                si = si + 1;
                fi = fi + 1;
            } else {
                fi = fi + 1;                 // past '%'
                i32 width = 0;
                bool hasWidth = false;
                while *(fmt + fi) >= 48 && *(fmt + fi) <= 57 {
                    width = width * 10 + cast(i32, *(fmt + fi) - 48);
                    hasWidth = true;
                    fi = fi + 1;
                }
                u8 conv = *(fmt + fi);
                fi = fi + 1;
                if conv == 105 || conv == 100 || conv == 117 {   // %i %d %u
                    while __sc_ws(*(s + si)) { si = si + 1; }
                    i64 sign = 1;
                    if *(s + si) == 45 { sign = 0 - 1; si = si + 1; }
                    else if *(s + si) == 43 { si = si + 1; }
                    bool any = false;
                    i64 v = 0;
                    while *(s + si) >= 48 && *(s + si) <= 57 {
                        v = v * 10 + cast(i64, *(s + si) - 48);
                        si = si + 1;
                        any = true;
                    }
                    if !any { break; }
                    i32* out = cast(i32*, arg_read_ptr(ap));
                    *out = cast(i32, v * sign);
                    count = count + 1;
                } else if conv == 102 {                          // %f
                    while __sc_ws(*(s + si)) { si = si + 1; }
                    i32 start = si;
                    if *(s + si) == 45 || *(s + si) == 43 { si = si + 1; }
                    while (*(s + si) >= 48 && *(s + si) <= 57) || *(s + si) == 46 { si = si + 1; }
                    if si == start { break; }
                    f32* out = cast(f32*, arg_read_ptr(ap));
                    *out = __sc_atof(s + start, si - start);
                    count = count + 1;
                } else if conv == 115 {                          // %s
                    while __sc_ws(*(s + si)) { si = si + 1; }
                    u8* out = cast(u8*, arg_read_ptr(ap));
                    i32 n = 0;
                    while *(s + si) != 0 && !__sc_ws(*(s + si)) && (!hasWidth || n < width - 1) {
                        *(out + n) = *(s + si); n = n + 1; si = si + 1;
                    }
                    *(out + n) = 0;
                    count = count + 1;
                } else if conv == 91 {                           // %[set]
                    bool negate = false;
                    if *(fmt + fi) == 94 { negate = true; fi = fi + 1; }   // '^'
                    u8 setc = *(fmt + fi);                                  // single-char set
                    while *(fmt + fi) != 0 && *(fmt + fi) != 93 { fi = fi + 1; }  // to ']'
                    if *(fmt + fi) == 93 { fi = fi + 1; }
                    u8* out = cast(u8*, arg_read_ptr(ap));
                    i32 n = 0;
                    while *(s + si) != 0 && (!hasWidth || n < width - 1) {
                        bool inset = *(s + si) == setc;
                        if negate && inset { break; }
                        if !negate && !inset { break; }
                        *(out + n) = *(s + si); n = n + 1; si = si + 1;
                    }
                    *(out + n) = 0;
                    count = count + 1;
                } else if conv == 37 {                           // %%
                    if *(s + si) == 37 { si = si + 1; }
                }
            }
        }
        return count;
    }
    i32 sscanf(u8* s, u8* fmt, ...) { return __minc_vsscanf(s, fmt, &...); }
}
