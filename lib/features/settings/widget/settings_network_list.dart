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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 32, top: 24, bottom: 8),
                child: Text(
                  'Available networks',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFA0A8BB),
                  ),
                ),
              ),
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
                          const Divider(
                            indent: 32,
                            endIndent: 32,
                            height: 1,
                            color: Color(0xFFE0E0E0),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

