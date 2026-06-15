import 'package:admin/core/l10n/admin_locale_provider.dart';
import 'package:admin/config/theme/admin_theme.dart';
import 'package:admin/core/app/admin_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace_shared/l10n/app_language.dart';

class AdminApp extends ConsumerWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(adminLocaleProvider);
    final strings = ref.watch(adminStringsProvider);

    return MaterialApp(
      title: strings.adminTitle,
      debugShowCheckedModeBanner: false,
      theme: AdminTheme.light,
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
      home: const AdminRoot(),
    );
  }
}
