# build.ps1 — build (and run) a raylib-minc example.
#
# Usage:
#   ./build.ps1                          # build + run examples/core/core_basic_window.mc
#   ./build.ps1 <path-to-main.mc>        # build + run any .mc file
#   ./build.ps1 <path-to-main.mc> -NoRun # just compile, don't run
#
# Examples:
#   ./build.ps1 examples/shapes/shapes_basic_shapes.mc
#   ./build.ps1 my_game/main.mc
#
# Your `.mc` file just writes:
#
#   import raylib;
#   i32 main() { InitWindow(...); ... }
#
# The binary is named after the .mc file's stem. If the .mc sits
# next to a `resources/` subdir, that subdir is mirrored into
# `build/` so relative `LoadImage("resources/...")` calls resolve.

param(
    [Parameter(Position=0)]
    [string]$Source,
    [switch]$NoRun
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path

# No argument → run the canonical hello-window example. Self-contained
# (no assets, no codecs) so it'll always work on a fresh clone; serves
# as the smoke-test for "does this dist work".
$defaultExample = "examples\core\core_basic_window.mc"
if (-not $Source) {
    $Source = $defaultExample
    Write-Host "no source given — running default example: $Source"
    Write-Host "  other examples:"
    Get-ChildItem (Join-Path $root 'examples') -Recurse -Filter *.mc |
        Where-Object { $_.FullName -ne (Join-Path $root $defaultExample) } |
        ForEach-Object {
            $rel = $_.FullName.Substring($root.Length + 1).Replace('\', '/')
            Write-Host "    ./build.ps1 $rel"
        }
    Write-Host ""
}

$srcPath = if ([System.IO.Path]::IsPathRooted($Source)) { $Source } else { Join-Path $root $Source }

# Accept either `<dir>/<file>.mc` or `<dir>` (legacy: dir containing main.mc).
if ((Test-Path $srcPath -PathType Container)) {
    $mainMc = Join-Path $srcPath 'main.mc'
    if (-not (Test-Path $mainMc)) { Write-Error "no main.mc in $srcPath"; exit 1 }
} else {
    $mainMc = $srcPath
    if (-not (Test-Path $mainMc)) { Write-Error "no such file: $mainMc"; exit 1 }
}

$srcDir = Split-Path -Parent $mainMc
$name   = [System.IO.Path]::GetFileNameWithoutExtension($mainMc)

# Locate the minc compiler — tools/minc/ (get_minc.ps1 drops it here),
# then PATH.
$minc = $null
$localMinc = Join-Path $root 'tools\minc\minc.exe'
if (Test-Path $localMinc) {
    $minc = (Resolve-Path $localMinc).Path
} else {
    $minc = (Get-Command minc.exe -ErrorAction SilentlyContinue).Source
}
if (-not $minc) {
    Write-Host ""
    Write-Host "minc compiler not found." -ForegroundColor Red
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  1. Auto-fetch the pinned closed-source binary:"
    Write-Host "       .\tools\get_minc.ps1"
    Write-Host "     (drops a tools\minc\minc.exe; gitignored; license at tools\minc\LICENSE.md)"
    Write-Host ""
    Write-Host "  2. Install manually from"
    Write-Host "       https://github.com/SpacesOfPlay/minc-dev/releases"
    Write-Host "     and put minc.exe on PATH."
    Write-Host ""
    Write-Host "See README.md (Prerequisites) and LICENSE.md (minc is separately licensed)."
    exit 1
}

$dll = Join-Path $root 'tools\glfw3.dll'
if (-not (Test-Path $dll)) {
    Write-Error "glfw3.dll not found at $dll. Run ./tools/get_glfw.ps1 first."
    exit 1
}

$libDir = Join-Path $root 'lib'
if (-not (Test-Path (Join-Path $libDir 'raylib.mc'))) {
    Write-Error "missing $libDir\raylib.mc — dist is corrupt"; exit 1
}

$buildDir = Join-Path $root 'build'
if (-not (Test-Path $buildDir)) { New-Item -ItemType Directory -Path $buildDir | Out-Null }
$exe = Join-Path $buildDir "$name.exe"

# Run minc with the dist root as CWD so `import raylib;` resolves to
# the lib/raylib.mc shipped in the dist.
Write-Host "compiling $name..."
Push-Location $root
try {
    & $minc $mainMc -o $exe
    if ($LASTEXITCODE -ne 0) {
        Write-Error "minc compile failed."
        exit $LASTEXITCODE
    }
} finally { Pop-Location }

Copy-Item -Path $dll -Destination (Join-Path $buildDir 'glfw3.dll') -Force

# If the example has a resources/ subdir next to it, mirror to build/
# so relative LoadImage("resources/...") resolves from the binary's cwd.
$resourcesSrc = Join-Path $srcDir 'resources'
if (Test-Path $resourcesSrc) {
    $resourcesDst = Join-Path $buildDir 'resources'
    if (Test-Path $resourcesDst) { Remove-Item -Recurse -Force $resourcesDst }
    Copy-Item -Path $resourcesSrc -Destination $resourcesDst -Recurse -Force
}

Write-Host "built $exe"

if (-not $NoRun) {
    Write-Host "running..."
    Push-Location $buildDir
    try {
        & $exe
        exit $LASTEXITCODE
    } finally { Pop-Location }
}
