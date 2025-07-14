import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/constants.dart';

/// A reusable single tab button widget with beautiful gradient styling
class AppTabButton extends StatelessWidget {
  final String text;
  final String? iconPath;
  final bool isSelected;
  final VoidCallback onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const AppTabButton({
    super.key,
    required this.text,
    this.iconPath,
    required this.isSelected,
    required this.onTap,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? EdgeInsets.only(right: AppSpacing.md),
        padding:
            padding ??
            EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
        constraints: const BoxConstraints(minWidth: 152),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? LinearGradient(
                    colors: [AppColors.primary800, AppColors.primary500],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                  : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.full),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppColors.primary700.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconPath != null) ...[
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary700 : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    iconPath!,
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      isSelected ? Colors.white : Colors.grey[600]!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
            ],
            Text(
              text,
              style: AppTypography.body(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
