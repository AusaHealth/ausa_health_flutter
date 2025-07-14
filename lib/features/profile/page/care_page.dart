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
        padding: EdgeInsets.all(AppSpacing.xl4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'Care provider',
              style: AppTypography.callout(weight: AppTypographyWeight.regular),
            ),
            SizedBox(height: AppSpacing.mdLarge),
            Text(
              'Dr. John Doe, Endocrinologist',
              style: AppTypography.body(weight: AppTypographyWeight.semibold),
            ),

            SizedBox(height: AppSpacing.xl2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Next availability
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next availability',
                      style: AppTypography.callout(
                        weight: AppTypographyWeight.regular,
                      ),
                    ),
                    SizedBox(height: AppSpacing.mdLarge),
                    Text(
                      'Today 3:00 PM',
                      style: AppTypography.body(
                        weight: AppTypographyWeight.semibold,
                      ),
                    ),
                  ],
                ),
                // Phone
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone',
                      style: AppTypography.callout(
                        weight: AppTypographyWeight.regular,
                      ),
                    ),
                    SizedBox(height: AppSpacing.mdLarge),
                    Text(
                      '+1 555-123-4567',
                      style: AppTypography.body(
                        weight: AppTypographyWeight.semibold,
                      ),
                    ),
                  ],
                ),
                // Email
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: AppTypography.callout(
                        weight: AppTypographyWeight.regular,
                      ),
                    ),
                    SizedBox(height: AppSpacing.mdLarge),
                    Text(
                      'johndoe@clinic.com',
                      style: AppTypography.body(
                        weight: AppTypographyWeight.semibold,
                      ),
                    ),
                  ],
                ),
                // Address
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address',
                      style: AppTypography.callout(
                        weight: AppTypographyWeight.regular,
                      ),
                    ),

                    SizedBox(height: AppSpacing.mdLarge),
                    Text(
                      '123 Main St, Los Angeles, CA, 90001',
                      style: AppTypography.body(
                        weight: AppTypographyWeight.semibold,
                      ),
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
