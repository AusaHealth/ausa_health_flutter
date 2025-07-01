import 'package:flutter/material.dart';
import '../../../constants/constants.dart';

class ConditionTagWidget extends StatelessWidget {
  final String condition;
  final Color? backgroundColor;
  final Color? textColor;

  const ConditionTagWidget({
    super.key,
    required this.condition,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
     padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
      child: Text(
        condition,
        style: AppTypography.callout(
          color: textColor ?? Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
