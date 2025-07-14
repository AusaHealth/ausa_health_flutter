import 'package:flutter/material.dart';
import '../../../constants/constants.dart';
import '../model/health_activity.dart';
import '../controller/health_schedule_controller.dart';

class MedicationCardWidget extends StatelessWidget {
  final HealthActivity medication;
  final HealthScheduleController controller;

  const MedicationCardWidget({
    super.key,
    required this.medication,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.lg),
      padding: EdgeInsets.only(
        left: AppSpacing.xl3,
        right: AppSpacing.xl3,
        top: AppSpacing.xl,
        bottom: AppSpacing.xl6,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary25.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppRadius.xl2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Medication details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Medication name
                Text(
                  medication.title,
                  style: AppTypography.body(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),

                // Prescribed by
                Text(
                  '${medication.subtitle}',
                  style: AppTypography.callout(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: AppSpacing.lg),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dosage
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F4FD),
                   borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    'Dosage: ${medication.dosage ?? '13.5 mg'}',
                    style: AppTypography.callout(
                      color: Color(0xFF165CFF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                  SizedBox(width: AppSpacing.lg),
          // Frequency pill

                Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              'Everyday',
              style: AppTypography.callout(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
            ],
          )
          
        ],
      ),
    );
  }
}
