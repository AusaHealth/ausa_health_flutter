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
      padding: EdgeInsets.all(AppSpacing.lg),
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
      onTap: () => controller.setTimeFilter(index),
      child: Container(
        width: double.infinity,
        height: 70,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
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
                    // Light outer shadow (top-left)
                    BoxShadow(
                      color: AppColors.primary700.withOpacity(0.3),
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
                      blurRadius: 5,
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
