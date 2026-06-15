import 'package:bazaar/config/env/env.dart';
import 'package:bazaar/config/routes/app_router.dart';
import 'package:bazaar/config/theme/app_theme.dart';
import 'package:bazaar/core/l10n/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace_shared/l10n/app_language.dart';

class BazaarApp extends ConsumerWidget {
  const BazaarApp({required this.env, super.key});

  final Env env;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final language = ref.watch(localeProvider);
    final strings = ref.watch(bazaarStringsProvider);

    return MaterialApp.router(
      title: strings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: Locale(language.code),
      supportedLocales: AppLanguage.supportedCodes.map(Locale.new).toList(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection:
              language == AppLanguage.ar ? TextDirection.rtl : TextDirection.ltr,
          child: child ?? const SizedBox.shrink(),
        );
      },
      routerConfig: router,
    );
  }
}
