import 'package:bazaar/config/env/env.dart';
import 'package:bazaar/config/routes/app_router.dart';
import 'package:bazaar/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BazaarApp extends ConsumerWidget {
  const BazaarApp({required this.env, super.key});

  final Env env;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: env.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
