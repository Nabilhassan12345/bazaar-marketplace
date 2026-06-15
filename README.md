# Bazaar — Buy & Sell Marketplace

A full-stack classifieds marketplace (OLX / Sahibinden style) built with **Flutter** and **Firebase**. Users browse and post listings for **cars**, **houses**, and **second-hand items**. A separate **Flutter Web admin dashboard** moderates content, manages users, and handles reports.

| | |
|---|---|
| **Bundle ID** | `com.bazaar.app` |
| **Firebase project** | `bazaar-dev-e4d92` |
| **Admin dashboard** | https://bazaar-dev-e4d92.web.app |
| **Platforms** | iOS · Android · Web (admin) |

---

## Features

### Mobile app (`lib/`)
- Email/password and Google sign-in
- Browse approved listings with category filters and search
- Create listings (draft → pending review → approved/rejected)
- Favorites, seller profiles, report & block users
- Account deletion (Settings → Delete My Account)
- In-app Privacy Policy and Terms of Service

### Admin dashboard (`admin/`)
- Email/password login with Firestore role check (`role: admin`)
- **Dashboard** — live user and listing stats
- **Listings** — approve, reject, and manage posts
- **Users** — view profiles, block/unblock
- **Reports** — review and resolve user reports
- Responsive sidebar (full on wide screens, icon rail on narrow)

### Backend (Firebase)
- **Authentication** — Email/Password, Google
- **Cloud Firestore** — users, listings, favorites, reports, blocks
- **Firebase Storage** — listing photos (requires Blaze billing)
- **Firebase Analytics** — login, registration, screen events
- **Firebase Hosting** — admin web app

---

## Architecture

Clean **feature-first** layout with **Riverpod** state management and **go_router** navigation. Shared models and enums live in a local Dart package.

```
┌─────────────────────────────────────────────────────────────────┐
│                        Bazaar Monorepo                          │
├─────────────────┬─────────────────────┬─────────────────────────┤
│  Mobile App     │  Admin Dashboard    │  Shared Package         │
│  lib/           │  admin/lib/         │  packages/marketplace_  │
│  iOS + Android  │  Flutter Web        │  shared/                │
└────────┬────────┴──────────┬──────────┴──────────┬────────────┘
         │                     │                     │
         └─────────────────────┼─────────────────────┘
                               ▼
                    ┌──────────────────────┐
                    │  Firebase (bazaar-dev) │
                    ├──────────────────────┤
                    │ Auth · Firestore     │
                    │ Storage · Analytics  │
                    │ Hosting (admin)      │
                    └──────────────────────┘
```

### Mobile feature modules

Each feature follows **data → domain → presentation**:

| Feature | Responsibility |
|---------|----------------|
| `auth` | Sign in/up, Google auth, Firestore user profile |
| `home` | Home feed, category chips |
| `listings` | CRUD, image upload, detail, my listings |
| `search` | Text search, filters, recent searches |
| `favorites` | Save/remove favorite listings |
| `profile` | Settings, edit profile, legal pages, delete account |
| `reports` | Report listings and users |
| `blocks` | Block/unblock users |
| `categories` / `cities` | Taxonomy data |
| `shell` | Bottom navigation scaffold |

### Listing lifecycle

```
draft  →  pending_review  →  approved  (visible in feed)
                          →  rejected   (seller can edit & resubmit)
```

Admins approve or reject via the web dashboard. Firestore security rules enforce status transitions and role-based access.

### State management & routing

- **Riverpod** — `StreamProvider` for auth, `AsyncNotifier` for feeds and forms
- **go_router** — auth-aware redirects; splash resolves before routing
- **Firebase** — initialized in `lib/core/firebase/firebase_initializer.dart`

> For the full schema, Firestore collections, security rules, and folder tree, see **[ARCHITECTURE.md](ARCHITECTURE.md)**.

---

## Project structure

