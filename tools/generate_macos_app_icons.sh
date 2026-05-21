#!/usr/bin/env bash
# generate_macos_app_icons.sh
# Usage:
#   ./generate_macos_app_icons.sh path/to/source.png
# or
#   ./generate_macos_app_icons.sh path/to/source.svg
#
# This script generates the standard macOS app icon PNGs used by Xcode
# and writes them into macos/Runner/Assets.xcassets/AppIcon.appiconset
# It requires either ImageMagick (`convert`) or macOS `sips`.

set -euo pipefail

SRC=${1:-}
if [ -z "$SRC" ]; then
  echo "Error: please provide a source image (SVG or PNG). Example: ./generate_macos_app_icons.sh assets/icon.svg"
  exit 2
fi

APPICON_DIR="macos/Runner/Assets.xcassets/AppIcon.appiconset"
if [ ! -d "$APPICON_DIR" ]; then
  echo "Error: AppIcon.appiconset not found at $APPICON_DIR"
  exit 2
fi

# Ensure source exists
if [ ! -f "$SRC" ]; then
  echo "Error: source file not found: $SRC"
  exit 2
fi

# Create a high-res base PNG (1024x1024)
BASE_TMP="/tmp/app_icon_base_$$.png"

if command -v convert >/dev/null 2>&1; then
  # ImageMagick can rasterize SVG and resize
  convert "$SRC" -resize 1024x1024 "$BASE_TMP"
elif command -v rsvg-convert >/dev/null 2>&1; then
  rsvg-convert -w 1024 -h 1024 "$SRC" -o "$BASE_TMP"
elif [[ "$SRC" == *.png ]]; then
  # If it's a PNG, use sips to create base
  sips -z 1024 1024 "$SRC" --out "$BASE_TMP" >/dev/null
else
  echo "Error: no suitable image converter found. Install ImageMagick (convert) or librsvg (rsvg-convert)."
  exit 3
fi

# Sizes mapping (filename -> pixel size)
declare -A sizes=(
  [app_icon_16.png]=16
  [app_icon_32.png]=32
  [app_icon_64.png]=64
  [app_icon_128.png]=128
  [app_icon_256.png]=256
  [app_icon_512.png]=512
  [app_icon_1024.png]=1024
)

for name in "${!sizes[@]}"; do
  size=${sizes[$name]}
  out="$APPICON_DIR/$name"
  if command -v convert >/dev/null 2>&1; then
    convert "$BASE_TMP" -resize ${size}x${size} "$out"
  else
    sips -z $size $size "$BASE_TMP" --out "$out" >/dev/null
  fi
  echo "Wrote $out ($size x $size)"
done

# Cleanup
rm -f "$BASE_TMP"

echo "Done. Replace the source with a graphic_eq-based SVG/PNG to get the desired icon."

echo "Note: After replacing the icons, clean build and run 'flutter build macos' or open the Xcode project and run to see the new icon in Finder/Spotlight."
