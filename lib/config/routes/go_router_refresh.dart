import 'package:flutter/material.dart';

/// Notifies [GoRouter] to re-run redirects when auth state resolves or changes.
class GoRouterAuthRefresh extends ChangeNotifier {
  void refresh() => notifyListeners();
}
