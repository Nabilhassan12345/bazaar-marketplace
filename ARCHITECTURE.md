# Marketplace App — Master Architecture Reference

> **Base:** [AbdullahChauhan/olx-clone](https://github.com/AbdullahChauhan/olx-clone) (Flutter marketplace starter)  
> **Stack:** Flutter (iOS + Android) · Flutter Web admin (`admin/lib/main.dart`) · Firebase (Auth, Firestore, Storage, Analytics, Hosting)  
> **Categories:** Cars · Houses · Second-hand items  
> **Listing status enum:** `draft` | `pending_review` | `approved` | `rejected`

Every future prompt should reference this document.

---

## 1. FOLDER STRUCTURE

```
marketplace/                              # repo root (olx-clone extended)
│
├── android/                              # mobile Android shell
├── ios/                                  # mobile iOS shell
├── web/                                  # mobile web shell (optional; admin uses own web/)
│
├── lib/                                  # MOBILE APP entry (iOS + Android)
│   ├── main.dart                         # mobile bootstrap
│   ├── main_dev.dart                     # dev flavor entry
│   ├── main_prod.dart                    # prod flavor entry
│   ├── app.dart                          # MaterialApp, theme, router root
│   ├── injection_container.dart          # GetIt / Riverpod providers setup
│   │
│   ├── config/
│   │   ├── env/
│   │   │   ├── env.dart
│   │   │   ├── dev_env.dart
│   │   │   └── prod_env.dart
│   │   ├── routes/
│   │   │   ├── app_router.dart           # go_router
│   │   │   └── route_names.dart
│   │   └── theme/
│   │       ├── app_theme.dart
│   │       ├── app_colors.dart
│   │       └── app_typography.dart
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   ├── firestore_paths.dart
│   │   │   └── storage_paths.dart
│   │   ├── enums/
│   │   │   ├── listing_status.dart
│   │   │   ├── user_role.dart
│   │   │   └── report_status.dart
│   │   ├── errors/
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   ├── extensions/
│   │   │   ├── context_extensions.dart
│   │   │   └── datetime_extensions.dart
│   │   ├── network/
│   │   │   └── connectivity_service.dart
│   │   ├── firebase/
│   │   │   ├── firebase_initializer.dart
│   │   │   └── analytics_service.dart
│   │   ├── utils/
│   │   │   ├── validators.dart
│   │   │   ├── formatters.dart
│   │   │   └── image_picker_helper.dart
│   │   └── widgets/
│   │       ├── app_loading.dart
│   │       ├── app_error_view.dart
│   │       ├── empty_state.dart
│   │       └── cached_network_image.dart
│   │
│   └── features/
│       ├── splash/
│       │   └── presentation/
│       │       └── pages/splash_page.dart
│       │
│       ├── auth/
│       │   ├── data/
│       │   │   ├── datasources/auth_remote_datasource.dart
│       │   │   ├── models/user_model.dart
│       │   │   └── repositories/auth_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/user_entity.dart
│       │   │   ├── repositories/auth_repository.dart
│       │   │   └── usecases/
│       │   │       ├── sign_in_with_email.dart
│       │   │       ├── sign_up_with_email.dart
│       │   │       ├── sign_in_with_google.dart
│       │   │       ├── sign_out.dart
│       │   │       └── get_current_user.dart
│       │   └── presentation/
│       │       ├── cubit/auth_cubit.dart
│       │       ├── pages/login_page.dart
│       │       ├── pages/register_page.dart
│       │       └── widgets/auth_text_field.dart
│       │
│       ├── home/
│       │   └── presentation/
│       │       ├── pages/home_page.dart
│       │       └── widgets/
│       │           ├── category_chips.dart
│       │           └── featured_listings_carousel.dart
│       │
│       ├── categories/
│       │   ├── data/
│       │   │   ├── datasources/category_remote_datasource.dart
│       │   │   ├── models/category_model.dart
│       │   │   └── repositories/category_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/category_entity.dart
│       │   │   ├── repositories/category_repository.dart
│       │   │   └── usecases/get_categories.dart
│       │   └── presentation/
│       │       ├── cubit/category_cubit.dart
│       │       └── pages/category_list_page.dart
│       │
│       ├── cities/
│       │   ├── data/
│       │   │   ├── datasources/city_remote_datasource.dart
│       │   │   ├── models/city_model.dart
│       │   │   └── repositories/city_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/city_entity.dart
│       │   │   ├── repositories/city_repository.dart
│       │   │   └── usecases/get_cities.dart
│       │   └── presentation/
│       │       ├── cubit/city_cubit.dart
│       │       └── widgets/city_picker.dart
│       │
│       ├── listings/
│       │   ├── data/
│       │   │   ├── datasources/
│       │   │   │   ├── listing_remote_datasource.dart
│       │   │   │   └── listing_storage_datasource.dart
│       │   │   ├── models/
│       │   │   │   ├── listing_model.dart
│       │   │   │   └── listing_attribute_model.dart
│       │   │   └── repositories/listing_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/listing_entity.dart
│       │   │   ├── repositories/listing_repository.dart
│       │   │   └── usecases/
│       │   │       ├── create_listing.dart
│       │   │       ├── update_listing.dart
│       │   │       ├── delete_listing.dart
│       │   │       ├── submit_listing_for_review.dart
│       │   │       ├── get_listing_by_id.dart
│       │   │       ├── get_approved_listings.dart
│       │   │       ├── get_my_listings.dart
│       │   │       └── search_listings.dart
│       │   └── presentation/
│       │       ├── cubit/
│       │       │   ├── listing_list_cubit.dart
│       │       │   ├── listing_detail_cubit.dart
│       │       │   └── create_listing_cubit.dart
│       │       ├── pages/
│       │       │   ├── listing_feed_page.dart
│       │       │   ├── listing_detail_page.dart
│       │       │   ├── create_listing_page.dart
│       │       │   ├── edit_listing_page.dart
│       │       │   └── my_listings_page.dart
│       │       └── widgets/
│       │           ├── listing_card.dart
│       │           ├── listing_image_gallery.dart
│       │           ├── price_tag.dart
│       │           └── attribute_form/
│       │               ├── car_attribute_form.dart
│       │               ├── house_attribute_form.dart
│       │               └── second_hand_attribute_form.dart
│       │
│       ├── favorites/
│       │   ├── data/
│       │   │   ├── datasources/favorite_remote_datasource.dart
│       │   │   ├── models/favorite_model.dart
│       │   │   └── repositories/favorite_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/favorite_entity.dart
│       │   │   ├── repositories/favorite_repository.dart
│       │   │   └── usecases/
│       │   │       ├── toggle_favorite.dart
│       │   │       └── get_favorites.dart
│       │   └── presentation/
│       │       ├── cubit/favorite_cubit.dart
│       │       └── pages/favorites_page.dart
│       │
│       ├── profile/
│       │   ├── data/
│       │   │   ├── datasources/profile_remote_datasource.dart
│       │   │   └── repositories/profile_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── repositories/profile_repository.dart
│       │   │   └── usecases/update_profile.dart
│       │   └── presentation/
│       │       ├── cubit/profile_cubit.dart
│       │       └── pages/profile_page.dart
│       │
│       ├── reports/
│       │   ├── data/
│       │   │   ├── datasources/report_remote_datasource.dart
│       │   │   ├── models/report_model.dart
│       │   │   └── repositories/report_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/report_entity.dart
│       │   │   ├── repositories/report_repository.dart
│       │   │   └── usecases/submit_report.dart
│       │   └── presentation/
│       │       ├── cubit/report_cubit.dart
│       │       └── widgets/report_dialog.dart
│       │
│       ├── blocks/
│       │   ├── data/
│       │   │   ├── datasources/block_remote_datasource.dart
│       │   │   ├── models/block_model.dart
│       │   │   └── repositories/block_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/block_entity.dart
│       │   │   ├── repositories/block_repository.dart
│       │   │   └── usecases/
│       │   │       ├── block_user.dart
│       │   │       ├── unblock_user.dart
│       │   │       └── get_blocked_users.dart
│       │   └── presentation/
│       │       ├── cubit/block_cubit.dart
│       │       └── pages/blocked_users_page.dart
│       │
│       └── shell/
│           └── presentation/
│               ├── pages/main_shell_page.dart
│               └── widgets/bottom_nav_bar.dart
│
├── admin/                                # ADMIN WEB APP (Flutter Web)
│   ├── web/
│   │   ├── index.html
│   │   ├── manifest.json
│   │   └── favicon.png
│   ├── lib/
│   │   ├── main.dart                     # admin bootstrap (Firebase Hosting target)
│   │   ├── app.dart
│   │   ├── injection_container.dart
│   │   │
│   │   ├── config/
│   │   │   ├── routes/admin_router.dart
│   │   │   └── theme/admin_theme.dart
│   │   │
│   │   ├── core/
│   │   │   ├── guards/admin_auth_guard.dart
│   │   │   └── widgets/
│   │   │       ├── admin_scaffold.dart
│   │   │       ├── admin_sidebar.dart
│   │   │       └── data_table_wrapper.dart
│   │   │
│   │   └── features/
│   │       ├── auth/
│   │       │   └── presentation/pages/admin_login_page.dart
│   │       ├── dashboard/
│   │       │   └── presentation/pages/dashboard_page.dart
│   │       ├── listings_review/
│   │       │   ├── data/listing_review_repository.dart
│   │       │   └── presentation/
│   │       │       ├── pages/pending_listings_page.dart
│   │       │       ├── pages/listing_review_detail_page.dart
│   │       │       └── cubit/listing_review_cubit.dart
│   │       ├── users/
│   │       │   └── presentation/pages/users_page.dart
│   │       ├── reports/
│   │       │   └── presentation/pages/reports_page.dart
│   │       ├── categories/
│   │       │   └── presentation/pages/categories_admin_page.dart
│   │       └── cities/
│   │           └── presentation/pages/cities_admin_page.dart
│   │
│   └── pubspec.yaml                      # admin depends on shared package
│
├── packages/
│   └── marketplace_shared/               # SHARED between mobile + admin
│       ├── lib/
│       │   ├── marketplace_shared.dart   # barrel export
│       │   ├── constants/
│       │   │   ├── collection_names.dart
│       │   │   └── listing_status.dart
│       │   ├── models/
│       │   │   ├── user_model.dart
│       │   │   ├── listing_model.dart
│       │   │   ├── category_model.dart
│       │   │   ├── city_model.dart
│       │   │   ├── favorite_model.dart
│       │   │   ├── report_model.dart
│       │   │   └── block_model.dart
│       │   ├── repositories/
│       │   │   └── firestore_helpers.dart
│       │   └── validators/
│       │       ├── listing_validator.dart
│       │       └── attribute_schemas.dart
│       └── pubspec.yaml
│
├── firebase/
│   ├── firebase.json                     # hosting targets: mobile-web, admin-web
│   ├── .firebaserc
│   ├── firestore.rules
│   ├── firestore.indexes.json
│   ├── storage.rules
│   └── seed/
│       ├── categories_seed.json
│       └── cities_seed.json
│
├── assets/
│   ├── images/
│   │   ├── logo.png
│   │   ├── placeholder_listing.png
│   │   └── onboarding/
│   ├── icons/
│   │   ├── category_cars.svg
│   │   ├── category_houses.svg
│   │   └── category_second_hand.svg
│   └── fonts/
│
├── test/
│   ├── unit/
│   ├── widget/
│   └── helpers/
│       └── firebase_mocks.dart
│
├── integration_test/
│   └── app_test.dart
│
├── scripts/
│   ├── seed_firestore.dart
│   └── set_admin_claim.dart
│
├── pubspec.yaml                          # mobile app (path: marketplace_shared)
├── analysis_options.yaml
├── melos.yaml                            # optional monorepo orchestration
└── README.md
```

### Key file responsibilities

| Path | Purpose |
|------|---------|
| `lib/main.dart` | Mobile app entry; initializes Firebase, DI, runs `App` |
| `admin/lib/main.dart` | Admin web entry; role-gated dashboard |
| `packages/marketplace_shared/` | Single source of truth for models, enums, Firestore field names |
| `firebase/firestore.rules` | Security rules for all 7 collections |
| `firebase/firestore.indexes.json` | Composite indexes for feed, filters, admin queues |
| `firebase/firebase.json` | Two Hosting targets: `admin` → `admin/build/web`, optional `app` → `build/web` |

---

## 2. FIRESTORE SCHEMA

### Conventions

- **Document IDs:** Auto-ID for all collections except `users` (ID = Firebase Auth `uid`).
- **Timestamps:** Firestore `Timestamp` type; stored as UTC.
- **Money:** `price` stored as `number` (minor units optional; here use whole currency units).
- **Images:** `imageUrls` = array of Firebase Storage download URLs; `imagePaths` = storage paths for cleanup.
- **Soft deletes:** `isDeleted: bool` on listings; hard-delete only by admin or owner on draft.

---

### Collection: `users`

**Path:** `users/{userId}`  
**Document ID:** Firebase Auth UID

| Field | Type | Required | Example |
|-------|------|----------|---------|
| `email` | string | yes | `"ali@example.com"` |
| `phone` | string | no | `"+905551234567"` |
| `displayName` | string | yes | `"Ali Yılmaz"` |
| `photoUrl` | string | no | `"https://storage.../avatars/uid.jpg"` |
| `role` | string | yes | `"user"` · `"moderator"` · `"admin"` |
| `cityId` | string | no | `"city_istanbul"` |
| `bio` | string | no | `"Selling quality used items"` |
| `isBlocked` | bool | yes | `false` |
| `blockedAt` | timestamp | no | `2026-06-01T10:00:00Z` |
| `blockedReason` | string | no | `"Repeated fraud reports"` |
| `listingCount` | number | yes | `12` |
| `approvedListingCount` | number | yes | `8` |
| `emailVerified` | bool | yes | `true` |
| `phoneVerified` | bool | yes | `false` |
| `preferredLanguage` | string | no | `"tr"` |
| `notificationSettings` | map | no | `{ "newMessage": true, "listingApproved": true }` |
| `createdAt` | timestamp | yes | `2026-01-15T08:30:00Z` |
| `updatedAt` | timestamp | yes | `2026-06-10T14:22:00Z` |
| `lastActiveAt` | timestamp | no | `2026-06-14T09:00:00Z` |

**Example document** (`users/abc123uid`):

```json
{
  "email": "ali@example.com",
  "phone": "+905551234567",
  "displayName": "Ali Yılmaz",
  "photoUrl": null,
  "role": "user",
  "cityId": "city_istanbul",
  "bio": "",
  "isBlocked": false,
  "blockedAt": null,
  "blockedReason": null,
  "listingCount": 3,
  "approvedListingCount": 2,
  "emailVerified": true,
  "phoneVerified": false,
  "preferredLanguage": "tr",
  "notificationSettings": { "listingApproved": true, "listingRejected": true },
  "createdAt": "2026-01-15T08:30:00Z",
  "updatedAt": "2026-06-10T14:22:00Z",
  "lastActiveAt": "2026-06-14T09:00:00Z"
}
```

---

### Collection: `categories`

**Path:** `categories/{categoryId}`

| Field | Type | Required | Example |
|-------|------|----------|---------|
| `name` | string | yes | `"Cars"` |
| `slug` | string | yes | `"cars"` |
| `parentId` | string | no | `null` (top-level) or `"cat_cars"` |
| `iconUrl` | string | no | `"assets/icons/category_cars.svg"` |
| `sortOrder` | number | yes | `1` |
| `isActive` | bool | yes | `true` |
| `attributeSchema` | array\<map\> | yes | see below |
| `createdAt` | timestamp | yes | `2026-01-01T00:00:00Z` |
| `updatedAt` | timestamp | yes | `2026-06-01T00:00:00Z` |

**`attributeSchema` item shape:**

| Key | Type | Example |
|-----|------|---------|
| `key` | string | `"year"` |
| `label` | string | `"Year"` |
| `type` | string | `"number"` · `"string"` · `"enum"` · `"boolean"` |
| `required` | bool | `true` |
| `options` | array\<string\> | `["petrol","diesel","electric"]` (enum only) |

**Seed categories:**

| categoryId | name | slug | parentId |
|------------|------|------|----------|
| `cat_cars` | Cars | cars | null |
| `cat_houses` | Houses | houses | null |
| `cat_second_hand` | Second-hand items | second-hand | null |
| `cat_cars_sedan` | Sedan | sedan | cat_cars |
| `cat_cars_suv` | SUV | suv | cat_cars |
| `cat_houses_sale` | For Sale | for-sale | cat_houses |
| `cat_houses_rent` | For Rent | for-rent | cat_houses |

**Cars `attributeSchema` example:**

```json
[
  { "key": "make", "label": "Make", "type": "string", "required": true },
  { "key": "model", "label": "Model", "type": "string", "required": true },
  { "key": "year", "label": "Year", "type": "number", "required": true },
  { "key": "mileage", "label": "Mileage (km)", "type": "number", "required": true },
  { "key": "fuelType", "label": "Fuel", "type": "enum", "required": true, "options": ["petrol","diesel","electric","hybrid","lpg"] },
  { "key": "transmission", "label": "Transmission", "type": "enum", "required": true, "options": ["manual","automatic"] },
  { "key": "bodyType", "label": "Body", "type": "enum", "required": false, "options": ["sedan","hatchback","suv","coupe","van"] },
  { "key": "color", "label": "Color", "type": "string", "required": false }
]
```

**Houses `attributeSchema` example:**

```json
[
  { "key": "listingType", "label": "Type", "type": "enum", "required": true, "options": ["sale","rent"] },
  { "key": "propertyType", "label": "Property", "type": "enum", "required": true, "options": ["apartment","house","villa","land","commercial"] },
  { "key": "rooms", "label": "Rooms", "type": "number", "required": true },
  { "key": "bathrooms", "label": "Bathrooms", "type": "number", "required": false },
  { "key": "areaSqm", "label": "Area (m²)", "type": "number", "required": true },
  { "key": "floor", "label": "Floor", "type": "number", "required": false },
  { "key": "buildingAge", "label": "Building age", "type": "number", "required": false },
  { "key": "furnished", "label": "Furnished", "type": "boolean", "required": false }
]
```

**Second-hand `attributeSchema` example:**

```json
[
  { "key": "condition", "label": "Condition", "type": "enum", "required": true, "options": ["new","like_new","good","fair","poor"] },
  { "key": "brand", "label": "Brand", "type": "string", "required": false },
  { "key": "itemCategory", "label": "Item type", "type": "enum", "required": true, "options": ["electronics","furniture","clothing","sports","books","other"] }
]
```

---

### Collection: `cities`

**Path:** `cities/{cityId}`

| Field | Type | Required | Example |
|-------|------|----------|---------|
| `name` | string | yes | `"Istanbul"` |
| `slug` | string | yes | `"istanbul"` |
| `countryCode` | string | yes | `"TR"` |
| `region` | string | no | `"Marmara"` |
| `sortOrder` | number | yes | `1` |
| `isActive` | bool | yes | `true` |
| `createdAt` | timestamp | yes | `2026-01-01T00:00:00Z` |

**Example** (`cities/city_istanbul`):

```json
{
  "name": "Istanbul",
  "slug": "istanbul",
  "countryCode": "TR",
  "region": "Marmara",
  "sortOrder": 1,
  "isActive": true,
  "createdAt": "2026-01-01T00:00:00Z"
}
```

---

### Collection: `listings`

**Path:** `listings/{listingId}`

| Field | Type | Required | Example |
|-------|------|----------|---------|
| `sellerId` | string | yes | `"abc123uid"` |
| `sellerDisplayName` | string | yes | `"Ali Yılmaz"` (denormalized) |
| `categoryId` | string | yes | `"cat_cars"` |
| `subcategoryId` | string | no | `"cat_cars_sedan"` |
| `cityId` | string | yes | `"city_istanbul"` |
| `title` | string | yes | `"2020 Toyota Corolla 1.6"` |
| `description` | string | yes | `"Well maintained, single owner..."` |
| `price` | number | yes | `850000` |
| `currency` | string | yes | `"TRY"` |
| `isNegotiable` | bool | yes | `true` |
| `status` | string | yes | `"approved"` — **must be** `draft` \| `pending_review` \| `approved` \| `rejected` |
| `rejectionReason` | string | no | `"Blurry photos"` |
| `reviewedBy` | string | no | `"admin_uid"` |
| `reviewedAt` | timestamp | no | `2026-06-12T11:00:00Z` |
| `imageUrls` | array\<string\> | yes | `["https://.../img1.jpg","https://.../img2.jpg"]` |
| `imagePaths` | array\<string\> | yes | `["listings/abc/img1.jpg"]` |
| `thumbnailUrl` | string | no | first image URL |
| `attributes` | map | yes | category-specific; see examples |
| `contactPhone` | string | no | `"+905551234567"` |
| `showPhone` | bool | yes | `true` |
| `viewCount` | number | yes | `142` |
| `favoriteCount` | number | yes | `8` |
| `isDeleted` | bool | yes | `false` |
| `searchKeywords` | array\<string\> | yes | `["toyota","corolla","2020","sedan"]` |
| `createdAt` | timestamp | yes | `2026-06-10T10:00:00Z` |
| `updatedAt` | timestamp | yes | `2026-06-12T11:00:00Z` |
| `submittedAt` | timestamp | no | when status → `pending_review` |
| `approvedAt` | timestamp | no | when status → `approved` |
| `expiresAt` | timestamp | no | `2026-09-10T10:00:00Z` |

**`attributes` examples by category:**

Cars:
```json
{ "make": "Toyota", "model": "Corolla", "year": 2020, "mileage": 45000, "fuelType": "petrol", "transmission": "automatic", "bodyType": "sedan", "color": "white" }
```

Houses:
```json
{ "listingType": "sale", "propertyType": "apartment", "rooms": 3, "bathrooms": 2, "areaSqm": 120, "floor": 5, "buildingAge": 8, "furnished": true }
```

Second-hand:
```json
{ "condition": "like_new", "brand": "Apple", "itemCategory": "electronics" }
```

**Full listing example** (`listings/list_abc123`):

```json
{
  "sellerId": "abc123uid",
  "sellerDisplayName": "Ali Yılmaz",
  "categoryId": "cat_cars",
  "subcategoryId": "cat_cars_sedan",
  "cityId": "city_istanbul",
  "title": "2020 Toyota Corolla 1.6",
  "description": "Well maintained, single owner, full service history.",
  "price": 850000,
  "currency": "TRY",
  "isNegotiable": true,
  "status": "approved",
  "rejectionReason": null,
  "reviewedBy": "admin_xyz",
  "reviewedAt": "2026-06-12T11:00:00Z",
  "imageUrls": ["https://storage.googleapis.com/.../img1.jpg"],
  "imagePaths": ["listings/list_abc123/img1.jpg"],
  "thumbnailUrl": "https://storage.googleapis.com/.../img1.jpg",
  "attributes": { "make": "Toyota", "model": "Corolla", "year": 2020, "mileage": 45000, "fuelType": "petrol", "transmission": "automatic" },
  "contactPhone": "+905551234567",
  "showPhone": true,
  "viewCount": 142,
  "favoriteCount": 8,
  "isDeleted": false,
  "searchKeywords": ["toyota","corolla","2020","sedan","istanbul"],
  "createdAt": "2026-06-10T10:00:00Z",
  "updatedAt": "2026-06-12T11:00:00Z",
  "submittedAt": "2026-06-11T09:00:00Z",
  "approvedAt": "2026-06-12T11:00:00Z",
  "expiresAt": "2026-09-10T10:00:00Z"
}
```

**Status lifecycle:**

```
draft → pending_review → approved
                       ↘ rejected → (edit) → pending_review
draft → (delete)
approved → (owner archive / admin remove)
```

---

### Collection: `favorites`

**Path:** `favorites/{favoriteId}`  
**Document ID:** `{userId}_{listingId}` (deterministic; prevents duplicates)

| Field | Type | Required | Example |
|-------|------|----------|---------|
| `userId` | string | yes | `"abc123uid"` |
| `listingId` | string | yes | `"list_abc123"` |
| `listingTitle` | string | yes | `"2020 Toyota Corolla"` (denormalized) |
| `listingThumbnailUrl` | string | no | `"https://.../thumb.jpg"` |
| `listingPrice` | number | yes | `850000` |
| `listingStatus` | string | yes | `"approved"` |
| `createdAt` | timestamp | yes | `2026-06-13T16:00:00Z` |

**Example** (`favorites/abc123uid_list_abc123`):

```json
{
  "userId": "abc123uid",
  "listingId": "list_abc123",
  "listingTitle": "2020 Toyota Corolla 1.6",
  "listingThumbnailUrl": "https://storage.../img1.jpg",
  "listingPrice": 850000,
  "listingStatus": "approved",
  "createdAt": "2026-06-13T16:00:00Z"
}
```

---

### Collection: `reports`

**Path:** `reports/{reportId}`

| Field | Type | Required | Example |
|-------|------|----------|---------|
| `reporterId` | string | yes | `"user_reporter_uid"` |
| `reportedUserId` | string | no | `"abc123uid"` |
| `listingId` | string | no | `"list_abc123"` |
| `type` | string | yes | `"fraud"` · `"spam"` · `"inappropriate"` · `"fake_listing"` · `"harassment"` · `"other"` |
| `reason` | string | yes | `"Seller asked for deposit outside app"` |
| `description` | string | no | `"Full details..."` |
| `status` | string | yes | `"pending"` · `"reviewed"` · `"resolved"` · `"dismissed"` |
| `reviewedBy` | string | no | `"admin_xyz"` |
| `reviewedAt` | timestamp | no | `2026-06-14T10:00:00Z` |
| `adminNotes` | string | no | `"Warning sent to seller"` |
| `createdAt` | timestamp | yes | `2026-06-14T08:00:00Z` |
| `updatedAt` | timestamp | yes | `2026-06-14T10:00:00Z` |

**Constraint:** At least one of `reportedUserId` or `listingId` must be set.

**Example:**

```json
{
  "reporterId": "user_reporter_uid",
  "reportedUserId": "abc123uid",
  "listingId": "list_abc123",
  "type": "fraud",
  "reason": "Seller asked for deposit outside app",
  "description": "Requested wire transfer before viewing",
  "status": "pending",
  "reviewedBy": null,
  "reviewedAt": null,
  "adminNotes": null,
  "createdAt": "2026-06-14T08:00:00Z",
  "updatedAt": "2026-06-14T08:00:00Z"
}
```

---

### Collection: `blocks`

**Path:** `blocks/{blockId}`  
**Document ID:** `{blockerId}_{blockedUserId}`

| Field | Type | Required | Example |
|-------|------|----------|---------|
| `blockerId` | string | yes | `"user_a_uid"` |
| `blockedUserId` | string | yes | `"user_b_uid"` |
| `blockedDisplayName` | string | no | `"Spam User"` (denormalized) |
| `createdAt` | timestamp | yes | `2026-06-14T12:00:00Z` |

**Example** (`blocks/user_a_uid_user_b_uid`):

```json
{
  "blockerId": "user_a_uid",
  "blockedUserId": "user_b_uid",
  "blockedDisplayName": "Spam User",
  "createdAt": "2026-06-14T12:00:00Z"
}
```

---

### Firebase Storage layout (not Firestore, but referenced by schema)

```
listings/{listingId}/{imageId}.jpg
users/{userId}/avatar.jpg
categories/{categoryId}/icon.png
```

---

## 3. FIREBASE SECURITY RULES

### `firebase/firestore.rules`

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // ─── Helpers ───────────────────────────────────────────────
    function isSignedIn() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }

    function userDoc() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid));
    }

    function isAdmin() {
      return isSignedIn()
        && userDoc().data.role == 'admin';
    }

    function isModeratorOrAdmin() {
      return isSignedIn()
        && userDoc().data.role in ['admin', 'moderator'];
    }

    function isNotBlocked() {
      return isSignedIn()
        && userDoc().data.isBlocked == false;
    }

    function validListingStatus(status) {
      return status in ['draft', 'pending_review', 'approved', 'rejected'];
    }

    function validUserRole(role) {
      return role in ['user', 'moderator', 'admin'];
    }

    function validReportType(type) {
      return type in ['fraud', 'spam', 'inappropriate', 'fake_listing', 'harassment', 'other'];
    }

    function validReportStatus(status) {
      return status in ['pending', 'reviewed', 'resolved', 'dismissed'];
    }

    // ─── users ─────────────────────────────────────────────────
    match /users/{userId} {
      allow read: if isSignedIn();

      allow create: if isOwner(userId)
        && request.resource.data.keys().hasAll([
          'email', 'displayName', 'role', 'isBlocked',
          'listingCount', 'approvedListingCount',
          'emailVerified', 'phoneVerified', 'createdAt', 'updatedAt'
        ])
        && request.resource.data.role == 'user'
        && request.resource.data.isBlocked == false
        && request.resource.data.listingCount == 0
        && request.resource.data.approvedListingCount == 0;

      allow update: if isOwner(userId)
        && isNotBlocked()
        && request.resource.data.role == resource.data.role
        && request.resource.data.isBlocked == resource.data.isBlocked
        && request.resource.data.diff(resource.data).affectedKeys()
          .hasOnly([
            'displayName', 'phone', 'photoUrl', 'cityId', 'bio',
            'preferredLanguage', 'notificationSettings',
            'updatedAt', 'lastActiveAt', 'emailVerified', 'phoneVerified'
          ])
        || isAdmin();

      allow delete: if isAdmin();
    }

    // ─── categories ────────────────────────────────────────────
    match /categories/{categoryId} {
      allow read: if true;
      allow write: if isAdmin();
    }

    // ─── cities ────────────────────────────────────────────────
    match /cities/{cityId} {
      allow read: if true;
      allow write: if isAdmin();
    }

    // ─── listings ──────────────────────────────────────────────
    match /listings/{listingId} {
      allow read: if resource.data.status == 'approved'
        && resource.data.isDeleted == false
        || isSignedIn() && (
          resource.data.sellerId == request.auth.uid
          || isModeratorOrAdmin()
        );

      allow create: if isSignedIn()
        && isNotBlocked()
        && request.resource.data.sellerId == request.auth.uid
        && request.resource.data.status == 'draft'
        && validListingStatus(request.resource.data.status)
        && request.resource.data.isDeleted == false
        && request.resource.data.viewCount == 0
        && request.resource.data.favoriteCount == 0;

      allow update: if isSignedIn() && isNotBlocked() && (
        // Owner: edit drafts/rejected; submit for review
        (resource.data.sellerId == request.auth.uid
          && resource.data.status in ['draft', 'rejected']
          && request.resource.data.status in ['draft', 'pending_review']
          && request.resource.data.sellerId == resource.data.sellerId
          && request.resource.data.reviewedBy == resource.data.reviewedBy
          && request.resource.data.reviewedAt == resource.data.reviewedAt
          && request.resource.data.approvedAt == resource.data.approvedAt
          && request.resource.data.rejectionReason == resource.data.rejectionReason)
        ||
        // Owner: soft-delete own draft
        (resource.data.sellerId == request.auth.uid
          && resource.data.status == 'draft'
          && request.resource.data.isDeleted == true)
        ||
        // Admin/Moderator: approve, reject, moderate
        (isModeratorOrAdmin()
          && validListingStatus(request.resource.data.status))
        ||
        // Anyone signed in: increment viewCount only (via transaction in app)
        (isSignedIn()
          && resource.data.status == 'approved'
          && request.resource.data.diff(resource.data).affectedKeys().hasOnly(['viewCount', 'updatedAt'])
          && request.resource.data.viewCount == resource.data.viewCount + 1)
      );

      allow delete: if isAdmin()
        || (isSignedIn()
          && resource.data.sellerId == request.auth.uid
          && resource.data.status == 'draft');
    }

    // ─── favorites ─────────────────────────────────────────────
    match /favorites/{favoriteId} {
      allow read: if isSignedIn()
        && resource.data.userId == request.auth.uid;

      allow create: if isSignedIn()
        && isNotBlocked()
        && request.resource.data.userId == request.auth.uid
        && favoriteId == request.auth.uid + '_' + request.resource.data.listingId;

      allow delete: if isSignedIn()
        && resource.data.userId == request.auth.uid;

      allow update: if false;
    }

    // ─── reports ───────────────────────────────────────────────
    match /reports/{reportId} {
      allow read: if isModeratorOrAdmin()
        || (isSignedIn() && resource.data.reporterId == request.auth.uid);

      allow create: if isSignedIn()
        && isNotBlocked()
        && request.resource.data.reporterId == request.auth.uid
        && request.resource.data.status == 'pending'
        && validReportType(request.resource.data.type)
        && (request.resource.data.listingId != null
          || request.resource.data.reportedUserId != null);

      allow update: if isModeratorOrAdmin()
        && validReportStatus(request.resource.data.status);

      allow delete: if isAdmin();
    }

    // ─── blocks ────────────────────────────────────────────────
    match /blocks/{blockId} {
      allow read: if isSignedIn()
        && resource.data.blockerId == request.auth.uid;

      allow create: if isSignedIn()
        && isNotBlocked()
        && request.resource.data.blockerId == request.auth.uid
        && request.resource.data.blockedUserId != request.auth.uid
        && blockId == request.auth.uid + '_' + request.resource.data.blockedUserId;

      allow delete: if isSignedIn()
        && resource.data.blockerId == request.auth.uid;

      allow update: if false;
    }
  }
}
```

### `firebase/storage.rules`

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {

    function isSignedIn() {
      return request.auth != null;
    }

    function isAdmin() {
      return isSignedIn()
        && firestore.get(/databases/(default)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }

    function isValidImage() {
      return request.resource.contentType.matches('image/.*')
        && request.resource.size < 5 * 1024 * 1024; // 5 MB
    }

    match /listings/{listingId}/{fileName} {
      allow read: if true;
      allow write: if isSignedIn()
        && isValidImage()
        && firestore.get(/databases/(default)/documents/listings/$(listingId)).data.sellerId == request.auth.uid;
      allow delete: if isSignedIn()
        && (firestore.get(/databases/(default)/documents/listings/$(listingId)).data.sellerId == request.auth.uid
          || isAdmin());
    }

    match /users/{userId}/avatar.jpg {
      allow read: if true;
      allow write: if isSignedIn()
        && request.auth.uid == userId
        && isValidImage();
      allow delete: if isOwner(userId) || isAdmin();
    }

    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }

    match /categories/{categoryId}/{fileName} {
      allow read: if true;
      allow write, delete: if isAdmin();
    }
  }
}
```

