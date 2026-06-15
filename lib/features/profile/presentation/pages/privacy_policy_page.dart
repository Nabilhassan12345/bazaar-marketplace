import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const _content = '''
Privacy Policy

Last updated: June 2026

Bazaar ("we", "our", or "us") operates the Bazaar marketplace mobile application. This Privacy Policy explains how we collect, use, and protect your information when you use our app.

What We Collect

When you use Bazaar, we may collect:

• Name and display name — provided when you create your account or edit your profile.
• Email address — used for account sign-in, communication, and account recovery.
• Listing data — including titles, descriptions, prices, categories, cities, and status when you post items for sale.
• Photos — images you upload for your listings or profile avatar.
• Usage data — such as favorites, search activity, and listing views to operate core marketplace features.

How We Use Your Information

We use the information we collect to:

• Operate the Bazaar marketplace and display listings to buyers and sellers.
• Create and manage your account.
• Process your listings, favorites, and profile updates.
• Improve app performance, safety, and user experience.
• Respond to support requests and enforce our Terms of Service.

Firebase and Google Services

Bazaar uses Google Firebase services to provide authentication, database storage, file storage, and analytics. These services may process your data according to Google's privacy policies. Firebase Authentication handles your sign-in credentials. Cloud Firestore stores your profile, listings, and app data. Firebase Storage stores photos you upload.

Your data is stored securely using industry-standard practices provided by Google Cloud infrastructure.

How to Delete Your Account

You can delete your account at any time from within the app:

Settings → Delete My Account

Deleting your account permanently removes your profile, listings, and favorites from Bazaar. This action cannot be undone.

Contact Us

If you have questions about this Privacy Policy or your data, contact us at:

privacy@bazaarapp.com
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: SelectableText(
          _content,
          style: TextStyle(fontSize: 15, height: 1.6),
        ),
      ),
    );
  }
}
