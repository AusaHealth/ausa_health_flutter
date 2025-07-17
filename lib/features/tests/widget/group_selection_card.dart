import 'package:ausa/constants/radius.dart';
import 'package:flutter/material.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/tests/model/test_group.dart';

class GroupSelectionCard extends StatelessWidget {
  final TestGroup group;
  final bool isSelected;
  final VoidCallback onTap;

  const GroupSelectionCard({
    super.key,
    required this.group,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl2),
          border: Border.all(
            color: isSelected ? AppColors.primary700 : Colors.transparent,
            width: isSelected ? 1 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(group.image, fit: BoxFit.contain),
            ),
            Positioned(
              bottom: 15,
              left: 6,
              right: 6,
              child: Text(
                group.name,
                style: AppTypography.body(weight: AppTypographyWeight.medium),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
