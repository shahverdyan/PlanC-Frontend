import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _passwordController = TextEditingController();
  final _confirmTextController = TextEditingController();
  bool _obscurePassword = true;
  bool _isGoogleUser = false;
  bool _isLoading = false;
  bool _isFormValid = false;

  void _updateFormValid() {
    setState(() {
      _isFormValid = _isGoogleUser
          ? _confirmTextController.text.trim() == 'ELIMINAR'
          : _passwordController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    final provider =
        Supabase.instance.client.auth.currentUser?.appMetadata['provider']
            as String? ??
        'email';
    _isGoogleUser = provider == 'google';
    _passwordController.addListener(_updateFormValid);
    _confirmTextController.addListener(_updateFormValid);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_updateFormValid);
    _confirmTextController.removeListener(_updateFormValid);
    _passwordController.dispose();
    _confirmTextController.dispose();
    super.dispose();
  }

  Future<void> _confirmAndDelete() async {
    final t = AppLocalizations.of(context)!;
    final input = _isGoogleUser
        ? _confirmTextController.text.trim()
        : _passwordController.text;

    if (_isGoogleUser && input != 'ELIMINAR') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.deleteAccountTypeConfirmRequired),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (!_isGoogleUser && input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.deleteAccountPasswordRequired),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.deleteAccountDialogTitle),
        content: Text(t.deleteAccountDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              t.deleteAccountDialogCancel,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              t.deleteAccountDialogConfirm,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      // For Google users, pass empty password (re-auth is skipped in the repo)
      final password = _isGoogleUser ? '' : input;
      await ref.read(authProvider.notifier).deleteAccount(password);
      if (mounted) {
        final localT = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localT.deleteAccountSuccess),
            backgroundColor: AppSemanticColors.of(context).success,
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (!mounted) return;
      final localT = AppLocalizations.of(context)!;
      final raw = e.toString().replaceFirst('Exception: ', '');
      final message = raw.isNotEmpty ? raw : localT.deleteAccountErrorFallback;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final sem = AppSemanticColors.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.deleteAccountTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: sem.destructiveSurface,
                border: Border.all(color: sem.destructive),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: sem.destructive),
                      const SizedBox(width: 8),
                      Text(
                        t.deleteAccountIrreversibleWarning,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: sem.destructive,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.deleteAccountWarningDetails,
                    style: TextStyle(color: sem.destructive),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            if (_isGoogleUser) ...[
              Text(
                t.deleteAccountTypeConfirmInstruction,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _confirmTextController,
                decoration: InputDecoration(
                  labelText: t.deleteAccountTypeConfirmLabel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide(color: sem.destructive, width: 2),
                  ),
                ),
              ),
            ] else ...[
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: t.deleteAccountPasswordLabel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide(color: sem.destructive, width: 2),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 36),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading || !_isFormValid ? null : _confirmAndDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: sem.destructive,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                  disabledBackgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  disabledForegroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onError,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        t.deleteAccountTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
