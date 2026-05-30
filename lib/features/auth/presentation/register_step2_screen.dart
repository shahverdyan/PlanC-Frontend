import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/auth/domain/registration_form_provider.dart';
import 'package:plan_c_frontend/features/auth/presentation/register_step3_screen.dart';
import 'package:plan_c_frontend/features/auth/presentation/register_step_dots.dart';
import 'package:plan_c_frontend/shared/custom_elevated_button.dart';
import 'package:plan_c_frontend/shared/custom_textform_input.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

const _gradientTop    = Color(0xFFFF5C35);
const _gradientBottom = Color(0xFFFF9A00);

class RegisterStep2Screen extends ConsumerStatefulWidget {
  final String email;
  final String contrasenya;

  const RegisterStep2Screen({
    super.key,
    required this.email,
    required this.contrasenya,
  });

  @override
  ConsumerState<RegisterStep2Screen> createState() =>
      _RegisterStep2ScreenState();
}

class _RegisterStep2ScreenState extends ConsumerState<RegisterStep2Screen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController usernameController;
  late TextEditingController nomController;
  late TextEditingController cognomsController;
  bool _isFormValid = false;

  Timer? _usernameDebounce;
  bool _usernameChecking = false;
  String? _usernameError;
  final _usernameFieldKey = GlobalKey<FormFieldState>();

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  void _updateFormValid() {
    final notifier = ref.read(registrationFormProvider.notifier);
    notifier.setUsername(usernameController.text);
    notifier.setNom(nomController.text);
    notifier.setCognoms(cognomsController.text);
    setState(() {
      final username = usernameController.text;
      _isFormValid = username.length >= 3 &&
          username.length <= 20 &&
          nomController.text.isNotEmpty &&
          cognomsController.text.isNotEmpty &&
          _usernameError == null &&
          !_usernameChecking;
    });
  }

  void _onUsernameChanged() {
    _updateFormValid();
    setState(() {
      _usernameError = null;
      _usernameChecking = false;
    });
    _usernameDebounce?.cancel();
    final username = usernameController.text.trim();
    if (username.length < 3 || username.length > 20) return;
    setState(() => _usernameChecking = true);
    _usernameDebounce = Timer(const Duration(milliseconds: 600), () async {
      try {
        final available = await ref
            .read(authRepositoryProvider)
            .checkUsernameAvailable(username);
        if (!mounted) return;
        setState(() {
          _usernameChecking = false;
          _usernameError = available
              ? null
              : AppLocalizations.of(context)!.registerUsernameTaken;
        });
        _updateFormValid();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _usernameFieldKey.currentState?.validate();
        });
      } catch (_) {
        if (!mounted) return;
        setState(() => _usernameChecking = false);
        _updateFormValid();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final saved = ref.read(registrationFormProvider);
    usernameController = TextEditingController(text: saved.username);
    nomController = TextEditingController(text: saved.nom);
    cognomsController = TextEditingController(text: saved.cognoms);
    usernameController.addListener(_onUsernameChanged);
    nomController.addListener(_updateFormValid);
    cognomsController.addListener(_updateFormValid);

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateFormValid());
  }

  Future<void> _pop() async {
    await _controller.reverse();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _usernameDebounce?.cancel();
    usernameController.removeListener(_onUsernameChanged);
    nomController.removeListener(_updateFormValid);
    cognomsController.removeListener(_updateFormValid);
    usernameController.dispose();
    nomController.dispose();
    cognomsController.dispose();
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
                                t.registerStep2Title,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.neutral0,
                                  fontFamily: 'Helvetica',
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 14),
                              RegisterStepDots(currentStep: 2, totalSteps: 3, onStepTap: (step) {
                                if (step < 2) _pop();
                              }),
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
                                  fieldKey: _usernameFieldKey,
                                  label: t.registerUsernameLabel,
                                  icon: Icons.alternate_email,
                                  controller: usernameController,
                                  externalError: _usernameError,
                                  helperText: _usernameChecking
                                      ? t.registerChecking
                                      : null,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return t.loginRequiredField;
                                    }
                                    if (value.length < 3) {
                                      return t.registerUsernameMinError;
                                    }
                                    if (value.length > 20) {
                                      return t.registerUsernameMaxError;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),
                                CustomTextformInput(
                                  label: t.registerNameLabel,
                                  icon: Icons.badge_outlined,
                                  controller: nomController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return t.registerNameRequiredError;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),
                                CustomTextformInput(
                                  label: t.registerSurnameLabel,
                                  icon: Icons.badge_outlined,
                                  controller: cognomsController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return t.registerSurnameRequiredError;
                                    }
                                    return null;
                                  },
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
                                                    RegisterStep3Screen(
                                                  email: widget.email,
                                                  contrasenya: widget.contrasenya,
                                                  nomUsuari: usernameController
                                                      .text
                                                      .trim(),
                                                  nom: nomController.text.trim(),
                                                  cognoms:
                                                      cognomsController.text.trim(),
                                                ),
                                                transitionsBuilder:
                                                    (ctx, animation, sec, child) =>
                                                        child,
                                              ),
                                            );
                                          }
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
