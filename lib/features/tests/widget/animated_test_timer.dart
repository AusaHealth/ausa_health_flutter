import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AnimatedTestTimerWidget extends StatefulWidget {
  final int duration; // in seconds
  final VoidCallback? onCompleted;
  final Widget centerWidget;
  final Widget? completedWidget;

  const AnimatedTestTimerWidget({
    super.key,
    required this.duration,
    required this.centerWidget,
    this.onCompleted,
    this.completedWidget,
  });

  @override
  State<AnimatedTestTimerWidget> createState() => _AnimatedTestTimerWidgetState();
}

class _AnimatedTestTimerWidgetState extends State<AnimatedTestTimerWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _timerController;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2000),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      lowerBound: 1,
      upperBound: 1.25,
    )..repeat(reverse: true);

    _timerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    )..forward();

    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isCompleted = true;
        });
        _rotationController.stop();
        _pulseController.stop();
        if (widget.onCompleted != null) {
          widget.onCompleted!();
        }
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          ScaleTransition(
            scale: _pulseController,
            child: Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
          ),
          // Circular timer arc
          AnimatedBuilder(
            animation: _timerController,
            builder: (_, __) {
              return CircularPercentIndicator(
                radius: 52,
                lineWidth: 2.0,
                percent: _timerController.value,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.transparent,
                progressColor: Colors.blue,
                animation: false,
              );
            },
          ),
      
          // Rotating gradient small circle
          RotationTransition(
            turns: _rotationController,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    Colors.transparent,
                    Colors.blue.withValues(alpha:0.1),
                    Colors.blue.withValues(alpha:0.3),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.3, 0.6, 0.9],
                  startAngle: 0.0,
                  endAngle: 2 * math.pi,
                  tileMode: TileMode.repeated,
                ),
              ),
            ),
          ),

          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(child: isCompleted ? widget.completedWidget ?? widget.centerWidget: widget.centerWidget,),),
        ],
      ),
    );
  }
}
