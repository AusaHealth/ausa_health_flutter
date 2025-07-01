import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBackPressed;

  const StepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 2,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Back button
        GestureDetector(
          onTap: onBackPressed ?? () => Navigator.of(context).pop(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black87,
                size: 16,
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Title
        Text('Pick another date', style: AppTypography.headline()),

        const SizedBox(width: 24),

        // Step indicators
        Row(
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
                            ? const Color(0xFFFFFFFF)
                            : isCompleted
                            ? AppColors.primaryColor
                            : Color(0xFFFFFFFF),
                    border: Border.all(
                      color:
                          isActive
                              ? const Color(0xFFFF8A00)
                              : isCompleted
                              ? AppColors.primaryColor
                              : Color(0xFFFFFFFF),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child:
                        isCompleted
                            ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                            : Text(
                              stepNumber.toString(),
                              style: AppTypography.body(
                                color:
                                    isActive
                                        ? Color(0xFFFF8A00)
                                        : Color(0xFFFF8A00),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),
                if (index < totalSteps - 1)
                  Container(
                    width: 20,
                    height: 2,
                    color:
                        isCompleted ? AppColors.primaryColor : Colors.grey[300],
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
