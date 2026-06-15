import 'package:admin/config/theme/admin_theme.dart';
import 'package:admin/core/app/admin_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminApp extends ConsumerWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Bazaar Admin',
      debugShowCheckedModeBanner: false,
      theme: AdminTheme.light,
      home: const AdminRoot(),
    );
  }
}
