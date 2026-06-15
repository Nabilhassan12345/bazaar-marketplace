import 'package:bazaar/config/routes/route_names.dart';
import 'package:bazaar/core/l10n/locale_provider.dart';
import 'package:bazaar/features/auth/presentation/providers/auth_providers.dart';
import 'package:bazaar/features/profile/data/datasources/account_deletion_datasource.dart';
import 'package:bazaar/features/profile/presentation/providers/account_deletion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DeleteAccountPage extends ConsumerStatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  ConsumerState<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends ConsumerState<DeleteAccountPage> {
  final _passwordController = TextEditingController();
  var _showReauth = false;
  var _isDeleting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _delete({required bool useGoogle}) async {
    final s = ref.str;
    final user = ref.read(authStateChangesProvider).valueOrNull;
    if (user == null) return;

    setState(() {
      _isDeleting = true;
      _errorMessage = null;
    });

    try {
      await ref.read(accountDeletionControllerProvider).deleteAccount(
            uid: user.id,
            password: useGoogle ? null : _passwordController.text,
            useGoogle: useGoogle,
          );

      if (!mounted) return;

      context.go(RouteNames.login);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.accountDeleted)),
      );
    } on AccountDeletionException catch (error) {
      if (mounted) {
        setState(() => _errorMessage = error.message);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = s.deleteAccountFailed);
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.str;
    final isGoogleAsync = ref.watch(isGoogleAccountProvider);
    final isGoogle = isGoogleAsync.valueOrNull ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(s.deleteAccount)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 56,
            color: Colors.red.shade700,
          ),
          const SizedBox(height: 16),
          Text(
            s.deleteAccountPermanent,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            s.deleteAccountWill,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _Bullet(text: s.deleteBulletListings),
          _Bullet(text: s.deleteBulletFavorites),
          _Bullet(text: s.deleteBulletProfile),
          _Bullet(text: s.deleteBulletCredentials),
          const SizedBox(height: 16),
          Text(
            s.deleteAccountFinalWarning,
            style: TextStyle(color: Colors.grey.shade700),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red.shade700),
            ),
          ],
          const SizedBox(height: 24),
          if (!_showReauth)
            FilledButton(
              onPressed: _isDeleting
                  ? null
                  : () => setState(() => _showReauth = true),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(s.continueAction),
            )
          else ...[
            Text(
              s.confirmIdentity,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              isGoogle ? s.reauthGoogleDelete : s.reauthPasswordDelete,
            ),
            const SizedBox(height: 16),
            if (isGoogle)
              FilledButton.icon(
                onPressed: _isDeleting ? null : () => _delete(useGoogle: true),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  minimumSize: const Size.fromHeight(48),
                ),
                icon: const Icon(Icons.g_mobiledata, size: 28),
                label: _isDeleting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(s.reauthAndDelete),
              )
            else ...[
              TextField(
                controller: _passwordController,
                obscureText: true,
                enabled: !_isDeleting,
                decoration: InputDecoration(
                  labelText: s.password,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _isDeleting ? null : () => _delete(useGoogle: false),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: _isDeleting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(s.deleteMyAccountAction),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
