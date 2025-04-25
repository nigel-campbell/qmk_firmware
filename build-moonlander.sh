#!/bin/bash

# Usage: ./build-moonlander.sh <your-keymap-name>
# Example: ./build-moonlander.sh nigel

KEYMAP_NAME=$1
OUTPUT_DIR="./firmware"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

if [ -z "$KEYMAP_NAME" ]; then
  echo "❌ You must specify a keymap name!"
  echo "Usage: $0 <keymap-name>"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

docker run --rm -v "$PWD":/qmk_firmware qmkfm/qmk_cli \
    bash -c "qmk compile -kb moonlander -km $KEYMAP_NAME"

HEX_SOURCE=".build/zsa_moonlander_${KEYMAP_NAME}.hex"
BIN_SOURCE=".build/zsa_moonlander_${KEYMAP_NAME}.bin"

if [ -f "$HEX_SOURCE" ]; then
  cp "$HEX_SOURCE" "$OUTPUT_DIR/zsa_moonlander_${KEYMAP_NAME}_${TIMESTAMP}.hex"
  echo "✅ Copied $HEX_SOURCE -> $OUTPUT_DIR/zsa_moonlander_${KEYMAP_NAME}_${TIMESTAMP}.hex"
else
  echo "❌ HEX file not found!"
fi

if [ -f "$BIN_SOURCE" ]; then
  cp "$BIN_SOURCE" "$OUTPUT_DIR/zsa_moonlander_${KEYMAP_NAME}_${TIMESTAMP}.bin"
  echo "✅ Copied $BIN_SOURCE -> $OUTPUT_DIR/zsa_moonlander_${KEYMAP_NAME}_${TIMESTAMP}.bin"
else
  echo "ℹ️  BIN file not found (optional, usually fine)."
fi

if command -v open &> /dev/null; then
  echo "🚀 Opening Keymapp for flashing..."
  open -a Keymapp
fi

echo "🎯 Firmware ready in: $OUTPUT_DIR"
