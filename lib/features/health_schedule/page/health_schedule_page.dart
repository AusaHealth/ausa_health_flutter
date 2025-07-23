import 'package:ausa/common/widget/app_back_header.dart';
import 'package:ausa/common/widget/app_main_container.dart';
import 'package:ausa/common/widget/app_tab_buttons.dart';
import 'package:ausa/common/widget/base_scaffold.dart';
import 'package:ausa/constants/constants.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/features/health_schedule/controller/health_schedule_controller.dart';
import 'package:ausa/features/health_schedule/widget/medication_card_widget.dart';
import 'package:ausa/features/health_schedule/widget/medication_filter_sidebar.dart';
import 'package:ausa/features/health_schedule/widget/time_filter_sidebar.dart';
import 'package:ausa/features/health_schedule/widget/time_slot_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HealthSchedulePage extends StatelessWidget {
  const HealthSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HealthScheduleController>();

    return BaseScaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                const AppBackHeader(title: 'Health Schedule'),

                // Tab buttons
                Obx(
                  () => Padding(
                    padding: EdgeInsets.only(
                      left: AppSpacing.xl6,
                      right: AppSpacing.xl6,
                      bottom: AppSpacing.xl,
                    ),
                    child: Row(
                      children: [
                        AppTabButton(
                          text: 'Routine',
                          iconPath: AusaIcons.repeat02,
                          isSelected: controller.currentTabIndex == 0,
                          onTap: () => controller.switchTab(0),
                        ),
                        AppTabButton(
                          text: 'Medication',
                          iconPath: AusaIcons.shieldPlus,
                          isSelected: controller.currentTabIndex == 1,
                          onTap: () => controller.switchTab(1),
                        ),
                      ],
                    ),
                  ),
                ),

                // Main content
                AppMainContainer(
                  child: Row(
                    children: [
                      // Left sidebar with filters
                      Obx(
                        () =>
                            controller.currentTabIndex == 0
                                ? TimeFilterSidebar(controller: controller)
                                : MedicationFilterSidebar(
                                  controller: controller,
                                ),
                      ),

                      // Main content area
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.xl2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.only(
                            left: AppSpacing.xl4,
                            right: AppSpacing.xl4,
                            top: AppSpacing.xl,
                          ),
                          // Use a Stack to keep the "Meal Times" button fixed while the list scrolls
                          child: Obx(() {
                            final bool isRoutineTab =
                                controller.currentTabIndex == 0;

                            return Stack(
                              children: [
                                // Main scrollable / tab content with top padding so it doesn't get hidden beneath the floating button.
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: isRoutineTab ? AppSpacing.xl4 : 0,
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child:
                                            isRoutineTab
                                                ? _buildTimelineContent(
                                                  controller,
                                                )
                                                : _buildMedicationContent(
                                                  controller,
                                                ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Floating "Meal Times" button – only visible on the Routine tab
                                if (isRoutineTab)
                                  Positioned(
                                    top:
                                        10, // aligns visually with the first timeline tag
                                    right: 0,
                                    child: _buildEditMealTimesButton(
                                      controller,
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditMealTimesButton(HealthScheduleController controller) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: controller.onEditMealTimes,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AusaIcons.edit02,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                  AppColors.primary700,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Text(
                'Meal Times',
                style: AppTypography.body(
                  color: AppColors.primary700,
                  weight: AppTypographyWeight.regular,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineContent(HealthScheduleController controller) {
    return Obx(() {
      final filteredSlots = controller.filteredTimeSlots;

      if (filteredSlots.isEmpty) {
        return Center(
          child: Text(
            'No activities for this time period',
            style: AppTypography.body(color: Colors.grey[600]),
          ),
        );
      }

      // Auto-scroll to current time slot after the widget is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.autoScrollToCurrentTime();
      });

      return Stack(
        children: [
          // Dashed line positioned on the left
          Positioned(
            left: 20,
            top: 2,
            bottom: 0,
            child: SizedBox(
              width: 2,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final dashHeight = 3.0;
                  final dashSpace = 6.0;
                  final dashCount =
                      (constraints.maxHeight / (dashHeight + dashSpace))
                          .floor();

                  return Column(
                    children: List.generate(dashCount, (index) {
                      return Container(
                        width: 2,
                        height: dashHeight,
                        decoration: BoxDecoration(
                          color: AppColors.primary700,
                          // borderRadius: BorderRadius.circular(1),
                        ),
                        margin: EdgeInsets.only(bottom: dashSpace),
                      );
                    }),
                  );
                },
              ),
            ),
          ),

          // Original content with ScrollController from controller
          SingleChildScrollView(
            controller: controller.timelineScrollController,
            child: Column(
              children:
                  filteredSlots.map((timeSlot) {
                    return TimeSlotWidget(
                      timeSlot: timeSlot,
                      controller: controller,
                    );
                  }).toList(),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildMedicationContent(HealthScheduleController controller) {
    return Obx(() {
      final filteredMedications = controller.filteredMedications;

      if (filteredMedications.isEmpty) {
        return Center(
          child: Text(
            'No medications for this condition',
            style: AppTypography.body(color: Colors.grey[600]),
          ),
        );
      }

      return SingleChildScrollView(
        child: Column(
          children:
              filteredMedications.map((medication) {
                return MedicationCardWidget(
                  medication: medication,
                  controller: controller,
                );
              }).toList(),
        ),
      );
    });
  }
}
