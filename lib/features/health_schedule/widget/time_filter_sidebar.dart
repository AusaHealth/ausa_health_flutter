import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/constants.dart';
import '../controller/health_schedule_controller.dart';

class TimeFilterSidebar extends StatelessWidget {
  final HealthScheduleController controller;

  const TimeFilterSidebar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: EdgeInsets.only(
        right: AppSpacing.lg,
        bottom: AppSpacing.lg,
      ),
      child: Column(
        children: [
          // All Day Button
          Obx(
            () =>
                _buildFilterButton('All Day', Icons.schedule, 0, isFirst: true),
          ),

          SizedBox(height: AppSpacing.lg),

          // Morning Button
          Obx(() => _buildFilterButton('Morning', Icons.wb_sunny_outlined, 1)),

          SizedBox(height: AppSpacing.lg),

          // Afternoon Button
          Obx(() => _buildFilterButton('Afternoon', Icons.wb_sunny, 2)),

          SizedBox(height: AppSpacing.lg),

          // Evening Button
          Obx(
            () => _buildFilterButton(
              'Evening',
              Icons.brightness_3_outlined,
              3,
              isLast: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(
    String title,
    IconData icon,
    int index, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isSelected = controller.selectedTimeFilter == index;

    // Determine border radius based on position
    BorderRadius borderRadius;
    if (isFirst) {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(AppRadius.xl3), // Higher top-left radius
        topRight: Radius.circular(AppRadius.xl),
        bottomLeft: Radius.circular(AppRadius.xl),
        bottomRight: Radius.circular(AppRadius.xl),
      );
    } else if (isLast) {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(AppRadius.xl),
        topRight: Radius.circular(AppRadius.xl),
        bottomLeft: Radius.circular(
          AppRadius.xl3,
        ), // Higher bottom-left radius
        bottomRight: Radius.circular(AppRadius.xl),
      );
    } else {
      borderRadius = BorderRadius.circular(AppRadius.xl);
    }

    return GestureDetector(
      onTap: () => controller.setTimeFilter(index),
      child: Container(
        width: double.infinity,
        height: 70,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl6,
          vertical: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          gradient: isSelected ? null : null,
          color: isSelected ? AppColors.primary700 : Colors.grey[100],
          borderRadius: borderRadius,
          border: isSelected ? null : null,
          boxShadow:
              isSelected
                  ? [
                    // Drop Shadow 1 – Black @10%
                    const BoxShadow(
                      color: Color(0x1A000000), // Black with 10% opacity
                      blurRadius: 10,
                      offset: Offset(5, 6),
                      spreadRadius: 0,
                    ),
                    // Drop Shadow 2 – Light blue highlight
                    BoxShadow(
                      color: const Color(0xFFC8D8FF), // #C8D8FF @100%
                      blurRadius: 10,
                      offset: const Offset(-3, -4),
                      spreadRadius: 0,
                    ),
                    // Inner Shadow approximation – Blue tint
                    BoxShadow(
                      color: const Color(0xFF86AAFF), // #86AAFF @100%
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ]
                  : [
                    // Single shadow for non-selected buttons – Black @10%
                    const BoxShadow(
                      color: Color(0x1A000000), // Black with 10% opacity
                      blurRadius: 10,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 20,
            ),
            SizedBox(width: AppSpacing.md),
            Text(
              title,
              style: AppTypography.body(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
