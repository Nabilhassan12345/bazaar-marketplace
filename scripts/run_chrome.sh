#!/usr/bin/env bash
# Run Bazaar mobile app in the browser at http://localhost:7370
set -euo pipefail

export PATH="$HOME/.cursor/flutter/bin:$HOME/.pub-cache/bin:$PATH"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
PORT="${BAZAAR_WEB_PORT:-7370}"

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter not found. Install it to: $HOME/.cursor/flutter"
  echo "Or add to ~/.zshrc:"
  echo '  export PATH="$HOME/.cursor/flutter/bin:$PATH"'
  exit 1
fi

# Free the port if a previous dev server is still running.
if lsof -tiTCP:"$PORT" -sTCP:LISTEN >/dev/null 2>&1; then
  echo "==> Stopping old server on port $PORT..."
  lsof -tiTCP:"$PORT" -sTCP:LISTEN | xargs kill -9 2>/dev/null || true
  sleep 1
fi

echo "==> Starting Bazaar at http://localhost:$PORT"
echo "    Demo login: review@bazaarapp.com / Review2024!"
echo "    Press q in this terminal to stop the server."
flutter run -d web-server --web-hostname=localhost --web-port="$PORT"
