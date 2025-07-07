import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/onboarding/controller/onboarding_controller.dart';
import 'package:ausa/features/settings/model/network_info_model.dart';
import 'package:ausa/features/settings/widget/settings_network_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingWifiPage extends StatelessWidget {
  OnboardingWifiPage({super.key});

  final List<NetworkInfo> networks = [
    NetworkInfo(
      name: 'DIRECT_37129t4bg937',
      isSecure: true,
      isConnected: false,
      signalStrength: 4,
    ),
    NetworkInfo(
      name: 'Mercy Housing Resident',
      isSecure: true,
      isConnected: false,
      signalStrength: 3,
    ),
    NetworkInfo(
      name: 'Jian Zhing Primary Care',
      isSecure: true,
      isConnected: false,
      signalStrength: 2,
    ),
    NetworkInfo(
      name: 'Other...',
      isSecure: false,
      isConnected: false,
      signalStrength: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wi-Fi',
          style: AppTypography.body(
            color: AppColors.bodyTextLightColor,
          ).copyWith(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          'Select your Wi-Fi network',
          style: AppTypography.title1(
            color: AppColors.bodyTextColor,
          ).copyWith(fontSize: 16),
        ),
        const SizedBox(height: 24),
        Text(
          'Available networks',
          style: AppTypography.body(
            color: Color(0xFF828282),
          ).copyWith(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: networks.length,
            separatorBuilder:
                (context, i) =>
                    const Divider(height: 1, color: Color(0xFFE0E0E0)),
            itemBuilder: (context, i) {
              final net = networks[i];
              return SettingsNetworkTile(
                networkName: net.name,
                isSecure: net.isSecure,
                isConnected: net.isConnected,
                signalStrength: net.signalStrength,
                selected: false,
                onTap: () {
                  controller.completeStep(OnboardingStep.wifi);
                  controller.goToStep(OnboardingStep.phone);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
