import 'package:ausa/features/onboarding/controller/onboarding_controller.dart';
import 'package:ausa/features/settings/model/network_info_model.dart';
import 'package:ausa/features/settings/widget/settings_network_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
        const Text(
          'Wi-Fi',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select your Wi-Fi network',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Available networks',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFFA0A8BB),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
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
