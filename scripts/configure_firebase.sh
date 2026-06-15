#!/usr/bin/env bash
# Configure Firebase for Bazaar after logging in.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export PATH="$ROOT/.tools/node_modules/.bin:$HOME/.pub-cache/bin:$HOME/.cursor/flutter/bin:$PATH"

echo "==> Checking Firebase CLI..."
firebase --version

echo "==> Checking FlutterFire CLI..."
flutterfire --version

echo "==> Run firebase login if not already authenticated:"
echo "    firebase login"

cd "$ROOT"
flutterfire configure \
  --project=bazaar-dev-e4d92 \
  --yes \
  --platforms=android,ios,web,macos \
  --ios-bundle-id=com.bazaar.app \
  --android-package-name=com.bazaar.app \
  --overwrite-firebase-options

echo "==> Done. Deploy rules with:"
echo "    cd firebase && firebase deploy --only firestore:rules,firestore:indexes,storage"
