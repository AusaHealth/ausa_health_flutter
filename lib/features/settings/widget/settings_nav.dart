import 'package:flutter/material.dart';

class SettingsNav extends StatelessWidget {
  final VoidCallback? onBack;
  const SettingsNav({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 36),
            onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            splashRadius: 28,
          ),
          const SizedBox(width: 8),
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Color(0xFF091227),
            ),
          ),
        ],
      ),
    );
  }
}
