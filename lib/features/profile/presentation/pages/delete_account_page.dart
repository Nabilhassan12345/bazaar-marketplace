import 'package:bazaar/config/routes/route_names.dart';
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
        const SnackBar(content: Text('Account deleted')),
      );
    } on AccountDeletionException catch (error) {
      if (mounted) {
        setState(() => _errorMessage = error.message);
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _errorMessage = 'Failed to delete account. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGoogleAsync = ref.watch(isGoogleAccountProvider);
    final isGoogle = isGoogleAsync.valueOrNull ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Delete My Account')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 56,
            color: Colors.red.shade700,
          ),
          const SizedBox(height: 16),
          const Text(
            'This action is permanent',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Deleting your account will:',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const _Bullet('Remove all your listings from Bazaar'),
          const _Bullet('Delete your saved favorites'),
          const _Bullet('Erase your profile and account data'),
          const _Bullet('Sign you out and delete your login credentials'),
          const SizedBox(height: 16),
          Text(
            'This cannot be undone. You will need to create a new account to use Bazaar again.',
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
              child: const Text('Continue'),
            )
          else ...[
            const Text(
              'Confirm your identity',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              isGoogle
                  ? 'Re-authenticate with Google to confirm account deletion.'
                  : 'Enter your password to confirm account deletion.',
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
                    : const Text('Re-authenticate & delete account'),
              )
            else ...[
              TextField(
                controller: _passwordController,
                obscureText: true,
                enabled: !_isDeleting,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
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
                    : const Text('Delete my account'),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);

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
