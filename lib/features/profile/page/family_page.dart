import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/profile/page/add_new_member.dart';
import 'package:ausa/features/profile/page/email_invite_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(AppSpacing.smMedium).copyWith(),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.xl2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Add new member card
                      InkWell(
                        onTap: () {
                          Get.to(() => AddNewMember());
                        },
                        child: Container(
                          height: DesignScaleManager.scaleValue(424),
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: const Color(0xffe3f2fd),
                            borderRadius: BorderRadius.circular(AppRadius.xl3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // User plus icon
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.person_add,
                                  size: 32,
                                  color: Color(0xFF2196F3),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Add new member\nmanually',
                                textAlign: TextAlign.center,
                                style: AppTypography.callout(
                                  color: AppColors.primary700,
                                  weight: AppTypographyWeight.medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: AppSpacing.xl3),

                      // OR divider
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey[300],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.xl,
                            ),
                            child: Text(
                              'OR',
                              style: AppTypography.callout(
                                weight: AppTypographyWeight.medium,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.xl2),
                      // const SizedBox(height: 12),

                      // Email invitation button
                      InkWell(
                        onTap: () {
                          Get.to(() => EmailInvitePage());
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                          ),

                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.email_outlined,
                                size: 20,

                                color: AppColors.primary700,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Send an email invitation',
                                style: AppTypography.body(
                                  weight: AppTypographyWeight.medium,
                                  color: AppColors.primary700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.xl2),
                    ],
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.lg),
              Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    Image.asset(AppImages.familyPerson),
                    Container(
                      width: 280,
                      margin: EdgeInsets.all(AppSpacing.smMedium),
                      height: 400,
                      padding: EdgeInsets.only(
                        left: AppSpacing.xl4,
                        right: AppSpacing.xl3,
                        top: AppSpacing.xl6,
                        bottom: AppSpacing.xl6,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF64B5F6), Color(0xFF1976D2)],
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.xl3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User icon
                          Row(
                            children: [
                              Text(
                                'Add a family\nmember.',
                                style: AppTypography.headline(
                                  color: Colors.white,
                                  weight: AppTypographyWeight.medium,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.person_add,
                                size: DesignScaleManager.scaleValue(80),
                                color: Colors.white,
                              ),
                            ],
                          ),

                          SizedBox(height: AppSpacing.xl2),

                          Text(
                            'Get your family member to download\nAusa Health App and scan the QR code.',
                            style: AppTypography.callout(
                              color: Colors.white,
                              weight: AppTypographyWeight.medium,
                            ),
                          ),

                          SizedBox(height: AppSpacing.xl5),
                          Text(
                            'This will enable them to join your family.',
                            style: AppTypography.callout(
                              color: Colors.white,
                              weight: AppTypographyWeight.medium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
