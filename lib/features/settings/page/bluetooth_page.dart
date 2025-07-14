import 'package:ausa/constants/app_images.dart';
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'Device status',
              style: AppTypography.body(weight: AppTypographyWeight.regular),
            ),
          ),
          SizedBox(height: AppSpacing.lg),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
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
          ),
        ],
      ),
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
        width: Get.width * 0.22,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl3),
          border: Border.all(
            color: isActive ? Color(0xFF1673FF) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 12,
              left: 0,
              right: -140,
              child: Image.asset(
                statusImagePath,
                width: 56,
                height: 28,
                fit: BoxFit.contain,
              ),
            ),
            // Device image and label
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    imagePath,
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),

                Text(
                  deviceName,
                  style: AppTypography.body(weight: AppTypographyWeight.medium),
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
