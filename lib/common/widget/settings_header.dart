import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.bluetooth, size: 32, color: Colors.blueGrey),
          const SizedBox(width: 24),
          Icon(Icons.wifi, size: 32, color: Colors.blueGrey),
          const SizedBox(width: 24),
          Icon(Icons.battery_full, size: 32, color: Colors.blueGrey),
        ],
      ),
    );
  }
}
