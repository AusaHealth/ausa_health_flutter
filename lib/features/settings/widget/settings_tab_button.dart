import 'package:flutter/material.dart';

class SettingsTabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const SettingsTabButton({
    super.key,
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF00267E) : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(60),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : Colors.black,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
