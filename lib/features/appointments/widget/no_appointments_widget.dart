import 'package:ausa/constants/typography.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:flutter/material.dart';

class NoAppointmentsWidget extends StatelessWidget {
  final VoidCallback? onWifiSettings;

  const NoAppointmentsWidget({super.key, this.onWifiSettings});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),

            Text(
              'No scheduled appointments found.',
              style: AppTypography.title2(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Text(
              'You\'re offline, but have scheduled appointments?\nGet online to sync.',
              style: AppTypography.body(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            if (onWifiSettings != null)
              AusaButton(
                text: 'Wi-Fi Settings',
                onPressed: onWifiSettings,
                variant: ButtonVariant.secondary,
                backgroundColor: Colors.white.withOpacity(0.2),
                textColor: Colors.white,
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
