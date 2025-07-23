import 'package:flutter/material.dart';
import 'package:ausa/constants/constants.dart';

class LegendItem extends StatelessWidget {
  const LegendItem({super.key, required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: AppTypography.callout(
              color: color,
              weight: AppTypographyWeight.medium,
            )),
      ],
    );
  }
}
