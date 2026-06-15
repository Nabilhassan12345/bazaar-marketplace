# Bazaar Launch Guide

**Firebase project:** `bazaar-dev-e4d92`  
**Bundle ID:** `com.bazaar.app`

---

## Admin dashboard (live)

| Item | URL |
|------|-----|
| **Admin dashboard** | https://bazaar-dev-e4d92.web.app |
| **Firebase Console** | https://console.firebase.google.com/project/bazaar-dev-e4d92 |

### First-time admin setup

1. Sign in to the **mobile app** once with your email (creates `users/{uid}` in Firestore).
2. Firebase Console → **Firestore** → `users` → your document → set `"role": "admin"`.
3. Open https://bazaar-dev-e4d92.web.app and sign in with the same email/password.
4. Use **Listings** to approve/reject posts, **Users** to manage accounts, **Reports** to moderate.

### Redeploy admin after code changes

```bash
bash scripts/deploy_admin.sh
```

---

## Demo account (App Store / Play Store reviewers)

After running the seed script:

| Field | Value |
|-------|-------|
| Email | `review@bazaarapp.com` |
| Password | `Review2024!` |

### Seed demo data (60 listings)

Your account must be **admin** in Firestore first, then:

```bash
export BAZAAR_ADMIN_EMAIL=nh483793@gmail.com
export BAZAAR_ADMIN_PASSWORD='your-password-here'
dart run tool/seed.dart
```

---

## Mobile app — Android (Google Play)

```bash
export PATH="$HOME/.cursor/flutter/bin:$PATH"
export JAVA_HOME="$HOME/.local/jdk/jdk-17.0.19+10/Contents/Home"
export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools
export GRADLE_USER_HOME="$HOME/.gradle-bazaar"
cd "/Users/nabilhassan/dr nabil sahibin"
flutter build appbundle --release
```

Upload: `build/app/outputs/bundle/release/app-release.aab`

### Play Store fields

| Field | Value |
|-------|-------|
| **App name** | Bazaar — Buy & Sell |
| **Short description** | Buy and sell cars, houses & second-hand items |
| **Privacy Policy URL** | *(host your policy — required)* |

---

## Mobile app — iOS (App Store)

1. Xcode → **Settings → Accounts** → sign in with Apple ID
2. **Runner** target → **Signing & Capabilities** → select your Team
3. ```bash
   flutter build ipa --release
   ```
4. Xcode → **Product → Archive → Distribute App**

### App Store Connect fields

| Field | Value |
|-------|-------|
| **Name** | Bazaar — Buy & Sell |
| **Subtitle** | Cars, Houses & More |
| **Keywords** | buy,sell,marketplace,cars,houses,secondhand,classifieds |
| **Age rating** | 4+ |

Paste demo account in **Notes for reviewer** (see above).

---

## Known limitations (v1)

| Item | Status |
|------|--------|
| Firebase Storage (photo uploads) | Requires Blaze plan + valid billing — blocked by `OR_BAOOC_15` until payments profile fixed |
| Seeded listings | Use external image URLs (Unsplash) — no Storage needed |
| User photo uploads | Needs Storage enabled later |

---

## Pre-launch checklist

- [ ] Your account has `role: admin` in Firestore
- [ ] Admin dashboard login works at https://bazaar-dev-e4d92.web.app
- [ ] Seed script run (or manual approved listings exist)
- [ ] Demo account `review@bazaarapp.com` works in mobile app
- [ ] Android AAB built and uploaded
- [ ] iOS IPA built with signing and uploaded
- [ ] Public privacy policy URL added to store listings
- [ ] Report / block / delete account tested

```bash
flutter analyze
flutter test
```
