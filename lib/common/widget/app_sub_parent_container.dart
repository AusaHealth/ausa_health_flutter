import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:flutter/material.dart';

class AppSubParentContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  const AppSubParentContainer({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.xl3),
        color: backgroundColor ?? AppColors.white,
      ),

      padding:
          padding ??
          EdgeInsets.symmetric(
            vertical: AppSpacing.xl4,
            horizontal: AppSpacing.xl6,
          ),
      child: child,
    );
  }
}
