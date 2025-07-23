import 'package:ausa/features/vitals_history/model/vital_reading.dart';
import 'package:flutter/material.dart';
import 'package:ausa/constants/constants.dart';

import 'legend_item.dart';
import 'parameter_selector.dart';
import 'chart_utils.dart';

class ChartHeader extends StatelessWidget {
  const ChartHeader({
    super.key,
    required this.vitalType,
    required this.selectedParameter,
    required this.onParameterTap,
  });

  final VitalType vitalType;
  final String selectedParameter;
  final ValueChanged<String> onParameterTap;

  @override
  Widget build(BuildContext context) {
    final parameters = chartParameters(vitalType);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _TitleAndLegend(
          vitalType: vitalType,
          selectedParameter: selectedParameter,
        ),
        if (parameters.length > 1)
          ParameterSelector(
            options: parameters,
            selected: selectedParameter,
            onTap: onParameterTap,
          ),
      ],
    );
  }
}

class _TitleAndLegend extends StatelessWidget {
  const _TitleAndLegend({
    required this.vitalType,
    required this.selectedParameter,
  });

  final VitalType vitalType;
  final String selectedParameter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Previous readings',
            style: AppTypography.body(weight: AppTypographyWeight.medium)),
        if (vitalType == VitalType.bloodPressure &&
            selectedParameter == 'BP')
          Row(
            children: [
              LegendItem(label: 'Systolic', color: AppColors.primary700),
              SizedBox(width: AppSpacing.lg),
              LegendItem(label: 'Diastolic', color: AppColors.accent),
            ],
          ),
      ],
    );
  }
}
