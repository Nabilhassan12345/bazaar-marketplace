#!/usr/bin/env bash
# Free memory before Xcode — run this, then QUIT Cursor and build in Xcode.
set -euo pipefail

echo "==> Stopping Flutter dev servers..."
for port in 7370 7371 7360 7361 7362; do
  lsof -tiTCP:"$port" -sTCP:LISTEN 2>/dev/null | xargs kill -9 2>/dev/null || true
done
pkill -f "flutter run" 2>/dev/null || true

echo "==> Clearing Xcode DerivedData (safe — Xcode will rebuild)..."
rm -rf "$HOME/Library/Developer/Xcode/DerivedData"/* 2>/dev/null || true

echo ""
echo "Memory tips for 8 GB Mac:"
echo "  1. Quit Cursor completely (Cmd+Q) before building in Xcode"
echo "  2. Quit Chrome or close extra tabs (Chrome was using ~5 GB)"
echo "  3. Build only in Xcode OR Terminal — not both at once"
echo ""
echo "To build iOS from Terminal (no Cursor needed):"
echo '  export PATH="$HOME/.cursor/flutter/bin:$PATH"'
echo '  cd "/Users/nabilhassan/dr nabil sahibin"'
echo "  flutter run -d \"iPhone 17 Pro\"    # simulator"
echo ""
echo "Opening Xcode..."
open "/Users/nabilhassan/dr nabil sahibin/ios/Runner.xcworkspace"
