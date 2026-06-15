#!/usr/bin/env bash
# Run Bazaar admin dashboard at http://localhost:7371
set -euo pipefail

export PATH="$HOME/.cursor/flutter/bin:$HOME/.pub-cache/bin:$PATH"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/admin"
PORT="${BAZAAR_ADMIN_PORT:-7371}"

if lsof -tiTCP:"$PORT" -sTCP:LISTEN >/dev/null 2>&1; then
  echo "==> Stopping old server on port $PORT..."
  lsof -tiTCP:"$PORT" -sTCP:LISTEN | xargs kill -9 2>/dev/null || true
  sleep 1
fi

echo "==> Starting admin dashboard at http://localhost:$PORT"
flutter run -d web-server --web-hostname=localhost --web-port="$PORT"
