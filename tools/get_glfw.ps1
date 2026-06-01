# get_glfw.ps1 — download a pinned GLFW Windows release.
#
# raylib-minc needs `glfw3.dll` next to the runtime binary. On Windows
# this script fetches a pinned upstream release, verifies its SHA-256,
# and drops `tools/glfw3.dll` for `build.ps1` to copy next to each
# example's exe. Linux/macOS users install GLFW via their system
# package manager (apt/brew); see README.md.
#
# Run once per checkout — the result is reused for every example.

$ErrorActionPreference = 'Stop'

$GlfwVersion = '3.4'
$GlfwUrl     = "https://github.com/glfw/glfw/releases/download/$GlfwVersion/glfw-$GlfwVersion.bin.WIN64.zip"
# SHA-256 of the upstream archive — pinned to the upstream
# glfw-3.4.bin.WIN64.zip release. If the download doesn't match, the
# script aborts. To rotate to a newer GLFW: bump $GlfwVersion + run
# the script once (it'll print the new SHA-256), paste it here.
$GlfwSha256  = '54efa829400f2a0537f742b2b3bdd74e437bb4f2f048e4b7d3c5557d11a611e6'

$here    = Split-Path -Parent $MyInvocation.MyCommand.Path
$zip     = Join-Path $here "glfw-$GlfwVersion.bin.WIN64.zip"
$extract = Join-Path $here "glfw-$GlfwVersion.bin.WIN64"
$outDll  = Join-Path $here 'glfw3.dll'

if (Test-Path $outDll) {
    Write-Host "glfw3.dll already present at $outDll — skipping download."
    exit 0
}

Write-Host "Downloading GLFW $GlfwVersion from $GlfwUrl"
Invoke-WebRequest -Uri $GlfwUrl -OutFile $zip

$actualSha = (Get-FileHash $zip -Algorithm SHA256).Hash.ToLower()
if ($GlfwSha256 -eq '<unverified-set-on-first-publish>') {
    Write-Warning "SHA-256 not pinned. Got: $actualSha"
    Write-Warning "Update tools/get_glfw.ps1's `$GlfwSha256 with this value to enable verification."
} elseif ($actualSha -ne $GlfwSha256.ToLower()) {
    Remove-Item $zip
    throw "GLFW download SHA-256 mismatch. Expected $GlfwSha256, got $actualSha. Refusing to proceed."
}

Expand-Archive -Path $zip -DestinationPath $here -Force
Copy-Item -Path (Join-Path $extract 'lib-vc2022\glfw3.dll') -Destination $outDll -Force
Remove-Item -Path $extract -Recurse -Force
Remove-Item -Path $zip -Force

Write-Host "OK — glfw3.dll at $outDll"
