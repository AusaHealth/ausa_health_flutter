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
    final controller = Get.put(HealthScheduleController());

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                const AppBackHeader(title: 'Health Schedule'),

                // Tab buttons
                Obx(
                  () => AppTabButtons(
                    tabs: const [
                      AppTabData(text: 'Routine', icon: Icons.person),
                      AppTabData(text: 'Medication', icon: Icons.medication),
                    ],
                    selectedIndex: controller.currentTabIndex,
                    onTabSelected: (index) => controller.switchTab(index),
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
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl4,
                            vertical: AppSpacing.xl,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: AppSpacing.lg),

                              // Edit meal times button (only for routine tab)
                              controller.currentTabIndex == 0
                                  ? _buildEditMealTimesButton(controller)
                                  : Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppSpacing.md,
                                        vertical: AppSpacing.sm,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            color: Colors.transparent,
                                            size: 16,
                                          ),
                                          SizedBox(width: AppSpacing.md),
                                          Text(
                                            'Meal Times',
                                            style: AppTypography.callout(
                                              color: Colors.transparent,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                              SizedBox(height: AppSpacing.lg),

                              // Content based on selected tab
                              Expanded(
                                child: Obx(
                                  () =>
                                      controller.currentTabIndex == 0
                                          ? _buildTimelineContent(controller)
                                          : _buildMedicationContent(controller),
                                ),
                              ),
                            ],
                          ),
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
              Icon(Icons.edit, color: AppColors.primaryColor, size: 16),
              SizedBox(width: AppSpacing.md),
              Text(
                'Meal Times',
                style: AppTypography.callout(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
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
                          color: AppColors.primaryColor,
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
