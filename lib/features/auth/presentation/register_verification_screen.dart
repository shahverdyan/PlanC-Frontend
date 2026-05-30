import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_state.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import 'package:plan_c_frontend/shared/custom_elevated_button.dart';

const _gradientTop = Color(0xFFFF5C35);
const _gradientBottom = Color(0xFFFF9A00);

class RegisterVerificationScreen extends ConsumerStatefulWidget {
  final String email;
  final String password;

  const RegisterVerificationScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  ConsumerState<RegisterVerificationScreen> createState() =>
      _RegisterVerificationScreenState();
}

class _RegisterVerificationScreenState
    extends ConsumerState<RegisterVerificationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;

    ref.listen(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }

      if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? t.verifyEmailNotYet),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }

      if (next.status == AuthStatus.awaitingEmailVerification &&
          previous?.status == AuthStatus.loading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.verifyEmailNotYet),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_gradientTop, _gradientBottom],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.mark_email_unread_outlined,
                          size: 72,
                          color: AppColors.neutral0,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          t.verifyEmailTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: AppColors.neutral0,
                            fontFamily: 'Helvetica',
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          t.verifyEmailBody(widget.email),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.neutral0.withValues(alpha: 0.88),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom card
                Expanded(
                  flex: 6,
                  child: FadeTransition(
                    opacity: _fade,
                    child: SlideTransition(
                      position: _slide,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            32,
                            36,
                            32,
                            32 + MediaQuery.of(context).padding.bottom,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomElevatedButton(
                                text: isLoading
                                    ? '...'
                                    : t.verifyEmailAlreadyVerified,
                                onPressed: isLoading
                                    ? null
                                    : () => ref
                                        .read(authProvider.notifier)
                                        .signIn(widget.email, widget.password),
                              ),
                              const SizedBox(height: 24),
                              Center(
                                child: TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .popUntil((route) => route.isFirst),
                                  child: Text(
                                    t.verifyEmailBackToLogin,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
