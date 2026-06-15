// ignore_for_file: avoid_print
//
// Bazaar Firestore seed script (REST API — runs on pure Dart VM).
//
// Run from project root:
//   export BAZAAR_ADMIN_EMAIL=your-admin@email.com
//   export BAZAAR_ADMIN_PASSWORD=your-admin-password
//   dart run tool/seed.dart
//
// Requires:
//   • Firebase Email/Password auth enabled
//   • An admin Firestore user (users/{uid}.role == "admin")
//   • Updated firestore.rules deployed (admin can create approved listings)

import 'dart:convert';
import 'dart:io' show Platform, exitCode, stderr;

import 'package:http/http.dart' as http;
import 'package:marketplace_shared/constants/collection_names.dart';
import 'package:marketplace_shared/enums/listing_category.dart';
import 'package:marketplace_shared/enums/listing_status.dart';
import 'package:marketplace_shared/utils/search_tokens.dart';

const _seedTag = 'bazaar_demo_v1';
const _reviewerEmail = 'review@bazaarapp.com';
const _reviewerPassword = 'Review2024!';
const _projectId = 'bazaar-dev-e4d92';
const _apiKey = 'AIzaSyCXP59PLf4ynrt3iEaEaM41t0Vd5a1aHpw';

const _adminEmailEnv = 'BAZAAR_ADMIN_EMAIL';
const _adminPasswordEnv = 'BAZAAR_ADMIN_PASSWORD';

const _authBase =
    'https://identitytoolkit.googleapis.com/v1/accounts';
const _firestoreBase =
    'https://firestore.googleapis.com/v1/projects/$_projectId/databases/(default)/documents';

// ─── Unsplash image sets (3 per listing) ───────────────────────────────────

const _carImages = [
  [
    'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=800',
    'https://images.unsplash.com/photo-1494976388531-d1058498bdd5?w=800',
    'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=800',
  ],
  [
    'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=800',
    'https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=800',
    'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=800',
  ],
  [
    'https://images.unsplash.com/photo-1619767886555-ef6f060fdc74?w=800',
    'https://images.unsplash.com/photo-1614200179396-2bdb4db74506?w=800',
    'https://images.unsplash.com/photo-1605559424843-9e4c228bf1c2?w=800',
  ],
  [
    'https://images.unsplash.com/photo-1617788138017-80ad40651399?w=800',
    'https://images.unsplash.com/photo-1621007947412-aaf487cc0c44?w=800',
    'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=800',
  ],
];

const _houseImages = [
  [
    'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800',
    'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800',
    'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800',
  ],
  [
    'https://images.unsplash.com/photo-1605276374104-dee2cfba720b?w=800',
    'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?w=800',
    'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800',
  ],
  [
    'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=800',
    'https://images.unsplash.com/photo-1600585154526-990dced4db0d?w=800',
    'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
  ],
  [
    'https://images.unsplash.com/photo-1600607687644-c7171b42498b?w=800',
    'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?w=800',
    'https://images.unsplash.com/photo-1600585154363-67eb9e2e2099?w=800',
  ],
];

const _secondhandImages = [
  [
    'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=800',
    'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800',
    'https://images.unsplash.com/photo-1592899677977-9c10ca588bbd?w=800',
  ],
  [
    'https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=800',
    'https://images.unsplash.com/photo-1486401899868-0e435ed85128?w=800',
    'https://images.unsplash.com/photo-1621259182978-fbf93132d53d?w=800',
  ],
  [
    'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800',
    'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=800',
    'https://images.unsplash.com/photo-1612815154850-32b61fbb9f4a?w=800',
  ],
  [
    'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=800',
    'https://images.unsplash.com/photo-1593784991095-a205069470b6?w=800',
    'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
  ],
  [
    'https://images.unsplash.com/photo-1485965120188-e8f8d33fc5eb?w=800',
    'https://images.unsplash.com/photo-1576435728670-68d0fbf94e85?w=800',
    'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=800',
  ],
];