---

## 4. FIRESTORE INDEXES

**File:** `firebase/firestore.indexes.json`

```json
{
  "indexes": [
    {
      "collectionGroup": "listings",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "isDeleted", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "listings",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "isDeleted", "order": "ASCENDING" },
        { "fieldPath": "categoryId", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "listings",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "isDeleted", "order": "ASCENDING" },
        { "fieldPath": "cityId", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "listings",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "isDeleted", "order": "ASCENDING" },
        { "fieldPath": "categoryId", "order": "ASCENDING" },
        { "fieldPath": "cityId", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "listings",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "isDeleted", "order": "ASCENDING" },
        { "fieldPath": "categoryId", "order": "ASCENDING" },
        { "fieldPath": "price", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "listings",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "isDeleted", "order": "ASCENDING" },
        { "fieldPath": "categoryId", "order": "ASCENDING" },
        { "fieldPath": "price", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "listings",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "sellerId", "order": "ASCENDING" },
        { "fieldPath": "isDeleted", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "listings",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "sellerId", "order": "ASCENDING" },
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "listings",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "isDeleted", "order": "ASCENDING" },
        { "fieldPath": "submittedAt", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "listings",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "isDeleted", "order": "ASCENDING" },
        { "fieldPath": "approvedAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "favorites",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "userId", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "favorites",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "userId", "order": "ASCENDING" },
        { "fieldPath": "listingStatus", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "reports",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "reports",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "listingId", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "reports",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "reportedUserId", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "blocks",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "blockerId", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "categories",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "isActive", "order": "ASCENDING" },
        { "fieldPath": "sortOrder", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "categories",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "parentId", "order": "ASCENDING" },
        { "fieldPath": "isActive", "order": "ASCENDING" },
        { "fieldPath": "sortOrder", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "cities",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "isActive", "order": "ASCENDING" },
        { "fieldPath": "sortOrder", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "cities",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "countryCode", "order": "ASCENDING" },
        { "fieldPath": "isActive", "order": "ASCENDING" },
        { "fieldPath": "sortOrder", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "users",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "role", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "users",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "isBlocked", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    }
  ],
  "fieldOverrides": [
    {
      "collectionGroup": "listings",
      "fieldPath": "searchKeywords",
      "indexes": [
        { "order": "ASCENDING", "queryScope": "COLLECTION" },
        { "arrayConfig": "CONTAINS", "queryScope": "COLLECTION" }
      ]
    }
  ]
}
```

