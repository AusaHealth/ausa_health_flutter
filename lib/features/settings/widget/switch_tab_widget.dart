import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';

class SwitchTabWidget extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;
  const SwitchTabWidget({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTypography.body(
            color: const Color(0xFF111827),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: 24),
        Expanded(
          child: Container(
            height: 1.4,
            decoration: BoxDecoration(
              color: Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        SizedBox(width: 24),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF1673FF),
            trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
            inactiveTrackColor: const Color(0xFFE9E9E9),
            inactiveThumbColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