final _carListings = [
  ('Toyota Corolla 2020', 8500.0, 'New York'),
  ('BMW 3 Series 2019', 22000.0, 'Los Angeles'),
  ('Ford F-150 2021', 31000.0, 'Chicago'),
  ('Honda Civic 2018', 11000.0, 'Houston'),
  ('Tesla Model 3 2022', 38000.0, 'San Francisco'),
  ('Mercedes-Benz C-Class 2020', 29500.0, 'Phoenix'),
  ('Chevrolet Silverado 2019', 27500.0, 'Philadelphia'),
  ('Nissan Altima 2021', 19500.0, 'San Antonio'),
  ('Audi A4 2018', 21000.0, 'San Diego'),
  ('Jeep Wrangler 2020', 33000.0, 'Dallas'),
  ('Subaru Outback 2021', 26500.0, 'San Jose'),
  ('Volkswagen Jetta 2019', 14500.0, 'Austin'),
  ('Lexus RX 350 2020', 36500.0, 'Jacksonville'),
  ('Mazda CX-5 2021', 24000.0, 'Columbus'),
  ('Kia Telluride 2022', 35500.0, 'Charlotte'),
  ('Hyundai Sonata 2020', 16800.0, 'Indianapolis'),
  ('Porsche Cayenne 2019', 52000.0, 'Seattle'),
  ('Volvo XC60 2021', 38900.0, 'Denver'),
  ('Ram 1500 2020', 29900.0, 'Nashville'),
  ('Toyota RAV4 2022', 28900.0, 'Boston'),
];

final _houseListings = [
  ('2BR Apartment for rent', 1800.0, 'Austin'),
  ('3BR House for sale', 320000.0, 'Dallas'),
  ('Studio Apartment', 950.0, 'Seattle'),
  ('4BR Villa for sale', 480000.0, 'Miami'),
  ('1BR Condo for rent', 1400.0, 'Chicago'),
  ('5BR Family Home for sale', 625000.0, 'Atlanta'),
  ('2BR Loft for rent', 2100.0, 'San Francisco'),
  ('3BR Townhouse for sale', 410000.0, 'Denver'),
  ('Studio near downtown', 1100.0, 'Portland'),
  ('4BR Suburban Home for sale', 395000.0, 'Phoenix'),
  ('2BR Beach Apartment for rent', 2400.0, 'San Diego'),
  ('3BR Ranch for sale', 285000.0, 'Nashville'),
  ('1BR City Flat for rent', 1250.0, 'Boston'),
  ('6BR Estate for sale', 890000.0, 'Los Angeles'),
  ('2BR Garden Apartment for rent', 1650.0, 'Minneapolis'),
  ('3BR Craftsman for sale', 445000.0, 'Raleigh'),
  ('4BR Lake House for sale', 550000.0, 'Detroit'),
  ('2BR Penthouse for rent', 3200.0, 'New York'),
  ('3BR Bungalow for sale', 310000.0, 'Tampa'),
  ('1BR Micro-Apartment for rent', 875.0, 'Las Vegas'),
];

final _secondhandListings = [
  ('iPhone 14 Pro 256GB', 720.0, 'Denver'),
  ('PlayStation 5', 420.0, 'Nashville'),
  ('MacBook Pro M2', 1100.0, 'Boston'),
  ('Samsung 65" TV', 480.0, 'Atlanta'),
  ('Road Bicycle', 350.0, 'Portland'),
  ('iPad Air 5th Gen', 480.0, 'Austin'),
  ('Nintendo Switch OLED', 280.0, 'Seattle'),
  ('Sony WH-1000XM5 Headphones', 220.0, 'Chicago'),
  ('Dyson V15 Vacuum', 390.0, 'Dallas'),
  ('Canon EOS R6 Camera', 1650.0, 'Los Angeles'),
  ('IKEA KALLAX Shelf Unit', 65.0, 'Phoenix'),
  ('KitchenAid Stand Mixer', 210.0, 'Miami'),
  ('Garmin Fenix 7 Watch', 520.0, 'San Francisco'),
  ('Xbox Series X', 400.0, 'Houston'),
  ('Bose SoundLink Speaker', 95.0, 'Philadelphia'),
  ('Electric Scooter', 275.0, 'San Diego'),
  ('Leather Office Chair', 140.0, 'Columbus'),
  ('Espresso Machine', 320.0, 'Charlotte'),
  ('DJI Mini 3 Drone', 580.0, 'Denver'),
  ('Vintage Vinyl Record Collection', 180.0, 'Nashville'),
];

const _seedSellers = [
  ('seed_seller_01', 'Alex Morgan'),
  ('seed_seller_02', 'Jordan Kim'),
  ('seed_seller_03', 'Sam Rivera'),
  ('seed_seller_04', 'Taylor Brooks'),
  ('seed_seller_05', 'Casey Nguyen'),
  ('seed_seller_06', 'Riley Patel'),
  ('seed_seller_07', 'Morgan Lee'),
  ('seed_seller_08', 'Jamie Carter'),
];

