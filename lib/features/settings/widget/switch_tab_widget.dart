import 'package:ausa/constants/color.dart';
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
        SizedBox(width: 24),
        Expanded(
          child: Container(
            height: 1.4,
            decoration: BoxDecoration(
              color: Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Transform.scale(
          scale: 0.7,
          child: Switch(
            padding: EdgeInsets.zero,
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.white,
            activeTrackColor: AppColors.primary500,
            trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
            inactiveTrackColor: const Color(0xFFE9E9E9),
            inactiveThumbColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
