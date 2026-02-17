#!/bin/bash
# Build SSHMan.app — a proper macOS .app bundle
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
APP_DIR="$PROJECT_DIR/build/SSHMan.app"

echo "==> Building SSHMan release binary..."
cd "$PROJECT_DIR"
swift build -c release

echo "==> Assembling SSHMan.app bundle..."
rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

# Copy binary
cp "$PROJECT_DIR/.build/release/SSHMan" "$APP_DIR/Contents/MacOS/SSHMan"

# Copy Info.plist
cp "$PROJECT_DIR/Resources/Info.plist" "$APP_DIR/Contents/Info.plist"

echo "==> Generating app icon..."
bash "$SCRIPT_DIR/gen-icon.sh"
cp "$PROJECT_DIR/build/AppIcon.icns" "$APP_DIR/Contents/Resources/AppIcon.icns"

echo "==> Code signing (ad-hoc)..."
codesign --force --deep --sign - "$APP_DIR"

echo ""
echo "================================================"
echo "  SSHMan.app built successfully!"
echo "  Location: $APP_DIR"
echo ""
echo "  To install, run:"
echo "    cp -R $APP_DIR /Applications/"
echo ""
echo "  To launch now:"
echo "    open $APP_DIR"
echo "================================================"
