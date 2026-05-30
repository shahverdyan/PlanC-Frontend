import 'package:flutter/material.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class CustomTextformInput extends StatefulWidget {
  final bool isPassword;
  final TextInputType keyboardType;
  final String? label;
  final IconData? icon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String? helperText;
  final bool showPasswordRequirements;
  final int? minLength;
  final bool requiresUpperCase;
  final bool requiresLowerCase;
  final bool requiresNumber;
  final bool requiresSpecialChar;
  final String? externalError;
  final GlobalKey<FormFieldState>? fieldKey;

  const CustomTextformInput({
    super.key,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.label,
    this.icon,
    this.validator,
    this.controller,
    this.helperText,
    this.showPasswordRequirements = false,
    this.minLength,
    this.requiresUpperCase = false,
    this.requiresLowerCase = false,
    this.requiresNumber = false,
    this.requiresSpecialChar = false,
    this.externalError,
    this.fieldKey,
  });

  @override
  State<CustomTextformInput> createState() => _CustomTextformInputState();
}

class _CustomTextformInputState extends State<CustomTextformInput> {
  bool _showPassword = false;
  late bool _hasMinLength;
  late bool _hasUpperCase;
  late bool _hasLowerCase;
  late bool _hasNumber;
  late bool _hasSpecialChar;

  @override
  void initState() {
    super.initState();
    _initializeChecks();
    widget.controller?.addListener(_updatePasswordChecks);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_updatePasswordChecks);
    super.dispose();
  }

  void _initializeChecks() {
    _hasMinLength = false;
    _hasUpperCase = false;
    _hasLowerCase = false;
    _hasNumber = false;
    _hasSpecialChar = false;
  }

  void _updatePasswordChecks() {
    if (!widget.showPasswordRequirements) return;
    
    final password = widget.controller?.text ?? '';
    setState(() {
      _hasMinLength = password.length >= (widget.minLength ?? 8);
      _hasUpperCase = password.contains(RegExp(r'[A-Z]'));
      _hasLowerCase = password.contains(RegExp(r'[a-z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{};:,.<>?/\\"]'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          key: widget.fieldKey,
          controller: widget.controller,
          obscureText: widget.isPassword && !_showPassword,
          keyboardType: widget.keyboardType,
          onChanged: (_) => _updatePasswordChecks(),
          decoration: InputDecoration(
            labelText: widget.label,
            prefixIcon: Icon(widget.icon, color: Theme.of(context).colorScheme.primary),
            helperText: widget.helperText,
            filled: true,
            fillColor: AppSemanticColors.of(context).inputFill,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppSemanticColors.of(context).inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppSemanticColors.of(context).inputFocusBorder, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      setState(() => _showPassword = !_showPassword);
                    },
                  )
                : null,
          ),
          validator: (v) {
            if (widget.externalError != null) return widget.externalError;
            return widget.validator?.call(v);
          },
        ),
        if (widget.showPasswordRequirements) ...[
          const SizedBox(height: 10),
          Builder(
            builder: (context) {
              final t = AppLocalizations.of(context)!;
              return Wrap(
                spacing: 14,
                runSpacing: 6,
                children: [
                  if (widget.minLength != null)
                    _RequirementChip(
                      met: _hasMinLength,
                      text: t.passwordRequirementMinLength(widget.minLength!),
                    ),
                  if (widget.requiresUpperCase)
                    _RequirementChip(
                      met: _hasUpperCase,
                      text: t.passwordRequirementUppercase,
                    ),
                  if (widget.requiresLowerCase)
                    _RequirementChip(
                      met: _hasLowerCase,
                      text: t.passwordRequirementLowercase,
                    ),
                  if (widget.requiresNumber)
                    _RequirementChip(
                      met: _hasNumber,
                      text: t.passwordRequirementNumber,
                    ),
                  if (widget.requiresSpecialChar)
                    _RequirementChip(
                      met: _hasSpecialChar,
                      text: t.passwordRequirementSpecialChar,
                    ),
                ],
              );
            },
          ),
        ],
      ],
    );
  }
}

class _RequirementChip extends StatelessWidget {
  final bool met;
  final String text;

  const _RequirementChip({required this.met, required this.text});

  @override
  Widget build(BuildContext context) {
    final color = met
        ? AppSemanticColors.of(context).success
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          met ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 13,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: met ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}