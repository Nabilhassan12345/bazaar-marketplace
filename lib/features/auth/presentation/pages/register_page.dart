import 'package:bazaar/config/routes/route_names.dart';
import 'package:bazaar/config/theme/app_colors.dart';
import 'package:bazaar/core/l10n/locale_provider.dart';
import 'package:bazaar/features/auth/presentation/providers/auth_providers.dart';
import 'package:bazaar/features/auth/presentation/providers/auth_state.dart';
import 'package:bazaar/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:bazaar/features/profile/presentation/widgets/legal_links_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authControllerProvider.notifier).signUpWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
          displayName: _nameController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthStatus>(authControllerProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        context.go(RouteNames.home);
      } else if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message)),
        );
        ref.read(authControllerProvider.notifier).clearError();
      }
    });

    final authStatus = ref.watch(authControllerProvider);
    final isLoading = authStatus is AuthLoading;
    final s = ref.str;

    return Scaffold(
      appBar: AppBar(title: Text(s.createAccount)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthTextField(
                  controller: _nameController,
                  label: s.displayName,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return s.nameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _emailController,
                  label: s.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return s.emailRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _passwordController,
                  label: s.password,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return s.passwordMinLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: isLoading ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(s.signUp),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.go(RouteNames.login),
                  child: Text(s.hasAccountSignIn),
                ),
                const LegalLinksFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
