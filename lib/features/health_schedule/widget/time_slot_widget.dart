import 'package:flutter/material.dart';
import '../../../constants/constants.dart';
import '../model/health_time_slot.dart';
import '../model/health_activity.dart';
import '../controller/health_schedule_controller.dart';
import 'health_activity_card.dart';

class TimeSlotWidget extends StatelessWidget {
  final HealthTimeSlot timeSlot;
  final HealthScheduleController controller;

  const TimeSlotWidget({
    super.key,
    required this.timeSlot,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time slot header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(
                color: AppColors.primary700.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              timeSlot.title,
              style: AppTypography.callout(
                color: AppColors.primary700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: AppSpacing.md),

          // Activities list
          Container(
            margin: EdgeInsets.only(left: 24),
            child: Column(children: _buildActivitiesWithDividers()),
          ),

          // Timeline connector line (except for last item)
          // Container(
          //   margin: EdgeInsets.only(left: AppSpacing.xl, top: AppSpacing.sm),
          //   child: CustomPaint(
          //     size: Size(2, AppSpacing.lg),
          //     painter: TimelineConnectorPainter(),
          //   ),
          // ),
        ],
      ),
    );
  }

  List<Widget> _buildActivitiesWithDividers() {
    // First filter the activities that should be shown
    final visibleActivities =
        timeSlot.activities.where((activity) {
          return controller.currentTabIndex == 0
              ? activity.type != HealthActivityType.medication
              : activity.type == HealthActivityType.medication;
        }).toList();

    List<Widget> widgets = [];

    for (int i = 0; i < visibleActivities.length; i++) {
      final activity = visibleActivities[i];

      widgets.add(
        HealthActivityCard(
          activity: activity,
          onTap: () {
            // Handle activity tap
          },
          onComplete: () {
            controller.completeActivity(activity.id);
          },
          onCTA:
              activity.ctaText != null
                  ? () => controller.onActivityCTA(activity.id)
                  : null,
        ),
      );

      // Add dashed divider between activities (not after the last one)
      if (i < visibleActivities.length - 1) {
        widgets.add(SizedBox(height: AppSpacing.sm));
        widgets.add(DashedDivider());
        widgets.add(SizedBox(height: AppSpacing.sm));
      }
    }

    return widgets;
  }
}

class DashedDivider extends StatelessWidget {
  final Color color;
  final double height;
  final double dashWidth;
  final double dashSpace;

  const DashedDivider({
    super.key,
    this.color = AppColors.primary700,
    this.height = 1,
    this.dashWidth = 3,
    this.dashSpace = 4,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: DashedLinePainter(
          color: color,
          dashWidth: dashWidth,
          dashSpace: dashSpace,
          strokeWidth: 2,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  DashedLinePainter({
    required this.color,
    required this.dashWidth,
    required this.dashSpace,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    double startX = 0;
    final y = size.height / 2;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TimelineConnectorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.primary700.withOpacity(0.3)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    // Create a dashed line effect manually
    double dashHeight = 3;
    double dashSpace = 3;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
