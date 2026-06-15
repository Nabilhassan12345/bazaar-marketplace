import 'package:bazaar/config/routes/route_names.dart';
import 'package:bazaar/core/l10n/locale_provider.dart';
import 'package:bazaar/features/profile/presentation/providers/package_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends ConsumerWidget {
  const ContactUsPage({super.key});

  static const _supportEmail = 'support@bazaarapp.com';

  Future<void> _emailSupport() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      query: 'subject=Bazaar%20App%20Support',
    );
    if (!await launchUrl(uri)) {
      throw Exception('Could not open email client');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.str;
    final versionAsync = ref.watch(packageInfoProvider);

    return Scaffold(
      appBar: AppBar(title: Text(s.contactUs)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            s.contactUsHeading,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(s.contactUsBody),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () async {
              try {
                await _emailSupport();
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(s.couldNotOpenEmail)),
                  );
                }
              }
            },
            icon: const Icon(Icons.email_outlined),
            label: Text(s.emailUs),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              _supportEmail,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 32),
          versionAsync.when(
            loading: () => ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(s.appVersion),
              subtitle: Text(s.loading),
            ),
            error: (_, __) => ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(s.appVersion),
              subtitle: Text(s.unknown),
            ),
            data: (info) => ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(s.appVersion),
              subtitle: Text('${info.version} (${info.buildNumber})'),
            ),
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(s.privacyPolicy),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed(RouteKeys.privacyPolicy),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(s.termsOfService),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed(RouteKeys.termsOfService),
          ),
        ],
      ),
    );
  }
}