### Index → query mapping

| Query | Index used |
|-------|------------|
| Home feed (approved, newest) | `status + isDeleted + createdAt DESC` |
| Category feed | `status + isDeleted + categoryId + createdAt DESC` |
| City filter | `status + isDeleted + cityId + createdAt DESC` |
| Category + city filter | `status + isDeleted + categoryId + cityId + createdAt DESC` |
| Price low→high | `status + isDeleted + categoryId + price ASC` |
| My listings (all) | `sellerId + isDeleted + createdAt DESC` |
| My listings by status | `sellerId + status + createdAt DESC` |
| Admin pending queue | `status + isDeleted + submittedAt ASC` |
| Recently approved | `status + isDeleted + approvedAt DESC` |
| User favorites | `userId + createdAt DESC` |
| Admin reports inbox | `status + createdAt DESC` |
| Active categories | `isActive + sortOrder` |
| Subcategories | `parentId + isActive + sortOrder` |
| Keyword search | `searchKeywords ARRAY_CONTAINS` + other filters |

---

## 5. DAY-BY-DAY PLAN (7 DAYS)

### Day 1 — Foundation & authentication

1. Clone olx-clone; restructure into feature-first layout per Section 1.
2. Create `packages/marketplace_shared` with models, enums, collection constants.
3. Initialize Firebase project (Auth, Firestore, Storage, Analytics, Hosting).
4. Add `firebase/` config: `firebase.json`, rules, indexes (deploy indexes early).
5. Implement Firebase initializer for mobile (`lib/core/firebase/`).
6. Implement Auth feature: email/password sign-up, sign-in, sign-out.
7. On first sign-up, create `users/{uid}` document with `role: user`.
8. Build splash → auth gate → main shell navigation (bottom nav skeleton).
9. Wire Firebase Analytics screen events on auth flows.

