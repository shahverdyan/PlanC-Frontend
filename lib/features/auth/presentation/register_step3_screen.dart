import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_state.dart';
import 'package:plan_c_frontend/features/auth/domain/registration_form_provider.dart';
import 'package:plan_c_frontend/features/auth/presentation/register_step_dots.dart';
import 'package:plan_c_frontend/features/auth/presentation/register_verification_screen.dart';
import 'package:plan_c_frontend/shared/custom_elevated_button.dart';
import 'package:plan_c_frontend/shared/custom_outlined_button.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

const _gradientTop    = Color(0xFFFF5C35);
const _gradientBottom = Color(0xFFFF9A00);

class RegisterStep3Screen extends ConsumerStatefulWidget {
  final String email;
  final String contrasenya;
  final String nomUsuari;
  final String nom;
  final String cognoms;

  const RegisterStep3Screen({
    super.key,
    required this.email,
    required this.contrasenya,
    required this.nomUsuari,
    required this.nom,
    required this.cognoms,
  });

  @override
  ConsumerState<RegisterStep3Screen> createState() =>
      _RegisterStep3ScreenState();
}

class _RegisterStep3ScreenState extends ConsumerState<RegisterStep3Screen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _bioController = TextEditingController();
  File? _imageFile;

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _submit({required File? fotoPerfil, required String? biografia}) async {
    await ref.read(authProvider.notifier).signUp(
      nomUsuari: widget.nomUsuari,
      email: widget.email,
      contrasenya: widget.contrasenya,
      nom: widget.nom,
      cognoms: widget.cognoms,
      fotoPerfil: fotoPerfil,
      biografia: biografia,
    );
  }

  @override
  void dispose() {
    _bioController.dispose();
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ??
                AppLocalizations.of(context)!.registerErrorFallback),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      if (next.status == AuthStatus.awaitingEmailVerification) {
        ref.read(registrationFormProvider.notifier).reset();
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            pageBuilder: (ctx, a, b) => RegisterVerificationScreen(
              email: widget.email,
              password: widget.contrasenya,
            ),
            transitionsBuilder: (ctx, animation, sec, child) => child,
          ),
        );
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
                // ── Capçalera (gradient) ─────────────────────────────────
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: AppColors.neutral0, size: 20),
                        onPressed: isLoading ? null : _pop,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(32, 0, 32, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                t.registerStep3Title,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.neutral0,
                                  fontFamily: 'Helvetica',
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 14),
                              RegisterStepDots(currentStep: 3, totalSteps: 3, onStepTap: (step) {
                                if (step < 3) _pop();
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
                                // Avatar picker
                                Center(
                                  child: GestureDetector(
                                    onTap: isLoading ? null : _pickImage,
                                    child: CircleAvatar(
                                      radius: 52,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainerHighest,
                                      backgroundImage: _imageFile != null
                                          ? FileImage(_imageFile!)
                                          : null,
                                      child: _imageFile == null
                                          ? Icon(
                                              Icons.person,
                                              size: 52,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: isLoading ? null : _pickImage,
                                  child: Text(
                                    t.registerAddPhotoButton,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Bio field
                                TextFormField(
                                  controller: _bioController,
                                  maxLines: 4,
                                  minLines: 3,
                                  maxLength: 160,
                                  buildCounter: (context,
                                      {required currentLength,
                                      required isFocused,
                                      maxLength}) {
                                    return Text(
                                      '$currentLength / $maxLength',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: currentLength > (maxLength ?? 160)
                                            ? Theme.of(context).colorScheme.error
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                      ),
                                    );
                                  },
                                  decoration: InputDecoration(
                                    labelText: t.registerBioLabel,
                                    hintText: t.registerBioHint,
                                    prefixIcon: Icon(Icons.edit_note_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    filled: true,
                                    fillColor:
                                        AppSemanticColors.of(context).inputFill,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 20),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: AppSemanticColors.of(context)
                                              .inputBorder),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: AppSemanticColors.of(context)
                                              .inputFocusBorder,
                                          width: 2),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          width: 2),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value != null && value.length > 160) {
                                      return t.registerBioMaxError;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),

                                CustomOutlinedButton(
                                  text: t.registerSkipButton,
                                  onPressed: isLoading
                                      ? null
                                      : () => _submit(
                                          fotoPerfil: null, biografia: null),
                                ),
                                const SizedBox(height: 12),
                                CustomElevatedButton(
                                  text: isLoading
                                      ? t.registerLoadingButton
                                      : t.registerSubmitButton,
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          if (formKey.currentState!.validate()) {
                                            final bio = _bioController.text
                                                    .trim()
                                                    .isEmpty
                                                ? null
                                                : _bioController.text.trim();
                                            _submit(
                                                fotoPerfil: _imageFile,
                                                biografia: bio);
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
