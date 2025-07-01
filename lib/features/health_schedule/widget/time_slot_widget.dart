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
              // color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              timeSlot.title,
              style: AppTypography.callout(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: AppSpacing.md),

          // Activities list
          Container(
            margin: EdgeInsets.only(left: AppSpacing.xl5),
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              children:
                  timeSlot.activities.map((activity) {
                    // Filter activities based on current tab
                    final shouldShow =
                        controller.currentTabIndex.value == 0
                            ? activity.type != HealthActivityType.medication
                            : activity.type == HealthActivityType.medication;

                    if (!shouldShow) return const SizedBox.shrink();

                    return HealthActivityCard(
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
                    );
                  }).toList(),
            ),
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
}

class TimelineConnectorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.primaryColor.withOpacity(0.3)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    // Create a dashed line effect manually
    double dashHeight = 5;
    double dashSpace = 5;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
