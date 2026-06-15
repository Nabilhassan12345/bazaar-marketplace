#!/usr/bin/env bash
# Build and deploy Bazaar admin dashboard to Firebase Hosting.
set -euo pipefail

export PATH="$HOME/.cursor/flutter/bin:$HOME/.pub-cache/bin:$PATH"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="${BAZAAR_FIREBASE_PROJECT:-bazaar-dev-e4d92}"

cd "$ROOT/admin"
echo "==> Building admin web (release)..."
flutter pub get
flutter build web --release

echo "==> Copying build to firebase/hosting-admin..."
rm -rf "$ROOT/firebase/hosting-admin"
mkdir -p "$ROOT/firebase/hosting-admin"
cp -R build/web/. "$ROOT/firebase/hosting-admin/"

cd "$ROOT/firebase"
echo "==> Deploying to Firebase Hosting ($PROJECT)..."
firebase use "$PROJECT"
firebase target:apply hosting admin "$PROJECT" 2>/dev/null || true
firebase deploy --only hosting:admin

echo ""
echo "✅ Admin dashboard deployed!"
echo "   URL: https://${PROJECT}.web.app"
echo ""
echo "Sign in with an account that has role: admin in Firestore users/{uid}"
