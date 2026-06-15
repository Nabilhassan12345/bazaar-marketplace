import 'package:bazaar/config/theme/app_colors.dart';
import 'package:bazaar/core/widgets/empty_state.dart';
import 'package:bazaar/features/auth/presentation/providers/auth_providers.dart';
import 'package:bazaar/features/auth/presentation/providers/auth_state.dart';
import 'package:bazaar/features/listings/presentation/providers/listing_providers.dart';
import 'package:bazaar/features/profile/presentation/providers/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  var _initialized = false;
  var _isSaving = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final user = ref.read(authStateChangesProvider).valueOrNull;
    if (user == null) return;

    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorMessage = 'Name is required.');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final updated = await ref.read(authRepositoryProvider).updateProfile(
            userId: user.id,
            displayName: name,
            phone: _phoneController.text.trim(),
          );
      await ref.read(listingRepositoryProvider).syncOwnerFieldsOnListings(
            ownerId: user.id,
            ownerName: updated.displayName,
            ownerPhoto: updated.photoUrl,
          );
      ref.invalidate(currentUserProfileProvider);
      if (mounted) Navigator.pop(context);
    } on AuthException catch (error) {
      setState(() {
        _isSaving = false;
        _errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        _isSaving = false;
        _errorMessage = 'Failed to save profile.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(currentUserProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorStateView(
          onRetry: () => ref.invalidate(currentUserProfileProvider),
        ),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Not signed in'));
          }

          if (!_initialized) {
            _initialized = true;
            _nameController.text = user.displayName;
            _phoneController.text = user.phone ?? '';
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade800),
                  ),
                ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isSaving ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }
}