### Day 2 — Categories, cities & seed data

1. Implement `categories` repository (read active categories + subcategories).
2. Implement `cities` repository (read active cities, country filter).
3. Build category chips on home screen; category list page.
4. Build city picker widget; persist selection in user profile + local cache.
5. Write `firebase/seed/categories_seed.json` and `cities_seed.json`.
6. Create `scripts/seed_firestore.dart` to populate categories + cities.
7. Render category-specific icons (Cars, Houses, Second-hand).
8. Admin stub: read-only categories/cities list (no CRUD yet).

### Day 3 — Listing creation (draft flow)

1. Implement `listings` data layer (Firestore + Storage datasources).
2. Build create-listing multi-step form: category → details → photos → preview.
3. Implement dynamic `attributes` forms per category (car / house / second-hand).
4. Image picker + upload to `listings/{id}/`; save `imageUrls` + `imagePaths`.
5. Save listing as `status: draft`; validate required fields via `attributeSchema`.
6. Build **My Listings** page showing drafts, rejected, pending, approved tabs.
7. Implement edit + delete for `draft` listings only.
8. Increment `users.listingCount` on create; decrement on draft delete.

### Day 4 — Submit for review & public browse

1. Implement `submit_listing_for_review` use case (`draft` → `pending_review`).
2. Prevent submit if no images or missing required attributes.
3. Build listing feed page: query `approved` + `isDeleted == false`, paginated.
4. Build listing detail page: gallery, attributes, seller info, contact phone.
5. Add filters: category, city, price range (client-side or indexed queries).
6. Add search by `searchKeywords` array (generate keywords on save).
7. Implement view-count increment (transaction-safe).
8. Show listing status badges on seller's **My Listings** (pending, rejected + reason).

