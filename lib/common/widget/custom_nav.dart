import 'package:flutter/material.dart';

class CustomNav extends StatelessWidget {
  final VoidCallback? onBack;
  final String title;
  const CustomNav({super.key, this.onBack, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 24,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.chevron_left, size: 32),
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                splashRadius: 28,
              ),
            ),
          ),
          const SizedBox(width: 32),
          Text(
            title,
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
