import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/providers/locale_provider.dart';
import 'package:plan_c_frontend/core/providers/theme_provider.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/auth/presentation/main_auth_wrapper.dart';
import 'package:plan_c_frontend/features/auth/presentation/screens/delete_account_screen.dart';
import 'package:plan_c_frontend/features/gustos/presentation/screens/seleccio_gustos_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          l10n.configuracioTitol,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              l10n.seccioPreferencies.toUpperCase(),
              style: TextStyle(
                color: cs.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
          _PreferenciaCard(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: const _SettingsIcon(icon: Icons.interests_rounded),
              title: Text(
                l10n.gustosTitol,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                l10n.gustosSettingsSubtitol,
                style: const TextStyle(fontSize: 12),
              ),
              trailing: Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SeleccioGustosScreen()),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _PreferenciaCard(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: const _SettingsIcon(icon: Icons.language),
              title: Text(
                l10n.idiomaLabel,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: DropdownButton<String>(
                value: currentLocale.languageCode,
                underline: const SizedBox(),
                icon: Icon(Icons.keyboard_arrow_down, color: cs.onSurface),
                borderRadius: BorderRadius.circular(16),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
                items: const [
                  DropdownMenuItem(value: 'ca', child: Text('Català')),
                  DropdownMenuItem(value: 'es', child: Text('Español')),
                  DropdownMenuItem(value: 'en', child: Text('English')),
                ],
                onChanged: (String? code) {
                  if (code != null) {
                    ref.read(localeProvider.notifier).setLocale(Locale(code));
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          _PreferenciaCard(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: _SettingsIcon(icon: isDark ? Icons.dark_mode : Icons.light_mode),
              title: Text(
                l10n.modeFoscLabel,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                l10n.modeFoscSubtitol,
                style: const TextStyle(fontSize: 12),
              ),
              trailing: Switch(
                value: isDark,
                activeThumbColor: Theme.of(context).colorScheme.primary,
                activeTrackColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                ref.read(authProvider.notifier).logOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => MainAuthWrapper()),
                  (route) => false,
                );
              },
              child: Text(
                l10n.editProfileLogoutButton,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppSemanticColors.of(context).destructive,
                foregroundColor: Theme.of(context).colorScheme.onError,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DeleteAccountScreen()),
              ),
              child: Text(
                l10n.editProfileDeleteAccount,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _PreferenciaCard extends StatelessWidget {
  final Widget child;
  const _PreferenciaCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SettingsIcon extends StatelessWidget {
  final IconData icon;
  const _SettingsIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Theme.of(context).colorScheme.primary),
    );
  }
}
