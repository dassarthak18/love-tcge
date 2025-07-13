#!/bin/bash

set -e

# 1. Game name and love file
GAME_DIR="$(basename "$(pwd)")"
LOVE_FILE="${GAME_DIR}.love"

echo "📄 Creating $LOVE_FILE..."
zip -9 -r "$LOVE_FILE" . \
    -x "*.love" "*.exe" "*.zip" "${GAME_DIR}-Windows/*" "love-win/*" "*.sh" "*.DS_Store" "__MACOSX"

echo "✅ $LOVE_FILE created!"

# 2. Download clean Windows runtime from official source
WIN_RUNTIME_URL="https://github.com/love2d/love/releases/download/11.5/love-11.5-win64.zip"
WIN_RUNTIME_DIR="love-win"

if [ ! -d "$WIN_RUNTIME_DIR" ]; then
    echo "⬇️  Downloading LÖVE Windows runtime..."
    wget "$WIN_RUNTIME_URL" -O runtime.zip

    echo "📦 Extracting to $WIN_RUNTIME_DIR..."
    mkdir "$WIN_RUNTIME_DIR"
    unzip -q runtime.zip -d "$WIN_RUNTIME_DIR/tmp"

    INNER_DIR=$(find "$WIN_RUNTIME_DIR/tmp" -mindepth 1 -maxdepth 1 -type d)
    mv "$INNER_DIR"/* "$WIN_RUNTIME_DIR/"
    rm -r "$WIN_RUNTIME_DIR/tmp"
    rm runtime.zip
else
    echo "✅ Windows runtime already downloaded."
fi

# 3. Build .exe by appending .love to official love.exe
GAME_EXE="${GAME_DIR}.exe"
echo "🛠️  Creating $GAME_EXE..."
cat "$WIN_RUNTIME_DIR/love.exe" "$LOVE_FILE" > "$GAME_EXE"
chmod +x "$GAME_EXE"

echo "✅ $GAME_EXE created!"

# 4. Organize output into bin/
BIN_DIR="bin"
mkdir -p "$BIN_DIR"

echo "📦 Moving $LOVE_FILE and $GAME_EXE to $BIN_DIR/"
mv "$LOVE_FILE" "$GAME_EXE" "$BIN_DIR/"

echo "📁 Copying LÖVE DLLs to $BIN_DIR/..."
cp "$WIN_RUNTIME_DIR"/*.dll "$BIN_DIR/"

# 5. Optional: Add icon and metadata (via Resource Hacker or rcedit - skip if unsigned)

# 6. Cleanup
echo "🧹 Removing Windows runtime directory..."
rm -rf "$WIN_RUNTIME_DIR"

# 7. Zip final release folder
ZIP_NAME="${GAME_DIR}-windows-portable.zip"
echo "🗜️  Zipping final build: $ZIP_NAME"
cd "$BIN_DIR"
zip -9 -r "../$ZIP_NAME" . -x "*.DS_Store"
cd ..

echo "✅ Build complete! Distributable: $ZIP_NAME"
