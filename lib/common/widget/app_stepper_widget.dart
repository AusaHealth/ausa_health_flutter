import 'package:ausa/constants/constants.dart';
import 'package:flutter/material.dart';

/// A reusable stepper widget that displays step indicators
/// Used with AppBackHeader to show progress through multi-step processes
class AppStepperWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color? activeStepColor;
  final Color? completedStepColor;
  final Color? inactiveStepColor;

  const AppStepperWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.activeStepColor = const Color(0xFFFF8A00),
    this.completedStepColor,
    this.inactiveStepColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final stepNumber = index + 1;
        final isActive = stepNumber == currentStep;
        final isCompleted = stepNumber < currentStep;

        return Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isActive
                        ? Colors.white
                        : isCompleted
                        ? (completedStepColor ?? AppColors.primary700)
                        : (inactiveStepColor ?? Colors.white),
                border: Border.all(
                  color:
                      isActive
                          ? activeStepColor!
                          : isCompleted
                          ? (completedStepColor ?? AppColors.primary700)
                          : (inactiveStepColor ?? Colors.grey[300]!),
                  width: 1,
                ),
              ),
              child: Center(
                child:
                    isCompleted
                        ? Icon(Icons.check, color: Colors.white, size: 16)
                        : Text(
                          stepNumber.toString(),
                          style: AppTypography.body(
                            color:
                                isActive
                                    ? activeStepColor
                                    : (inactiveStepColor ?? Colors.grey[600]),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
            ),
            if (index < totalSteps - 1)
              Container(
                width: 20,
                height: 2,
                margin: EdgeInsets.symmetric(horizontal: 4),
                color:
                    isCompleted
                        ? (completedStepColor ?? AppColors.primary700)
                        : Colors.grey[300],
              ),
          ],
        );
      }),
    );
  }
}
