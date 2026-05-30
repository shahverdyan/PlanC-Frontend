import 'package:flutter/material.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';

class RegisterStepDots extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final void Function(int step)? onStepTap;

  const RegisterStepDots({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalSteps, (i) {
        final step = i + 1;
        final isCompleted = step < currentStep;
        final isCurrent = step == currentStep;
        final isPending = step > currentStep;

        final dot = AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: isCurrent ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isPending
                ? AppColors.neutral0.withValues(alpha: 0.35)
                : AppColors.neutral0,
            borderRadius: BorderRadius.circular(4),
          ),
        );

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCompleted)
              GestureDetector(
                onTap: () => onStepTap?.call(step),
                child: dot,
              )
            else
              dot,
            if (step < totalSteps) const SizedBox(width: 6),
          ],
        );
      }),
    );
  }
}
