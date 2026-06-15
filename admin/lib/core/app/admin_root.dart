import 'package:admin/core/l10n/admin_locale_provider.dart';
import 'package:admin/core/shell/admin_shell.dart';
import 'package:admin/features/auth/domain/admin_session.dart';
import 'package:admin/features/auth/presentation/pages/access_denied_screen.dart';
import 'package:admin/features/auth/presentation/pages/admin_login_page.dart';
import 'package:admin/features/auth/presentation/providers/admin_auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminRoot extends ConsumerWidget {
  const AdminRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.str;
    final sessionAsync = ref.watch(adminSessionProvider);

    return sessionAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(child: Text(s.errorWithDetails('$error'))),
      ),
      data: (session) {
        return switch (session.status) {
          AdminSessionStatus.loading => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          AdminSessionStatus.unauthenticated => const AdminLoginPage(),
          AdminSessionStatus.accessDenied => const AccessDeniedScreen(),
          AdminSessionStatus.authenticated => const AdminShell(),
        };
      },
    );
  }
}
