import 'package:ausa/common/widget/trapezium_clippers.dart';
import 'package:flutter/material.dart';

class CustomSnackbar extends StatelessWidget {
  final Widget leading;
  final Widget body;
  final Color backgroundColor;

  const CustomSnackbar({
    super.key,
    required this.leading,
    required this.body,
    this.backgroundColor = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TopEntryTrapeziumClipper(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: backgroundColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            leading,
            const SizedBox(width: 12),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
