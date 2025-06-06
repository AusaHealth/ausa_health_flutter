import 'package:flutter/material.dart';

class BlurContainer extends StatelessWidget {
  const BlurContainer({
    super.key,
    required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.2),
              blurRadius: 40,
              offset: Offset(4, 4),
              blurStyle: BlurStyle.outer,
              spreadRadius: 10,
            ),
          ],
          // gradient: Gradients.gradient1,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: child,
        ),
      );
  }
}