```
bazaar/
├── lib/                    # Mobile app (iOS + Android)
├── admin/                  # Admin dashboard (Flutter Web)
├── packages/
│   └── marketplace_shared/ # Shared models, enums, constants
├── firebase/               # Firestore rules, indexes, storage rules, hosting
├── tool/                   # Seed & admin bootstrap scripts
├── scripts/                # Run, deploy, and Firebase helpers
├── android/ · ios/ · web/  # Platform shells
├── ARCHITECTURE.md         # Detailed technical reference
├── FIREBASE_SETUP.md       # Firebase console & CLI setup
└── SUBMISSION_NOTES.md     # App Store / Play Store launch guide
```

---

## Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) SDK `>=3.3.0`
- [Firebase CLI](https://firebase.google.com/docs/cli) (`npm install -g firebase-tools`)
- Xcode (iOS) / Android Studio or command-line tools (Android)
- A Firebase project with Auth, Firestore, and (optionally) Storage enabled

---

## Getting started

### 1. Clone and install dependencies

```bash
git clone https://github.com/Nabilhassan12345/bazaar-marketplace.git
cd bazaar-marketplace

flutter pub get
cd admin && flutter pub get && cd ..
cd packages/marketplace_shared && flutter pub get && cd ../..
```

### 2. Firebase configuration

Config files are included for project `bazaar-dev-e4d92`. To point at your own project:

```bash
dart pub global activate flutterfire_cli
firebase login
bash scripts/configure_firebase.sh
```

See **[FIREBASE_SETUP.md](FIREBASE_SETUP.md)** for console setup steps.

### 3. Deploy Firestore rules and indexes

```bash
cd firebase
firebase deploy --only firestore:rules,firestore:indexes,storage
```

### 4. Run the mobile app

```bash
flutter run                  # pick a device
flutter run -d chrome        # web (optional)
```

### 5. Run the admin dashboard locally

```bash
bash scripts/run_admin.sh    # http://localhost:7371
```

### 6. Promote an admin user

Set `role: "admin"` on your `users/{uid}` document in Firestore, or:

```bash
export BAZAAR_ADMIN_EMAIL=you@example.com
export BAZAAR_ADMIN_PASSWORD='your-password'
dart run tool/promote_admin.dart
```

### 7. Seed demo listings (optional)

Requires an admin account:

```bash
export BAZAAR_ADMIN_EMAIL=you@example.com
export BAZAAR_ADMIN_PASSWORD='your-password'
dart run tool/seed.dart
```

Creates 60 approved listings and a reviewer demo account (`review@bazaarapp.com`).

---

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/run_admin.sh` | Run admin dashboard on port 7371 |
| `scripts/run_chrome.sh` | Run mobile app in Chrome |
| `scripts/deploy_admin.sh` | Build and deploy admin to Firebase Hosting |
| `scripts/configure_firebase.sh` | Regenerate `firebase_options.dart` via FlutterFire |
| `scripts/setup_bazaar_dev.sh` | One-time Firebase project bootstrap helper |

---

## Build for release

### Android (Google Play)

```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

Signing: create `android/key.properties` and a keystore (see `.gitignore` — never commit secrets).

### iOS (App Store)

1. Open `ios/Runner.xcworkspace` in Xcode
2. Set your signing team
3. `flutter build ipa --release`
4. Archive and upload via Xcode Organizer

### Admin web

```bash
bash scripts/deploy_admin.sh
```

---

## Store submission

See **[SUBMISSION_NOTES.md](SUBMISSION_NOTES.md)** for the full pre-launch checklist, demo credentials, store listing copy, and known v1 limitations.

---

## Tech stack

| Layer | Technology |
|-------|------------|
| Mobile & admin UI | Flutter 3.x |
| State management | flutter_riverpod |
| Routing | go_router |
| Backend | Firebase (Auth, Firestore, Storage, Analytics, Hosting) |
| Images | cached_network_image, image_picker, flutter_image_compress |
| Admin tables | data_table_2 |

---

## Security notes

- `android/key.properties` and `android/release.jks` are gitignored — generate locally for release builds
- Firestore security rules in `firebase/firestore.rules` enforce role-based access and listing status transitions
- Remove the `isBootstrapAdmin` block from `firestore.rules` after running `tool/promote_admin.dart`

---

## License

Private project. All rights reserved unless a license file is added.
