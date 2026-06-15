// ignore_for_file: avoid_print
//
// One-time bootstrap: promote your Firebase Auth user to admin in Firestore.
//
// Prerequisites:
//   • firestore.rules deployed with bootstrap allow for your UID (see BOOTSTRAP_ADMIN_UID)
//   • Email/password account already exists in Firebase Auth
//
// Run from project root:
//   export BAZAAR_ADMIN_EMAIL=you@example.com
//   export BAZAAR_ADMIN_PASSWORD=your-password
//   dart run tool/promote_admin.dart
//
// After success, remove BOOTSTRAP_ADMIN_UID from firestore.rules and redeploy.

import 'dart:convert';
import 'dart:io' show Platform, exitCode, stderr;

import 'package:http/http.dart' as http;
import 'package:marketplace_shared/constants/collection_names.dart';

const _projectId = 'bazaar-dev-e4d92';
const _apiKey = 'AIzaSyCXP59PLf4ynrt3iEaEaM41t0Vd5a1aHpw';
const _expectedUid = 'Sgue66y7EANCYj6mLFjFkpOtD572';

const _emailEnv = 'BAZAAR_ADMIN_EMAIL';
const _passwordEnv = 'BAZAAR_ADMIN_PASSWORD';

const _authBase = 'https://identitytoolkit.googleapis.com/v1/accounts';
const _firestoreBase =
    'https://firestore.googleapis.com/v1/projects/$_projectId/databases/(default)/documents';

Future<void> main(List<String> args) async {
  final email = _envOrArg(args, _emailEnv, 0);
  final password = _envOrArg(args, _passwordEnv, 1);

  if (email == null || password == null) {
    print('Usage:');
    print('  export BAZAAR_ADMIN_EMAIL=you@example.com');
    print('  export BAZAAR_ADMIN_PASSWORD=your-password');
    print('  dart run tool/promote_admin.dart');
    exitCode = 1;
    return;
  }

  print('🔐 Signing in as $email...');
  final auth = await _signIn(email: email, password: password);

  if (auth.localId != _expectedUid) {
    _fail(
      'UID mismatch: signed in as ${auth.localId}, expected $_expectedUid.\n'
      'Use the account that matches your Firebase Auth UID.',
    );
  }

  final docPath = '${CollectionNames.users}/${auth.localId}';
  final now = DateTime.now().toUtc();

  print('👤 Promoting users/${auth.localId} to admin...');

  final existing = await _getDocument(auth.idToken, docPath);
  if (existing == null) {
    await _setDocument(
      auth.idToken,
      docPath,
      {
        'email': _str(email),
        'displayName': _str(email.split('@').first),
        'role': _str('admin'),
        'isBlocked': _bool(false),
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
        'createdAt': _ts(now),
        'updatedAt': _ts(now),
      },
    );
    print('   ✓ Created Firestore profile with role=admin');
  } else {
    final currentRole = existing['role']?['stringValue'] as String? ?? 'user';
    if (currentRole == 'admin') {
      print('   ℹ Already admin — nothing to do.');
    } else {
      await _patchDocument(
        auth.idToken,
        docPath,
        {
          'role': _str('admin'),
          'updatedAt': _ts(now),
        },
      );
      print('   ✓ Updated role: $currentRole → admin');
    }
  }

  print('');
  print('✅ Done! Sign out and back in on the admin dashboard.');
  print('   Then remove BOOTSTRAP_ADMIN_UID from firebase/firestore.rules and redeploy.');
}

Map<String, dynamic> _str(String v) => {'stringValue': v};
Map<String, dynamic> _int(int v) => {'integerValue': '$v'};
Map<String, dynamic> _bool(bool v) => {'booleanValue': v};
Map<String, dynamic> _ts(DateTime v) => {
      'timestampValue': v.toIso8601String(),
    };

class AuthTokens {
  const AuthTokens({required this.idToken, required this.localId});

  final String idToken;
  final String localId;
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
    final message = body['error']?['message'] as String? ?? 'Sign-in failed';
    _fail(message);
  }

  return AuthTokens(
    idToken: body['idToken'] as String,
    localId: body['localId'] as String,
  );
}

Future<Map<String, dynamic>?> _getDocument(
  String idToken,
  String docPath,
) async {
  final res = await http.get(
    Uri.parse('$_firestoreBase/$docPath'),
    headers: {'Authorization': 'Bearer $idToken'},
  );

  if (res.statusCode == 404) return null;
  if (res.statusCode != 200) {
    _fail('Firestore read failed ($docPath): ${res.body}');
  }

  final body = jsonDecode(res.body) as Map<String, dynamic>;
  return body['fields'] as Map<String, dynamic>?;
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
