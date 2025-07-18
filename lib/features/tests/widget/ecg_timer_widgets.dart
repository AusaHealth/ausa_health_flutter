import 'dart:math' as math;
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:ausa/constants/color.dart';

/// Simple timer for 2-lead ECG with grey background container
class Ecg2LeadTimerWidget extends StatefulWidget {
  final int duration; // in seconds
  final VoidCallback? onCompleted;
  final Widget? completedWidget;

  const Ecg2LeadTimerWidget({
    super.key,
    required this.duration,
    this.onCompleted,
    this.completedWidget,
  });

  @override
  State<Ecg2LeadTimerWidget> createState() => _Ecg2LeadTimerWidgetState();
}

class _Ecg2LeadTimerWidgetState extends State<Ecg2LeadTimerWidget>
    with TickerProviderStateMixin {
  late AnimationController _timerController;
  late AnimationController _waveController;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();

    _timerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    )..forward();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isCompleted = true;
        });
        _waveController.stop();
        if (widget.onCompleted != null) {
          widget.onCompleted!();
        }
      }
    });
  }

  @override
  void dispose() {
    _timerController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        // ECG Wave Animation
        if (!isCompleted)
          AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(200, 100),
                painter: EcgWavePainter(_waveController.value),
              );
            },
          ),

        // Timer Circle
        Positioned(
          top: 5,
          right: 27,
          child: Container(
            width: 215,
            height: 139,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _timerController,
              builder: (_, __) {
                return CircularPercentIndicator(
                  radius: 50,
                  lineWidth: 6.0,
                  percent: _timerController.value,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: AppColors.white,
                  progressColor: AppColors.primary500,
                  animation: false,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(widget.duration * (1 - _timerController.value)).round()}',
                        style: AppTypography.body(
                          weight: AppTypographyWeight.semibold,
                          color: AppColors.primary500,
                        ),
                      ),
                      Text(
                        'sec',
                        style: AppTypography.callout(
                          weight: AppTypographyWeight.medium,
                          color: AppColors.primary500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        // Completion indicator
        if (isCompleted)
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child:
                widget.completedWidget ??
                const Icon(Icons.check, color: Colors.white, size: 50),
          ),
      ],
    );
  }
}

/// Complex timer for 6-lead ECG with ECG graph, lead placement, and small timer
class Ecg6LeadTimerWidget extends StatefulWidget {
  final int duration; // in seconds
  final VoidCallback? onCompleted;
  final Widget? completedWidget;
  final int currentStep; // 0-2 for the 3 steps

  const Ecg6LeadTimerWidget({
    super.key,
    required this.duration,
    required this.currentStep,
    this.onCompleted,
    this.completedWidget,
  });

  @override
  State<Ecg6LeadTimerWidget> createState() => _Ecg6LeadTimerWidgetState();
}

class _Ecg6LeadTimerWidgetState extends State<Ecg6LeadTimerWidget>
    with TickerProviderStateMixin {
  late AnimationController _timerController;
  late AnimationController _waveController;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();

    _timerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    )..forward();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isCompleted = true;
        });
        _waveController.stop();
        if (widget.onCompleted != null) {
          widget.onCompleted!();
        }
      }
    });
  }

  @override
  void dispose() {
    _timerController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // ECG Graph Section and Timer in same row (3:2 ratio)
          Expanded(
            flex: 3,
            child: Row(
              children: [
                // ECG Graph Section
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Stack(
                      children: [
                        // Grid background
                        CustomPaint(
                          size: const Size(double.infinity, double.infinity),
                          painter: GridPainter(),
                        ),

                        // ECG Wave
                        if (!isCompleted)
                          AnimatedBuilder(
                            animation: _waveController,
                            builder: (context, child) {
                              return CustomPaint(
                                size: const Size(
                                  double.infinity,
                                  double.infinity,
                                ),
                                painter: EcgWavePainter(_waveController.value),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),

                // Small Timer
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         AnimatedBuilder(
                        animation: _timerController,
                        builder: (_, __) {
                          return CircularPercentIndicator(
                            radius: 25,
                            lineWidth: 3.0,
                            percent: _timerController.value,
                            circularStrokeCap: CircularStrokeCap.round,
                            backgroundColor: const Color.fromARGB(
                              36,
                              234,
                              236,
                              240,
                            ),
                            progressColor: const Color.fromARGB(
                              255,
                              255,
                              255,
                              255,
                            ),
                            animation: false,
                          );
                        },
                      ),
                      SizedBox(height: 10),
                        Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${(widget.duration * (1 - _timerController.value)).round()}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'sec',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: const Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                              ],
                            ),
                      ],
                     
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lead Placement Diagram
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: CustomPaint(
                  size: const Size(double.infinity, double.infinity),
                  painter: LeadPlacementPainter(widget.currentStep),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for ECG wave animation
class EcgWavePainter extends CustomPainter {
  final double animationValue;

  EcgWavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color.fromARGB(255, 255, 255, 255)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

    final path = Path();
    final width = size.width;
    final height = size.height;
    final centerY = height / 2;

    // Create ECG-like wave pattern
    for (double x = 0; x < width; x += 2) {
      final normalizedX = x / width;
      final waveX = (normalizedX + animationValue) % 1.0;

      double y;
      if (waveX < 0.1) {
        // P wave
        y = centerY - 10 * math.sin(waveX * 10 * math.pi);
      } else if (waveX < 0.2) {
        // QRS complex
        y = centerY + 20 * math.sin((waveX - 0.1) * 20 * math.pi);
      } else if (waveX < 0.3) {
        // T wave
        y = centerY - 8 * math.sin((waveX - 0.2) * 10 * math.pi);
      } else {
        // Baseline
        y = centerY;
      }

      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(EcgWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// Custom painter for grid background
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey[300]!
          ..strokeWidth = 0.5;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += 10) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += 10) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for lead placement diagram
class LeadPlacementPainter extends CustomPainter {
  final int currentStep;

  LeadPlacementPainter(this.currentStep);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey[400]!
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

    final leadPaint =
        Paint()
          ..color = const Color.fromARGB(255, 255, 255, 255)
          ..style = PaintingStyle.fill;

    // Draw simplified torso outline
    final torsoPath = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Head
    torsoPath.addOval(
      Rect.fromCenter(
        center: Offset(centerX, centerY - 25),
        width: 20,
        height: 20,
      ),
    );

    // Torso
    torsoPath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, centerY + 5),
          width: 40,
          height: 40,
        ),
        const Radius.circular(8),
      ),
    );

    canvas.drawPath(torsoPath, paint);

    // Draw lead positions based on current step
    final leads = _getLeadPositions(centerX, centerY);

    for (int i = 0; i < leads.length; i++) {
      final lead = leads[i];
      final isActive = i <= currentStep;

      canvas.drawCircle(lead, 4, isActive ? leadPaint : paint);
    }
  }

  List<Offset> _getLeadPositions(double centerX, double centerY) {
    return [
      Offset(centerX - 15, centerY - 15), // Left shoulder
      Offset(centerX + 15, centerY - 15), // Right shoulder
      Offset(centerX, centerY + 15), // Lower abdomen
    ];
  }

  @override
  bool shouldRepaint(LeadPlacementPainter oldDelegate) {
    return oldDelegate.currentStep != currentStep;
  }
}
