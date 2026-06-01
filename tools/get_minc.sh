#!/usr/bin/env bash
# get_minc.sh — download a pinned minc compiler release.
#
# minc is the language picotls-minc is written in. It's a separate
# **closed-source** binary distributed from
# https://github.com/SpacesOfPlay/minc-dev/releases — see LICENSE.md
# at the top of this repo for the disclosure.
#
# This script fetches the pinned version for the current platform,
# verifies its SHA-256, and extracts to `tools/minc/` (gitignored).
# `build.sh` picks it up automatically — no PATH changes needed.
#
# Supported platforms: Linux x64, Linux arm64, macOS arm64.
#
# To rotate: bump MINC_VERSION + each MINC_SHA256_* below, re-run.
# A SHA-256 mismatch aborts.

set -e

MINC_VERSION='0.9.5'
MINC_SHA256_LINUX_X64='d7b995e63d9e8c22ed6173a5358506cfbf1a91b7e7ed3aec6e9e4bcf3a1e06c5'
MINC_SHA256_LINUX_ARM64='41a48e9869ef2c7ad294ce6aa6b614038972ab80ed61315ae68880dde52de4d8'
MINC_SHA256_MACOS_ARM64='d93a34aac948d5946c09b982576a813fd4830373107080a123224964fb448eb5'

uname_s="$(uname -s)"
uname_m="$(uname -m)"
case "$uname_s/$uname_m" in
    Linux/x86_64)             plat='linux-x64';   MINC_SHA256="$MINC_SHA256_LINUX_X64" ;;
    Linux/aarch64|Linux/arm64) plat='linux-arm64'; MINC_SHA256="$MINC_SHA256_LINUX_ARM64" ;;
    Darwin/arm64)             plat='macos-arm64'; MINC_SHA256="$MINC_SHA256_MACOS_ARM64" ;;
    *) echo "Unsupported platform: $uname_s/$uname_m. Available builds: linux-x64, linux-arm64, macos-arm64." >&2; exit 1 ;;
esac

here="$(cd "$(dirname "$0")" && pwd)"
zip_name="minc-${MINC_VERSION}-${plat}.zip"
zip_url="https://github.com/SpacesOfPlay/minc-dev/releases/download/v${MINC_VERSION}/${zip_name}"
zip_path="$here/$zip_name"
dst_dir="$here/minc"
minc_bin="$dst_dir/minc"

if [ -x "$minc_bin" ]; then
    echo "minc already installed at $minc_bin — skipping download."
    echo "(delete tools/minc/ to force a re-fetch.)"
    exit 0
fi

echo "minc compiler is closed-source proprietary software from"
echo "  https://github.com/SpacesOfPlay/minc-dev/"
echo "It is NOT covered by this repo's license. See LICENSE.md."
echo
echo "Downloading minc v$MINC_VERSION from $zip_url"

if command -v curl >/dev/null 2>&1; then
    curl -fSL -o "$zip_path" "$zip_url"
elif command -v wget >/dev/null 2>&1; then
    wget -O "$zip_path" "$zip_url"
else
    echo "Neither curl nor wget found. Install one and re-run." >&2
    exit 1
fi

# SHA-256 verify. Prefer sha256sum (Linux), fall back to shasum (macOS).
if command -v sha256sum >/dev/null 2>&1; then
    actual_sha="$(sha256sum "$zip_path" | awk '{print $1}')"
elif command -v shasum >/dev/null 2>&1; then
    actual_sha="$(shasum -a 256 "$zip_path" | awk '{print $1}')"
else
    echo "Neither sha256sum nor shasum found. Cannot verify download." >&2
    rm -f "$zip_path"
    exit 1
fi

if [ "$MINC_SHA256" = '<unverified-set-on-first-publish>' ]; then
    echo "WARNING: SHA-256 not pinned. Got: $actual_sha" >&2
    echo "Update tools/get_minc.sh's MINC_SHA256 with this value." >&2
elif [ "$actual_sha" != "$MINC_SHA256" ]; then
    rm -f "$zip_path"
    echo "minc download SHA-256 mismatch. Expected $MINC_SHA256, got $actual_sha. Refusing to proceed." >&2
    exit 1
fi

# The zip extracts a `minc-<plat>/` directory at the root. Rename
# to `tools/minc/` so the lookup path is stable across versions.
tmp_extract="$here/__minc_extract"
rm -rf "$tmp_extract"
mkdir -p "$tmp_extract"

if command -v unzip >/dev/null 2>&1; then
    unzip -q "$zip_path" -d "$tmp_extract"
elif command -v python3 >/dev/null 2>&1; then
    python3 -c "import zipfile,sys; zipfile.ZipFile(sys.argv[1]).extractall(sys.argv[2])" "$zip_path" "$tmp_extract"
else
    rm -rf "$tmp_extract"
    rm -f "$zip_path"
    echo "Neither unzip nor python3 found. Install one and re-run." >&2
    exit 1
fi

inner="$tmp_extract/minc-${plat}"
if [ ! -d "$inner" ]; then
    rm -rf "$tmp_extract"
    rm -f "$zip_path"
    echo "Unexpected zip layout — expected minc-${plat}/ at root." >&2
    exit 1
fi

rm -rf "$dst_dir"
mv "$inner" "$dst_dir"
rm -rf "$tmp_extract"
rm -f "$zip_path"
chmod +x "$minc_bin"

echo
echo "OK — minc v$MINC_VERSION installed at $dst_dir"
echo "     license: $dst_dir/LICENSE.md"
echo
echo "Try it: ./build.sh"
