import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';

class SwitchTabWidget extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;
  const SwitchTabWidget({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTypography.body(weight: AppTypographyWeight.regular),
        ),
        SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Container(
            height: 1.4,
            decoration: BoxDecoration(
              color: Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(
                DesignScaleManager.scaleValue(100),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.md),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: DesignScaleManager.scaleValue(86),
            height: DesignScaleManager.scaleValue(52),
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            decoration: BoxDecoration(
              color: value ? AppColors.primary500 : Color(0xFFE9E9E9),
              borderRadius: BorderRadius.circular(
                DesignScaleManager.scaleValue(100),
              ),
              // border: Border.all(
              //   color: value ? AppColors.primary500 : Color(0xFFE0E0E0),
              //   width: 1.2,
              // ),
            ),
            child: Align(
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: DesignScaleManager.scaleValue(32),
                height: DesignScaleManager.scaleValue(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
