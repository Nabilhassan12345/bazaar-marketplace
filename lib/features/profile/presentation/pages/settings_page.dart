import 'package:bazaar/config/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.block_outlined),
            title: const Text('Blocked Users'),
            subtitle: const Text('Manage users you have blocked'),
            onTap: () => context.pushNamed(RouteKeys.blockedUsers),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () => context.pushNamed(RouteKeys.privacyPolicy),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Service'),
            onTap: () => context.pushNamed(RouteKeys.termsOfService),
          ),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text('Contact Us'),
            onTap: () => context.pushNamed(RouteKeys.contactUs),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text('Notifications'),
            subtitle: Text('Coming soon'),
          ),
          const ListTile(
            leading: Icon(Icons.language_outlined),
            title: Text('Language'),
            subtitle: Text('Coming soon'),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.delete_forever_outlined, color: Colors.red.shade700),
            title: Text(
              'Delete My Account',
              style: TextStyle(color: Colors.red.shade700),
            ),
            subtitle: const Text('Permanently delete your account and data'),
            onTap: () => context.pushNamed(RouteKeys.deleteAccount),
          ),
        ],
      ),
    );
  }
}
