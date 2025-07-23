// lib/ui/graph/chart_utils.dart
// Centralised helpers for VitalsChart widgets
// ------------------------------------------------------------
// This file groups *all* math, formatting and FL Chart helpers
// so the UI layer can stay lean. Nothing here touches Flutter
// widgets directly; only value‑objects and fl_chart classes.

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ausa/constants/constants.dart';

import 'package:ausa/features/vitals_history/model/vital_reading.dart';
import 'package:ausa/features/vitals_history/model/blood_pressure_reading.dart';
import 'package:ausa/features/vitals_history/model/spo2_heart_rate_reading.dart';
import 'package:ausa/features/vitals_history/model/blood_glucose_reading.dart';
import 'package:ausa/features/vitals_history/model/body_temperature_reading.dart';
import 'package:ausa/features/vitals_history/model/ecg_reading.dart';

// ------------------------------------------------------------
// • Public API
// ------------------------------------------------------------

/// Parameter list in display order per [VitalType].
List<String> chartParameters(VitalType type) {
  switch (type) {
    case VitalType.bloodPressure:
      return ['BP', 'MAP', 'PP'];
    case VitalType.spO2HeartRate:
      return ['SpO2'];
    case VitalType.bloodGlucose:
      return ['Fasting', 'Post meal'];
    case VitalType.bodyTemperature:
      return ['°C', '°F'];
    case VitalType.ecg:
      return ['Heart Rate'];
  }
}

/// The first entry in [chartParameters].
String chartDefaultParameter(VitalType type) => chartParameters(type).first;

/// Cap the number of points to keep UI readable & performant.
// int maxReadings(List<VitalReading> readings) =>
//     readings.length < 5 ? readings.length : 5;

int maxReadings(List readings) => readings.length;

/// Build all [LineChartBarData] curves (and BP connector) for a chart.
List<LineChartBarData> buildChartBars({
  required List<VitalReading> readings,
  required VitalType vitalType,
  required String parameter,
}) {
  if (readings.isEmpty) return [];

  final bars = <LineChartBarData>[];

  // Connector bar for BP (vertical highlight of latest reading)
  final connector = _buildLatestConnectionLine(
    readings: readings,
    vitalType: vitalType,
    parameter: parameter,
  );
  if (connector != null) bars.add(connector);

  // Main curves --------------------------------------------------
  if (vitalType == VitalType.bloodPressure && parameter == 'BP') {
    // Dual‑line mode
    bars.addAll([
      _buildLine(
        readings: readings,
        vitalType: vitalType,
        parameter: 'Systolic',
        color: AppColors.primary700,
      ),
      _buildLine(
        readings: readings,
        vitalType: vitalType,
        parameter: 'Diastolic',
        color: AppColors.accent,
      ),
    ]);
  } else {
    // Single‑curve mode
    bars.add(
      _buildLine(
        readings: readings,
        vitalType: vitalType,
        parameter: parameter,
        color: AppColors.primary700,
      ),
    );
  }
  return bars;
}

FlGridData buildGrid(
  VitalType type,
  String parameter,
  List<VitalReading> readings,
) {
  final interval = _gridInterval(type, parameter, readings);
  return FlGridData(
    show: true,
    drawVerticalLine: true,
    getDrawingVerticalLine:
        (v) => FlLine(color: Colors.grey[200]!, strokeWidth: .2),
    horizontalInterval: interval,
    getDrawingHorizontalLine:
        (v) => FlLine(color: Colors.grey[300]!, strokeWidth: .2),
  );
}

