// raylib_wasm_host.js — JS host for the raylib-minc wasm target.
//
// Forked from ../lang/apps/sokol_wasm_host.js: the WebGL2 `gl` import
// table, the i64/BigInt arg marshalling, the f64-bits float decode, and
// the env/VFS surface carry over near-verbatim (rlgl drives GL the same
// way sokol does). What differs is the platform surface: raylib's rcore
// wasm backend (ext/raylib/rcore_wasm_app.mc) imports module "app"
// (rl_host_width / rl_host_height) and the browser drives frames by
// calling the exported `frame()` each requestAnimationFrame, after the
// one-time exported `main()` boots the window (InitWindow).
//
// minc widens every non-math import arg to i64 → BigInt on the JS side;
// f32/f64 cross as the f64 bit-pattern packed in that i64 (fbits()). The
// `math` module is the exception: native f32/f64 signatures, no BigInt.
'use strict';

(() => {
const RL = {};
window.raylibWasm = RL;

RL.onLog = (msg, isError) => { if (isError) console.warn(msg); else console.log(msg); };

// Asset VFS (RPW4): preloadAssets fills this; env.open/read/close serve it.
RL._vfs = {};
RL._fdMap = {};
RL._nextFd = 100;
RL.preloadAssets = async function(paths) {
    if (!paths || paths.length === 0) return;
    await Promise.all(paths.map(async (p) => {
        try {
            const r = await fetch(p);
            if (!r.ok) { console.warn(`preloadAssets: ${p} → HTTP ${r.status}`); return; }
            RL._vfs[p] = new Uint8Array(await r.arrayBuffer());
        } catch (e) { console.warn(`preloadAssets: ${p} → ${e.message}`); }
    }));
};

// --- Mount point ---------------------------------------------------------
const canvas = document.getElementById('canvas');
if (!canvas) { RL._initError = new Error('raylib_wasm_host: <canvas id="canvas"> required'); }
const gl = canvas && canvas.getContext('webgl2', { antialias: true, alpha: false, depth: true, stencil: true });
if (canvas && !gl) { RL._initError = new Error('raylib_wasm_host: WebGL2 not available'); }
if (gl) (gl.getSupportedExtensions() || []).forEach(name => gl.getExtension(name));

// --- Memory + arg decoding ----------------------------------------------
let memory = null;
let instance = null;
const u8view = () => new Uint8Array(memory.buffer);
const readString = (ptr, len) => new TextDecoder().decode(u8view().slice(Number(ptr), Number(ptr) + Number(len)));
const readCStr = (ptr) => {
    const u8 = u8view(); const start = Number(ptr); let end = start;
    while (u8[end] !== 0 && end - start < 8192) end++;
    return new TextDecoder().decode(u8.subarray(start, end));
};
const _8 = new ArrayBuffer(8);
const _u64 = new BigUint64Array(_8);
const _f64 = new Float64Array(_8);
const fbits = (b) => { _u64[0] = BigInt.asUintN(64, BigInt(b)); return _f64[0]; };
const v = (fn) => (...args) => { fn(...args); return 0n; };
const N = (x) => Number(x);

// --- WebGL handle table --------------------------------------------------
const handles = [null];
const put = (o) => { handles.push(o); return BigInt(handles.length - 1); };
const get = (id) => handles[Number(id)];
const arr = (kind, ptr, count) => {
    const buf = memory.buffer, off = N(ptr), c = N(count);
    if (kind === 'f32') return new Float32Array(buf, off, c);
    if (kind === 'i32') return new Int32Array(buf, off, c);
    if (kind === 'u32') return new Uint32Array(buf, off, c);
    if (kind === 'u8')  return new Uint8Array(buf, off, c);
};
const writeStr = (ptr, s) => { const b = new TextEncoder().encode(s); u8view().set(b, N(ptr)); u8view()[N(ptr) + b.length] = 0; };

// --- requestAnimationFrame loop -----------------------------------------
let running = false;
function syncCanvasSize() {
    const dpr = window.devicePixelRatio || 1;
    const w = Math.max(1, Math.floor(canvas.clientWidth * dpr));
    const h = Math.max(1, Math.floor(canvas.clientHeight * dpr));
    if (canvas.width !== w || canvas.height !== h) { canvas.width = w; canvas.height = h; }
}
function rafLoop() {
    if (!running) return;
    try {
        if (instance.exports.frame) instance.exports.frame();
        // Honor SetExitKey/Escape/CloseWindow — stop the loop and clean up.
        if (instance.exports.rl_should_close && Number(instance.exports.rl_should_close())) {
            running = false;
            if (instance.exports.cleanup) instance.exports.cleanup();
            return;
        }
    } catch (e) { console.error('frame error:', e); running = false; return; }
    requestAnimationFrame(rafLoop);
}

// --- Imports -------------------------------------------------------------
RL.makeImports = function() {
    return {
        env: {
            write: (fd, ptr, len) => { RL.onLog(readString(ptr, len), N(fd) === 2); return BigInt(N(len)); },
            clock: () => BigInt(Math.round(performance.now() * 1e6)),
            open: (pathPtr, flags) => {
                // Normalize the path: raylib's GetDirectoryPath prepends
                // "./" (e.g. a .fnt's texture → "./resources/foo.png"), but
                // the VFS is keyed by the asset path ("resources/foo.png").
                const raw = readCStr(pathPtr);
                const norm = raw.replace(/^(\.\/)+/, '');
                const data = RL._vfs[norm] || RL._vfs[raw] || RL._vfs[norm.replace(/^.*\//, '')];
                if (!data) return -1n;
                const fd = RL._nextFd++; RL._fdMap[fd] = { data, pos: 0 };
                return BigInt(fd);
            },
            read: (fd, ptr, len) => {
                const f = RL._fdMap[N(fd)]; if (!f) return 0n;
                const n = Math.min(f.data.length - f.pos, N(len)); if (n <= 0) return 0n;
                u8view().set(f.data.subarray(f.pos, f.pos + n), N(ptr)); f.pos += n;
                return BigInt(n);
            },
            close: (fd) => { delete RL._fdMap[N(fd)]; return 0n; },
            fsize: (fd) => { const f = RL._fdMap[N(fd)]; return BigInt(f ? f.data.length : -1); },
            __sys_exit: (code) => { running = false; throw new Error('__sys_exit(' + N(code) + ')'); },
        },

        // raylib rcore wasm platform backend host helpers.
        app: {
            rl_host_width:  () => BigInt(canvas.width),
            rl_host_height: () => BigInt(canvas.height),
            rl_host_dpi_x1000: () => BigInt(Math.round((window.devicePixelRatio || 1) * 1000)),
            // DisableCursor/EnableCursor. Pointer lock needs a user gesture,
            // so just arm/disarm here; attachInput grabs it on the next click.
            rl_host_set_cursor_lock: (lock) => {
                RL._wantLock = N(lock) !== 0;
                if (!RL._wantLock && document.pointerLockElement) document.exitPointerLock();
            },
        },

        // Native f32/f64 — no BigInt marshalling.
        math: {
            sin: Math.sin, cos: Math.cos, tan: Math.tan, asin: Math.asin,
            acos: Math.acos, atan: Math.atan, atan2: Math.atan2, exp: Math.exp,
            log: Math.log, log2: Math.log2, log10: Math.log10, pow: Math.pow,
            fmod: (a, b) => a % b, floor: Math.floor, ceil: Math.ceil,
            sinf: Math.sin, cosf: Math.cos, tanf: Math.tan, asinf: Math.asin,
            acosf: Math.acos, atanf: Math.atan, atan2f: Math.atan2, expf: Math.exp,
            logf: Math.log, powf: Math.pow, fmodf: (a, b) => a % b,
            floorf: Math.floor, ceilf: Math.ceil,
        },

        // WebGL2 surface. A Proxy auto-stubs any gl* the module references
        // but WebGL2 doesn't expose (rlgl gates them off at runtime).
        gl: (() => {
            const stubbed = new Set();
            const autoStub = (name) => (...a) => {
                if (!stubbed.has(name)) { stubbed.add(name); console.warn(`[raylib] gl auto-stub: ${name}(${a.length})`); }
                return 0n;
            };
            const table = {
                glViewport: v((x,y,w,h) => gl.viewport(N(x),N(y),N(w),N(h))),
                glScissor:  v((x,y,w,h) => gl.scissor(N(x),N(y),N(w),N(h))),
                glClearColor: v((r,g,b,a) => gl.clearColor(fbits(r),fbits(g),fbits(b),fbits(a))),
                glClearDepthf: v((d) => gl.clearDepth(fbits(d))),
                glClear: v((m) => gl.clear(N(m))),
                glEnable: v((c) => gl.enable(N(c))),
                glDisable: v((c) => gl.disable(N(c))),
                glColorMask: v((r,g,b,a) => gl.colorMask(!!N(r),!!N(g),!!N(b),!!N(a))),
                glDepthMask: v((m) => gl.depthMask(!!N(m))),
                glDepthFunc: v((f) => gl.depthFunc(N(f))),
                glCullFace: v((m) => gl.cullFace(N(m))),
                glFrontFace: v((m) => gl.frontFace(N(m))),
                glBlendFunc: v((s,d) => gl.blendFunc(N(s),N(d))),
                glBlendFuncSeparate: v((sr,dr,sa,da) => gl.blendFuncSeparate(N(sr),N(dr),N(sa),N(da))),
                glBlendEquation: v((m) => gl.blendEquation(N(m))),
                glBlendColor: v((r,g,b,a) => gl.blendColor(fbits(r),fbits(g),fbits(b),fbits(a))),
                glPixelStorei: v((p,x) => gl.pixelStorei(N(p),N(x))),
                glPolygonOffset: v((a,b) => gl.polygonOffset(fbits(a),fbits(b))),

                glGenBuffers: v((n,ptr) => { const a=arr('u32',ptr,N(n)); for(let k=0;k<N(n);k++) a[k]=Number(put(gl.createBuffer())); }),
                glDeleteBuffers: v((n,ptr) => { const a=arr('u32',ptr,N(n)); for(let k=0;k<N(n);k++){ gl.deleteBuffer(get(a[k])); handles[a[k]]=null; } }),
                glBindBuffer: v((t,b) => gl.bindBuffer(N(t),get(b))),
                glBufferData: v((t,sz,ptr,u) => { if(N(ptr)===0) gl.bufferData(N(t),N(sz),N(u)); else gl.bufferData(N(t),arr('u8',ptr,sz),N(u)); }),
                glBufferSubData: v((t,off,sz,ptr) => gl.bufferSubData(N(t),N(off),arr('u8',ptr,sz))),

                glGenVertexArrays: v((n,ptr) => { const a=arr('u32',ptr,N(n)); for(let k=0;k<N(n);k++) a[k]=Number(put(gl.createVertexArray())); }),
                glDeleteVertexArrays: v((n,ptr) => { const a=arr('u32',ptr,N(n)); for(let k=0;k<N(n);k++){ gl.deleteVertexArray(get(a[k])); handles[a[k]]=null; } }),
                glBindVertexArray: v((va) => gl.bindVertexArray(get(va))),
                glEnableVertexAttribArray: v((i) => gl.enableVertexAttribArray(N(i))),
                glDisableVertexAttribArray: v((i) => gl.disableVertexAttribArray(N(i))),
                glVertexAttribPointer: v((i,sz,t,nm,st,off) => gl.vertexAttribPointer(N(i),N(sz),N(t),!!N(nm),N(st),N(off))),
                glVertexAttrib4fv: v((i,ptr) => gl.vertexAttrib4fv(N(i),arr('f32',ptr,4))),

                glGenTextures: v((n,ptr) => { const a=arr('u32',ptr,N(n)); for(let k=0;k<N(n);k++) a[k]=Number(put(gl.createTexture())); }),
                glDeleteTextures: v((n,ptr) => { const a=arr('u32',ptr,N(n)); for(let k=0;k<N(n);k++){ gl.deleteTexture(get(a[k])); handles[a[k]]=null; } }),
                glActiveTexture: v((u) => gl.activeTexture(N(u))),
                glBindTexture: v((t,x) => gl.bindTexture(N(t),get(x))),
                glTexParameteri: v((t,p,x) => gl.texParameteri(N(t),N(p),N(x))),
                glTexImage2D: v((t,l,ifmt,w,h,b,fmt,ty,ptr) => {
                    const wn=N(w),hn=N(h),fmtn=N(fmt),tyn=N(ty);
                    const bpp=(fmtn===0x1908?4:fmtn===0x1907?3:fmtn===0x190A?2:1)*(tyn===0x1406?4:1);
                    const d=N(ptr)?new Uint8Array(memory.buffer,N(ptr),wn*hn*bpp):null;
                    gl.texImage2D(N(t),N(l),N(ifmt),wn,hn,N(b),fmtn,tyn,d);
                }),
                glGenerateMipmap: v((t) => gl.generateMipmap(N(t))),
                glTexParameterf: v((t,p,x) => gl.texParameterf(N(t),N(p),fbits(x))),
                glPixelStorei: v((p,x) => gl.pixelStorei(N(p),N(x))),

                // Framebuffers + renderbuffers (raylib RenderTexture2D /
                // BeginTextureMode → rlLoadFramebuffer). Objects live in the
                // handle table like buffers/textures.
                glGenFramebuffers: v((n,ptr) => { const a=arr('u32',ptr,N(n)); for(let k=0;k<N(n);k++) a[k]=Number(put(gl.createFramebuffer())); }),
                glDeleteFramebuffers: v((n,ptr) => { const a=arr('u32',ptr,N(n)); for(let k=0;k<N(n);k++){ gl.deleteFramebuffer(get(a[k])); handles[a[k]]=null; } }),
                glBindFramebuffer: v((t,fb) => gl.bindFramebuffer(N(t),get(fb))),
                glCheckFramebufferStatus: (t) => BigInt(gl.checkFramebufferStatus(N(t))),
                glFramebufferTexture2D: v((t,att,tt,tex,lvl) => gl.framebufferTexture2D(N(t),N(att),N(tt),get(tex),N(lvl))),
                glFramebufferRenderbuffer: v((t,att,rt,rb) => gl.framebufferRenderbuffer(N(t),N(att),N(rt),get(rb))),
                glGenRenderbuffers: v((n,ptr) => { const a=arr('u32',ptr,N(n)); for(let k=0;k<N(n);k++) a[k]=Number(put(gl.createRenderbuffer())); }),
                glDeleteRenderbuffers: v((n,ptr) => { const a=arr('u32',ptr,N(n)); for(let k=0;k<N(n);k++){ gl.deleteRenderbuffer(get(a[k])); handles[a[k]]=null; } }),
                glBindRenderbuffer: v((t,rb) => gl.bindRenderbuffer(N(t),get(rb))),
                glRenderbufferStorage: v((t,fmt,w,h) => gl.renderbufferStorage(N(t),N(fmt),N(w),N(h))),

                glCreateShader: (t) => BigInt(put(gl.createShader(N(t)))),
                glDeleteShader: v((s) => gl.deleteShader(get(s))),
                glShaderSource: v((s,count,strs,lens) => {
                    const sp=arr('u32',strs,N(count)); const lp=N(lens)===0?null:arr('i32',lens,N(count));
                    let src=''; for(let k=0;k<N(count);k++){ const p=sp[k]; const l=lp?lp[k]:(()=>{let e=p;while(u8view()[e]!==0)e++;return e-p;})(); src+=readString(p,l); }
                    const sh=get(s); gl.shaderSource(sh,src); sh._src=src;
                }),
                glCompileShader: v((s) => { const sh=get(s); gl.compileShader(sh); if(!gl.getShaderParameter(sh,gl.COMPILE_STATUS)){ RL.onLog('shader compile failed:\n'+sh._src+'\n'+(gl.getShaderInfoLog(sh)||''),true);} }),
                glGetShaderiv: v((s,p,ptr) => { const pn=N(p); let val = pn===0x8B84 ? (gl.getShaderInfoLog(get(s))||'').length+1 : gl.getShaderParameter(get(s),pn); arr('i32',ptr,1)[0]=val|0; }),
                glGetShaderInfoLog: v((s,max,lp,logp) => { const l=(gl.getShaderInfoLog(get(s))||'').slice(0,N(max)-1); writeStr(logp,l); if(N(lp)) arr('i32',lp,1)[0]=l.length; }),
                glCreateProgram: () => BigInt(put(gl.createProgram())),
                glDeleteProgram: v((p) => gl.deleteProgram(get(p))),
                glAttachShader: v((p,s) => gl.attachShader(get(p),get(s))),
                glLinkProgram: v((p) => { const pr=get(p); gl.linkProgram(pr); if(!gl.getProgramParameter(pr,gl.LINK_STATUS)){ RL.onLog('program link failed:\n'+(gl.getProgramInfoLog(pr)||''),true);} }),
                glUseProgram: v((p) => gl.useProgram(get(p))),
                glGetProgramiv: v((p,pn,ptr) => { const n=N(pn); let val = n===0x8B84 ? (gl.getProgramInfoLog(get(p))||'').length+1 : gl.getProgramParameter(get(p),n); arr('i32',ptr,1)[0]=val|0; }),
                glGetProgramInfoLog: v((p,max,lp,logp) => { const l=(gl.getProgramInfoLog(get(p))||'').slice(0,N(max)-1); writeStr(logp,l); if(N(lp)) arr('i32',lp,1)[0]=l.length; }),
                glGetAttribLocation: (p,ptr) => BigInt(gl.getAttribLocation(get(p),readCStr(ptr))),
                glBindAttribLocation: v((p,i,ptr) => gl.bindAttribLocation(get(p),N(i),readCStr(ptr))),
                glGetUniformLocation: (p,ptr) => { const loc=gl.getUniformLocation(get(p),readCStr(ptr)); return BigInt(loc===null?-1:put(loc)); },
                glUniform1i: v((l,x) => gl.uniform1i(get(l),N(x))),
                glUniform1f: v((l,x) => gl.uniform1f(get(l),fbits(x))),
                glUniform4f: v((l,x,y,z,w) => gl.uniform4f(get(l),fbits(x),fbits(y),fbits(z),fbits(w))),
                glUniform1fv: v((l,n,ptr) => gl.uniform1fv(get(l),arr('f32',ptr,N(n)))),
                glUniform2fv: v((l,n,ptr) => gl.uniform2fv(get(l),arr('f32',ptr,2*N(n)))),
                glUniform3fv: v((l,n,ptr) => gl.uniform3fv(get(l),arr('f32',ptr,3*N(n)))),
                glUniform4fv: v((l,n,ptr) => gl.uniform4fv(get(l),arr('f32',ptr,4*N(n)))),
                glUniform1iv: v((l,n,ptr) => gl.uniform1iv(get(l),arr('i32',ptr,N(n)))),
                glUniformMatrix4fv: v((l,n,t,ptr) => gl.uniformMatrix4fv(get(l),!!N(t),arr('f32',ptr,16*N(n)))),

                glDrawArrays: v((m,f,c) => gl.drawArrays(N(m),N(f),N(c))),
                glDrawElements: v((m,c,t,off) => gl.drawElements(N(m),N(c),N(t),N(off))),
                glGetIntegerv: v((pname,ptr) => {
                    const np=N(pname); let val;
                    if(np===0x821B) val=3; else if(np===0x821C) val=0;
                    else if(np===0x821D) val=(gl.getSupportedExtensions()||[]).length;
                    else { const r=gl.getParameter(np); if(typeof r==='number') arr('i32',ptr,1)[0]=r; else arr('i32',ptr,1)[0]=0; return; }
                    arr('i32',ptr,1)[0]=val;
                }),
                glGetFloatv: v((pname,ptr) => {
                    const r = gl.getParameter(N(pname));
                    if (typeof r === 'number') arr('f32',ptr,1)[0] = r;
                    else if (r && r.length) { const a = arr('f32',ptr,r.length); for (let k=0;k<r.length;k++) a[k]=r[k]; }
                    else arr('f32',ptr,1)[0] = 0;
                }),
                glGetString: (name) => 0n,
                glGetError: () => BigInt(gl.getError()),
            };
            return new Proxy(table, { get(t,p){ if(p in t) return t[p]; if(typeof p==='string'&&p.startsWith('gl')) return autoStub(p); return undefined; } });
        })(),
    };
};

// --- DOM input → raylib KeyboardKey (== GLFW keycodes) ------------------
const KEYCODE_MAP = {
    'Space':32,'Quote':39,'Comma':44,'Minus':45,'Period':46,'Slash':47,
    'Digit0':48,'Digit1':49,'Digit2':50,'Digit3':51,'Digit4':52,'Digit5':53,
    'Digit6':54,'Digit7':55,'Digit8':56,'Digit9':57,'Semicolon':59,'Equal':61,
    'KeyA':65,'KeyB':66,'KeyC':67,'KeyD':68,'KeyE':69,'KeyF':70,'KeyG':71,
    'KeyH':72,'KeyI':73,'KeyJ':74,'KeyK':75,'KeyL':76,'KeyM':77,'KeyN':78,
    'KeyO':79,'KeyP':80,'KeyQ':81,'KeyR':82,'KeyS':83,'KeyT':84,'KeyU':85,
    'KeyV':86,'KeyW':87,'KeyX':88,'KeyY':89,'KeyZ':90,
    'BracketLeft':91,'Backslash':92,'BracketRight':93,'Backquote':96,
    'Escape':256,'Enter':257,'Tab':258,'Backspace':259,'Insert':260,'Delete':261,
    'ArrowRight':262,'ArrowLeft':263,'ArrowDown':264,'ArrowUp':265,
    'PageUp':266,'PageDown':267,'Home':268,'End':269,'CapsLock':280,
    'ScrollLock':281,'NumLock':282,'PrintScreen':283,'Pause':284,
    'F1':290,'F2':291,'F3':292,'F4':293,'F5':294,'F6':295,'F7':296,'F8':297,
    'F9':298,'F10':299,'F11':300,'F12':301,
    'ShiftLeft':340,'ControlLeft':341,'AltLeft':342,'MetaLeft':343,
    'ShiftRight':344,'ControlRight':345,'AltRight':346,'MetaRight':347,
};
const mapKey = (code) => KEYCODE_MAP[code] || 0;
// DOM button 0=left,1=middle,2=right → raylib LEFT=0,RIGHT=1,MIDDLE=2.
const mapBtn = (b) => (b === 0 ? 0 : b === 1 ? 2 : b === 2 ? 1 : b);
const KEYS_TO_PREVENT = new Set(['Tab','ArrowUp','ArrowDown','ArrowLeft','ArrowRight',
    'F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12','Space']);

function mousePos(ev) {
    const r = canvas.getBoundingClientRect();
    // CSS coords → backbuffer pixels (handles display ≠ buffer size / dpr).
    const sx = canvas.width / (r.width || canvas.width);
    const sy = canvas.height / (r.height || canvas.height);
    return [(ev.clientX - r.left) * sx, (ev.clientY - r.top) * sy];
}

function attachInput(inst) {
    const ex = inst.exports;
    const isEditable = () => { const t = document.activeElement; return t && (t.tagName === 'INPUT' || t.tagName === 'TEXTAREA' || t.isContentEditable); };
    window.addEventListener('keydown', (e) => {
        if (isEditable()) return;
        if (KEYS_TO_PREVENT.has(e.code)) e.preventDefault();
        if (ex.rl_wasm_key) ex.rl_wasm_key(mapKey(e.code), 1);
        if (ex.rl_wasm_char && typeof e.key === 'string' && e.key.length === 1) {
            const cp = e.key.codePointAt(0); if (cp >= 0x20) ex.rl_wasm_char(cp);  // u32 param = JS number
        }
    });
    window.addEventListener('keyup', (e) => { if (isEditable()) return; if (ex.rl_wasm_key) ex.rl_wasm_key(mapKey(e.code), 0); });
    canvas.addEventListener('mousemove', (e) => {
        if (document.pointerLockElement === canvas) {
            // Locked (DisableCursor): feed relative motion for GetMouseDelta.
            const dpr = canvas.width / (canvas.getBoundingClientRect().width || canvas.width);
            if (ex.rl_wasm_mouse_delta) ex.rl_wasm_mouse_delta(e.movementX * dpr, e.movementY * dpr);
        } else {
            const [x,y] = mousePos(e); if (ex.rl_wasm_mouse_pos) ex.rl_wasm_mouse_pos(x,y);
        }
    });
    canvas.addEventListener('mousedown', (e) => {
        // If the app asked to hide the cursor (DisableCursor), grab pointer
        // lock now — this click is the required user gesture.
        if (RL._wantLock && document.pointerLockElement !== canvas && canvas.requestPointerLock) canvas.requestPointerLock();
        if (ex.rl_wasm_mouse_button) ex.rl_wasm_mouse_button(mapBtn(e.button), 1);
    });
    window.addEventListener('mouseup', (e) => { if (ex.rl_wasm_mouse_button) ex.rl_wasm_mouse_button(mapBtn(e.button), 0); });
    canvas.addEventListener('mouseenter', () => { if (ex.rl_wasm_cursor_enter) ex.rl_wasm_cursor_enter(1); });
    canvas.addEventListener('mouseleave', () => { if (ex.rl_wasm_cursor_enter) ex.rl_wasm_cursor_enter(0); });
    canvas.addEventListener('wheel', (e) => { e.preventDefault(); if (ex.rl_wasm_mouse_wheel) ex.rl_wasm_mouse_wheel(-e.deltaX/100, -e.deltaY/100); }, { passive: false });
    canvas.addEventListener('contextmenu', (e) => e.preventDefault());
}

// --- Boot ----------------------------------------------------------------
RL.runFromBytes = async function(bytes) {
    if (RL._initError) throw RL._initError;
    syncCanvasSize();
    const { instance: inst } = await WebAssembly.instantiate(bytes, RL.makeImports());
    instance = inst; memory = inst.exports.memory; RL.instance = inst;
    inst.exports.main();              // InitWindow + setup (sets raylib's render size)
    // Size the canvas drawing buffer to raylib's render size so its
    // glViewport fills the whole buffer (not a bottom-left corner). CSS
    // (#canvas { width:100% }) scales that buffer to the page.
    if (inst.exports.rl_render_width && inst.exports.rl_render_height) {
        const rw = Number(inst.exports.rl_render_width());
        const rh = Number(inst.exports.rl_render_height());
        if (rw > 0 && rh > 0) {
            // Backbuffer = raylib's render size (physical px under HiDPI).
            canvas.width = rw; canvas.height = rh;
            // CSS display size = logical screen size, so a HiDPI backbuffer
            // maps 1:1 to device pixels (crisp) instead of being upscaled.
            if (inst.exports.rl_screen_width && inst.exports.rl_screen_height) {
                canvas.style.width  = Number(inst.exports.rl_screen_width())  + 'px';
                canvas.style.height = Number(inst.exports.rl_screen_height()) + 'px';
            }
            gl.viewport(0, 0, rw, rh);
        }
    }
    attachInput(inst);
    if (inst.exports.frame) { running = true; requestAnimationFrame(rafLoop); }
};
RL.run = async function(wasmPath) {
    const bytes = await fetch(wasmPath).then(r => r.arrayBuffer());
    return RL.runFromBytes(bytes);
};

// `minc run --target wasm` generated-shell entry point.
RL.start = function({ wasmPath, canvas: _c }) { return RL.run(wasmPath); };

})();
