import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuccessPopup extends StatelessWidget {
  final VoidCallback onClose;

  const SuccessPopup({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF0E2457).withOpacity(0.8),
      child: Center(
        child: Container(
          width: 500,
          margin: const EdgeInsets.symmetric(horizontal: 50),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4F7EFF), Color(0xFF2B5CE6)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: onClose,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Success icon with glow effect
              Container(
                width: 100,
                height: 100,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                              AusaIcons.check,
                              colorFilter: ColorFilter.mode(Color(0xFF2B5CE6), BlendMode.srcIn),
                            ),
              ),

              const SizedBox(height: 32),

              // Success text
              Text(
                'Successfully Scheduled',
                style: AppTypography.title2(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                'You will be reminded about this\nappointment before the scheduled time.',
                style: AppTypography.body(
                  color: Colors.white.withOpacity(0.95),
                  fontWeight: FontWeight.w400,
                ).copyWith(height: 1.4),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
