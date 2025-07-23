import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';

class ReadingValueWidget extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final double? labelFontSize;
  final double? valueFontSize;
  final bool isBloodSugar;

  const ReadingValueWidget({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    this.labelFontSize,
    this.valueFontSize,
    this.isBloodSugar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isBloodSugar)
          Text(
            label,
            style: AppTypography.callout(
              color: AppColors.valueColor,
              weight: AppTypographyWeight.regular,
            ),
          ),
        if (isBloodSugar)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: AppTypography.callout(
                    color: AppColors.valueColor,
                    weight: AppTypographyWeight.regular,
                  ),
                ),
                TextSpan(
                  text: '2',
                  style: AppTypography.callout(
                    color: AppColors.valueColor,
                    weight: AppTypographyWeight.regular,
                  ).copyWith(fontSize: AppTypography.callout().fontSize! * 0.7),
                ),
              ],
            ),
          ),

        SizedBox(height: AppSpacing.smMedium),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: AppTypography.body(
                  color: AppColors.valueColor,
                  weight: AppTypographyWeight.bold,
                ),
              ),
              TextSpan(
                text: unit,
                style: AppTypography.body(
                  color: AppColors.valueColor,
                  weight: AppTypographyWeight.regular,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
