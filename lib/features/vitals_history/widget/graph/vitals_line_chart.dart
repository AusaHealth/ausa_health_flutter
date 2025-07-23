import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ausa/features/vitals_history/model/vital_reading.dart';

import 'chart_utils.dart';

class VitalsLineChart extends StatefulWidget {
  const VitalsLineChart({
    super.key,
    required this.readings,
    required this.vitalType,
    required this.selectedParameter,
    this.transformationController,
  });

  final List<VitalReading> readings;
  final VitalType vitalType;
  final String selectedParameter;
  final TransformationController? transformationController;

  @override
  State<VitalsLineChart> createState() => _VitalsLineChartState();
}

class _VitalsLineChartState extends State<VitalsLineChart> {
  late TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _transformationController = widget.transformationController ?? TransformationController();
    
    // Scroll to the right end after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
    });
  }

  void _scrollToEnd() {
    // Calculate the translation needed to show the right end
    // This assumes your chart width and you may need to adjust the value
    final chartWidth = MediaQuery.of(context).size.width - 32; // Adjust padding as needed
    final dataPoints = widget.readings.length;
    final pointWidth = chartWidth / 10; // Adjust based on your visible points
    
    // Calculate translation to show the last portion of the chart
    final translation = -(dataPoints - 10) * pointWidth; // Show last 10 points
    
    _transformationController.value = Matrix4.identity()
      ..translate(translation.clamp(-chartWidth * 9, 0.0), 0.0); // Clamp to valid range
  }

  @override
  Widget build(BuildContext context) {
    final chartData = buildChartBars(
      readings: widget.readings,
      vitalType: widget.vitalType,
      parameter: widget.selectedParameter,
    );
    if (chartData.isEmpty) return const SizedBox.shrink();

    return LineChart(
      transformationConfig: FlTransformationConfig(
        scaleAxis: FlScaleAxis.horizontal,
        minScale: 1.0,
        maxScale: 10.0,
        panEnabled: true,
        scaleEnabled: false,
        transformationController: _transformationController,
      ),
      LineChartData(
        minX: 0,
        maxX: (widget.readings.length - 1).toDouble(),
        minY: calcMinY(widget.readings, widget.vitalType, widget.selectedParameter),
        maxY: calcMaxY(widget.readings, widget.vitalType, widget.selectedParameter),
        lineBarsData: chartData,
        borderData: FlBorderData(show: false),
        gridData: buildGrid(widget.vitalType, widget.selectedParameter, widget.readings),
        titlesData: buildTitles(
          readings: widget.readings,
          vitalType: widget.vitalType,
          parameter: widget.selectedParameter,
        ),
      ),
    );
  }
}