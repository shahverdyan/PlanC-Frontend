import 'package:flutter/material.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onPressed;
  final Color? disabledBackgroundColor;

  const CustomElevatedButton({
    super.key,
    required this.text,
    this.backgroundColor = AppColors.orange500,
    this.foregroundColor = AppColors.neutral0,
    this.onPressed,
    this.disabledBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        disabledBackgroundColor: disabledBackgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest,
        disabledForegroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, fontFamily: 'Helvetica'))
    );
  }


}
