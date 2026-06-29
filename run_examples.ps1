# run_examples.ps1 — walk every example in examples/ one at a time.
#
#   .\run_examples.ps1                 # native: build + run each example. Close
#                                      #   the window (or press Enter) for the next.
#   .\run_examples.ps1 native -Start 10  # native: start from example #10.
#   .\run_examples.ps1 wasm            # web: compile all examples, then serve ONE
#                                      #   clickable menu (needs python). Click an
#                                      #   example, view it, use Back for the menu.
#   .\run_examples.ps1 wasm -Port 9000
#
# Native uses build.ps1 per example (so it picks up GLFW etc. exactly like a
# normal build). Web compiles each example to build/web_all/<name>.wasm and
# writes a menu.html that loads them via the harness's ?app=<name>.
param(
    [Parameter(Position=0)][ValidateSet('native','wasm')][string]$Mode = 'native',
    [int]$Start = 1,
    [int]$Port = 8080
)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$exs = Get-ChildItem (Join-Path $root 'examples') -Recurse -Filter *.mc | Sort-Object FullName
$n = $exs.Count
if ($n -eq 0) { Write-Error "no examples found under $root\examples"; exit 1 }

$minc = Join-Path $root 'tools\minc\minc.exe'
if (-not (Test-Path $minc)) {
    $g = Get-Command minc.exe -ErrorAction SilentlyContinue
    $minc = if ($g) { $g.Source } else { $null }
}
if (-not $minc) { Write-Error "minc not found — run .\tools\get_minc.ps1 (or put minc.exe on PATH)"; exit 1 }

# ---------------------------------------------------------------- web mode
if ($Mode -eq 'wasm') {
    $web = Join-Path $root 'build\web_all'
    if (Test-Path $web) { Remove-Item -Recurse -Force $web }
    New-Item -ItemType Directory -Path $web | Out-Null
    Copy-Item (Join-Path $root 'lib\raylib_wasm_host.js') $web
    Copy-Item (Join-Path $root 'lib\raylib_wasm_harness.html') (Join-Path $web 'index.html')

    # Merge every example's resources/ into one dir + a combined manifest.
    # (Every app preloads all assets — harmless, a few KB extra. Same-named
    #  files across examples collide; last one wins. Fine for a test pass.)
    $assets = New-Object System.Collections.Generic.List[string]
    foreach ($ex in $exs) {
        $resSrc = Join-Path $ex.DirectoryName 'resources'
        if (Test-Path $resSrc) {
            $resDst = Join-Path $web 'resources'
            if (-not (Test-Path $resDst)) { New-Item -ItemType Directory -Path $resDst | Out-Null }
            Copy-Item (Join-Path $resSrc '*') $resDst -Recurse -Force
            Get-ChildItem $resSrc -Recurse -File | ForEach-Object {
                $r = 'resources/' + $_.FullName.Substring($resSrc.Length + 1).Replace('\', '/')
                if (-not $assets.Contains($r)) { $assets.Add($r) }
            }
        }
    }
    if ($assets.Count -gt 0) {
        Set-Content -Path (Join-Path $web 'assets.json') `
            -Value ('[' + (($assets | ForEach-Object { '"' + $_ + '"' }) -join ',') + ']') -NoNewline
    }

    $items = New-Object System.Text.StringBuilder
    $i = 0; $ok = 0; $fails = @(); $lastCat = ''
    foreach ($ex in $exs) {
        $i++; $name = $ex.BaseName
        $cat = Split-Path -Leaf $ex.DirectoryName
        Write-Host ("[{0}/{1}] {2,-30}" -f $i, $n, $name) -NoNewline
        Push-Location $root
        try { & $minc $ex.FullName --target wasm -o (Join-Path $web "$name.wasm") *> $null; $rc = $LASTEXITCODE }
        finally { Pop-Location }
        if ($rc -eq 0) {
            $ok++; Write-Host " ok"
            if ($cat -ne $lastCat) { [void]$items.AppendLine("  <h2>$cat</h2>"); $lastCat = $cat }
            [void]$items.AppendLine("  <a href=""index.html?app=$name"">$name</a>")
        } else { $fails += $name; Write-Host " FAIL" }
    }

    $html = @"
<!doctype html><meta charset="utf-8"><title>raylib-minc examples</title>
<style>
 body{background:#222;color:#ddd;font-family:system-ui,sans-serif;padding:2em;max-width:60em;margin:auto}
 h1{font-size:1.3em} h2{color:#8ab;border-bottom:1px solid #444;margin-top:1.5em}
 a{display:inline-block;min-width:18em;color:#9cf;text-decoration:none;padding:.25em .5em}
 a:hover{background:#333}
</style>
<h1>raylib-minc &mdash; $ok/$n examples (web)</h1>
<p>Click an example; use the browser <b>Back</b> button to return here.</p>
$($items.ToString())
"@
    Set-Content -Path (Join-Path $web 'menu.html') -Value $html

    Write-Host ""
    Write-Host "compiled $ok/$n examples -> $web"
    if ($fails.Count) { Write-Host ("FAILED to compile: " + ($fails -join ', ')) -ForegroundColor Yellow }

    $py = Get-Command python -ErrorAction SilentlyContinue
    if (-not $py) { $py = Get-Command python3 -ErrorAction SilentlyContinue }
    if (-not $py) { Write-Error "python not found — serve '$web' with any static server and open menu.html"; exit 1 }
    # Serve with Cache-Control: no-store so the browser never pins a stale
    # raylib_wasm_host.js / .wasm between runs (plain http.server caches).
    $serve = @"
import http.server, sys
class H(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Cache-Control', 'no-store')
        http.server.SimpleHTTPRequestHandler.end_headers(self)
http.server.HTTPServer(('127.0.0.1', int(sys.argv[1])), H).serve_forever()
"@
    Set-Content -Path (Join-Path $web '_serve.py') -Value $serve
    $url = "http://localhost:$Port/menu.html"
    Write-Host "serving at $url  (Ctrl+C to stop)"
    Start-Process $url
    Push-Location $web
    try { & $py.Source '_serve.py' $Port } finally { Pop-Location }
    exit 0
}

# ------------------------------------------------------------- native mode
$psHost = if (Get-Command pwsh -ErrorAction SilentlyContinue) { 'pwsh' } else { 'powershell' }
$buildPs1 = Join-Path $root 'build.ps1'
Write-Host "native run — $n examples. Close each window (or press Enter) for the next."
$auto = $false
for ($i = $Start; $i -le $n; $i++) {
    $rel = $exs[$i - 1].FullName.Substring($root.Length + 1)
    Write-Host ""
    Write-Host ("===== [{0}/{1}] {2} =====" -f $i, $n, $rel) -ForegroundColor Cyan
    # Run build.ps1 in a child process so its `exit` can't end this loop;
    # -Wait blocks until the example window is closed.
    Start-Process -FilePath $psHost -ArgumentList '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $buildPs1, $rel -Wait -NoNewWindow
    if ($auto) { continue }
    while ($true) {
        $k = Read-Host "[Enter]=next  r=replay  s=skip-prompts  q=quit"
        if ($k -eq 'q') { Write-Host 'bye'; exit 0 }
        if ($k -eq 'r') { Start-Process -FilePath $psHost -ArgumentList '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $buildPs1, $rel -Wait -NoNewWindow; continue }
        if ($k -eq 's') { $auto = $true; break }
        break
    }
}
Write-Host "done."
