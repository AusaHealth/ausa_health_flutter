import 'package:ausa/constants/radius.dart';
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
    this.backgroundColor = const Color(0xFFFFA726),
    this.selectedColor = const Color(0xFFFFCC80),
    this.unselectedColor = Colors.transparent,
    this.selectedTextColor = const Color(0xFF6D3B00),
    this.unselectedTextColor = const Color(0xFF6D3B00),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: List.generate(items.length, (index) {
          final bool isSelected = index == selectedIndex;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 4 : 0,
                right: index == items.length - 1 ? 4 : 0,
              ),
              child: GestureDetector(
                onTap: () => onSelected(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? selectedColor : unselectedColor,
                    borderRadius: BorderRadius.circular(AppRadius.xl3),
                  ),
                  child: Center(
                    child: Text(
                      items[index],
                      style: AppTypography.callout(
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
    );
  }
}