final _reviewerCarListings = [
  (
    'Honda Accord 2021 — App Review Demo',
    19500.0,
    'San Francisco',
    'Well-maintained sedan for App Store review demo. Single owner, full service history.',
  ),
  (
    'Toyota Camry 2020 — App Review Demo',
    17800.0,
    'Oakland',
    'Reliable daily driver listed for marketplace review testing. Clean title, low mileage.',
  ),
];

Future<void> main(List<String> args) async {
  final adminEmail = _envOrArg(args, _adminEmailEnv, 0);
  final adminPassword = _envOrArg(args, _adminPasswordEnv, 1);

  if (adminEmail == null || adminPassword == null) {
    _fail(
      'Admin credentials required.\n'
      '  export BAZAAR_ADMIN_EMAIL=your-admin@email.com\n'
      '  export BAZAAR_ADMIN_PASSWORD=your-password\n'
      '  dart run tool/seed.dart',
    );
  }

  print('🌱 Bazaar seed script ($_seedTag)');
  print('Project: $_projectId');
  print('');

  print('🔐 Signing in as admin ($adminEmail)...');
  final adminAuth = await _signIn(email: adminEmail, password: adminPassword);
  print('   ✓ Admin authenticated');
  print('');

  final existing = await _runQuery(
    adminAuth.idToken,
    CollectionNames.listings,
    field: 'seedTag',
    value: _seedTag,
    limit: 1,
  );

  if (existing.isNotEmpty) {
    print('⚠️  Seed data already exists (seedTag: $_seedTag).');
    print('   Skipping 60 listings. Updating reviewer account...');
    print('');
    await _seedReviewerAccount(adminAuth.idToken);
    return;
  }

  final now = DateTime.now().toUtc();
  final seededListingIds = <String>[];

  print('📦 Seeding 60 approved listings...');

  Future<void> writeListings({
    required ListingCategory category,
    required List<(String title, double price, String city)> items,
    required List<List<String>> imageSets,
    required String idPrefix,
  }) async {
    for (var i = 0; i < items.length; i++) {
      final (title, price, city) = items[i];
      final seller = _seedSellers[i % _seedSellers.length];
      final id = '${idPrefix}_${(i + 1).toString().padLeft(2, '0')}';
      final images = imageSets[i % imageSets.length];
      final createdAt = now.subtract(Duration(days: 60 - i));

      await _setDocument(
        adminAuth.idToken,
        '${CollectionNames.listings}/$id',
        _listingFields(
          title: title,
          description:
              '$title available in $city. Excellent condition, priced to sell. Contact seller for details.',
          price: price,
          category: category,
          city: city,
          images: images,
          ownerId: seller.$1,
          ownerName: seller.$2,
          createdAt: createdAt,
          updatedAt: now,
          viewCount: 10 + i * 3,
          isFeatured: i < 3,
        ),
      );

      seededListingIds.add(id);
      if ((i + 1) % 10 == 0) {
        print('   ✓ ${i + 1} ${category.label} listings written');
      }
    }
  }

  await writeListings(
    category: ListingCategory.cars,
    items: _carListings,
    imageSets: _carImages,
    idPrefix: 'seed_car',
  );
  await writeListings(
    category: ListingCategory.houses,
    items: _houseListings,
    imageSets: _houseImages,
    idPrefix: 'seed_house',
  );
  await writeListings(
    category: ListingCategory.secondhand,
    items: _secondhandListings,
    imageSets: _secondhandImages,
    idPrefix: 'seed_secondhand',
  );

  print('   ✓ 60 listings seeded');
  print('');

  await _seedReviewerAccount(
    adminAuth.idToken,
    favoriteListingIds: seededListingIds.take(5).toList(),
  );

  print('');
  print('✅ Seed complete!');
  print('   • 60 approved listings (20 cars, 20 houses, 20 second-hand)');
  print('   • Demo reviewer: $_reviewerEmail / $_reviewerPassword');
  print('   • 2 reviewer car listings + 5 favorites');
}

