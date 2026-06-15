import 'package:bazaar/features/blocks/presentation/providers/block_providers.dart';
import 'package:bazaar/features/shell/presentation/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainShellPage extends ConsumerWidget {
  const MainShellPage({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(blockedUserIdsProvider);

    return Scaffold(
      body: child,
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
