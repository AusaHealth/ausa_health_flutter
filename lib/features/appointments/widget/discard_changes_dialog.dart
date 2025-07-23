import 'dart:ui';

import 'package:ausa/constants/typography.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:flutter/material.dart';

class DiscardChangesDialog extends StatelessWidget {
  final VoidCallback onDiscard;
  final VoidCallback onKeepEditing;

  const DiscardChangesDialog({
    super.key,
    required this.onDiscard,
    required this.onKeepEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Backdrop
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: const Color(0xFF0E2457).withOpacity(0.8)),
          ),
        ),

        // Close button
        Positioned(
          top: 50,
          right: 24,
          child: GestureDetector(
            onTap: onKeepEditing,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 24),
            ),
          ),
        ),

        // Dialog content
        Center(
          child: Container(
            width: 500,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Warning icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xffffe5c340).withOpacity(.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.remove_circle_outline,
                    size: 32,
                    color: const Color(0xFFE38000),
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                Text(
                  'Discard Changes',
                  style: AppTypography.title2(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF8C00),
                  ),
                ),

                const SizedBox(height: 16),

                // Message
                Text(
                  'You haven\'t saved the changes made to this appointment. Are you sure you want to exit?',
                  style: AppTypography.body(color: const Color(0xFF6B7280)),
                  textAlign: TextAlign.start,
                ),

                const SizedBox(height: 32),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: AusaButton(
                        text: 'No',
                        onPressed: onKeepEditing,
                        variant: ButtonVariant.secondary,
                        height: 48,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AusaButton(
                        text: 'Yes',
                        onPressed: onDiscard,
                        variant: ButtonVariant.primary,
                        height: 48,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
