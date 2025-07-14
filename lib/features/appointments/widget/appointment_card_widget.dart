import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/appointments/model/appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl3,
        vertical: AppSpacing.xl4,
      ),
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
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary700.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AusaIcons.clock, // or wifi/batteryFull
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        AppColors.primary700,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      appointment.formattedTime,
                      style: AppTypography.body(
                        weight: AppTypographyWeight.medium,
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
                    child: SvgPicture.asset(
                      AusaIcons.edit01,
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        AppColors.primary700,
                        BlendMode.srcIn,
                      ),
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
                    style: AppTypography.title2(
                      weight: AppTypographyWeight.medium,
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
                style: AppTypography.body(
                  color: Colors.black,
                  weight: AppTypographyWeight.medium,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xl4),
          Row(
            children: [
              Text(
                'Symptoms: ',
                style: AppTypography.body(color: Colors.grey[600]),
              ),
              Text(
                _getTruncatedSymptoms(appointment.symptoms),
                style: AppTypography.body(color: Colors.grey[600]),
              ),
              const SizedBox(width: 4),
              if (_shouldShowReadMore(appointment.symptoms))
                GestureDetector(
                  onTap: onShowFullSymptoms,
                  child: Text(
                    'read more',
                    style: AppTypography.body(color: AppColors.primary700),
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
    String iconPath;
    switch (status) {
      case AppointmentStatus.confirmed:
        textColor = const Color(0xFF2E7D32);
        text = 'Confirmed';
        iconPath = AusaIcons.checkCircle;
        break;
      case AppointmentStatus.pending:
        textColor = const Color(0xFFE65100);
        text = 'Not confirmed';
        iconPath = AusaIcons.infoCircle;
        break;
      case AppointmentStatus.cancelled:
        textColor = Colors.red;
        text = 'Cancelled';
        iconPath = AusaIcons.xCircle;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 14,
            height: 14,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTypography.body(
              color: textColor,
              weight: AppTypographyWeight.regular,
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
