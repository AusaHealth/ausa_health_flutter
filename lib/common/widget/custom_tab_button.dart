import 'package:ausa/constants/color.dart';
import 'package:flutter/material.dart';

class CustomTabButton extends StatelessWidget {
  final String selectedImagePath;
  final String unselectedImagePath;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const CustomTabButton({
    super.key,
    required this.selectedImagePath,
    required this.unselectedImagePath,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient:
              selected
                  ? const LinearGradient(
                    colors: [
                      AppColors.primaryDarkColor,
                      AppColors.primaryLightColor,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                  : const LinearGradient(
                    colors: [Colors.white, Colors.white],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
          borderRadius: BorderRadius.circular(60),
          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ]
                  : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              selected ? selectedImagePath : unselectedImagePath,
              width: 28,
              height: 28,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
