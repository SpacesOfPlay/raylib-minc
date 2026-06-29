#!/usr/bin/env bash
# run_examples.sh — walk every example in examples/ one at a time.
#
#   ./run_examples.sh                # native: build + run each example. Close the
#                                    #   window (or press Enter) to advance.
#   ./run_examples.sh native 10      # native: start from example #10.
#   ./run_examples.sh wasm           # web: compile all examples, then serve ONE
#                                    #   clickable menu (needs python3). Click an
#                                    #   example, view it, use Back for the menu.
#   PORT=9000 ./run_examples.sh wasm
#
# Native uses build.sh per example (so GLFW etc. resolve exactly like a normal
# build). Web compiles each example to build/web_all/<name>.wasm and writes a
# menu.html that loads them through the harness's ?app=<name>.
set -u
mode="${1:-native}"
start="${2:-1}"
port="${PORT:-8080}"
root="$(cd "$(dirname "$0")" && pwd)"

# collect examples (portable: no `mapfile`, so macOS bash 3.2 works)
exs=()
while IFS= read -r f; do exs+=("$f"); done < <(find "$root/examples" -name '*.mc' -type f | LC_ALL=C sort)
n=${#exs[@]}
[ "$n" -gt 0 ] || { echo "no examples found under $root/examples" >&2; exit 1; }

minc="$root/tools/minc/minc"
[ -x "$minc" ] || minc="$(command -v minc 2>/dev/null || true)"
[ -n "$minc" ] || { echo "minc not found — run ./tools/get_minc.sh (or put minc on PATH)" >&2; exit 1; }

# ---------------------------------------------------------------- web mode
if [ "$mode" = "wasm" ]; then
    web="$root/build/web_all"
    rm -rf "$web"; mkdir -p "$web"
    cp "$root/lib/raylib_wasm_host.js" "$web/"
    cp "$root/lib/raylib_wasm_harness.html" "$web/index.html"

    # Merge every example's resources/ into one dir + a combined manifest.
    # (Every app preloads all assets — harmless. Same-named files collide;
    #  last one wins. Fine for a verification pass.)
    assets_tmp="$web/.assets.tmp"; : > "$assets_tmp"
    for ex in "${exs[@]}"; do
        d="$(dirname "$ex")"
        if [ -d "$d/resources" ]; then
            mkdir -p "$web/resources"
            cp -R "$d/resources/." "$web/resources/"
            ( cd "$d" && find resources -type f ) >> "$assets_tmp"
        fi
    done
    if [ -s "$assets_tmp" ]; then
        sort -u "$assets_tmp" | awk 'BEGIN{printf"["}{printf"%s\"%s\"",(NR>1?",":""),$0}END{printf"]"}' > "$web/assets.json"
    fi
    rm -f "$assets_tmp"

    items="$web/.menu_items"; : > "$items"
    i=0; ok=0; fails=""; last_cat=""
    for ex in "${exs[@]}"; do
        i=$((i + 1))
        name="$(basename "$ex" .mc)"
        cat="$(basename "$(dirname "$ex")")"
        printf "[%d/%d] %-30s" "$i" "$n" "$name"
        if ( cd "$root" && "$minc" "$ex" --target wasm -o "$web/$name.wasm" ) >/dev/null 2>&1; then
            ok=$((ok + 1)); echo " ok"
            [ "$cat" = "$last_cat" ] || { echo "  <h2>$cat</h2>" >> "$items"; last_cat="$cat"; }
            echo "  <a href=\"index.html?app=$name\">$name</a>" >> "$items"
        else
            echo " FAIL"; fails="$fails $name"
        fi
    done

    {
        echo '<!doctype html><meta charset="utf-8"><title>raylib-minc examples</title>'
        echo '<style>'
        echo ' body{background:#222;color:#ddd;font-family:system-ui,sans-serif;padding:2em;max-width:60em;margin:auto}'
        echo ' h1{font-size:1.3em} h2{color:#8ab;border-bottom:1px solid #444;margin-top:1.5em}'
        echo ' a{display:inline-block;min-width:18em;color:#9cf;text-decoration:none;padding:.25em .5em}'
        echo ' a:hover{background:#333}'
        echo '</style>'
        echo "<h1>raylib-minc &mdash; $ok/$n examples (web)</h1>"
        echo '<p>Click an example; use the browser <b>Back</b> button to return here.</p>'
        cat "$items"
    } > "$web/menu.html"
    rm -f "$items"

    echo
    echo "compiled $ok/$n examples -> $web"
    [ -z "$fails" ] || echo "FAILED to compile:$fails"

    py="$(command -v python3 2>/dev/null || command -v python 2>/dev/null || true)"
    [ -n "$py" ] || { echo "python not found — serve '$web' with any static server and open menu.html" >&2; exit 1; }
    # Serve with Cache-Control: no-store so the browser never pins a stale
    # raylib_wasm_host.js / .wasm between runs (plain http.server caches).
    cat > "$web/_serve.py" <<'PY'
import http.server, sys
class H(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cache-Control', 'no-store')
        http.server.SimpleHTTPRequestHandler.end_headers(self)
http.server.HTTPServer(('127.0.0.1', int(sys.argv[1])), H).serve_forever()
PY
    url="http://localhost:$port/menu.html"
    echo "serving at $url  (Ctrl+C to stop)"
    ( cd "$web" && "$py" _serve.py "$port" >/dev/null 2>&1 ) &
    srv=$!
    trap 'kill "$srv" 2>/dev/null' EXIT INT TERM
    sleep 1
    case "$(uname -s)" in
        Darwin) open "$url" 2>/dev/null || true ;;
        *)      xdg-open "$url" 2>/dev/null || true ;;
    esac
    wait "$srv"
    exit 0
fi

# ------------------------------------------------------------- native mode
echo "native run — $n examples. Close each window (or press Enter) for the next."
auto=0
i=0
for ex in "${exs[@]}"; do
    i=$((i + 1))
    [ "$i" -ge "$start" ] || continue
    rel="${ex#$root/}"
    echo
    echo "===== [$i/$n] $rel ====="
    ( "$root/build.sh" "$rel" ) || echo "(build/run failed for $rel)"
    [ "$auto" -eq 1 ] && continue
    while true; do
        printf "[Enter]=next  r=replay  s=skip-prompts  q=quit: "
        read -r k </dev/tty || k=""
        case "$k" in
            q) echo "bye"; exit 0 ;;
            r) ( "$root/build.sh" "$rel" ) || true; continue ;;
            s) auto=1; break ;;
            *) break ;;
        esac
    done
done
echo "done."
