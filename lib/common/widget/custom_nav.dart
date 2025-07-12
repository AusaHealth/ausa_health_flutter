import 'package:ausa/common/widget/app_icons.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';

class CustomNav extends StatelessWidget {
  final VoidCallback? onBack;
  final String title;
  const CustomNav({super.key, this.onBack, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.chevron_left, size: 24),
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                splashRadius: 28,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: AppTypography.headline(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
