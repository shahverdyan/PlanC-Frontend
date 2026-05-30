import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {

  final String text;
  final IconData? icon;
  final Color? iconColor;
  final Widget? iconWidget;
  final VoidCallback? onPressed;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    this.icon,
    this.iconColor,
    this.iconWidget,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: cs.outline, width: 1.5),
        foregroundColor: cs.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        if (iconWidget != null) ...[
          iconWidget!,
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(icon, size: 30, color: iconColor),
          const SizedBox(width: 8),
        ],
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, fontFamily: 'Helvetica'),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

