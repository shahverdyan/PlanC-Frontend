import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_state.dart';
import 'package:plan_c_frontend/features/auth/presentation/forgottenpassword_screen.dart';
import 'package:plan_c_frontend/features/auth/presentation/register_screen.dart';
import 'package:plan_c_frontend/features/auth/presentation/register_verification_screen.dart';
import 'package:plan_c_frontend/features/navigation/domain/navigation_provider.dart';
import 'package:plan_c_frontend/shared/custom_elevated_button.dart';
import 'package:plan_c_frontend/shared/custom_outlined_button.dart';
import 'package:plan_c_frontend/shared/custom_textform_input.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

const _gradientTop    = Color(0xFFFF5C35);
const _gradientBottom = Color(0xFFFF9A00);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool _isFormValid = false;

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  void _updateFormValid() {
    setState(() {
      _isFormValid = emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailController.addListener(_updateFormValid);
    passwordController.addListener(_updateFormValid);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 400),
    );

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));

    _controller.forward();
  }

  Future<void> _pop() async {
    await _controller.reverse();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    emailController.removeListener(_updateFormValid);
    passwordController.removeListener(_updateFormValid);
    emailController.dispose();
    passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    ref.listen(authProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        final localT = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? localT.loginErrorFallback),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }

      if (next.status == AuthStatus.awaitingEmailVerification) {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            pageBuilder: (ctx, a, b) => RegisterVerificationScreen(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            ),
            transitionsBuilder: (ctx, animation, sec, child) => child,
          ),
        );
      }

      if (next.status == AuthStatus.authenticated) {
        final localT = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localT.loginSuccessSnackbar),
            backgroundColor: AppSemanticColors.of(context).success,
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _pop();
      },
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
              // ── Capçalera hero ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: AppColors.neutral0, size: 20),
                      onPressed: _pop,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.loginTitle,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: AppColors.neutral0,
                          fontFamily: 'Helvetica',
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        t.loginWelcomeBack,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.neutral0.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Formulari (animat) ───────────────────────────────────────
              Expanded(
                flex: 7,
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
                          32, 36, 32,
                          32 + MediaQuery.of(context).padding.bottom,
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomTextformInput(
                                label: t.loginEmailOrUsernameLabel,
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return t.loginRequiredField;
                                  }
                                  return null;
                                },
                                controller: emailController,
                              ),
                              const SizedBox(height: 16),
                              CustomTextformInput(
                                label: t.loginPasswordLabel,
                                isPassword: true,
                                icon: Icons.lock_outline,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return t.loginRequiredField;
                                  }
                                  return null;
                                },
                                controller: passwordController,
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const ForgottenpasswordScreen(),
                                    ),
                                  ),
                                  child: Text(
                                    t.loginForgotPassword,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              CustomElevatedButton(
                                text: isLoading
                                    ? t.loginLoadingButton
                                    : t.loginSignInButton,
                                onPressed: isLoading || !_isFormValid
                                    ? null
                                    : () {
                                        if (formKey.currentState!.validate()) {
                                          ref
                                              .read(authProvider.notifier)
                                              .signIn(
                                                emailController.text.trim(),
                                                passwordController.text.trim(),
                                              );
                                          ref
                                              .read(
                                                  navigationProvider.notifier)
                                              .state = NavTab.home;
                                        }
                                      },
                              ),
                              const SizedBox(height: 28),
                              Row(
                                children: [
                                  const Expanded(child: Divider()),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      t.loginContinueWith,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  const Expanded(child: Divider()),
                                ],
                              ),
                              const SizedBox(height: 28),
                              CustomOutlinedButton(
                                text: t.loginGoogleButton,
                                iconWidget: SvgPicture.asset(
                                  'assets/images/google_logo.svg',
                                  width: 24,
                                  height: 24,
                                ),
                                onPressed: () => ref
                                    .read(authProvider.notifier)
                                    .signInWithGoogle(),
                              ),
                              const SizedBox(height: 28),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    t.loginNoAccount,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const RegisterScreen()),
                                    ),
                                    child: Text(
                                      t.loginSignUpHere,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
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
