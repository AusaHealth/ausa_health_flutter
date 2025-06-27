import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/appointments/controller/appointments_controller.dart';
import 'package:ausa/features/appointments/model/appointment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduledAppointmentsPage extends StatelessWidget {
  const ScheduledAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppointmentsController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Content
            Expanded(
              child: Obx(() {
                if (controller.appointments.isEmpty) {
                  return _buildNoAppointmentsView();
                } else {
                  return _buildAppointmentsList(controller.appointments);
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(Get.context!).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black87,
                size: 24,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Title
          Text(
            'Scheduled appointments',
            style: AppTypography.title1(fontWeight: FontWeight.w600),
          ),

          const Spacer(),

          // WiFi settings link (when offline)
          Text(
            'Offline, but scheduled appointments? Check ',
            style: AppTypography.callout(
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
          GestureDetector(
            onTap: () {
              // TODO: Navigate to WiFi settings
            },
            child: Text(
              'W-Fi Settings',
              style: AppTypography.callout(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoAppointmentsView() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),

            Text(
              'No scheduled appointments found.',
              style: AppTypography.title2(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Text(
              'You\'re offline, but have scheduled appointments?\nGet online to sync.',
              style: AppTypography.body(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to WiFi settings
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Wi-Fi Settings',
                    style: AppTypography.body(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList(List<Appointment> appointments) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
        ),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return _buildAppointmentCard(appointment);
        },
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
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
              GestureDetector(
                onTap: () {
                  // TODO: Edit appointment
                },
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
          GestureDetector(
            onTap: () {
              // TODO: Show full symptoms
            },
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
