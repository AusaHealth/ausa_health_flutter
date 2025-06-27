import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/appointments/controller/appointments_controller.dart';
import 'package:ausa/features/appointments/model/appointment.dart';
import 'package:ausa/features/appointments/widget/appointment_card_widget.dart';
import 'package:ausa/features/appointments/widget/calendar_view_widget.dart';
import 'package:ausa/features/appointments/widget/no_appointments_widget.dart';
import 'package:ausa/features/appointments/widget/step_indicator.dart';
import 'package:ausa/features/appointments/widget/success_popup.dart';
import 'package:ausa/features/appointments/widget/time_slots_grid.dart';
import 'package:ausa/features/appointments/widget/voice_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentSchedulingPage extends StatelessWidget {
  const AppointmentSchedulingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppointmentsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              if (controller.isViewingAppointments) {
                // Show appointments list view
                return _buildAppointmentsView(controller);
              } else if (controller.isMonthView &&
                  controller.currentStep == 2) {
                // Step 2: Full screen symptoms entry in month view
                return _buildStep2Layout(controller);
              } else {
                // Normal layout (single step or month view step 1)
                return _buildMainLayout(controller);
              }
            }),

            // Success popup overlay
            Obx(
              () =>
                  controller.showSuccessPopup
                      ? SuccessPopup(onClose: controller.closeSuccessPopup)
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsView(AppointmentsController controller) {
    return Column(
      children: [
        // Header for appointments view
        _buildAppointmentsHeader(controller),

        // Appointments content
        Expanded(
          child: Obx(() {
            if (controller.appointments.isEmpty) {
              return NoAppointmentsWidget(
                onWifiSettings: () {
                  // TODO: Navigate to WiFi settings
                },
              );
            } else {
              return _buildAppointmentsList(controller.appointments);
            }
          }),
        ),
      ],
    );
  }

  Widget _buildAppointmentsHeader(AppointmentsController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: controller.goBackToScheduling,
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
          return AppointmentCardWidget(
            appointment: appointment,
            onEdit: () {
              // TODO: Edit appointment
            },
            onShowFullSymptoms: () {
              // TODO: Show full symptoms
            },
          );
        },
      ),
    );
  }

  Widget _buildMainLayout(AppointmentsController controller) {
    return Column(
      children: [
        // Header
        _buildHeader(controller),

        // Main content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left card
                Expanded(flex: 1, child: _buildLeftCard(controller)),

                const SizedBox(width: 24),

                // Right card
                Expanded(flex: 1, child: _buildRightCard(controller)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2Layout(AppointmentsController controller) {
    return Column(
      children: [
        // Step indicator header
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              StepIndicator(currentStep: controller.currentStep),
              const Spacer(),
              GestureDetector(
                onTap: controller.toggleViewMode,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Scheduled Appointments',
                        style: AppTypography.callout(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Selected date/time display
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(
                controller.selectedTimeSlot?.dateTime.toString().split(
                      ' ',
                    )[0] ??
                    '',
                style: AppTypography.headline(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              Container(width: 1, height: 16, color: Colors.grey[300]),
              const SizedBox(width: 8),
              Text(
                controller.selectedTimeSlot?.formattedTime ?? '',
                style: AppTypography.headline(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              GestureDetector(
                onTap: controller.goBackToStep1,
                child: Text(
                  'Change',
                  style: AppTypography.body(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Full screen symptoms entry
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Any symptoms you want to share?',
                  style: AppTypography.headline(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 24),

                // Text input area
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Obx(
                      () => TextField(
                        controller: TextEditingController(
                          text: controller.symptomsText,
                        ),
                        onChanged: controller.updateSymptomsText,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type...',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        style: AppTypography.body(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Voice input and finish button
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => VoiceInputWidget(
                          isRecording: controller.isRecording,
                          onToggleRecording: controller.startRecording,
                          onClear: controller.clearSymptomsText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Obx(() => _buildFlexibleFinishButton(controller)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(AppointmentsController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Obx(() {
        if (controller.isMonthView) {
          return StepIndicator(currentStep: controller.currentStep);
        } else {
          return Row(
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
                'Connect with care team',
                style: AppTypography.title1(fontWeight: FontWeight.w600),
              ),

              const Spacer(),

              // Scheduled appointments button
              GestureDetector(
                onTap: controller.toggleViewMode,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Scheduled Appointments',
                        style: AppTypography.callout(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  Widget _buildLeftCard(AppointmentsController controller) {
    return Container(
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
      child: Obx(() {
        if (controller.isMonthView) {
          return CalendarViewWidget(
            selectedDate: controller.selectedDate,
            onDateSelected: controller.selectDate,
            onBackToWeekView: controller.toggleMonthView,
          );
        } else {
          return _buildDateTimeSelectionCard(controller);
        }
      }),
    );
  }

  Widget _buildRightCard(AppointmentsController controller) {
    return Container(
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
      child: Obx(() {
        if (controller.isMonthView) {
          return TimeSlotsGrid(
            timeSlots: controller.availableTimeSlots,
            selectedTimeSlot: controller.selectedTimeSlot,
            onTimeSlotSelected: (timeSlot) {
              controller.selectTimeSlot(timeSlot);
              // Auto navigate to step 2 after selecting time slot
              Future.delayed(const Duration(milliseconds: 300), () {
                controller.goToStep2();
              });
            },
          );
        } else {
          return _buildSymptomsCard(controller);
        }
      }),
    );
  }

  Widget _buildDateTimeSelectionCard(AppointmentsController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with month view toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Date',
                style: AppTypography.headline(fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: controller.toggleMonthView,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_view_month,
                        size: 16,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Month View',
                        style: AppTypography.callout(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Week view dates
          _buildWeekView(controller),

          const SizedBox(height: 32),

          Text(
            'Select Time Slot',
            style: AppTypography.headline(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          // Time slots in normal view
          Expanded(
            child: Obx(
              () => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: controller.availableTimeSlots.length,
                itemBuilder: (context, index) {
                  final timeSlot = controller.availableTimeSlots[index];
                  final isSelected =
                      controller.selectedTimeSlot?.id == timeSlot.id;

                  return GestureDetector(
                    onTap:
                        timeSlot.isAvailable
                            ? () => controller.selectTimeSlot(timeSlot)
                            : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? const Color(0xFF1B1B3B)
                                : timeSlot.isAvailable
                                ? AppColors.primaryColor.withOpacity(0.1)
                                : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              isSelected
                                  ? const Color(0xFF1B1B3B)
                                  : timeSlot.isAvailable
                                  ? AppColors.primaryColor.withOpacity(0.3)
                                  : Colors.grey[300]!,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          timeSlot.formattedTime,
                          style: AppTypography.callout(
                            color:
                                isSelected
                                    ? Colors.white
                                    : timeSlot.isAvailable
                                    ? AppColors.primaryColor
                                    : Colors.grey[400],
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekView(AppointmentsController controller) {
    final today = DateTime.now();
    final weekDates = List.generate(6, (index) {
      final date = today.add(Duration(days: index));
      final monthNames = ['MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG'];
      return {
        'month': monthNames[date.month - 3 > 0 ? date.month - 3 : 0],
        'day': date.day.toString(),
        'date': date,
      };
    });

    return Row(
      children:
          weekDates.map((dateInfo) {
            final date = dateInfo['date'] as DateTime;
            final isSelected = _isSameDay(date, controller.selectedDate);

            return Expanded(
              child: GestureDetector(
                onTap: () => controller.selectDate(date),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? const Color(0xFF1B1B3B)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          isSelected
                              ? const Color(0xFF1B1B3B)
                              : Colors.grey[300]!,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        dateInfo['month'] as String,
                        style: AppTypography.callout(
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateInfo['day'] as String,
                        style: AppTypography.title2(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildSymptomsCard(AppointmentsController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Anything you want to share?',
            style: AppTypography.headline(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),

          const SizedBox(height: 24),

          // Text input area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Obx(
                () => TextField(
                  controller: TextEditingController(
                    text: controller.symptomsText,
                  ),
                  onChanged: controller.updateSymptomsText,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: AppTypography.body(),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Voice input
          Obx(
            () => VoiceInputWidget(
              isRecording: controller.isRecording,
              onToggleRecording: controller.startRecording,
              onClear: controller.clearSymptomsText,
            ),
          ),

          const SizedBox(height: 24),

          // Finish button
          Obx(() => _buildFinishButton(controller)),
        ],
      ),
    );
  }

  Widget _buildFinishButton(AppointmentsController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.canFinish ? controller.scheduleAppointment : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              controller.canFinish ? AppColors.primaryColor : Colors.grey[300],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child:
            controller.isLoading
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Text(
                  'Finish',
                  style: AppTypography.body(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
      ),
    );
  }

  Widget _buildFlexibleFinishButton(AppointmentsController controller) {
    return ElevatedButton(
      onPressed: controller.canFinish ? controller.scheduleAppointment : null,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            controller.canFinish ? AppColors.primaryColor : Colors.grey[300],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child:
          controller.isLoading
              ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
              : Text(
                'Finish',
                style: AppTypography.body(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