Future<void> _seedReviewerAccount(
  String adminIdToken, {
  List<String>? favoriteListingIds,
}) async {
  print('👤 Setting up demo reviewer account...');

  AuthTokens reviewerAuth;
  try {
    reviewerAuth = await _signUp(
      email: _reviewerEmail,
      password: _reviewerPassword,
    );
    print('   ✓ Auth user created');
  } on _AuthException catch (error) {
    if (error.code == 'EMAIL_EXISTS') {
      print('   ℹ Auth user already exists, signing in...');
      reviewerAuth = await _signIn(
        email: _reviewerEmail,
        password: _reviewerPassword,
      );
    } else {
      rethrow;
    }
  }

  final uid = reviewerAuth.localId;
  final now = DateTime.now().toUtc();

  await _setDocument(
    reviewerAuth.idToken,
    '${CollectionNames.users}/$uid',
    {
      'email': _str(_reviewerEmail),
      'displayName': _str('App Reviewer'),
      'role': _str('user'),
      'isBlocked': _bool(false),
      'isBanned': _bool(false),
      'isAdmin': _bool(false),
      'listingCount': _int(0),
      'approvedListingCount': _int(0),
      'emailVerified': _bool(true),
      'phoneVerified': _bool(false),
      'bio': _str(''),
      'notificationSettings': {
        'mapValue': {
          'fields': {
            'listingApproved': _bool(true),
            'listingRejected': _bool(true),
          },
        },
      },
      'preferredLanguage': _str('en'),
      'seedTag': _str(_seedTag),
      'createdAt': _ts(now),
      'updatedAt': _ts(now),
      'lastActiveAt': _ts(now),
    },
  );

  print('   ✓ Firestore profile: users/$uid');

  for (var i = 0; i < _reviewerCarListings.length; i++) {
    final (title, price, city, description) = _reviewerCarListings[i];
    final id = 'seed_reviewer_car_${i + 1}';
    final images = _carImages[i % _carImages.length];
    final createdAt = now.subtract(Duration(days: 5 - i));

    await _setDocument(
      adminIdToken,
      '${CollectionNames.listings}/$id',
      _listingFields(
        title: title,
        description: description,
        price: price,
        category: ListingCategory.cars,
        city: city,
        images: images,
        ownerId: uid,
        ownerName: 'App Reviewer',
        createdAt: createdAt,
        updatedAt: now,
        viewCount: 25 + i * 10,
        isFeatured: false,
      ),
    );
  }

  await _patchDocument(
    adminIdToken,
    '${CollectionNames.users}/$uid',
    {
      'listingCount': _int(_reviewerCarListings.length),
      'approvedListingCount': _int(_reviewerCarListings.length),
      'updatedAt': _ts(now),
    },
  );

  print('   ✓ 2 approved car listings for reviewer');

  var favIds = favoriteListingIds;
  if (favIds == null || favIds.isEmpty) {
    final snap = await _runQuery(
      adminIdToken,
      CollectionNames.listings,
      field: 'seedTag',
      value: _seedTag,
      limit: 5,
    );
    favIds = snap.map((d) => d.split('/').last).toList();
  }

  for (final listingId in favIds.take(5)) {
    await _setDocument(
      reviewerAuth.idToken,
      '${CollectionNames.favorites}/$uid/items/$listingId',
      {
        'listingId': _str(listingId),
        'addedAt': _ts(now),
      },
    );
  }

  print('   ✓ 5 favorites added');
  print('');
  print('   Login credentials:');
  print('     Email:    $_reviewerEmail');
  print('     Password: $_reviewerPassword');
}

// ─── Firestore field builders ────────────────────────────────────────────────

Map<String, dynamic> _listingFields({
  required String title,
  required String description,
  required double price,
  required ListingCategory category,
  required String city,
  required List<String> images,
  required String ownerId,
  required String ownerName,
  required DateTime createdAt,
  required DateTime updatedAt,
  required int viewCount,
  required bool isFeatured,
}) {
  return {
    'title': _str(title),
    'description': _str(description),
    'price': _double(price),
    'category': _str(category.value),
    'city': _str(city),
    'images': _strArray(images),
    'ownerId': _str(ownerId),
    'ownerName': _str(ownerName),
    'ownerPhoto': {'nullValue': null},
    'status': _str(ListingStatus.approved.value),
    'createdAt': _ts(createdAt),
    'updatedAt': _ts(updatedAt),
    'approvedAt': _ts(updatedAt),
    'viewCount': _int(viewCount),
    'isFeatured': _bool(isFeatured),
    'sellerId': _str(ownerId),
    'isDeleted': _bool(false),
    'favoriteCount': _int(0),
    'seedTag': _str(_seedTag),
    'searchTokens': _strArray(
      generateSearchTokens(title: title, description: description),
    ),
  };
}

