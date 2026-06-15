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
import 'package:marketplace_shared/constants/market_geography.dart';
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
  ('Toyota Corolla 2020', 5200000.0, 'bf-ouagadougou'),
  ('Peugeot 301 2019', 4500000.0, 'ci-abidjan'),
  ('Hyundai Tucson 2021', 8900000.0, 'bf-bobo-dioulasso'),
  ('Toyota Hilux 2018', 12500000.0, 'sd-khartoum'),
  ('Renault Duster 2020', 6800000.0, 'ci-bouake'),
  ('Mercedes C200 2019', 15000000.0, 'sd-omdurman'),
  ('Nissan Patrol 2017', 18000000.0, 'ci-daloa'),
  ('Suzuki Swift 2021', 4200000.0, 'bf-koudougou'),
  ('Mitsubishi Pajero 2018', 11000000.0, 'sd-port-sudan'),
  ('Kia Rio 2020', 4800000.0, 'ci-yamoussoukro'),
  ('Ford Ranger 2019', 13500000.0, 'ci-san-pedro'),
  ('Honda CR-V 2021', 9500000.0, 'ci-korhogo'),
  ('Toyota Yaris 2022', 5500000.0, 'bf-ouahigouya'),
  ('Chevrolet Spark 2018', 3200000.0, 'sd-kassala'),
  ('Volkswagen Golf 2020', 7200000.0, 'ci-man'),
  ('Mazda 3 2019', 6100000.0, 'bf-banfora'),
  ('Isuzu D-Max 2020', 10200000.0, 'sd-nyala'),
  ('Toyota Land Cruiser 2016', 25000000.0, 'ci-gagnoa'),
  ('Peugeot 208 2021', 4900000.0, 'sd-el-obeid'),
  ('Hyundai Accent 2019', 4100000.0, 'sd-wad-madani'),
];

final _houseListings = [
  ('Appartement 2 chambres à louer', 85000.0, 'bf-ouagadougou'),
  ('Maison 3 chambres à vendre', 45000000.0, 'ci-abidjan'),
  ('Studio meublé', 120000.0, 'bf-bobo-dioulasso'),
  ('Villa 4 chambres à vendre', 95000000.0, 'sd-khartoum'),
  ('Appartement 1 chambre', 65000.0, 'ci-bouake'),
  ('Maison familiale 5 chambres', 72000000.0, 'sd-omdurman'),
  ('Loft 2 chambres à louer', 150000.0, 'ci-daloa'),
  ('Maison 3 chambres à vendre', 38000000.0, 'bf-koudougou'),
  ('Studio centre-ville', 90000.0, 'sd-port-sudan'),
  ('Maison 4 chambres', 55000000.0, 'ci-yamoussoukro'),
  ('Appartement bord de mer', 200000.0, 'ci-san-pedro'),
  ('Maison 3 chambres', 32000000.0, 'ci-korhogo'),
  ('Appartement 1 chambre', 75000.0, 'sd-kassala'),
  ('Villa de luxe', 120000000.0, 'ci-abidjan'),
  ('Appartement jardin', 110000.0, 'bf-ouahigouya'),
  ('Maison 3 chambres', 41000000.0, 'ci-man'),
  ('Maison 4 chambres au lac', 48000000.0, 'bf-banfora'),
  ('Penthouse 2 chambres', 280000.0, 'sd-khartoum'),
  ('Bungalow 3 chambres', 35000000.0, 'ci-gagnoa'),
  ('Micro-appartement', 55000.0, 'sd-atbara'),
];

final _secondhandListings = [
  ('iPhone 14 Pro 256 Go', 420000.0, 'bf-ouagadougou'),
  ('PlayStation 5', 280000.0, 'ci-abidjan'),
  ('MacBook Pro M2', 750000.0, 'bf-bobo-dioulasso'),
  ('Samsung TV 65"', 320000.0, 'sd-khartoum'),
  ('Vélo de route', 85000.0, 'ci-bouake'),
  ('iPad Air 5e gen', 290000.0, 'ci-daloa'),
  ('Nintendo Switch OLED', 180000.0, 'bf-koudougou'),
  ('Casque Sony WH-1000XM5', 145000.0, 'sd-omdurman'),
  ('Aspirateur Dyson V15', 220000.0, 'ci-yamoussoukro'),
  ('Appareil photo Canon EOS R6', 680000.0, 'sd-port-sudan'),
  ('Étagère IKEA KALLAX', 35000.0, 'ci-san-pedro'),
  ('Robot cuisine KitchenAid', 120000.0, 'ci-korhogo'),
  ('Montre Garmin Fenix 7', 310000.0, 'sd-kassala'),
  ('Xbox Series X', 260000.0, 'ci-man'),
  ('Enceinte Bose SoundLink', 65000.0, 'bf-ouahigouya'),
  ('Trottinette électrique', 95000.0, 'sd-nyala'),
  ('Chaise de bureau cuir', 55000.0, 'bf-banfora'),
  ('Machine à espresso', 110000.0, 'sd-el-obeid'),
  ('Drone DJI Mini 3', 380000.0, 'sd-wad-madani'),
  ('Collection vinyles vintage', 75000.0, 'ci-gagnoa'),
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
    'Honda Accord 2021 — Démo',
    12500000.0,
    'ci-abidjan',
    'Berline bien entretenue pour la démonstration. Un seul propriétaire.',
  ),
  (
    'Toyota Camry 2020 — App Review Demo',
    17800000.0,
    'bf-ouagadougou',
    'Véhicule fiable pour les tests de revue. Bon état, faible kilométrage.',
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
    required List<(String title, double price, String localityId)> items,
    required List<List<String>> imageSets,
    required String idPrefix,
  }) async {
    for (var i = 0; i < items.length; i++) {
      final (title, price, localityId) = items[i];
      final seller = _seedSellers[i % _seedSellers.length];
      final id = '${idPrefix}_${(i + 1).toString().padLeft(2, '0')}';
      final images = imageSets[i % imageSets.length];
      final createdAt = now.subtract(Duration(days: 60 - i));
      final cityLabel = MarketGeography.localityLabel(localityId, 'fr');

      await _setDocument(
        adminAuth.idToken,
        '${CollectionNames.listings}/$id',
        _listingFields(
          title: title,
          description:
              '$title disponible à $cityLabel. Excellent état, prix attractif. Contactez le vendeur pour plus de détails.',
          price: price,
          category: category,
          localityId: localityId,
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
      'preferredLanguage': _str('fr'),
      'seedTag': _str(_seedTag),
      'createdAt': _ts(now),
      'updatedAt': _ts(now),
      'lastActiveAt': _ts(now),
    },
  );

  print('   ✓ Firestore profile: users/$uid');

  for (var i = 0; i < _reviewerCarListings.length; i++) {
    final (title, price, localityId, description) = _reviewerCarListings[i];
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
        localityId: localityId,
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
  required String localityId,
  required List<String> images,
  required String ownerId,
  required String ownerName,
  required DateTime createdAt,
  required DateTime updatedAt,
  required int viewCount,
  required bool isFeatured,
}) {
  final locality = MarketGeography.localityById(localityId);
  if (locality == null) {
    _fail('Unknown locality id: $localityId');
  }

  return {
    'title': _str(title),
    'description': _str(description),
    'price': _double(price),
    'category': _str(category.value),
    'city': _str(localityId),
    'countryCode': _str(locality.countryCode),
    'regionId': _str(locality.regionId),
    'districtId': _str(locality.districtId),
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
