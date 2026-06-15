import 'package:bazaar/config/routes/route_names.dart';
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
    final versionAsync = ref.watch(packageInfoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'We\'re here to help',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Have a question, issue, or feedback? Reach out to our support team.',
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () async {
              try {
                await _emailSupport();
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not open email app.'),
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.email_outlined),
            label: const Text('Email us'),
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
            loading: () => const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('App version'),
              subtitle: Text('Loading...'),
            ),
            error: (_, __) => const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('App version'),
              subtitle: Text('Unknown'),
            ),
            data: (info) => ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('App version'),
              subtitle: Text('${info.version} (${info.buildNumber})'),
            ),
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed(RouteKeys.privacyPolicy),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed(RouteKeys.termsOfService),
          ),
        ],
      ),
    );
  }
}
