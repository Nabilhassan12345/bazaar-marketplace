import 'package:bazaar/core/l10n/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace_shared/l10n/app_language.dart';

class LanguageSelectorTile extends ConsumerWidget {
  const LanguageSelectorTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.str;
    final current = ref.watch(localeProvider);

    return ListTile(
      leading: const Icon(Icons.language_outlined),
      title: Text(strings.languageLabel),
      subtitle: Text(current.nativeName),
      onTap: () async {
        final selected = await showModalBottomSheet<AppLanguage>(
          context: context,
          showDragHandle: true,
          builder: (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    strings.languageLabel,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                for (final lang in AppLanguage.values)
                  ListTile(
                    leading: Icon(
                      current == lang ? Icons.check_circle : Icons.circle_outlined,
                      color: current == lang
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    title: Text(lang.nativeName),
                    subtitle: Text(lang.englishName),
                    onTap: () => Navigator.pop(context, lang),
                  ),
              ],
            ),
          ),
        );
        if (selected != null && selected != current) {
          await ref.read(localeProvider.notifier).setLanguage(selected);
        }
      },
    );
  }
}
