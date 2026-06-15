import 'package:bazaar/core/l10n/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrivacyPolicyPage extends ConsumerWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.str;
    return Scaffold(
      appBar: AppBar(title: Text(s.privacyPolicy)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: SelectableText(
          s.privacyPolicyContent,
          style: const TextStyle(fontSize: 15, height: 1.6),
        ),
      ),
    );
  }
}
