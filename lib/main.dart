import 'package:bazaar/app.dart';
import 'package:bazaar/config/env/dev_env.dart';
import 'package:bazaar/core/firebase/firebase_initializer.dart';
import 'package:bazaar/features/search/presentation/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.initialize();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const BazaarApp(env: DevEnv()),
    ),
  );
}
