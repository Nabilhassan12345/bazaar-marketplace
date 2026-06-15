#!/usr/bin/env bash
# Connect the Bazaar app to YOUR Firebase project (bazaar-dev).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export PATH="$ROOT/.tools/node_modules/.bin:$HOME/.cursor/flutter/bin:$HOME/.pub-cache/bin:$PATH"
PROJECT_ID="${1:-bazaar-dev-e4d92}"

cd "$ROOT"

echo "==> Firebase project: $PROJECT_ID"
echo ""
echo "Before running this script, complete these in Firebase Console:"
echo "  1. Authentication → Sign-in method → Enable Email/Password"
echo "  2. Firestore Database → Create database (production mode is fine)"
echo "  3. Storage → Get started"
echo ""
read -r -p "Done with the console steps? Press Enter to continue..."

echo "==> Logging into Firebase (browser will open if needed)..."
firebase login

echo "==> Linking Flutter app to $PROJECT_ID..."
flutterfire configure \
  --project="$PROJECT_ID" \
  --yes \
  --platforms=android,ios,web,macos \
  --ios-bundle-id=com.bazaar.app \
  --android-package-name=com.bazaar.app \
  --overwrite-firebase-options

echo "==> Deploying Firestore rules, indexes, and Storage rules..."
cd "$ROOT/firebase"
firebase use "$PROJECT_ID"
firebase deploy --only firestore:rules,firestore:indexes,storage

echo ""
echo "==> Setup complete!"
echo "    Start the app:  bash scripts/run_chrome.sh"
echo "    Then sign up at http://localhost:7370 with your email."
echo ""
echo "    Optional — seed demo data (needs admin account in Firebase Auth):"
echo "      export BAZAAR_ADMIN_EMAIL=your@email.com"
echo "      export BAZAAR_ADMIN_PASSWORD='your-password'"
echo "      dart run tool/seed.dart"
