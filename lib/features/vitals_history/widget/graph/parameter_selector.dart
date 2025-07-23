import 'package:flutter/material.dart';
import 'package:ausa/constants/constants.dart';

class ParameterSelector extends StatelessWidget {
  const ParameterSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onTap,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.05),
        borderRadius: BorderRadius.circular(AppRadius.xl3),
      ),
      child: Row(
        children: [
          for (final p in options) ...[
            GestureDetector(
              onTap: () => onTap(p),
              child: Container(
                margin: EdgeInsets.only(right: AppSpacing.sm),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color:
                      p == selected ? const Color(0xFFFFC107) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(AppRadius.xl3),
                ),
                child: Text(
                  p,
                  style: AppTypography.body(
                    color: const Color(0xFF1A2A78),
                    weight: p == selected
                        ? AppTypographyWeight.semibold
                        : AppTypographyWeight.medium,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
