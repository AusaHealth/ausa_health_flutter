import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class BluetoothPage extends StatelessWidget {
  const BluetoothPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
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
              style: AppTypography.callout(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ).copyWith(fontSize: 16),
            ),
          ),
          SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DeviceStatusCard(
                    deviceName: 'Blood pressure',
                    imagePath: AppImages.bloodPressure,

                    statusImagePath: AppImages.connecting,
                    isActive: true,
                  ),
                  SizedBox(width: 32),
                  DeviceStatusCard(
                    deviceName: 'X',
                    imagePath: AppImages.X,

                    statusImagePath: AppImages.notFound,
                    isActive: false,
                  ),
                  SizedBox(width: 32),
                  DeviceStatusCard(
                    deviceName: 'ECG',
                    imagePath: AppImages.ecg,

                    statusImagePath: AppImages.notFound,
                    isActive: false,
                  ),
                ],
              ),
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
    return Container(
      width: Get.width * 0.23,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
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
          // Status badge
          Positioned(
            top: 24,
            left: 0,
            right: -120,
            child: Image.asset(
              statusImagePath,
              width: 80,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
          // Device image and label
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Image.asset(
                imagePath,
                width: 160,
                height: 160,
                fit: BoxFit.contain,
              ),

              Text(deviceName, style: AppTypography.body(color: Colors.black)),
              SizedBox(height: 30),
            ],
          ),
        ],
      ),
    );
  }
}
