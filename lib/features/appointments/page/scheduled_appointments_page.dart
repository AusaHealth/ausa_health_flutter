import 'package:ausa/common/widget/app_back_header.dart';
import 'package:ausa/common/widget/app_main_container.dart';
import 'package:ausa/common/widget/base_scaffold.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/appointments/controller/appointments_controller.dart';
import 'package:ausa/features/appointments/model/appointment.dart';
import 'package:ausa/features/appointments/widget/appointment_card_widget.dart';
import 'package:ausa/features/appointments/widget/no_appointments_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ScheduledAppointmentsPage extends StatelessWidget {
  const ScheduledAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppointmentsController>();

    return BaseScaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Column(
          children: [
            AppBackHeader(
              title: 'Scheduled appointments',
              actionButtons: [
                AusaButton(
                  text: 'Schedule an Appointment',
                  onPressed: controller.navigateToScheduleAppointment,
                  variant: ButtonVariant.secondary,
                  borderColor: AppColors.white,
                  leadingIcon: SvgPicture.asset(
                    AusaIcons.calendar,
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      AppColors.primary700,
                      BlendMode.srcIn,
                    ),
                  ),
                  size: ButtonSize.md,
                ),
              ],
            ),
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
          AusaButton(
            text: 'New Appointment',
            onPressed: controller.navigateToScheduleAppointment,
            variant: ButtonVariant.secondary,
            leadingIcon: Icon(Icons.add, size: 16, color: AppColors.primary700),
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
    return AppMainContainer(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.2,
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
    );
  }
}
