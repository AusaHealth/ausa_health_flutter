import 'package:flutter/material.dart';

class SettingsNetworkTile extends StatelessWidget {
  final String networkName;
  final bool isSecure;
  final bool isConnected;
  final int signalStrength; // 0-4
  final bool selected;
  final VoidCallback? onTap;

  const SettingsNetworkTile({
    super.key,
    required this.networkName,
    this.isSecure = false,
    this.isConnected = false,
    this.signalStrength = 3,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color selectedBg = const Color(0xFFE5F0FF);
    final Color normalBg = Colors.white;
    final Color selectedText = const Color(0xFF00267E);
    final Color normalText = Colors.black;
    final Color iconColor = Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: selected ? selectedBg : normalBg,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                networkName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  color: selected ? selectedText : normalText,
                ),
              ),
            ),
            if (isSecure) ...[
              Icon(Icons.lock, size: 20, color: iconColor),
              const SizedBox(width: 8),
            ],
            Icon(Icons.wifi, size: 24, color: iconColor),
            const SizedBox(width: 8),
            Icon(Icons.info_outline, size: 22, color: iconColor),
          ],
        ),
      ),
    );
  }
}
