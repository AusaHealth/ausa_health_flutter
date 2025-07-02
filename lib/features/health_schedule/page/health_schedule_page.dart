import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/constants.dart';
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
                _buildHeader(controller),

                // Tab buttons
                _buildTabButtons(controller),

                // Main content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Container(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.xl2),
                        color: Colors.white.withOpacity(0.5),
                      ),
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
                                borderRadius: BorderRadius.circular(
                                  AppRadius.xl2,
                                ),
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
                                              ? _buildTimelineContent(
                                                controller,
                                              )
                                              : _buildMedicationContent(
                                                controller,
                                              ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(HealthScheduleController controller) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black87,
                size: 16,
              ),
            ),
          ),

          SizedBox(width: AppSpacing.md),

          // Title
          Text(
            'Health Schedule',
            style: AppTypography.headline(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButtons(HealthScheduleController controller) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl6,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children:
              controller.tabs.asMap().entries.map((entry) {
                final index = entry.key;
                final tab = entry.value;
                final isSelected = controller.currentTabIndex == index;

                return GestureDetector(
                  onTap: () => controller.switchTab(index),
                  child: Container(
                    margin: EdgeInsets.only(right: AppSpacing.md),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.lg,
                    ),
                    decoration: BoxDecoration(
                      gradient:
                          isSelected
                              ? LinearGradient(
                                colors: [
                                  Color.fromRGBO(0, 38, 126, 0.90),
                                  Color.fromRGBO(0, 73, 245, 0.90),
                                ],
                                begin: Alignment(-0.5, 0.5),
                                end: Alignment(1.5, -0.5),
                                transform: GradientRotation(
                                  136 * 3.14159 / 180,
                                ),
                              )
                              : null,
                      color: isSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ]
                              : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? Color(0xFF155AF7)
                                    : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              index == 0 ? Icons.person : Icons.medication,
                              color:
                                  isSelected ? Colors.white : Colors.grey[600],
                              size: 18,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Text(
                          tab,
                          style: AppTypography.body(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
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