FlTitlesData buildTitles({
  required List<VitalReading> readings,
  required VitalType vitalType,
  required String parameter,
}) {
  // 1) Compute the exact min/max we’re using
  final minY = calcMinY(readings, vitalType, parameter);
  final maxY = calcMaxY(readings, vitalType, parameter);

  // 2) Divide that range into 4 segments ⇒ 5 ticks total
  final interval = (maxY - minY) / 4;

  // 3) Figure out which tick is the “current” one
  final double? currentVal = _currentValue(
    readings: readings,
    vitalType: vitalType,
    parameter: parameter,
  );
  double? currentTick;
  if (currentVal != null) {
    final rawIdx = (currentVal - minY) / interval;
    currentTick = minY + rawIdx.round() * interval;
  }

  return FlTitlesData(
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 50,
        interval: interval, // ← only five labels now
        getTitlesWidget: (value, meta) {
          final bool isCurrentTick =
              currentTick != null && (value - currentTick).abs() < 1e-6;
          final bool isGridLine = _isGridValue(
            value,
            interval: interval,
            minY: minY,
          );

          if (isCurrentTick) {
            // yellow pill, showing the *actual* reading
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC107),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                _formatLeftAxisValue(currentVal!, vitalType),
                style: AppTypography.callout(
                  color: Colors.black,
                  weight: AppTypographyWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (isGridLine) {
            // normal grid-line label
            return Text(
              _formatLeftAxisValue(value, vitalType),
              style: AppTypography.callout(
                color: const Color(0xff59739E),
                weight: AppTypographyWeight.medium,
              ),
              textAlign: TextAlign.center,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 45,
        interval: 1,
        getTitlesWidget: (value, meta) {
          final idx = value.toInt();
          if (idx < 0 || idx >= maxReadings(readings))
            return const SizedBox.shrink();

          final reading = readings[readings.length - 1 - idx];
          final isLatest = idx == maxReadings(readings) - 1;
          final showDate = _shouldShowDateLabel(idx, readings);

          return Padding(
            padding: const EdgeInsets.only(left: 11),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isLatest ? const Color(0xFFFFC107) : null,
                    borderRadius:
                        isLatest ? BorderRadius.circular(AppRadius.full) : null,
                  ),
                  child: Text(
                    _formatTime(reading.timestamp),
                    style: AppTypography.callout(
                      color: isLatest ? Colors.black : const Color(0xff59739E),
                      weight:
                          isLatest
                              ? AppTypographyWeight.bold
                              : AppTypographyWeight.medium,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 15,
                  child:
                      showDate
                          ? Container(
                            color: const Color(0xFFFAFAFA),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              _formatDate(reading.timestamp),
                              style: AppTypography.callout(
                                color: const Color(0xFF6B6B6B),
                                weight: AppTypographyWeight.medium,
                              ),
                            ),
                          )
                          : null,
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

/// Inclusive minY (rounded to nice interval)
double calcMinY(
  List<VitalReading> readings,
  VitalType vitalType,
  String parameter,
) {
  if (readings.isEmpty) return _defaultMinY(vitalType, parameter);

  final values = _axisValues(readings, vitalType, parameter);
  final dataMin = values.reduce((a, b) => a < b ? a : b);
  final interval = _gridInterval(vitalType, parameter, readings);
  final padding = _axisPadding(vitalType, parameter);
  final tentative = dataMin - padding;
  return (tentative / interval).floor() * interval;
}

/// Exclusive maxY (4 grid intervals above minY)
double calcMaxY(
  List<VitalReading> readings,
  VitalType vitalType,
  String parameter,
) {
  final minY = calcMinY(readings, vitalType, parameter);
  final interval = _gridInterval(vitalType, parameter, readings);
  return minY + interval * 4;
}

// ------------------------------------------------------------
// • Private helpers
// ------------------------------------------------------------

LineChartBarData _buildLine({
  required List<VitalReading> readings,
  required VitalType vitalType,
  required String parameter,
  required Color color,
}) {
  final spots = _generateSpots(readings, vitalType, parameter);
  return LineChartBarData(
    spots: spots,
    isCurved: true,
    curveSmoothness: .5,
    color: color,
    barWidth: 1,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: true,
      getDotPainter: (spot, percent, barData, idx) {
        final isLatest = idx == spots.length - 1;
        return FlDotCirclePainter(
          radius: 4,
          color: color,
          strokeWidth: isLatest ? 3 : 0,
          strokeColor: isLatest ? const Color(0xffFFC107) : Colors.transparent,
        );
      },
    ),
    belowBarData: BarAreaData(show: false),
  );
}

LineChartBarData? _buildLatestConnectionLine({
  required List<VitalReading> readings,
  required VitalType vitalType,
  required String parameter,
}) {
  if (readings.isEmpty) return null;
  if (vitalType != VitalType.bloodPressure || parameter != 'BP') return null;

  final maxX = (maxReadings(readings) - 1).toDouble();
  final latest = readings.first as BloodPressureReading;
  final s = latest.systolic.toDouble();
  final d = latest.diastolic.toDouble();
  final spots =
      s > d
          ? [FlSpot(maxX, d), FlSpot(maxX, s)]
          : [FlSpot(maxX, s), FlSpot(maxX, d)];

  return LineChartBarData(
    spots: spots,
    isCurved: false,
    barWidth: 14,
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xffFFC107),
        Color(0x80FFC107),
        Color(0x80FFC107),
        Color(0xffFFC107),
      ],
      stops: [0.0, 0.33, 0.67, 1.0],
    ),
    dotData: FlDotData(show: false),
    isStrokeCapRound: true,
    belowBarData: BarAreaData(show: false),
  );
}

List<FlSpot> _generateSpots(
  List<VitalReading> readings,
  VitalType vitalType,
  String parameter,
) {
  final maxPts = maxReadings(readings);
  final spots = <FlSpot>[];

  for (int i = 0; i < maxPts; i++) {
    final reading = readings[readings.length - 1 - i];
    final value = _valueForParameter(reading, vitalType, parameter);
    if (value != null) {
      spots.add(FlSpot(i.toDouble(), value));
    }
  }
  return spots;
}

// -- Axis helpers ----------------------------------------------------------

List<double> _axisValues(
  List<VitalReading> readings,
  VitalType vitalType,
  String parameter,
) {
  final values = <double>[];
  final maxPts = maxReadings(readings);

  if (vitalType == VitalType.bloodPressure && parameter == 'BP') {
    for (final reading in readings.take(maxPts)) {
      final bp = reading as BloodPressureReading;
      values
        ..add(bp.systolic.toDouble())
        ..add(bp.diastolic.toDouble());
    }
  } else {
    for (final r in readings.take(maxPts)) {
      final v = _valueForParameter(r, vitalType, parameter);
      if (v != null) values.add(v);
    }
  }
  return values;
}

// Nice‑number grid step
List<double> _niceStepsTemp = [0.1, 0.2, 0.5, 1, 2, 5, 10, 20, 25, 50, 100];
List<double> _niceStepsDefault = [1, 2, 5, 10, 20, 25, 50, 100];

double _gridInterval(
  VitalType vitalType,
  String parameter,
  List<VitalReading> readings,
) {
  final values = _axisValues(readings, vitalType, parameter);
  if (values.isEmpty) return 1;

  final min = values.reduce((a, b) => a < b ? a : b);
  final max = values.reduce((a, b) => a > b ? a : b);
  final paddedMin = min - _axisPadding(vitalType, parameter);
  final paddedMax = max + _axisPadding(vitalType, parameter);
  final target = (paddedMax - paddedMin) / 4;
  final steps =
      vitalType == VitalType.bodyTemperature
          ? _niceStepsTemp
          : _niceStepsDefault;
  for (final s in steps) {
    if (s >= target) return s;
  }
  return steps.last;
}

double _axisPadding(VitalType type, String parameter) {
  switch (type) {
    case VitalType.bloodPressure:
      return 40;
    case VitalType.spO2HeartRate:
      return 2;
    case VitalType.bloodGlucose:
      return 20;
    case VitalType.bodyTemperature:
      return parameter == '°C' ? 0.5 : 1;
    case VitalType.ecg:
      return 10;
  }
}

double _defaultMinY(VitalType type, String parameter) {
  switch (type) {
    case VitalType.bloodPressure:
      return parameter == 'BP' ? 40 : (parameter == 'MAP' ? 60 : 10);
    case VitalType.spO2HeartRate:
      return 90;
    case VitalType.bloodGlucose:
      return 70;
    case VitalType.bodyTemperature:
      return parameter == '°C' ? 35 : 95;
    case VitalType.ecg:
      return 40;
  }
}

// Current/latest reading helpers -----------------------------------------

double? _currentValue({
  required List<VitalReading> readings,
  required VitalType vitalType,
  required String parameter,
}) {
  if (readings.isEmpty) return null;

  if (vitalType == VitalType.bloodPressure && parameter == 'BP') {
    final bp = readings.first as BloodPressureReading;
    return bp.systolic.toDouble();
  }
  return _valueForParameter(readings.first, vitalType, parameter);
}

bool _isCurrentValue(
  double value, {
  required List<VitalReading> readings,
  required VitalType vitalType,
  required String parameter,
}) {
  if (readings.isEmpty) return false;
  double tolerance = 0.1;
  if (vitalType == VitalType.bodyTemperature) {
    tolerance = 0.05;
  } else if (vitalType == VitalType.spO2HeartRate) {
    tolerance = 0.5;
  }

  if (vitalType == VitalType.bloodPressure && parameter == 'BP') {
    final bp = readings.first as BloodPressureReading;
    final s = bp.systolic.toDouble();
    final d = bp.diastolic.toDouble();
    return (value - s).abs() < tolerance || (value - d).abs() < tolerance;
  }

  final curr = _valueForParameter(readings.first, vitalType, parameter);
  return curr != null && (value - curr).abs() < tolerance;
}

bool _isGridValue(
  double value, {
  required double interval,
  required double minY,
}) {
  const epsilon = 1e-6;
  final dist = (value - minY).abs();
  return (dist % interval).abs() < epsilon ||
      interval - (dist % interval).abs() < epsilon;
}

// Value extraction --------------------------------------------------------

double? _valueForParameter(
  VitalReading reading,
  VitalType vitalType,
  String parameter,
) {
  switch (vitalType) {
    case VitalType.bloodPressure:
      final bp = reading as BloodPressureReading;
      switch (parameter) {
        case 'Systolic':
          return bp.systolic.toDouble();
        case 'Diastolic':
          return bp.diastolic.toDouble();
        case 'MAP':
          return bp.map.toDouble();
        case 'PP':
          return bp.pulsePressure.toDouble();
      }
      break;
    case VitalType.spO2HeartRate:
      final sp = reading as SpO2HeartRateReading;
      if (parameter == 'SpO2') return sp.oxygenSaturation;
      break;
    case VitalType.bloodGlucose:
      final gl = reading as BloodGlucoseReading;
      if (parameter == 'Fasting' &&
          gl.measurementType == GlucoseMeasurementType.fasting) {
        return gl.glucoseLevel;
      } else if (parameter == 'Post meal' &&
          gl.measurementType == GlucoseMeasurementType.postMeal) {
        return gl.glucoseLevel;
      }
      break;
    case VitalType.bodyTemperature:
      final temp = reading as BodyTemperatureReading;
      if (parameter == '°C') return temp.convertToCelsius();
      if (parameter == '°F') return temp.convertToFahrenheit();
      break;
    case VitalType.ecg:
      final ecg = reading as ECGReading;
      return ecg.heartRate.toDouble();
  }
  return null;
}

// Formatting --------------------------------------------------------------

String _formatLeftAxisValue(double value, VitalType type) {
  switch (type) {
    case VitalType.bodyTemperature:
      return value.toStringAsFixed(1);
    default:
      return value.toInt().toString();
  }
}

String _formatTime(DateTime ts) {
  final hour = ts.hour;
  final period = hour < 12 ? 'AM' : 'PM';
  final display = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
  return '$display $period';
}

String _formatDate(DateTime ts) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[ts.month - 1]} ${ts.day}';
}

bool _shouldShowDateLabel(int idx, List<VitalReading> readings) {
  if (idx == 0) return true;
  final current = readings[readings.length - 1 - idx];
  final prev = readings[readings.length - idx];
  return !_sameDay(current.timestamp, prev.timestamp);
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
