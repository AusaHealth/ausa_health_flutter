import 'package:ausa/constants/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../constants/constants.dart';

class AppBackHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? buttonColor;
  final Color? buttonIconColor;

  // Optional stepper widget
  final Widget? stepperWidget;

  // Optional action buttons on the right
  final List<Widget>? actionButtons;

  const AppBackHeader({
    super.key,
    required this.title,
    this.onBackPressed,
    this.backgroundColor,
    this.titleColor,
    this.buttonColor,
    this.buttonIconColor,
    this.stepperWidget,
    this.actionButtons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: EdgeInsets.only(
        left: AppSpacing.xl3,
        right: AppSpacing.xl3,
        top: AppSpacing.lg,
        bottom: AppSpacing.xl,
      ),
      color: backgroundColor,
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: onBackPressed ?? () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: buttonColor ?? Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SvgPicture.asset(
                AusaIcons.chevronLeft,
                colorFilter: ColorFilter.mode(AppColors.black, BlendMode.srcIn),
              ),
            ),
          ),

          SizedBox(width: AppSpacing.xl),

          // Title
          Text(
            title,
            style: AppTypography.headline(color: titleColor ?? Colors.black87),
          ),

          // Stepper widget (if provided)
          if (stepperWidget != null) ...[
            SizedBox(width: AppSpacing.lg),
            stepperWidget!,
          ],

          // Action buttons (if provided)
          if (actionButtons != null && actionButtons!.isNotEmpty) ...[
            Expanded(child: const SizedBox()),
            Row(mainAxisSize: MainAxisSize.min, children: actionButtons!),
          ],
        ],
      ),
    );
  }
}

class AppBackHeader2 extends StatelessWidget {
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

  const AppBackHeader2({
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
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      color: backgroundColor,
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: onBackPressed ?? () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: buttonColor ?? Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: buttonIconColor ?? Colors.black87,
                size: 16,
              ),
            ),
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
                                ? (completedStepColor ?? AppColors.primary700)
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
