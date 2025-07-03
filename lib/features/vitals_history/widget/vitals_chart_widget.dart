import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../constants/constants.dart';
import '../model/vital_reading.dart';
import '../model/blood_pressure_reading.dart';
import '../model/spo2_heart_rate_reading.dart';
import '../model/blood_glucose_reading.dart';
import '../model/body_temperature_reading.dart';
import '../model/ecg_reading.dart';

class VitalsChartWidget extends StatefulWidget {
  final List<VitalReading> readings;
  final VitalType vitalType;
  final String? selectedParameter;

  const VitalsChartWidget({
    super.key,
    required this.readings,
    required this.vitalType,
    this.selectedParameter,
  });

  @override
  State<VitalsChartWidget> createState() => _VitalsChartWidgetState();
}

class _VitalsChartWidgetState extends State<VitalsChartWidget> {
  String selectedParameter = '';

  @override
  void initState() {
    super.initState();
    selectedParameter = widget.selectedParameter ?? _getDefaultParameter();
  }

  @override
  void didUpdateWidget(VitalsChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.vitalType != widget.vitalType) {
      selectedParameter = _getDefaultParameter();
    } else if (widget.selectedParameter != null &&
        widget.selectedParameter!.isNotEmpty) {
      // Use the external selected parameter
      selectedParameter = widget.selectedParameter!;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.readings.isEmpty) {
      return _buildEmptyChart();
    }

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl2),
        // border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChartHeader(),
          SizedBox(height: AppSpacing.lg),
          Expanded(child: _buildChart()),
        ],
      ),
    );
  }

  Widget _buildChartHeader() {
    final parameters = _getParametersForVitalType();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Previous readings',
              style: AppTypography.body(color: Colors.grey[600]),
            ),
            if (widget.vitalType == VitalType.bloodPressure &&
                selectedParameter == 'BP')
              Container(
                margin: EdgeInsets.only(top: AppSpacing.md),
                child: Row(
                  children: [
                    _buildLegendItem('Systolic', AppColors.primaryColor),
                    SizedBox(width: AppSpacing.lg),
                    _buildLegendItem('Diastolic', Colors.orange),
                  ],
                ),
              ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        if (parameters.length > 1)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(AppRadius.xl3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),

            child: Row(
              children:
                  parameters.map((parameter) {
                    final isSelected = parameter == selectedParameter;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedParameter = parameter;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: AppSpacing.sm),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? const Color(0xFFFFC107)
                                  : Colors.grey[100],
                          borderRadius: BorderRadius.circular(AppRadius.xl3),
                        ),
                        child: Text(
                          parameter,
                          style: AppTypography.callout(
                            color: Color(0xFF1A2A78),
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Text(
      label,
      style: AppTypography.callout(color: color, fontWeight: FontWeight.w400),
    );
  }

  Widget _buildChart() {
    final chartData = _generateChartData();

    if (chartData.isEmpty) {
      return _buildEmptyChartContent();
    }

    return SizedBox(
      height: 300,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              getDrawingVerticalLine: (value) {
                return FlLine(color: Colors.grey[200]!, strokeWidth: 0.2);
              },
              horizontalInterval: _getGridInterval(),
              getDrawingHorizontalLine: (value) {
                return FlLine(color: Colors.grey[300]!, strokeWidth: 0.2);
              },
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: _getGridInterval(),
                  getTitlesWidget: (value, meta) {
                    // Show all grid values plus exact current values
                    final isCurrentValue = _isCurrentValue(value);
                    final isGridValue = _isGridValue(value);

                    if (isGridValue || isCurrentValue) {
                      return Text(
                        _formatLeftAxisValue(value),
                        style: AppTypography.callout(
                          color:
                              isCurrentValue
                                  ? AppColors.primaryColor
                                  : Colors.grey[600],
                          fontWeight:
                              isCurrentValue
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 45,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    final maxReadings = _getMaxReadings();
                    if (index >= 0 && index < maxReadings) {
                      final reading =
                          widget.readings[widget.readings.length - 1 - index];
                      final isToday = _isToday(reading.timestamp);
                      final showDateLabel = _shouldShowDateLabel(index);

                      return Padding(
                        padding: const EdgeInsets.only(left: 11),
                        child: Stack(
                          children: [
                            // // Dashed line
                            // if (index > 0 && showDateLabel)
                            //   Positioned(
                            //     left: -20,
                            //     right: -20,
                            //     top: 0,
                            //     child: CustomPaint(
                            //       painter: DashedLinePainter(
                            //         color: Colors.grey[300]!,
                            //       ),
                            //     ),
                            //   ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 20, // Fixed height for date area
                                  child:
                                      showDateLabel
                                          ? Text(
                                            _formatDate(reading.timestamp),
                                            style: AppTypography.callout(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                          : null,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatTime(reading.timestamp),
                                  style: AppTypography.callout(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: (_getMaxReadings() - 1).toDouble(),
            minY: _getMinY(),
            maxY: _getMaxY(),
            lineBarsData: chartData,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyChart() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(AppRadius.xl2),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Previous readings',
            style: AppTypography.callout(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(child: _buildEmptyChartContent()),
        ],
      ),
    );
  }

  Widget _buildEmptyChartContent() {
    return Center(
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

  List<LineChartBarData> _generateChartData() {
    if (widget.vitalType == VitalType.bloodPressure &&
        selectedParameter == 'BP') {
      // Generate two lines for systolic and diastolic
      return [
        _generateLineChartBarData('Systolic', AppColors.primaryColor),
        _generateLineChartBarData('Diastolic', Colors.orange),
      ];
    } else {
      // Generate single line for other parameters
      final spots = _generateSpots();
      if (spots.isEmpty) return [];

      return [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.2,
          color: Colors.grey[400],
          barWidth: 1, // This is where the line width is set for the main chart
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              final isLatest = index == spots.length - 1;
              return FlDotCirclePainter(
                radius: 3,
                color:
                    isLatest
                        ? AppColors.primaryColor
                        : const Color.fromARGB(
                          255,
                          193,
                          193,
                          193,
                        ).withOpacity(0.6),
                strokeWidth: 0,
              );
            },
          ),
          belowBarData: BarAreaData(show: false),
        ),
      ];
    }
  }

  LineChartBarData _generateLineChartBarData(String parameter, Color color) {
    final spots = <FlSpot>[];
    final maxReadings = _getMaxReadings();

    for (int i = 0; i < maxReadings; i++) {
      final reading = widget.readings[widget.readings.length - 1 - i];
      final value = _getValueForParameter(reading, parameter);

      if (value != null) {
        spots.add(FlSpot(i.toDouble(), value));
      }
    }

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.2,
      color: color,
      barWidth: 1, // This is where the line width is set for BP chart lines
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          final isLatest = index == spots.length - 1;
          return FlDotCirclePainter(
            radius: 3,
            color: isLatest ? color : color.withOpacity(0.6),
            strokeWidth: 0,
          );
        },
      ),
      belowBarData: BarAreaData(show: false),
    );
  }

  List<FlSpot> _generateSpots() {
    final spots = <FlSpot>[];
    final maxReadings = _getMaxReadings();

    for (int i = 0; i < maxReadings; i++) {
      final reading = widget.readings[widget.readings.length - 1 - i];
      final value = _getValueForParameter(reading, selectedParameter);

      if (value != null) {
        spots.add(FlSpot(i.toDouble(), value));
      }
    }

    return spots;
  }

  double? _getValueForParameter(VitalReading reading, String parameter) {
    switch (widget.vitalType) {
      case VitalType.bloodPressure:
        final bpReading = reading as BloodPressureReading;
        switch (parameter) {
          case 'Systolic':
            return bpReading.systolic.toDouble();
          case 'Diastolic':
            return bpReading.diastolic.toDouble();
          case 'MAP':
            return bpReading.map.toDouble();
          case 'PP':
            return bpReading.pulsePressure.toDouble();
        }
        break;
      case VitalType.spO2HeartRate:
        final spO2Reading = reading as SpO2HeartRateReading;
        switch (parameter) {
          case 'SpO2':
            return spO2Reading.oxygenSaturation;
          case 'Heart rate':
            return spO2Reading.heartRate.toDouble();
        }
        break;
      case VitalType.bloodGlucose:
        final glucoseReading = reading as BloodGlucoseReading;
        return glucoseReading.glucoseLevel;
      case VitalType.bodyTemperature:
        final tempReading = reading as BodyTemperatureReading;
        return tempReading.temperature;
      case VitalType.ecg:
        final ecgReading = reading as ECGReading;
        return ecgReading.heartRate.toDouble();
    }
    return null;
  }

  double? _getCurrentValue() {
    if (widget.readings.isEmpty) return null;

    // For BP, return systolic as the primary value
    if (widget.vitalType == VitalType.bloodPressure &&
        selectedParameter == 'BP') {
      return _getValueForParameter(widget.readings.first, 'Systolic');
    }

    return _getValueForParameter(widget.readings.first, selectedParameter);
  }

  List<String> _getParametersForVitalType() {
    switch (widget.vitalType) {
      case VitalType.bloodPressure:
        return ['BP', 'MAP', 'PP'];
      case VitalType.spO2HeartRate:
        return ['SpO2', 'Heart rate'];
      case VitalType.bloodGlucose:
        return ['Glucose'];
      case VitalType.bodyTemperature:
        return ['Temperature'];
      case VitalType.ecg:
        return ['Heart Rate'];
    }
  }

  String _getDefaultParameter() {
    final parameters = _getParametersForVitalType();
    return parameters.first;
  }

  int _getMaxReadings() {
    return widget.readings.length < 5 ? widget.readings.length : 5;
  }

  double _getMinY() {
    // Always start from 0 for all vital types
    return 0;
  }

  double _getMaxY() {
    if (widget.readings.isEmpty) {
      return _getDefaultMaxY();
    }

    // Get actual data range
    final values = <double>[];

    final maxReadings = _getMaxReadings();
    if (widget.vitalType == VitalType.bloodPressure &&
        selectedParameter == 'BP') {
      // For BP chart, include both systolic and diastolic values
      for (final reading in widget.readings.take(maxReadings)) {
        final systolic = _getValueForParameter(reading, 'Systolic');
        final diastolic = _getValueForParameter(reading, 'Diastolic');
        if (systolic != null) values.add(systolic);
        if (diastolic != null) values.add(diastolic);
      }
    } else {
      // For single parameter charts
      for (final reading in widget.readings.take(maxReadings)) {
        final value = _getValueForParameter(reading, selectedParameter);
        if (value != null) values.add(value);
      }
    }

    if (values.isEmpty) return _getDefaultMaxY();

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final defaultMax = _getDefaultMaxY();

    // Add some padding above the maximum value, but don't go below the default maximum
    final paddedMax =
        maxValue + (maxValue - values.reduce((a, b) => a < b ? a : b)) * 0.1;
    return paddedMax > defaultMax ? paddedMax : defaultMax;
  }

  double _getDefaultMinY() {
    switch (widget.vitalType) {
      case VitalType.bloodPressure:
        return selectedParameter == 'BP'
            ? 40 // To accommodate both systolic and diastolic
            : selectedParameter == 'MAP'
            ? 60
            : 10; // Pulse Pressure - reduced from 20 to 10
      case VitalType.spO2HeartRate:
        return selectedParameter == 'SpO2' ? 90 : 40;
      case VitalType.bloodGlucose:
        return 70;
      case VitalType.bodyTemperature:
        return 35;
      case VitalType.ecg:
        return 40;
    }
  }

  double _getDefaultMaxY() {
    switch (widget.vitalType) {
      case VitalType.bloodPressure:
        return selectedParameter == 'BP'
            ? 180 // To accommodate both systolic and diastolic
            : selectedParameter == 'MAP'
            ? 130
            : 100; // Pulse Pressure - increased from 80 to 100
      case VitalType.spO2HeartRate:
        return selectedParameter == 'SpO2' ? 100 : 120;
      case VitalType.bloodGlucose:
        return 200;
      case VitalType.bodyTemperature:
        return 42;
      case VitalType.ecg:
        return 120;
    }
  }

  double _getGridInterval() {
    final range = _getMaxY() - _getMinY();

    // Calculate an appropriate interval that gives us 4-6 grid lines
    final targetLines = 5;
    double interval = range / targetLines;

    // Round to nice numbers
    if (interval <= 1) return 1;
    if (interval <= 2) return 2;
    if (interval <= 5) return 5;
    if (interval <= 10) return 10;
    if (interval <= 20) return 20;
    if (interval <= 25) return 25;
    if (interval <= 50) return 50;

    // For larger intervals, round to nearest 10, 25, or 50
    if (interval <= 100) {
      return ((interval / 25).round() * 25).toDouble();
    }

    final rounded = (interval / 50).round() * 50;
    return rounded.toDouble();
  }

  bool _isToday(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(timestamp.year, timestamp.month, timestamp.day);
    return date == today;
  }

  String _formatLeftAxisValue(double value) {
    // Format the value based on the vital type and selected parameter
    switch (widget.vitalType) {
      case VitalType.bloodPressure:
        return value.toInt().toString();
      case VitalType.spO2HeartRate:
        if (selectedParameter == 'SpO2') {
          return '${value.toInt()}%';
        } else {
          return value.toInt().toString();
        }
      case VitalType.bloodGlucose:
        return value.toInt().toString();
      case VitalType.bodyTemperature:
        return '${value.toStringAsFixed(1)}°';
      case VitalType.ecg:
        return value.toInt().toString();
    }
  }

  bool _isGridValue(double value) {
    // Check if value is a regular grid interval
    final interval = _getGridInterval();
    return (value % interval).abs() < 0.1;
  }

  bool _isCurrentValue(double value) {
    if (widget.readings.isEmpty) return false;

    // Get the latest reading values
    final latestReading = widget.readings.first;
    final tolerance = 0.5; // Allow some tolerance for floating point comparison

    if (widget.vitalType == VitalType.bloodPressure &&
        selectedParameter == 'BP') {
      final systolic = _getValueForParameter(latestReading, 'Systolic');
      final diastolic = _getValueForParameter(latestReading, 'Diastolic');

      if (systolic != null && (value - systolic).abs() < tolerance) return true;
      if (diastolic != null && (value - diastolic).abs() < tolerance)
        return true;
    } else {
      final currentValue = _getValueForParameter(
        latestReading,
        selectedParameter,
      );
      if (currentValue != null && (value - currentValue).abs() < tolerance)
        return true;
    }

    return false;
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour;
    final period = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour $period';
  }

  String _formatDate(DateTime timestamp) {
    final months = [
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
    return '${months[timestamp.month - 1]} ${timestamp.day}';
  }

  bool _shouldShowDateLabel(int index) {
    if (index == 0) return true;

    final currentReading = widget.readings[widget.readings.length - 1 - index];
    final previousReading = widget.readings[widget.readings.length - index];

    return !_isSameDay(currentReading.timestamp, previousReading.timestamp);
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 1;

    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startX = 0;
    final endX = size.width;

    while (startX < endX) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
