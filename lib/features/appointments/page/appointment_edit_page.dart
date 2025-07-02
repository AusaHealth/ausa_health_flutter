import 'dart:ui';

import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/appointments/controller/appointment_edit_controller.dart';
import 'package:ausa/features/appointments/model/appointment.dart';
import 'package:ausa/features/appointments/widget/calendar_view_widget.dart';
import 'package:ausa/features/appointments/widget/cancel_appointment_dialog.dart';
import 'package:ausa/features/appointments/widget/discard_changes_dialog.dart';
import 'package:ausa/features/appointments/widget/step_indicator.dart';
import 'package:ausa/features/appointments/widget/time_slots_grid.dart';
import 'package:ausa/features/appointments/widget/voice_input_widget.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentEditPage extends StatelessWidget {
  const AppointmentEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appointment = Get.arguments as Appointment;
    final controller = Get.put(AppointmentEditController(appointment));

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              if (controller.isMonthView && controller.currentStep == 2) {
                return _buildStep2Layout(controller);
              } else {
                return _buildMainLayout(controller);
              }
            }),

            // Discard changes dialog overlay
            Obx(
              () =>
                  controller.showDiscardDialog
                      ? DiscardChangesDialog(
                        onDiscard: controller.discardChanges,
                        onKeepEditing: controller.hideDiscardChangesDialog,
                      )
                      : const SizedBox.shrink(),
            ),

            // Cancel appointment dialog overlay
            Obx(
              () =>
                  controller.showCancelDialog
                      ? CancelAppointmentDialog(
                        appointment: controller.appointment,
                        onCancel: controller.cancelAppointment,
                        onKeep: controller.hideCancelAppointmentDialog,
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainLayout(AppointmentEditController controller) {
    return Column(
      children: [
        _buildHeader(controller),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: const Color.fromRGBO(222, 222, 222, 0.5),
                backgroundBlendMode: BlendMode.srcOver,
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: _buildLeftCard(controller)),
                      const SizedBox(width: 24),
                      Expanded(flex: 2, child: _buildRightCard(controller)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2Layout(AppointmentEditController controller) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              StepIndicator(
                currentStep: controller.currentStep,
                onBackPressed: controller.handleBackPressed,
              ),
              const Spacer(),
              SecondaryButton(
                text: 'Cancel this appointment',
                onPressed: controller.showCancelAppointmentDialog,
                icon: Icons.cancel_outlined,
                iconSize: 16,
                height: 40,
                textColor: const Color(0xFFFF8C00),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(46),
              ),
              width: double.infinity,
              height: double.infinity,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(36),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 350,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(42),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          Text(
                            controller.selectedTimeSlot?.dateTime
                                    .toString()
                                    .split(' ')[0] ??
                                '',
                            style: AppTypography.body(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 1,
                            height: 16,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            controller.selectedTimeSlot?.formattedTime ?? '',
                            style: AppTypography.body(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          SecondaryButton(
                            text: 'Change',
                            onPressed: controller.goBackToStep1,
                            iconSize: 16,
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Any symptoms you want to share? (Optional)',
                      style: AppTypography.body(),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  16,
                                  16,
                                  0,
                                ),
                                child: Obx(
                                  () => TextField(
                                    controller: TextEditingController(
                                      text: controller.symptomsText,
                                    ),
                                    onChanged: controller.updateSymptomsText,
                                    maxLines: null,
                                    expands: true,
                                    textAlignVertical: TextAlignVertical.top,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText:
                                          'Optional: Describe any symptoms...',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: AppTypography.body(),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Obx(
                                () => VoiceInputWidget(
                                  isRecording: controller.isRecording,
                                  onToggleRecording: controller.startRecording,
                                  onClear: controller.clearSymptomsText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Obx(() => _buildFinishButton(controller)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(AppointmentEditController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Obx(() {
        if (controller.isMonthView) {
          return Row(
            children: [
              StepIndicator(
                currentStep: controller.currentStep,
                onBackPressed: controller.handleBackPressed,
              ),
              const Spacer(),
              SecondaryButton(
                text: 'Cancel this appointment',
                onPressed: controller.showCancelAppointmentDialog,
                icon: Icons.cancel_outlined,
                iconSize: 16,
                height: 40,
                textColor: const Color(0xFFFF8C00),
              ),
            ],
          );
        } else {
          return Row(
            children: [
              GestureDetector(
                onTap: controller.handleBackPressed,
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
              Text('Edit Appointment', style: AppTypography.headline()),
              const Spacer(),
              SecondaryButton(
                text: 'Cancel this appointment',
                onPressed: controller.showCancelAppointmentDialog,
                icon: Icons.cancel_outlined,
                iconSize: 16,
                height: 40,
                textColor: const Color(0xFFFF8C00),
              ),
            ],
          );
        }
      }),
    );
  }

  Widget _buildLeftCard(AppointmentEditController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
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

  Widget _buildRightCard(AppointmentEditController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
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
          return Column(
            children: [
              Expanded(
                child: TimeSlotsGrid(
                  timeSlots: controller.availableTimeSlots,
                  selectedTimeSlot: controller.selectedTimeSlot,
                  onTimeSlotSelected: controller.selectTimeSlot,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: PrimaryButton(
                  text: 'Enter Symptoms',
                  onPressed:
                      controller.selectedTimeSlot != null
                          ? controller.goToStep2
                          : null,
                  isEnabled: controller.selectedTimeSlot != null,
                  width: double.infinity,
                  height: 56,
                  borderRadius: 32,
                ),
              ),
            ],
          );
        } else {
          return _buildSymptomsCard(controller);
        }
      }),
    );
  }

  Widget _buildDateTimeSelectionCard(AppointmentEditController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Select Date', style: AppTypography.body()),
              TertiaryButton(
                text: 'Month View',
                onPressed: controller.toggleMonthView,
                icon: Icons.calendar_view_month,
                textColor: AppColors.primaryColor,
                iconColor: AppColors.primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildWeekView(controller),
          const SizedBox(height: 20),
          Text('Select Time Slot', style: AppTypography.body()),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(
              () => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 47,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 15,
                ),
                itemCount: controller.availableTimeSlots.length,
                itemBuilder: (context, index) {
                  final timeSlot = controller.availableTimeSlots[index];
                  final isSelected =
                      controller.selectedTimeSlot?.id == timeSlot.id;

                  return SelectionButton(
                    key: ValueKey('${timeSlot.id}_$isSelected'),
                    text: timeSlot.formattedTime,
                    initialSelected: isSelected,
                    isEnabled: timeSlot.isAvailable,
                    onSelectionChanged: (selected) {
                      if (selected) {
                        controller.selectTimeSlot(timeSlot);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekView(AppointmentEditController controller) {
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
      spacing: 20,
      children:
          weekDates.map((dateInfo) {
            final date = dateInfo['date'] as DateTime;
            final isSelected = _isSameDay(date, controller.selectedDate);

            return Expanded(
              child: GestureDetector(
                onTap: () => controller.selectDate(date),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? const Color(0xFF1B1B3B)
                            : const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 4,
                        blurRadius: 7,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        dateInfo['month'] as String,
                        style: AppTypography.callout(
                          color:
                              isSelected
                                  ? Colors.white
                                  : const Color(0xFF666666),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateInfo['day'] as String,
                        style: AppTypography.headline(
                          color: isSelected ? Colors.white : Colors.black,
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

  Widget _buildSymptomsCard(AppointmentEditController controller) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Obx(
                        () => TextField(
                          controller: TextEditingController(
                            text: controller.symptomsText,
                          ),
                          onChanged: controller.updateSymptomsText,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Optional: Describe any symptoms...',
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: AppTypography.body(),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Obx(
                      () => VoiceInputWidget(
                        isRecording: controller.isRecording,
                        onToggleRecording: controller.startRecording,
                        onClear: controller.clearSymptomsText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(child: Obx(() => _buildFinishButton(controller))),
        ],
      ),
    );
  }

  Widget _buildFinishButton(AppointmentEditController controller) {
    return PrimaryButton(
      text: 'Update',
      onPressed: controller.canFinish ? controller.updateAppointment : null,
      isLoading: controller.isLoading,
      isEnabled: controller.canFinish,
      width: 100,
      height: 56,
      borderRadius: 32,
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
