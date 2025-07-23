import 'package:flutter/material.dart';
import 'package:ausa/constants/constants.dart';

class EmptyChartPlaceholder extends StatelessWidget {
  const EmptyChartPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(AppRadius.xl2),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.show_chart, color: Colors.grey[400], size: 48),
          SizedBox(height: AppSpacing.md),
          Text(
            'No data available',
            style: AppTypography.callout(
              color: Colors.grey[500],
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
