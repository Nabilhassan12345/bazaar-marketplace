import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  static const _content = '''
Terms of Service

Last updated: June 2026

Welcome to Bazaar. By creating an account or using our marketplace app, you agree to these Terms of Service.

Using Bazaar

Bazaar is a platform that helps people buy and sell items locally. You are responsible for the accuracy of your listings and for your interactions with other users.

Prohibited Items

You may not list, sell, or promote the following on Bazaar:

• Weapons, firearms, ammunition, or explosives
• Illegal drugs, controlled substances, or drug paraphernalia
• Stolen goods or items you do not have the right to sell
• Adult or sexually explicit content
• Any item that violates applicable local, national, or international law

We reserve the right to remove listings and suspend accounts that violate these rules.

Account Suspension

We may suspend or permanently ban accounts that:

• Post prohibited items or misleading listings
• Engage in fraud, harassment, spam, or abusive behavior
• Receive repeated valid reports from other users
• Violate these Terms or applicable laws

Suspended users may lose access to listings, messages, and account features.

Transactions and Liability

Bazaar is a marketplace platform only. We do not process payments between buyers and sellers, and we are not a party to any transaction.

You are solely responsible for:

• Negotiating prices and payment methods with other users
• Meeting safely and verifying items before purchase
• Complying with local laws related to buying and selling

Bazaar is not responsible for the quality, safety, legality, or delivery of items listed by users, nor for any disputes, losses, or damages arising from transactions between users.

Changes to These Terms

We may update these Terms from time to time. Continued use of Bazaar after changes are posted constitutes acceptance of the updated Terms.

Contact Us

If you have questions about these Terms, contact us at:

support@bazaarapp.com
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
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
