import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/appointments/controller/appointments_controller.dart';
import 'package:ausa/features/appointments/model/appointment.dart';
import 'package:ausa/features/appointments/widget/appointment_card_widget.dart';
import 'package:ausa/features/appointments/widget/no_appointments_widget.dart';
import 'package:ausa/common/widget/buttons.dart';
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
            _buildHeader(controller),
            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.appointments.isEmpty) {
                  return NoAppointmentsWidget(
                    onWifiSettings: () {
                      // TODO: Navigate to WiFi settings
                    },
                  );
                } else {
                  return _buildAppointmentsList(
                    controller.appointments,
                    controller,
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppointmentsController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black87,
                  size: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text('Scheduled appointments', style: AppTypography.headline()),
          const Spacer(),
          SecondaryButton(
            text: 'New Appointment',
            onPressed: controller.navigateToScheduleAppointment,
            icon: Icons.add,
            iconSize: 16,
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(
    List<Appointment> appointments,
    AppointmentsController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(32),
        ),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return AppointmentCardWidget(
              appointment: appointment,
              onEdit: () {
                controller.editAppointment(appointment);
              },
              onShowFullSymptoms: () {
                controller.navigateToAppointmentDetails(appointment);
              },
            );
          },
        ),
      ),
    );
  }
}
