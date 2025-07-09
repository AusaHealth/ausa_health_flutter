import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(AppImages.appBarBluetooth, height: 32, width: 32),
          SizedBox(width: AppSpacing.xl2),

          Image.asset(AppImages.appBarWifi, height: 32, width: 32),

          SizedBox(width: AppSpacing.xl2),

          Image.asset(AppImages.appBarBattery, height: 32, width: 32),
          SizedBox(width: AppSpacing.xl2),
        ],
      ),
    );
  }
}
