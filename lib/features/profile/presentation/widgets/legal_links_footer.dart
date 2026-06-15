import 'package:bazaar/config/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bazaar/core/l10n/locale_provider.dart';

class LegalLinksFooter extends ConsumerWidget {
  const LegalLinksFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.str;

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          s.legalAgreePrefix,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
        TextButton(
          onPressed: () => context.pushNamed(RouteKeys.termsOfService),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(s.termsOfService),
        ),
        Text(
          s.legalAnd,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
        TextButton(
          onPressed: () => context.pushNamed(RouteKeys.privacyPolicy),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(s.privacyPolicy),
        ),
        Text(
          '.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
      ],
    );
  }
}
