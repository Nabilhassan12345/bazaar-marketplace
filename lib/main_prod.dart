import 'package:bazaar/app.dart';
import 'package:bazaar/config/env/prod_env.dart';
import 'package:bazaar/core/firebase/firebase_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.initialize();
  runApp(
    const ProviderScope(
      child: BazaarApp(env: ProdEnv()),
    ),
  );
}
