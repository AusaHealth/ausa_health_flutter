import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: DesignScaleManager.scaleValue(88),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ).copyWith(right: AppSpacing.xl3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              AppImages.appBarBluetooth,
              height: DesignScaleManager.scaleValue(40),
            ),
            SizedBox(width: AppSpacing.xl2),
            Image.asset(
              AppImages.appBarWifi,
              height: DesignScaleManager.scaleValue(40),
            ),
            SizedBox(width: AppSpacing.xl2),
            Image.asset(
              AppImages.appBarBattery,
              height: DesignScaleManager.scaleValue(40),
            ),
          ],
        ),
      ),
    );
  }
}
