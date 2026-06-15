import 'package:bazaar/core/l10n/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditListingPage extends ConsumerWidget {
  const EditListingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.str;

    return Scaffold(
      appBar: AppBar(title: Text(s.editListing)),
      body: Center(child: Text(s.editListing)),
    );
  }
}
