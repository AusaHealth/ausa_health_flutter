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
