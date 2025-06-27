import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/appointments/model/appointment.dart';
import 'package:flutter/material.dart';

class AppointmentCardWidget extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback? onEdit;
  final VoidCallback? onShowFullSymptoms;

  const AppointmentCardWidget({
    super.key,
    required this.appointment,
    this.onEdit,
    this.onShowFullSymptoms,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status and edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusChip(appointment.status),
              if (onEdit != null)
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.edit, color: Colors.grey[600], size: 16),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Date and time
          Text(
            appointment.formattedDate,
            style: AppTypography.headline(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 4),

          Text(
            appointment.formattedTime,
            style: AppTypography.headline(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 12),

          // Doctor info
          Text(
            'With ${appointment.doctorName}',
            style: AppTypography.body(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 12),

          // Symptoms
          Text(
            'Symptoms',
            style: AppTypography.callout(
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          Expanded(
            child: Text(
              appointment.symptoms,
              style: AppTypography.body(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 8),

          // Read more link
          if (onShowFullSymptoms != null)
            GestureDetector(
              onTap: onShowFullSymptoms,
              child: Text(
                'Read more',
                style: AppTypography.callout(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(AppointmentStatus status) {
    Color chipColor;
    Color textColor;
    String text;
    IconData icon;

    switch (status) {
      case AppointmentStatus.confirmed:
        chipColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        text = 'Appointment Confirmed';
        icon = Icons.check_circle;
        break;
      case AppointmentStatus.pending:
        chipColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        text = 'Not confirmed';
        icon = Icons.access_time;
        break;
      case AppointmentStatus.cancelled:
        chipColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        text = 'Cancelled';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTypography.callout(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
