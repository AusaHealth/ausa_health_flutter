import 'dart:ui';

import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';

class HorizontalTabBar extends StatelessWidget {
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Color backgroundColor;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;

  const HorizontalTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.backgroundColor = const Color(0xfff99017),
    this.selectedColor = const Color(0xFFFFCC80),
    this.unselectedColor = Colors.transparent,
    this.selectedTextColor = const Color(0xFF6D3B00),
    this.unselectedTextColor = const Color(0xFF6D3B00),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: DesignScaleManager.scaleValue(96),
        maxHeight: DesignScaleManager.scaleValue(96),
        maxWidth: DesignScaleManager.scaleValue(220),
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl2),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(AppRadius.xl2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: List.generate(items.length, (index) {
                final bool isSelected = index == selectedIndex;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: index > 0 ? AppSpacing.md : 0.0,
                    ),
                    child: GestureDetector(
                      onTap: () => onSelected(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.ease,
                        decoration: BoxDecoration(
                          boxShadow:
                              isSelected
                                  ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 10),
                                      spreadRadius: 0,
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withValues(
                                        alpha: 0.23,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(-2, -3),
                                      spreadRadius: 0,
                                    ),
                                  ]
                                  : null,
                          gradient:
                              isSelected
                                  ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFfFFE3E2),
                                      const Color(0xFfFFba6b),
                                    ],
                                  )
                                  : null,
                          color: isSelected ? null : unselectedColor,
                          border:
                              isSelected
                                  ? Border.all(
                                    width: 2,
                                    color: Color.fromRGBO(255, 255, 255, 0.12),
                                  )
                                  : null,
                          borderRadius: BorderRadius.circular(AppRadius.xl2),
                        ),
                        child: Center(
                          child: Text(
                            items[index],
                            style: AppTypography.callout(
                              weight: AppTypographyWeight.medium,
                              color:
                                  isSelected
                                      ? selectedTextColor
                                      : unselectedTextColor,
                            ),

                            // ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
