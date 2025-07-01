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
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.lg,
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
                      if (index > 0) SizedBox(height: AppSpacing.md),
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
    final isSelected = controller.selectedMedicationFilter.value == index;

    // Determine border radius based on position
    BorderRadius borderRadius;
    if (isFirst) {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(AppRadius.xl * 2.5),
        topRight: Radius.circular(AppRadius.xl),
        bottomLeft: Radius.circular(AppRadius.xl),
        bottomRight: Radius.circular(AppRadius.xl),
      );
    } else if (isLast) {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(AppRadius.xl),
        topRight: Radius.circular(AppRadius.xl),
        bottomLeft: Radius.circular(AppRadius.xl * 2.5),
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
            Expanded(
              child: Text(
                title,
                style: AppTypography.body(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
