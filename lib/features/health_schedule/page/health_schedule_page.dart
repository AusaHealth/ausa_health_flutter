import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/constants.dart';
import '../../../common/widget/app_back_header.dart';
import '../../../common/widget/app_tab_buttons.dart';
import '../../../common/widget/app_main_container.dart';
import '../controller/health_schedule_controller.dart';
import '../widget/time_filter_sidebar.dart';
import '../widget/medication_filter_sidebar.dart';
import '../widget/medication_card_widget.dart';
import '../widget/time_slot_widget.dart';

class HealthSchedulePage extends StatelessWidget {
  const HealthSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HealthScheduleController>();

    return Scaffold(
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
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl6,
                      vertical: AppSpacing.lg,
                    ),
                    child: Row(
                      children: [
                        AppTabButton(
                          text: 'Routine',
                          icon: Icons.person,
                          isSelected: controller.currentTabIndex == 0,
                          onTap: () => controller.switchTab(0),
                        ),
                        AppTabButton(
                          text: 'Medication',
                          icon: Icons.medication,
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
              Icon(Icons.edit, color: AppColors.primary700, size: 16),
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

      return Stack(
        children: [
          // Dashed line positioned on the left
          Positioned(
            left: 20,
            top: 2,
            bottom: 0,
            child: Container(
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

          // Original content
          SingleChildScrollView(
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
