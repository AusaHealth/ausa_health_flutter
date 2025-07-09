import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/constants.dart';
import 'buttons.dart';

/// A reusable header widget with back button and page title
/// Optionally displays step indicators when currentStep and totalSteps are provided
///
/// Example usage:
/// ```dart
/// // Regular header
/// AppBackHeader(title: 'Settings')
///
/// // Header with steps
/// AppBackHeader(
///   title: 'Setup Process',
///   currentStep: 2,
///   totalSteps: 4,
/// )
/// ```
class AppBackHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? buttonColor;
  final Color? buttonIconColor;

  // Optional step functionality
  final int? currentStep;
  final int? totalSteps;
  final Color? activeStepColor;
  final Color? completedStepColor;
  final Color? inactiveStepColor;

  const AppBackHeader({
    super.key,
    required this.title,
    this.onBackPressed,
    this.backgroundColor,
    this.titleColor,
    this.buttonColor,
    this.buttonIconColor,
    this.currentStep,
    this.totalSteps,
    this.activeStepColor = const Color(0xFFFF8A00),
    this.completedStepColor,
    this.inactiveStepColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      color: backgroundColor,
      child: Row(
        children: [
          // Back button
          AusaButton(
            text: '',
            variant: ButtonVariant.icon,
            icon: Icons.arrow_back_ios_new,
            onPressed: onBackPressed ?? () => Get.back(),
            backgroundColor: buttonColor ?? Colors.white,
            iconColor: buttonIconColor ?? Colors.black87,
            iconSize: 16,
            width: 40,
            height: 40,
            borderRadius: 20, // Makes it circular
            boxShadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),

          SizedBox(width: AppSpacing.xl2),

          // Title
          Text(
            title,
            style: AppTypography.headline(color: titleColor ?? Colors.black87),
          ),

          // Step indicators (only show if currentStep and totalSteps are provided)
          if (currentStep != null && totalSteps != null) ...[
            SizedBox(width: AppSpacing.lg),
            Row(
              children: List.generate(totalSteps!, (index) {
                final stepNumber = index + 1;
                final isActive = stepNumber == currentStep;
                final isCompleted = stepNumber < currentStep!;

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
                                ? (completedStepColor ?? AppColors.primaryColor)
                                : (inactiveStepColor ?? Colors.white),
                        border: Border.all(
                          color:
                              isActive
                                  ? activeStepColor!
                                  : isCompleted
                                  ? (completedStepColor ??
                                      AppColors.primaryColor)
                                  : (inactiveStepColor ?? Colors.grey[300]!),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child:
                            isCompleted
                                ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                )
                                : Text(
                                  stepNumber.toString(),
                                  style: AppTypography.body(
                                    color:
                                        isActive
                                            ? activeStepColor
                                            : (inactiveStepColor ??
                                                Colors.grey[600]),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                      ),
                    ),
                    if (index < totalSteps! - 1)
                      Container(
                        width: 20,
                        height: 2,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        color:
                            isCompleted
                                ? (completedStepColor ?? AppColors.primaryColor)
                                : Colors.grey[300],
                      ),
                  ],
                );
              }),
            ),
          ],
        ],
      ),
    );
  }
}
