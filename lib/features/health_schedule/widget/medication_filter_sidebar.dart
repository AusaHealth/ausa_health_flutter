import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/constants.dart';
import '../controller/health_schedule_controller.dart';

class MedicationFilterSidebar extends StatelessWidget {
  final HealthScheduleController controller;

  const MedicationFilterSidebar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      child: Obx(() {
        final filters = controller.dynamicMedicationFilters;

        return SingleChildScrollView(
          padding: EdgeInsets.only(
            right: AppSpacing.lg,
          ),
          child: Column(
            children:
                filters.asMap().entries.map((entry) {
                  final index = entry.key;
                  final filterName = entry.value;
                  final isFirst = index == 0;
                  final isLast = index == filters.length - 1;

                  return Column(
                    children: [
                      if (index > 0) SizedBox(height: AppSpacing.lg),
                      _buildFilterButton(
                        filterName,
                        index,
                        isFirst: isFirst,
                        isLast: isLast,
                      ),
                    ],
                  );
                }).toList(),
          ),
        );
      }),
    );
  }

  Widget _buildFilterButton(
    String title,
    int index, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isSelected = controller.selectedMedicationFilter == index;

    // Determine border radius based on position
    BorderRadius borderRadius;
    if (isFirst) {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(AppRadius.xl3),
        topRight: Radius.circular(AppRadius.xl),
        bottomLeft: Radius.circular(AppRadius.xl),
        bottomRight: Radius.circular(AppRadius.xl),
      );
    } else if (isLast) {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(AppRadius.xl),
        topRight: Radius.circular(AppRadius.xl),
        bottomLeft: Radius.circular(AppRadius.xl3),
        bottomRight: Radius.circular(AppRadius.xl),
      );
    } else {
      borderRadius = BorderRadius.circular(AppRadius.xl);
    }

    return GestureDetector(
      onTap: () => controller.setMedicationFilterSafe(index),
      child: Container(
        width: double.infinity,
        height: 70,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary700 : Colors.grey[100],
          borderRadius: borderRadius,
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
            Expanded(
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTypography.body(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
