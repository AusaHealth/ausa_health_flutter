import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';

class CarePage extends StatelessWidget {
  const CarePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl3,
        ).copyWith(top: AppSpacing.xl2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Care provider', style: AppTypography.calloutRegular()),
            const SizedBox(height: 8),
            Text(
              'Dr. John Doe, Endocrinologist',
              style: AppTypography.bodyBold(),
            ),

            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Next availability
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next availability',
                      style: AppTypography.calloutRegular(),
                    ),
                    SizedBox(height: 8),
                    Text('Today 3:00 PM', style: AppTypography.bodyBold()),
                  ],
                ),
                // Phone
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone', style: AppTypography.calloutRegular()),
                    SizedBox(height: 8),
                    Text('+1 555-123-4567', style: AppTypography.bodyBold()),
                  ],
                ),
                // Email
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email', style: AppTypography.calloutRegular()),
                    SizedBox(height: 8),
                    Text('johndoe@clinic.com', style: AppTypography.bodyBold()),
                  ],
                ),
                // Address
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Address', style: AppTypography.calloutRegular()),

                    SizedBox(height: 8),
                    Text(
                      '123 Main St, Los Angeles,\nCA, 90001',
                      style: AppTypography.bodyBold(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
