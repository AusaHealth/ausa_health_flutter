import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarePage extends StatelessWidget {
  const CarePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(7),
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
              profileController.care.careProviderName,
              style: AppTypography.body(weight: AppTypographyWeight.semibold),
            ),
            SizedBox(height: AppSpacing.xl2),
            // Headers Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Next availability',
                    style: AppTypography.callout(
                      weight: AppTypographyWeight.regular,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Phone',
                    style: AppTypography.callout(
                      weight: AppTypographyWeight.regular,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Email',
                    style: AppTypography.callout(
                      weight: AppTypographyWeight.regular,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Address',
                    style: AppTypography.callout(
                      weight: AppTypographyWeight.regular,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.mdLarge),
            // Values Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    profileController.care.nextAvailability,
                    style: AppTypography.body(
                      weight: AppTypographyWeight.semibold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    profileController.care.phone,
                    style: AppTypography.body(
                      weight: AppTypographyWeight.semibold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    profileController.care.email,
                    style: AppTypography.body(
                      weight: AppTypographyWeight.semibold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    profileController.care.address,
                    style: AppTypography.body(
                      weight: AppTypographyWeight.semibold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
