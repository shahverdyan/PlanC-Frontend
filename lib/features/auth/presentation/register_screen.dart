import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/auth/domain/registration_form_provider.dart';
import 'package:plan_c_frontend/features/auth/presentation/register_step2_screen.dart';
import 'package:plan_c_frontend/features/auth/presentation/register_step_dots.dart';
import 'package:plan_c_frontend/shared/custom_elevated_button.dart';
import 'package:plan_c_frontend/shared/custom_outlined_button.dart';
import 'package:plan_c_frontend/shared/custom_textform_input.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

const _gradientTop    = Color(0xFFFF5C35);
const _gradientBottom = Color(0xFFFF9A00);

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends ConsumerState<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController repeatPasswordController;
  bool _isFormValid = false;

  Timer? _emailDebounce;
  bool _emailChecking = false;
  String? _emailError;
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _repeatPasswordFieldKey = GlobalKey<FormFieldState>();

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  static final _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{8,}$',
  );

  void _updateFormValid() {
    final notifier = ref.read(registrationFormProvider.notifier);
    notifier.setEmail(emailController.text);
    notifier.setPassword(passwordController.text);
    setState(() {
      final password = passwordController.text;
      _isFormValid = emailController.text.contains('@') &&
          _passwordRegex.hasMatch(password) &&
          repeatPasswordController.text == password &&
          _emailError == null &&
          !_emailChecking;
    });
    if (repeatPasswordController.text.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _repeatPasswordFieldKey.currentState?.validate();
      });
    }
  }

  void _onEmailChanged() {
    _updateFormValid();
    setState(() {
      _emailError = null;
      _emailChecking = false;
    });
    _emailDebounce?.cancel();
    final email = emailController.text.trim();
    if (!_emailRegex.hasMatch(email)) return;
    setState(() => _emailChecking = true);
    _emailDebounce = Timer(const Duration(milliseconds: 600), () async {
      try {
        final available = await ref
            .read(authRepositoryProvider)
            .checkEmailAvailable(email);
        if (!mounted) return;
        setState(() {
          _emailChecking = false;
          _emailError = available
              ? null
              : AppLocalizations.of(context)!.registerEmailTaken;
        });
        _updateFormValid();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _emailFieldKey.currentState?.validate();
        });
      } catch (_) {
        if (!mounted) return;
        setState(() => _emailChecking = false);
        _updateFormValid();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final saved = ref.read(registrationFormProvider);
    emailController = TextEditingController(text: saved.email);
    passwordController = TextEditingController(text: saved.password);
    repeatPasswordController = TextEditingController();
    emailController.addListener(_onEmailChanged);
    passwordController.addListener(_updateFormValid);
    repeatPasswordController.addListener(_updateFormValid);

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
    // Recalcular estat inicial si hi ha dades guardades
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateFormValid());
  }

  Future<void> _pop() async {
    await _controller.reverse();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _emailDebounce?.cancel();
    emailController.removeListener(_onEmailChanged);
    passwordController.removeListener(_updateFormValid);
    repeatPasswordController.removeListener(_updateFormValid);
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

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
                // ── Capçalera (gradient) ─────────────────────────────────
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: AppColors.neutral0, size: 20),
                        onPressed: _pop,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(32, 0, 32, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                t.registerCreateAccountTitle,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.neutral0,
                                  fontFamily: 'Helvetica',
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 14),
                              const RegisterStepDots(currentStep: 1, totalSteps: 3),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Formulari (blanc, animat) ────────────────────────────
                Expanded(
                  flex: 8,
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
                                  fieldKey: _emailFieldKey,
                                  label: t.registerEmailLabel,
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  externalError: _emailError,
                                  helperText: _emailChecking
                                      ? t.registerChecking
                                      : null,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return t.loginRequiredField;
                                    }
                                    if (!value.contains('@')) {
                                      return t.registerEmailInvalidError;
                                    }
                                    return null;
                                  },
                                  controller: emailController,
                                ),
                                const SizedBox(height: 24),
                                CustomTextformInput(
                                  label: t.registerPasswordLabel,
                                  isPassword: true,
                                  icon: Icons.lock_outline,
                                  showPasswordRequirements: true,
                                  minLength: 8,
                                  requiresUpperCase: true,
                                  requiresLowerCase: true,
                                  requiresNumber: true,
                                  requiresSpecialChar: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return t.loginRequiredField;
                                    }
                                    if (!_passwordRegex.hasMatch(value)) {
                                      return t.registerPasswordInvalidError;
                                    }
                                    return null;
                                  },
                                  controller: passwordController,
                                ),
                                const SizedBox(height: 24),
                                CustomTextformInput(
                                  fieldKey: _repeatPasswordFieldKey,
                                  label: t.registerRepeatPasswordLabel,
                                  isPassword: true,
                                  icon: Icons.lock_outline,
                                  validator: (value) {
                                    if (passwordController.text !=
                                        repeatPasswordController.text) {
                                      return t.registerPasswordMismatchError;
                                    }
                                    return null;
                                  },
                                  controller: repeatPasswordController,
                                ),
                                const SizedBox(height: 32),
                                CustomElevatedButton(
                                  text: t.registerContinueButton,
                                  onPressed: !_isFormValid
                                      ? null
                                      : () {
                                          if (formKey.currentState!.validate()) {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                transitionDuration: Duration.zero,
                                                reverseTransitionDuration:
                                                    Duration.zero,
                                                pageBuilder: (ctx, a, b) =>
                                                    RegisterStep2Screen(
                                                  email: emailController.text.trim(),
                                                  contrasenya:
                                                      passwordController.text.trim(),
                                                ),
                                                transitionsBuilder:
                                                    (ctx, animation, sec, child) =>
                                                        child,
                                              ),
                                            );
                                          }
                                        },
                                ),
                                const SizedBox(height: 20),
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
                                const SizedBox(height: 20),
                                CustomOutlinedButton(
                                  text: t.loginGoogleButton,
                                  iconWidget: SvgPicture.asset(
                                    'assets/images/google_logo.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                  onPressed: () {
                                    ref
                                        .read(authProvider.notifier)
                                        .signUpWithGoogle();
                                  },
                                ),
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
