import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Back button
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black87,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Title
        Text(
          'Pick another date',
          style: AppTypography.headline(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(width: 24),

        // Step indicators
        Row(
          children: List.generate(totalSteps, (index) {
            final stepNumber = index + 1;
            final isActive = stepNumber == currentStep;
            final isCompleted = stepNumber < currentStep;

            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isActive
                              ? const Color(0xFFFF8A00)
                              : isCompleted
                              ? AppColors.primaryColor
                              : Colors.grey[300],
                      border: Border.all(
                        color:
                            isActive
                                ? const Color(0xFFFF8A00)
                                : isCompleted
                                ? AppColors.primaryColor
                                : Colors.grey[300]!,
                        width: 2,
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
                                style: TextStyle(
                                  color:
                                      isActive
                                          ? Colors.white
                                          : Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                    ),
                  ),
                  if (index < totalSteps - 1)
                    Container(
                      width: 20,
                      height: 2,
                      color:
                          isCompleted
                              ? AppColors.primaryColor
                              : Colors.grey[300],
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