### Day 5 — Favorites, reports & blocks

1. Implement favorites toggle; deterministic doc ID `{userId}_{listingId}`.
2. Denormalize listing snapshot fields into favorite doc on create.
3. Build favorites page; sync `listings.favoriteCount` on add/remove.
4. Implement report dialog on listing detail + user profile (type, reason).
5. Create `reports` docs with `status: pending`; prevent duplicate reports (optional).
6. Implement block user flow; hide blocked users' listings in feed (client filter).
7. Build blocked users management page in profile settings.
8. Filter out blocked sellers from search results and detail contact actions.

### Day 6 — Admin dashboard (Flutter Web)

1. Scaffold `admin/lib/main.dart` with admin theme, sidebar, auth guard.
2. Admin login; restrict access to `role in [admin, moderator]` via Firestore check.
3. Dashboard page: counts (pending listings, open reports, users, approved today).
4. **Pending listings** queue: list `status == pending_review`, sort by `submittedAt`.
5. Listing review detail: approve → `approved` + `approvedAt`; reject → `rejectionReason`.
6. Reports inbox: list `status == pending`; resolve / dismiss with `adminNotes`.
7. Users page: list users, block/unblock (`isBlocked`, `blockedReason`).
8. Categories & cities admin CRUD (create, toggle `isActive`, reorder `sortOrder`).
9. Build admin for `flutter build web`; add Firebase Hosting target `admin`.

