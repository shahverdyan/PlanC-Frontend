import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_state.dart';
import 'package:plan_c_frontend/shared/custom_elevated_button.dart';
import 'package:plan_c_frontend/shared/custom_textform_input.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class ForgottenpasswordScreen extends ConsumerStatefulWidget{

  const ForgottenpasswordScreen({super.key});

  @override
  ConsumerState<ForgottenpasswordScreen> createState() => ForgottenpasswordScreenState();

}

class ForgottenpasswordScreenState extends ConsumerState<ForgottenpasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  bool _isFormValid = false;
  bool _emailSent = false;

  void _updateFormValid() {
    setState(() {
      _isFormValid = emailController.text.isNotEmpty &&
          emailController.text.contains('@');
    });
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    emailController.addListener(_updateFormValid);
  }

  @override
  void dispose() {
    emailController.removeListener(_updateFormValid);
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    ref.listen(authProvider, (previous, next) {
      if (next.status == AuthStatus.successful) {
        final localT = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localT.forgotPasswordEmailSent),
            backgroundColor: AppSemanticColors.of(context).success,
          ),
        );
        setState(() => _emailSent = true);
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton()
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: formKey,
            child: Column (
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Icon(Icons.lock_reset, size: 80, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 16),
                Text(t.forgotPasswordTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Text(t.forgotPasswordDescription,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 64),
                CustomTextformInput(keyboardType: TextInputType.emailAddress,
                  label: t.registerEmailLabel,
                  icon: Icons.email_outlined,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return t.loginRequiredField;
                    if (!value.contains("@")) return t.forgotPasswordEmailInvalid;
                    return null;
                  }
                ),
                const SizedBox(height: 64),
                CustomElevatedButton(text: t.forgotPasswordButton,
                  onPressed: _isFormValid
                      ? () {
                          if (formKey.currentState!.validate()) {
                            ref.read(authProvider.notifier).resetPassword(emailController.text.trim());
                          }
                        }
                      : null),
                if (_emailSent) ...[
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        t.forgotPasswordGoToLogin,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            )
          )
        )
      )
    );
  }
}
