import 'package:flutter/material.dart';
import '../../constants/constants.dart';

/// Tab data model for the AppTabButtons widget
class AppTabData {
  final String text;
  final IconData icon;

  const AppTabData({required this.text, required this.icon});
}

/// A reusable tab buttons widget with beautiful gradient styling
class AppTabButtons extends StatelessWidget {
  final List<AppTabData> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final EdgeInsets? padding;
  final double? spacing;

  const AppTabButtons({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.padding,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: AppSpacing.xl6,
            vertical: AppSpacing.md,
          ),
      child: Row(
        children:
            tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              final isSelected = selectedIndex == index;

              return GestureDetector(
                onTap: () => onTabSelected(index),
                child: Container(
                  margin: EdgeInsets.only(right: spacing ?? AppSpacing.md),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.lg,
                  ),
                  decoration: BoxDecoration(
                    gradient:
                        isSelected
                            ? LinearGradient(
                              colors: [
                                AppColors.primary800,
                                AppColors.primary500,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                            : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    boxShadow:
                        isSelected
                            ? [
                              BoxShadow(
                                color: AppColors.primary700.withOpacity(0.3),
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
                                  ? AppColors.primary700
                                  : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            tab.icon,
                            color: isSelected ? Colors.white : Colors.grey[600],
                            size: 18,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        tab.text,
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
    );
  }
}
