import 'package:admin/app.dart';
import 'package:admin/core/firebase/firebase_initializer.dart';
import 'package:admin/core/l10n/admin_locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.initialize();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [adminLocaleOverride(prefs)],
      child: const AdminApp(),
    ),
  );
}
