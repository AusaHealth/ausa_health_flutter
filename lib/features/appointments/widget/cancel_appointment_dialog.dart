import 'dart:ui';

import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/appointments/model/appointment.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancelAppointmentDialog extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onCancel;
  final VoidCallback onKeep;

  const CancelAppointmentDialog({
    super.key,
    required this.appointment,
    required this.onCancel,
    required this.onKeep,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Backdrop
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: const Color(0xFF0E2457).withOpacity(0.8)),
          ),
        ),

        // Close button
        Positioned(
          top: 50,
          right: 24,
          child: GestureDetector(
            onTap: onKeep,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 24),
            ),
          ),
        ),

        // Dialog content
        Center(
          child: Container(
            width: 500,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Calendar icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE5C340).withOpacity(.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    size: 32,
                    color: const Color(0xFFE38000),
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                Text(
                  'Cancel Appointment',
                  style: AppTypography.title2(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF8C00),
                  ),
                ),

                const SizedBox(height: 16),

                // Message
                Text(
                  'Are you sure you want to cancel?',
                  style: AppTypography.body(color: const Color(0xFF6B7280)),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // Appointment details card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(26),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Row(
                    children: [
                      // Time info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 21,
                                    color: const Color(0xFF6B7280),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    appointment.formattedTime,
                                    style: AppTypography.headline(
                                      color: const Color.fromARGB(
                                        255,
                                        107,
                                        107,
                                        107,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: onKeep,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.edit_outlined,
                                    size: 26,
                                    color: AppColors.primary700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            appointment.formattedDate,
                            style: AppTypography.title2(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDBEAFE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              appointment.doctorName,
                              style: AppTypography.body(
                                color: const Color(0xFF1E40AF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            'Symptoms: ${appointment.symptoms}',
                            style: AppTypography.body(
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Edit icon
                    ],
                  ),
                ),

                // Symptoms
                const SizedBox(height: 28),

                // Cancel button
                Align(
                  alignment: Alignment.centerRight,
                  child: AusaButton(
                    text: 'Cancel Appointment',
                    onPressed: () {
                      Get.back(
                        result: true,
                      ); // Return true to indicate confirmation
                    },
                    variant: ButtonVariant.primary,
                    width: 150,
                    height: 48,
                    backgroundColor: const Color(0xFFFF8C00),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
