import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTabButton extends StatelessWidget {
  final String icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const CustomTabButton({
    super.key,
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: AppSpacing.lg,
          right: AppSpacing.xl2,
        ),
        decoration: BoxDecoration(
          gradient:
              selected
                  ? const LinearGradient(
                    colors: [
                      AppColors.primaryDarkColor,
                      AppColors.primaryLightColor,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                  : const LinearGradient(
                    colors: [Colors.white, Colors.white],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
          borderRadius: BorderRadius.circular(AppRadius.xl2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 0,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: DesignScaleManager.scaleValue(48),
              height: DesignScaleManager.scaleValue(48),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary500 : Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.xl2),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                icon,
                width: DesignScaleManager.scaleValue(32),
                height: DesignScaleManager.scaleValue(32),
                colorFilter: ColorFilter.mode(
                  selected ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(width: AppSpacing.smMedium),
            Text(
              label,
              style:
                  selected
                      ? AppTypography.body(
                        weight: AppTypographyWeight.semibold,
                        color: Colors.white,
                      )
                      : AppTypography.body(
                        weight: AppTypographyWeight.regular,
                        color: Colors.black,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