### Day 7 — Polish, security hardening & deploy

1. Deploy final `firestore.rules` and `storage.rules`; verify with rules emulator tests.
2. Confirm all composite indexes built (Firebase console green).
3. Add `expiresAt` logic for approved listings (90-day default); filter expired in feed.
4. Rejected listing flow: allow seller edit → resubmit `pending_review`.
5. Profile page: edit displayName, phone, city, avatar upload.
6. Empty states, error handling, pull-to-refresh, skeleton loaders on feeds.
7. Firebase Analytics: log `listing_created`, `listing_approved`, `listing_viewed`, `report_submitted`.
8. Deploy admin to Firebase Hosting; smoke-test iOS, Android, and web admin end-to-end.
9. Write README setup steps: flavors, seed script, admin role assignment (`scripts/set_admin_claim.dart` or manual Firestore `role: admin`).

---

## Quick reference

| Item | Value |
|------|-------|
| Listing statuses | `draft` · `pending_review` · `approved` · `rejected` |
| User roles | `user` · `moderator` · `admin` |
| Top categories | `cat_cars` · `cat_houses` · `cat_second_hand` |
| Mobile entry | `lib/main.dart` |
| Admin entry | `admin/lib/main.dart` |
| Shared package | `packages/marketplace_shared/` |
| Master doc | `ARCHITECTURE.md` (this file) |

---

*Generated: 2026-06-14 · Reference for all future development prompts.*
