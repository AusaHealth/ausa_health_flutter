import 'dart:ui';

import 'package:ausa/common/widget/app_back_header.dart';
import 'package:ausa/common/widget/app_main_container.dart';
import 'package:ausa/common/widget/app_stepper_widget.dart';
import 'package:ausa/common/widget/base_scaffold.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/constants.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/appointments/controller/appointment_scheduling_controller.dart';
import 'package:ausa/features/appointments/widget/calendar_view_widget.dart';
import 'package:ausa/features/appointments/widget/success_popup.dart';
import 'package:ausa/features/appointments/widget/time_slots_grid.dart';
import 'package:ausa/features/appointments/widget/voice_input_widget.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ausa/routes/app_routes.dart';

class AppointmentSchedulingPage extends StatelessWidget {
  const AppointmentSchedulingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppointmentSchedulingController>();

    return BaseScaffold(
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

  Widget _buildMainLayout(AppointmentSchedulingController controller) {
    return Column(
      children: [
        // _buildHeader(controller),
        Obx(
          () => AppBackHeader(
            title: 'Connect with care team',
            stepperWidget:
                controller.isMonthView
                    ? AppStepperWidget(
                      currentStep: controller.currentStep,
                      totalSteps: 2,
                    )
                    : null,
            actionButtons: [
              AusaButton(
                text: 'Scheduled appointments',
                onPressed: () => Get.toNamed(AppRoutes.appointmentScheduled),
                variant: ButtonVariant.secondary,
                leadingIcon: SvgPicture.asset(
                  AusaIcons.calendarCheck01,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    AppColors.primary700,
                    BlendMode.srcIn,
                  ),
                ),
                borderColor: AppColors.white,
                size: ButtonSize.md,
              ),
            ],
          ),
        ),
        AppMainContainer(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 4, child: _buildLeftCard(controller)),
              SizedBox(width: AppSpacing.lg),
              Expanded(flex: 2, child: _buildRightCard(controller)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep2Layout(AppointmentSchedulingController controller) {
    return Column(
      children: [
        AppBackHeader(
          title: 'Connect with care team',
          stepperWidget: AppStepperWidget(
            currentStep: controller.currentStep,
            totalSteps: 2,
          ),
          onBackPressed: controller.handleBackPressed,
        ),

        AppMainContainer(
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
                        controller.selectedTimeSlot?.dateTime.toString().split(
                              ' ',
                            )[0] ??
                            '',
                        style: AppTypography.body(fontWeight: FontWeight.w600),
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
                        style: AppTypography.body(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      AusaButton(
                        text: 'Change',
                        onPressed: controller.goBackToStep1,
                        variant: ButtonVariant.tertiary,
                        height: 45,
                      ),
                      const SizedBox(width: 20),
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
                  child: Obx(
                    () => AusaButton(
                      text: 'Finish',
                      onPressed:
                          controller.canFinish
                              ? controller.scheduleAppointment
                              : null,
                      isLoading: controller.isLoading,
                      isEnabled: controller.canFinish,
                      variant: ButtonVariant.primary,
                      width: 100,
                      height: 50,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeftCard(AppointmentSchedulingController controller) {
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

  Widget _buildRightCard(AppointmentSchedulingController controller) {
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
                padding: EdgeInsets.only(
                  bottom: AppSpacing.xl4,
                  top: AppSpacing.xl2,
                ),
                child: Center(
                  child: AusaButton(
                    text: 'Enter Symptoms',
                    onPressed:
                        controller.selectedTimeSlot != null
                            ? controller.goToStep2
                            : null,
                    isEnabled: controller.selectedTimeSlot != null,
                    variant: ButtonVariant.primary,
                    leadingIcon: SvgPicture.asset(
                      AusaIcons.keyboard02,
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        controller.selectedTimeSlot != null
                            ? Colors.white
                            : Colors.grey[600]!,
                        BlendMode.srcIn,
                      ),
                    ),
                    trailingIcon: SvgPicture.asset(
                      AusaIcons.arrowRight,
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        controller.selectedTimeSlot != null
                            ? Colors.white
                            : Colors.grey[600]!,
                        BlendMode.srcIn,
                      ),
                    ),
                    height: 56,
                  ),
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

  Widget _buildDateTimeSelectionCard(
    AppointmentSchedulingController controller,
  ) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40, top: 28, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Select Date', style: AppTypography.body()),
              AusaButton(
                text: 'Month View',
                onPressed: controller.toggleMonthView,
                variant: ButtonVariant.tertiary,
                leadingIcon: SvgPicture.asset(
                  AusaIcons.calendar,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    AppColors.primary700,
                    BlendMode.srcIn,
                  ),
                ),
                textColor: AppColors.primary700,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildWeekView(controller),
          const SizedBox(height: 20),
          Text('Select Time Slot', style: AppTypography.body()),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(
              () => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 47,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 20,
                ),
                itemCount: controller.availableTimeSlots.length,
                itemBuilder: (context, index) {
                  final timeSlot = controller.availableTimeSlots[index];
                  final isSelected =
                      controller.selectedTimeSlot?.id == timeSlot.id;

                  return AusaButton(
                    key: ValueKey('${timeSlot.id}_$isSelected'),
                    text: timeSlot.formattedTime,
                    backgroundColor:
                        isSelected ? AppColors.black : AppColors.primary25,
                    borderColor: AppColors.primary25,
                    textColor:
                        isSelected ? AppColors.white : AppColors.primary700,
                    variant:
                        isSelected
                            ? ButtonVariant.primary
                            : ButtonVariant.secondary,
                    isEnabled: timeSlot.isAvailable,
                    onPressed:
                        timeSlot.isAvailable
                            ? () => controller.selectTimeSlot(timeSlot)
                            : null,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekView(AppointmentSchedulingController controller) {
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          weekDates.map((dateInfo) {
            final date = dateInfo['date'] as DateTime;
            final isSelected = _isSameDay(date, controller.selectedDate);

            return GestureDetector(
              onTap: () => controller.selectDate(date),
              child: Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? const Color(0xFF1B1B3B)
                          : const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dateInfo['month'] as String,
                      style: AppTypography.callout(
                        weight: AppTypographyWeight.medium,
                        color:
                            isSelected ? Colors.white : const Color(0xFF666666),
                      ),
                    ),
                    Text(
                      dateInfo['day'] as String,
                      style: AppTypography.title2(
                        weight: AppTypographyWeight.medium,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildSymptomsCard(AppointmentSchedulingController controller) {
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
          Padding(
            padding: EdgeInsets.only(
              bottom: AppSpacing.xl4,
              top: AppSpacing.xl2,
            ),
            child: Center(
              child: Obx(
                () => AusaButton(
                  text: 'Finish',
                  onPressed:
                      controller.canFinish
                          ? controller.scheduleAppointment
                          : null,
                  isLoading: controller.isLoading,
                  isEnabled: controller.canFinish,
                  variant: ButtonVariant.primary,
                  height: 50,
                  width: 100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
