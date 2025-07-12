import 'package:flutter/material.dart';
import '../../../constants/constants.dart';

class FloatingCTAWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isVisible;

  const FloatingCTAWidget({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Positioned(
      bottom: AppSpacing.xl,
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary700,
              borderRadius: BorderRadius.circular(AppRadius.full),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: AppTypography.body(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
