import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/constants.dart';

/// A reusable header widget with back button and page title
/// Optionally displays a stepper widget and action buttons
///
/// Example usage:
/// ```dart
/// // Regular header
/// AppBackHeader(title: 'Settings')
///
/// // Header with stepper widget
/// AppBackHeader(
///   title: 'Setup Process',
///   stepperWidget: MyCustomStepper(),
/// )
///
/// // Header with action buttons
/// AppBackHeader(
///   title: 'Settings',
///   actionButtons: [
///     IconButton(icon: Icon(Icons.edit), onPressed: () {}),
///     IconButton(icon: Icon(Icons.delete), onPressed: () {}),
///   ],
/// )
/// ```
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
      height: 80, // Fixed height to ensure consistency
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
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

          SizedBox(width: AppSpacing.md),

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

          // Spacer to push action buttons to the right
          const Spacer(),

          // Action buttons (if provided)
          if (actionButtons != null && actionButtons!.isNotEmpty) ...[
            SizedBox(width: AppSpacing.md),
            Row(mainAxisSize: MainAxisSize.min, children: actionButtons!),
          ],
        ],
      ),
    );
  }
}
