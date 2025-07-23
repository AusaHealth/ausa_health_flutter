import 'package:ausa/constants/constants.dart';
import 'package:flutter/material.dart';

class AppMainContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double? opacity;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;

  const AppMainContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.opacity = 0.5,
    this.margin,
    this.padding,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin:
            margin ??
            EdgeInsets.only(
              left: AppSpacing.xl3,
              right: AppSpacing.xl3,
              top: 0,
              bottom: AppSpacing.xl,
            ),
        padding: padding ?? EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.xl3),
          color:
              backgroundColor?.withOpacity(opacity ?? 0.5) ??
              Colors.white.withOpacity(opacity ?? 0.5),
          boxShadow: boxShadow,
        ),
        child: child,
      ),
    );
  }
}
