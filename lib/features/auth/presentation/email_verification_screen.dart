import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/shared/custom_elevated_button.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

const _gradientTop    = Color(0xFFFF5C35);
const _gradientBottom = Color(0xFFFF9A00);

/// Pantalla mostrada després del registre exitós, informant l'usuari
/// que s'ha enviat un correu de verificació al seu compte.
class EmailVerificationScreen extends StatelessWidget {
  final String email;

  const EmailVerificationScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

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
                // ── Capçalera (gradient) ────────────────────────────────
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: AppColors.neutral0.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.mark_email_read_outlined,
                          size: 48,
                          color: AppColors.neutral0,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        t.registerVerificationTitle,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: AppColors.neutral0,
                          fontFamily: 'Helvetica',
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        t.registerVerificationSubtitle,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.neutral0.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // ── Cos (blanc) ─────────────────────────────────────────
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(
                      32, 36, 32,
                      32 + MediaQuery.of(context).padding.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Icon(
                            Icons.email_outlined,
                            size: 60,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          t.registerVerificationBody(email),
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.onSurface,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                        CustomElevatedButton(
                          text: t.registerVerificationButton,
                          onPressed: () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                        ),
                        const SizedBox(height: 8),
                      ],
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
