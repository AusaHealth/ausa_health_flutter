import 'package:ausa/common/widget/app_main_container.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/settings/model/network_info_model.dart';
import 'package:flutter/material.dart';
import 'settings_network_tile.dart';

class SettingsNetworkList extends StatelessWidget {
  final List<NetworkInfo> networks;
  final ValueChanged<int>? onTileTap;
  final int? selectedIndex;

  const SettingsNetworkList({
    super.key,
    required this.networks,
    this.onTileTap,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl3),
      ),

      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.xl4,
        horizontal: AppSpacing.xl6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available networks',
            style: AppTypography.body(
              weight: AppTypographyWeight.regular,
              color: AppColors.gray400,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Expanded(
            child: ListView.builder(
              // shrinkWrap: true,
              itemCount: networks.length,
              itemBuilder: (context, i) {
                final net = networks[i];
                return Column(
                  children: [
                    SettingsNetworkTile(
                      networkName: net.name,
                      isSecure: net.isSecure,
                      isConnected: net.isConnected,
                      signalStrength: net.signalStrength,
                      selected: selectedIndex == i,
                      onTap: () => onTileTap?.call(i),
                    ),
                    if (i < networks.length - 1)
                      const Divider(height: 1, color: Color(0xFFE0E0E0)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