Map<String, dynamic> _str(String v) => {'stringValue': v};
Map<String, dynamic> _int(int v) => {'integerValue': '$v'};
Map<String, dynamic> _double(double v) => {'doubleValue': v};
Map<String, dynamic> _bool(bool v) => {'booleanValue': v};
Map<String, dynamic> _ts(DateTime v) => {
      'timestampValue': v.toIso8601String(),
    };
Map<String, dynamic> _strArray(List<String> values) => {
      'arrayValue': {
        'values': values.map(_str).toList(),
      },
    };

// ─── REST helpers ────────────────────────────────────────────────────────────

class AuthTokens {
  const AuthTokens({required this.idToken, required this.localId});

  final String idToken;
  final String localId;
}

class _AuthException implements Exception {
  const _AuthException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => message;
}

Future<AuthTokens> _signIn({
  required String email,
  required String password,
}) async {
  final res = await http.post(
    Uri.parse('$_authBase:signInWithPassword?key=$_apiKey'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    }),
  );

  final body = jsonDecode(res.body) as Map<String, dynamic>;
  if (res.statusCode != 200) {
    throw _AuthException(
      body['error']?['message'] as String? ?? 'AUTH_ERROR',
      body['error']?['message'] as String? ?? 'Sign-in failed',
    );
  }

  return AuthTokens(
    idToken: body['idToken'] as String,
    localId: body['localId'] as String,
  );
}

Future<AuthTokens> _signUp({
  required String email,
  required String password,
}) async {
  final res = await http.post(
    Uri.parse('$_authBase:signUp?key=$_apiKey'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    }),
  );

  final body = jsonDecode(res.body) as Map<String, dynamic>;
  if (res.statusCode != 200) {
    throw _AuthException(
      body['error']?['message'] as String? ?? 'AUTH_ERROR',
      body['error']?['message'] as String? ?? 'Sign-up failed',
    );
  }

  return AuthTokens(
    idToken: body['idToken'] as String,
    localId: body['localId'] as String,
  );
}

Future<void> _setDocument(
  String idToken,
  String docPath,
  Map<String, dynamic> fields,
) async {
  final res = await http.patch(
    Uri.parse('$_firestoreBase/$docPath'),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'fields': fields}),
  );

  if (res.statusCode != 200) {
    _fail('Firestore write failed ($docPath): ${res.body}');
  }
}

Future<void> _patchDocument(
  String idToken,
  String docPath,
  Map<String, dynamic> fields,
) async {
  final mask = fields.keys.map(Uri.encodeComponent).join('&updateMask.fieldPaths=');
  final res = await http.patch(
    Uri.parse('$_firestoreBase/$docPath?updateMask.fieldPaths=$mask'),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'fields': fields}),
  );

  if (res.statusCode != 200) {
    _fail('Firestore patch failed ($docPath): ${res.body}');
  }
}

Future<List<String>> _runQuery(
  String idToken,
  String collection,
  {
  required String field,
  required String value,
  int limit = 1,
}) async {
  final res = await http.post(
    Uri.parse(
      'https://firestore.googleapis.com/v1/projects/$_projectId/databases/(default)/documents:runQuery',
    ),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'structuredQuery': {
        'from': [{'collectionId': collection}],
        'where': {
          'fieldFilter': {
            'field': {'fieldPath': field},
            'op': 'EQUAL',
            'value': {'stringValue': value},
          },
        },
        'limit': limit,
      },
    }),
  );

  if (res.statusCode != 200) {
    return [];
  }

  final rows = jsonDecode(res.body) as List<dynamic>;
  return rows
      .whereType<Map<String, dynamic>>()
      .where((row) => row.containsKey('document'))
      .map((row) => row['document']['name'] as String)
      .toList();
}

String? _envOrArg(List<String> args, String envKey, int argIndex) {
  final fromEnv = Platform.environment[envKey];
  if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
  if (args.length > argIndex && args[argIndex].isNotEmpty) return args[argIndex];
  return null;
}

Never _fail(String message) {
  stderr.writeln('❌ $message');
  exitCode = 1;
  throw StateError(message);
}
