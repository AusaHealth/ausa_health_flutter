import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/constants.dart';
import '../controller/meal_times_controller.dart';

class MealTimesPage extends StatelessWidget {
  const MealTimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MealTimesController());

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

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
                      // Left sidebar with meal options
                      _buildMealsSidebar(controller),

                      // Right content area with time picker
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

                              // Set meal time header
                              _buildSetTimeHeader(controller),

                              SizedBox(height: AppSpacing.xl4),

                              // Time picker
                              Expanded(child: _buildTimePicker(controller)),
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
      ),
    );
  }

  Widget _buildHeader() {
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
            'Edit Meal Times',
            style: AppTypography.headline(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildMealsSidebar(MealTimesController controller) {
    return Container(
      width: 220,
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Obx(
        () => Column(
          children:
              controller.meals.asMap().entries.map((entry) {
                final index = entry.key;
                final meal = entry.value;
                final isSelected = controller.selectedMealIndex == index;
                final isFirst = index == 0;
                final isLast = index == controller.meals.length - 1;

                return Container(
                  margin: EdgeInsets.only(bottom: AppSpacing.md),
                  child: _buildMealButton(
                    meal['name'],
                    meal['icon'],
                    index,
                    controller,
                    isFirst: isFirst,
                    isLast: isLast,
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildMealButton(
    String title,
    IconData icon,
    int index,
    MealTimesController controller, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isSelected = controller.selectedMealIndex == index;

    // Determine border radius based on position
    BorderRadius borderRadius;
    if (isFirst) {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(AppRadius.xl * 2.5), // Higher top-left radius
        topRight: Radius.circular(AppRadius.xl),
        bottomLeft: Radius.circular(AppRadius.xl),
        bottomRight: Radius.circular(AppRadius.xl),
      );
    } else if (isLast) {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(AppRadius.xl),
        topRight: Radius.circular(AppRadius.xl),
        bottomLeft: Radius.circular(
          AppRadius.xl * 2.5,
        ), // Higher bottom-left radius
        bottomRight: Radius.circular(AppRadius.xl),
      );
    } else {
      borderRadius = BorderRadius.circular(AppRadius.xl);
    }

    return GestureDetector(
      onTap: () => controller.selectMeal(index),
      child: Container(
        width: double.infinity,
        height: 70,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF165CFF) : Colors.grey[100],
          borderRadius: borderRadius,
          boxShadow:
              isSelected
                  ? [
                    // Light outer shadow (top-left)
                    BoxShadow(
                      color: Color(0xFFC8D8FF),
                      blurRadius: 10,
                      offset: Offset(-3, -4),
                    ),
                    // Dark outer shadow (bottom-right)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 10,
                      offset: Offset(5, 6),
                    ),
                  ]
                  : [
                    // Light grey shadow (top-left)
                    BoxShadow(
                      color: Color(0xFFF5F5F5),
                      blurRadius: 10,
                      offset: Offset(-3, -4),
                    ),
                    // Dark grey shadow (bottom-right)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: Offset(5, 6),
                    ),
                  ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 22,
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTypography.body(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  Text(
                    _getCurrentMealTime(controller, index),
                    style: AppTypography.callout(
                      color:
                          isSelected
                              ? Colors.white.withOpacity(0.8)
                              : Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentMealTime(MealTimesController controller, int index) {
    switch (index) {
      case 0:
        return controller.breakfastTime;
      case 1:
        return controller.lunchTime;
      case 2:
        return controller.dinnerTime;
      default:
        return '';
    }
  }

  Widget _buildSetTimeHeader(MealTimesController controller) {
    return Obx(
      () => Row(
        children: [
          Text(
            'Set ${controller.currentMealName} Time',
            style: AppTypography.body(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.mic, color: AppColors.primaryColor, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker(MealTimesController controller) {
    return Obx(
      () => Center(
        child: Container(
          height: 500,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hour picker
              _buildScrollableColumn(
                controller: controller,
                items:
                    controller.availableHours
                        .map((hour) => hour.toString())
                        .toList(),
                selectedIndex: controller.currentHourIndex,
                onChanged: (index) {
                  final selectedHour = controller.availableHours[index];
                  controller.updateHour(selectedHour);
                },
                width: 100,
              ),

              SizedBox(width: AppSpacing.lg),

              // Minute picker
              _buildScrollableColumn(
                controller: controller,
                items:
                    controller.availableMinutes
                        .map((minute) => minute.toString().padLeft(2, '0'))
                        .toList(),
                selectedIndex: controller.currentMinuteIndex,
                onChanged: (index) {
                  final selectedMinute = controller.availableMinutes[index];
                  controller.updateMinute(selectedMinute);
                },
                width: 100,
              ),

              SizedBox(width: AppSpacing.lg),

              // AM/PM picker - always show but interactive only for dinner
              _buildPeriodColumn(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodColumn(MealTimesController controller) {
    final mealIndex = controller.selectedMealIndex;

    // Get the fixed period for breakfast/lunch or available periods for dinner
    List<String> items;
    int selectedIndex;
    bool isInteractive;

    switch (mealIndex) {
      case 0: // Breakfast - always AM
        items = ['AM'];
        selectedIndex = 0;
        isInteractive = false;
        break;
      case 1: // Lunch - always PM
        items = ['PM'];
        selectedIndex = 0;
        isInteractive = false;
        break;
      case 2: // Dinner - interactive AM/PM
        items = controller.availablePeriods;
        selectedIndex = controller.currentPeriodIndex;
        isInteractive = true;
        break;
      default:
        items = ['AM'];
        selectedIndex = 0;
        isInteractive = false;
    }

    return _buildScrollableColumn(
      controller: controller,
      items: items,
      selectedIndex: selectedIndex,
      onChanged:
          isInteractive
              ? (index) {
                final selectedPeriod = controller.availablePeriods[index];
                controller.updatePeriod(selectedPeriod);
              }
              : (index) {}, // Empty function for non-interactive
      width: 100,
      isInteractive: isInteractive,
    );
  }

  Widget _buildScrollableColumn({
    required MealTimesController controller,
    required List<String> items,
    required int selectedIndex,
    required Function(int) onChanged,
    required double width,
    bool isInteractive = true,
  }) {
    return Container(
      width: width,
      height: 500,
      child: Stack(
        children: [
          // Clipped wheel scroll view to prevent edge artifacts
          ClipRect(
            child: ListWheelScrollView.useDelegate(
              itemExtent: 80,
              diameterRatio: 2.2, // Balanced curvature without artifacts
              perspective: 0.004, // Smooth 3D effect
              squeeze: 1.0,
              useMagnifier: false, // Disable magnifier to prevent artifacts
              magnification: 1.0,
              physics:
                  isInteractive
                      ? FixedExtentScrollPhysics()
                      : NeverScrollableScrollPhysics(),
              onSelectedItemChanged: isInteractive ? onChanged : null,
              controller: FixedExtentScrollController(
                initialItem: selectedIndex.clamp(0, items.length - 1),
              ),
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  if (index < 0 || index >= items.length) return null;

                  final isSelected = index == selectedIndex;

                  return Container(
                    height: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.primaryColor.withOpacity(0.1)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    child: Text(
                      items[index],
                      style: AppTypography.title2(
                        color:
                            isSelected
                                ? AppColors.primaryColor
                                : Colors.grey[400],
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  );
                },
                childCount: items.length,
              ),
            ),
          ),

          // Top fade gradient - extended to hide artifacts
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.6),
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.0),
                    ],
                    stops: [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Bottom fade gradient - extended to hide artifacts
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 200,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.6),
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.0),
                    ],
                    stops: [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
