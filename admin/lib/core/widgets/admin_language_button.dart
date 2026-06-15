import 'package:admin/core/l10n/admin_locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace_shared/l10n/app_language.dart';

class AdminLanguageButton extends ConsumerWidget {
  const AdminLanguageButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(adminLocaleProvider);

    return PopupMenuButton<AppLanguage>(
      tooltip: ref.str.languageLabel,
      icon: const Icon(Icons.language),
      onSelected: (lang) => ref.read(adminLocaleProvider.notifier).setLanguage(lang),
      itemBuilder: (context) => [
        for (final lang in AppLanguage.values)
          PopupMenuItem(
            value: lang,
            child: Row(
              children: [
                if (current == lang) ...[
                  Icon(Icons.check, size: 18, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                ] else
                  const SizedBox(width: 26),
                Text(lang.nativeName),
              ],
            ),
          ),
      ],
    );
  }
}
