// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ausa/features/vitals_history/model/vital_reading.dart';
import 'package:ausa/features/vitals_history/widget/graph/chart_utils.dart';
import 'package:flutter/material.dart';
import 'package:ausa/constants/constants.dart';

import 'chart_header.dart';
import 'vitals_line_chart.dart';

class VitalsChartWidget extends StatefulWidget {
  const VitalsChartWidget({
    super.key,
    required this.readings,
    required this.vitalType,
    this.selectedParameter,
    this.onParameterTap,
    this.externalController,
  });

  final List<VitalReading> readings;
  final VitalType vitalType;
  final String? selectedParameter;
  final ValueChanged<String>? onParameterTap;
  final TransformationController? externalController;

  @override
  State<VitalsChartWidget> createState() => _VitalsChartWidgetState();
}

class _VitalsChartWidgetState extends State<VitalsChartWidget>
    with SingleTickerProviderStateMixin {
  late final TransformationController _xform;
  late String _selectedParameter;
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  // final _xform = TransformationController();

  @override
  void initState() {
    super.initState();

    _xform = widget.externalController ?? TransformationController();

    _selectedParameter =
        widget.selectedParameter ?? chartDefaultParameter(widget.vitalType);

    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();

    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _slide = Tween(
      begin: const Offset(0, .30),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  @override
  void didUpdateWidget(covariant VitalsChartWidget old) {
    super.didUpdateWidget(old);
    if (old.vitalType != widget.vitalType) {
      _selectedParameter = chartDefaultParameter(widget.vitalType);
      _ctrl
        ..reset()
        ..forward();
    } else if (widget.selectedParameter != null) {
      _selectedParameter = widget.selectedParameter!;
    }
  }

  @override
  void dispose() {
    if (widget.externalController == null) {
      _xform.dispose();
    }
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: _ChartCard(
          header: ChartHeader(
            vitalType: widget.vitalType,
            selectedParameter: _selectedParameter,
            onParameterTap: (p) {
              setState(() => _selectedParameter = p);
              widget.onParameterTap?.call(p);
            },
          ),
          chart: VitalsLineChart(
            readings: widget.readings,
            vitalType: widget.vitalType,
            selectedParameter: _selectedParameter,
            transformationController: _xform, // NEW
          ),
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.header, required this.chart});
  final Widget header;
  final Widget chart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl2),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(AppRadius.xl3),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          SizedBox(height: AppSpacing.lg),
          Expanded(
            child: chart,
          ),
        ],
      ),
    );
  }
}
