import 'package:ausa/constants/constants.dart';
import 'package:ausa/features/vitals_history/model/blood_glucose_reading.dart';
import 'package:ausa/features/vitals_history/model/blood_pressure_reading.dart';
import 'package:ausa/features/vitals_history/model/body_temperature_reading.dart';
import 'package:ausa/features/vitals_history/model/ecg_reading.dart';
import 'package:ausa/features/vitals_history/model/spo2_heart_rate_reading.dart';
import 'package:ausa/features/vitals_history/model/vital_reading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadingCardWidget extends StatelessWidget {
  final VitalReading reading;
  final bool isToday;
  final bool showDateHeader;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final Function(String)? onParameterTap;
  final bool Function(String)? isParameterSelected;

  const ReadingCardWidget({
    super.key,
    required this.reading,
    this.isToday = false,
    this.showDateHeader = true,
    this.isSelected = false,
    this.onTap,
    this.onDoubleTap,
    this.onParameterTap,
    this.isParameterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.lg),
        padding: EdgeInsets.only(
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDateHeader) ...[
              _buildCardHeader(),
              SizedBox(height: AppSpacing.md),
            ],
            _buildReadingData(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _formatDate(),
          style: AppTypography.callout(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildReadingData() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 0,
              vertical: AppSpacing.md,
            ),
            child: Text(
              _formatTime(),
              style: AppTypography.callout(
                color: Color(0xFF415981),
                weight: AppTypographyWeight.medium,
              ),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildVitalSpecificData(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildVitalSpecificData() {
    switch (reading.type) {
      case VitalType.bloodPressure:
        return _buildBloodPressureData();
      case VitalType.spO2HeartRate:
        return _buildSpO2HeartRateData();
      case VitalType.bloodGlucose:
        return _buildBloodGlucoseData();
      case VitalType.bodyTemperature:
        return _buildBodyTemperatureData();
      case VitalType.ecg:
        return _buildECGData();
    }
  }

  List<Widget> _buildBloodPressureData() {
    final bpReading = reading as BloodPressureReading;
    return [
      Obx(
        () => GestureDetector(
          onTap: () => onParameterTap?.call('Systolic'),
          child: Container(
            decoration: BoxDecoration(
              color:
                  isParameterSelected?.call('Systolic') == true ||
                          isParameterSelected?.call('Diastolic') == true
                      ? Color(0xFFFFF7DE)
                      : null,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.lg,
                    ),
                    child: _buildDataPoint(
                      'BP Systolic',
                      '${bpReading.systolic}',
                      'mmHg',
                      isHighlighted:
                          isParameterSelected?.call('Systolic') == true ||
                          isParameterSelected?.call('Diastolic') == true,
                    ),
                  ),
                ),
                // SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    child: _buildDataPoint(
                      'BP Diastolic',
                      '${bpReading.diastolic}',
                      'mmHg',
                      isHighlighted:
                          isParameterSelected?.call('Systolic') == true ||
                          isParameterSelected?.call('Diastolic') == true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      SizedBox(height: AppSpacing.md),
      Row(
        children: [
          Expanded(
            child: Obx(
              () => GestureDetector(
                onTap: () => onParameterTap?.call('MAP'),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.lg,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isParameterSelected?.call('MAP') == true
                            ? Color(0xFFFFF7DE)
                            : null,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                  child: _buildDataPoint(
                    'MAP',
                    '${bpReading.map}',
                    'mmHg',
                    isHighlighted: isParameterSelected?.call('MAP') == true,
                  ),
                ),
              ),
            ),
          ),
          // SizedBox(width: AppSpacing.md),
          Expanded(
            child: Obx(
              () => GestureDetector(
                onTap: () => onParameterTap?.call('Pulse Pressure'),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isParameterSelected?.call('Pulse Pressure') == true
                            ? Color(0xFFFFF7DE)
                            : null,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                  child: _buildDataPoint(
                    'Pulse Pressure',
                    '${bpReading.pulsePressure}',
                    'mmHg',
                    isHighlighted:
                        isParameterSelected?.call('Pulse Pressure') == true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildSpO2HeartRateData() {
    final spO2Reading = reading as SpO2HeartRateReading;
    return [
      Obx(
        () => GestureDetector(
          onTap: () => onParameterTap?.call('SpO2'),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color:
                  isParameterSelected?.call('SpO2') == true
                      ? Color(0xFFFFF7DE)
                      : null,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: _buildDataPoint(
              'SpO₂',
              spO2Reading.oxygenSaturation.toStringAsFixed(1),
              '%',
              isHighlighted: isParameterSelected?.call('SpO2') == true,
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildBloodGlucoseData() {
    final glucoseReading = reading as BloodGlucoseReading;
    return [
      Obx(
        () => GestureDetector(
          onTap: () => onParameterTap?.call('Glucose Level'),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color:
                  isParameterSelected?.call('Glucose Level') == true
                      ? Color(0xFFFFF7DE)
                      : null,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Row(
              children: [
                _buildDataPoint(
                  'Glucose Level',
                  glucoseReading.displayValue,
                  glucoseReading.unit,
                  isHighlighted:
                      isParameterSelected?.call('Glucose Level') == true,
                ),
                SizedBox(width: AppSpacing.xl),
                _buildDataPoint(
                  'Type',
                  glucoseReading.measurementTypeDisplay,
                  '',
                  isHighlighted:
                      isParameterSelected?.call('Glucose Level') == true,
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildBodyTemperatureData() {
    final tempReading = reading as BodyTemperatureReading;
    return [
      Obx(
        () => GestureDetector(
          onTap: () => onParameterTap?.call('Temperature'),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color:
                  isParameterSelected?.call('Temperature') == true
                      ? Color(0xFFFFF7DE)
                      : null,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: _buildDataPoint(
              'Temperature',
              tempReading.displayValue,
              tempReading.unit,
              isHighlighted: isParameterSelected?.call('Temperature') == true,
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildECGData() {
    final ecgReading = reading as ECGReading;
    return [
      Obx(
        () => GestureDetector(
          onTap: () => onParameterTap?.call('ECG Heart Rate'),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color:
                  isParameterSelected?.call('ECG Heart Rate') == true ||
                          isParameterSelected?.call('Rhythm') == true
                      ? Color(0xFFFFF7DE)
                      : null,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Row(
              children: [
                _buildDataPoint(
                  'Heart Rate',
                  '${ecgReading.heartRate}',
                  'BPM',
                  isHighlighted:
                      isParameterSelected?.call('ECG Heart Rate') == true ||
                      isParameterSelected?.call('Rhythm') == true,
                ),
                SizedBox(width: AppSpacing.xl),
                _buildDataPoint(
                  'Rhythm',
                  ecgReading.rhythmDisplay,
                  '',
                  isHighlighted:
                      isParameterSelected?.call('ECG Heart Rate') == true ||
                      isParameterSelected?.call('Rhythm') == true,
                ),
              ],
            ),
          ),
        ),
      ),
      SizedBox(height: AppSpacing.md),
      Obx(
        () => GestureDetector(
          onTap: () => onParameterTap?.call('Duration'),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color:
                  isParameterSelected?.call('Duration') == true
                      ? Color(0xFFFFF7DE)
                      : null,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: _buildDataPoint(
              'Duration',
              ecgReading.durationDisplay,
              '',
              isHighlighted: isParameterSelected?.call('Duration') == true,
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildDataPoint(
    String label,
    String value,
    String unit, {
    bool isHighlighted = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.callout(
            color: Color(0xFF415981),
            weight: AppTypographyWeight.medium,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: AppTypography.body(
                color: isHighlighted ? AppColors.primary700 : _getValueColor(),
                weight: AppTypographyWeight.bold,
              ),
            ),
            if (unit.isNotEmpty) ...[
              SizedBox(width: AppSpacing.xs),
              Text(
                unit,
                style: AppTypography.body(
                  color:
                      isHighlighted ? AppColors.primary700 : _getValueColor(),
                  weight: AppTypographyWeight.regular,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Color _getValueColor() {
    switch (reading.status) {
      case VitalStatus.normal:
        return Color(0xFF415981);
      case VitalStatus.high:
      case VitalStatus.critical:
        return Color(0xFFD92D20);
      case VitalStatus.low:
        return Color.fromARGB(255, 209, 115, 0);
    }
  }

  String _formatDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final readingDate = DateTime(
      reading.timestamp.year,
      reading.timestamp.month,
      reading.timestamp.day,
    );

    if (readingDate == today) {
      return 'Mar ${reading.timestamp.day}, 2024';
    } else {
      return 'Mar ${reading.timestamp.day}, 2024';
    }
  }

  String _formatTime() {
    final hour = reading.timestamp.hour;
    final minute = reading.timestamp.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');

    return '$displayHour:$displayMinute $period';
  }
}
