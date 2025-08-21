#!/usr/bin/env bash
# Build both halves of the Chocofi Corne + nice‑view and copy UF2s to ./outputs/

set -euo pipefail

# --- user‑tweakable bits -----------------------------------------------------
BOARD="nice_nano_v2"
SHIELD_LEFT="corne_left nice_view_adapter nice_view"
SHIELD_RIGHT="corne_right nice_view_adapter nice_view"
CONFIG_DIR="$(pwd)/config"          # where your .keymap & custom_config live
OUTDIR="$(pwd)/outputs"             # final UF2s land here
APP_DIR="$(pwd)/zmk/app"            # CMakeLists.txt lives here
PATCHES_DIR="$(pwd)/patches"        # custom patches directory
# ----------------------------------------------------------------------------

# Apply patches if patches directory exists
if [ -d "$PATCHES_DIR" ]; then
    echo "🔧 Applying patches..."
    for patch in "$PATCHES_DIR"/*.patch; do
        if [ -f "$patch" ]; then
            echo "   Applying: $(basename "$patch")"
            (cd "$(pwd)/zmk" && git apply "$patch" 2>/dev/null || true)
        fi
    done
fi

build_half () {
  local side=$1
  local shield=$2
  local builddir="build/${side}"

  echo "🏗  Building ${side} (shields: ${shield})"
  west build -p -s "${APP_DIR}" -d "${builddir}" -b "${BOARD}" \
    -- -DSHIELD="${shield}" \
       -DZMK_CONFIG="${CONFIG_DIR}"

  local uf2="${builddir}/zephyr/zmk.uf2"
  local target="${OUTDIR}/chocofi-${side}.uf2"
  mkdir -p "${OUTDIR}"
  cp -v "${uf2}" "${target}"
}

build_half "left"  "${SHIELD_LEFT}"
build_half "right" "${SHIELD_RIGHT}"

echo "✅  Done. UF2s are in ${OUTDIR}/"

