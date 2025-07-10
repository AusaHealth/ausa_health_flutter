import 'package:flutter/material.dart';
import '../../../constants/constants.dart';
import '../model/health_activity.dart';
import 'condition_tag_widget.dart';

class HealthActivityCard extends StatelessWidget {
  final HealthActivity activity;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onCTA;

  const HealthActivityCard({
    super.key,
    required this.activity,
    this.onTap,
    this.onComplete,
    this.onCTA,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Activity icon
            Icon(_getActivityIcon(), size: 20, color: Colors.grey[600]),

            SizedBox(width: AppSpacing.md),

            // Activity content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    activity.title,
                    style: AppTypography.body(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  // Target range or dosage
                  if (activity.targetRange != null ||
                      activity.dosage != null) ...[
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      activity.targetRange ??
                          (activity.dosage != null
                              ? 'Dosage: ${activity.dosage}'
                              : ''),
                      style: AppTypography.callout(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],

                  // Description
                  if (activity.description != null) ...[
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      activity.description!,
                      style: AppTypography.callout(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(width: AppSpacing.md),

            // Condition tag and action button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Condition tag
                if (activity.condition != null)
                  ConditionTagWidget(condition: activity.condition!),

                if (activity.condition != null &&
                    (onComplete != null || activity.ctaText != null))
                  SizedBox(height: AppSpacing.sm),

                // CTA Button
                if (activity.ctaText != null && onCTA != null)
                  GestureDetector(
                    onTap: onCTA,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary700,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary700.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            activity.ctaText!,
                            style: AppTypography.callout(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          if (activity.ctaIcon != null) ...[
                            SizedBox(width: AppSpacing.md),
                            Icon(
                              activity.ctaIcon!,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getActivityIcon() {
    switch (activity.type) {
      case HealthActivityType.bloodPressureCheck:
        return Icons.monitor_heart_outlined;
      case HealthActivityType.bloodSugarCheck:
        return Icons.bloodtype_outlined;
      case HealthActivityType.medication:
        return Icons.medication_outlined;
      case HealthActivityType.exercise:
        return Icons.fitness_center_outlined;
      case HealthActivityType.meal:
        return Icons.restaurant_outlined;
      case HealthActivityType.vitals:
        return Icons.healing_outlined;
      case HealthActivityType.other:
        return Icons.circle_outlined;
    }
  }
}
