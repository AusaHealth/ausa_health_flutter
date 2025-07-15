import 'package:ausa/common/widget/app_sub_parent_container.dart';
import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class BluetoothPage extends StatelessWidget {
  const BluetoothPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.xl6,
            bottom: AppSpacing.xl2,
            top: AppSpacing.xl,
          ),
          child: Text(
            'Device status',
            style: AppTypography.body(weight: AppTypographyWeight.regular),
          ),
        ),

        Row(
          children: [
            DeviceStatusCard(
              deviceName: 'Blood pressure',
              imagePath: AppImages.bloodPressure,
              statusImagePath: AppImages.connecting,
              isActive: true,
            ),
            SizedBox(width: AppSpacing.lg),
            DeviceStatusCard(
              deviceName: 'X',
              imagePath: AppImages.X,
              statusImagePath: AppImages.notFound,
              isActive: false,
            ),
            SizedBox(width: AppSpacing.lg),
            DeviceStatusCard(
              deviceName: 'ECG',
              imagePath: AppImages.ecg,
              statusImagePath: AppImages.notFound,
              isActive: false,
            ),
          ],
        ),
      ],
    );
  }
}

class DeviceStatusCard extends StatelessWidget {
  final String deviceName;
  final String imagePath;

  final String statusImagePath;
  final bool isActive;

  const DeviceStatusCard({
    super.key,
    required this.deviceName,
    required this.imagePath,
    required this.statusImagePath,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl3),
          border: Border.all(
            color: isActive ? Color(0xFF1673FF) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  statusImagePath,
                  width: DesignScaleManager.scaleValue(266),
                  height: DesignScaleManager.scaleValue(120),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Device image and label
            Center(
              child: Image.asset(
                imagePath,
                height: DesignScaleManager.scaleValue(328),
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: AppSpacing.sm),

            Center(
              child: Text(
                deviceName,
                style: AppTypography.body(weight: AppTypographyWeight.medium),
              ),
            ),
            SizedBox(height: AppSpacing.xl6),
          ],
        ),
      ),
    );
  }
}
