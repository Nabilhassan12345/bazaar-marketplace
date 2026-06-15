# Firebase Setup — Bazaar

## 1. Firebase Console (https://console.firebase.google.com)

Project: **bazaar-dev-e4d92** (display name: `bazaar-dev`)

Enable these products:

| Product | Action |
|---------|--------|
| **Authentication** | Enable Email/Password + Google sign-in |
| **Firestore** | Create database (production mode, then deploy rules) |
| **Storage** | Enable default bucket |
| **Analytics** | Enabled by default with Firebase app |

### Register apps

| Platform | Bundle / Package ID |
|----------|---------------------|
| Android | `com.bazaar.app` |
| iOS | `com.bazaar.app` |
| Web | `bazaar` (admin uses separate web app later) |

## 2. FlutterFire CLI (recommended — refreshes all config files)

```bash
# One-time login
export PATH="$PWD/.tools/node_modules/.bin:$HOME/.pub-cache/bin:$PATH"
firebase login

# Generate firebase_options.dart + platform config files
chmod +x scripts/configure_firebase.sh
./scripts/configure_firebase.sh
```

## 3. Config files in this repo

| File | Purpose |
|------|---------|
| `lib/firebase_options.dart` | Dart Firebase options (all platforms) |
| `android/app/google-services.json` | Android Firebase config |
| `ios/Runner/GoogleService-Info.plist` | iOS Firebase config |
| `firebase/firestore.rules` | Firestore security rules |
| `firebase/storage.rules` | Storage security rules |
| `firebase/firestore.indexes.json` | Composite indexes |

## 4. Deploy rules & indexes

```bash
export PATH="$PWD/.tools/node_modules/.bin:$PATH"
cd firebase
firebase deploy --only firestore:rules,firestore:indexes,storage
```

## 5. Verify connection

```bash
flutter run -d chrome   # or iOS Simulator / Android emulator
```

Look for `[core]` Firebase init success in logs — no `no-app` or `API key` errors.
