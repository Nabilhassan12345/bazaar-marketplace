import 'package:bazaar/config/routes/route_names.dart';
import 'package:bazaar/core/l10n/locale_provider.dart';
import 'package:bazaar/core/widgets/language_selector_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.str;

    return Scaffold(
      appBar: AppBar(title: Text(s.settings)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.block_outlined),
            title: Text(s.blockedUsers),
            subtitle: Text(s.blockedUsersSubtitle),
            onTap: () => context.pushNamed(RouteKeys.blockedUsers),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(s.privacyPolicy),
            onTap: () => context.pushNamed(RouteKeys.privacyPolicy),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(s.termsOfService),
            onTap: () => context.pushNamed(RouteKeys.termsOfService),
          ),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: Text(s.contactUs),
            onTap: () => context.pushNamed(RouteKeys.contactUs),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(s.notifications),
            subtitle: Text(s.comingSoon),
          ),
          const LanguageSelectorTile(),
          const Divider(),
          ListTile(
            leading: Icon(Icons.delete_forever_outlined, color: Colors.red.shade700),
            title: Text(
              s.deleteAccount,
              style: TextStyle(color: Colors.red.shade700),
            ),
            subtitle: Text(s.deleteAccountSubtitle),
            onTap: () => context.pushNamed(RouteKeys.deleteAccount),
          ),
        ],
      ),
    );
  }
}
