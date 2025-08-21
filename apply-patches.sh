#!/usr/bin/env bash
# Apply custom patches to ZMK before building

set -euo pipefail

PATCHES_DIR="$(pwd)/patches"
ZMK_DIR="$(pwd)/zmk"

if [ -d "$PATCHES_DIR" ]; then
    echo "Applying patches from $PATCHES_DIR..."
    for patch in "$PATCHES_DIR"/*.patch; do
        if [ -f "$patch" ]; then
            echo "Applying patch: $(basename "$patch")"
            (cd "$ZMK_DIR" && git apply "$patch")
        fi
    done
    echo "✅ All patches applied"
else
    echo "No patches directory found"
fi