import 'package:admin/core/l10n/admin_locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CitiesAdminPage extends ConsumerWidget {
  const CitiesAdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.str;
    return Scaffold(
      appBar: AppBar(title: Text(s.cities)),
      body: Center(child: Text(s.cities)),
    );
  }
}
