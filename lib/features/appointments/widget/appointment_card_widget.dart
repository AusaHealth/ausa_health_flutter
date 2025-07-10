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
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(52),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top section with time and status/edit button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time display with icon
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary700.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 20,
                      color: AppColors.primary700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      appointment.formattedTime,
                      style: AppTypography.body(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary700,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              if (onEdit != null)
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.edit_outlined,
                      color: AppColors.primary700,
                      size: 24,
                    ),
                  ),
                ),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    appointment.formattedDate,
                    style: AppTypography.headline(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  _buildStatusChip(appointment.status),
                ],
              ),

              const SizedBox(height: 6),

              // Doctor info
              Text(
                'with ${appointment.doctorName}',
                style: AppTypography.headline(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          Row(
            children: [
              Text(
                'Symptoms: ',
                style: AppTypography.body(
                  color: Colors.grey[600],
                ),
              ),
              Text(
                _getTruncatedSymptoms(appointment.symptoms),
                style: AppTypography.body(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 4),
              if (_shouldShowReadMore(appointment.symptoms))
                GestureDetector(
                  onTap: onShowFullSymptoms,
                  child: Text(
                    'read more',
                    style: AppTypography.body(
                      color: AppColors.primary700,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(AppointmentStatus status) {
    Color textColor;
    String text;
    switch (status) {
      case AppointmentStatus.confirmed:
        textColor = const Color(0xFF2E7D32);
        text = 'Appointment Confirmed';
        break;
      case AppointmentStatus.pending:
        textColor = const Color(0xFFE65100);
        text = 'Not confirmed';
        break;
      case AppointmentStatus.cancelled:
        textColor = Colors.red;
        text = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
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

  String _getTruncatedSymptoms(String symptoms) {
    const maxLength = 21; // Adjust based on your needs
    if (symptoms.length <= maxLength) {
      return symptoms;
    }
    return symptoms.substring(0, maxLength);
  }

  bool _shouldShowReadMore(String symptoms) {
    const maxLength = 21;
    return symptoms.length > maxLength;
  }
}
