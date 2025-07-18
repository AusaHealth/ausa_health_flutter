import 'package:ausa/constants/constants.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/tests/model/test_prerequisites.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrerequisiteCheckDialog extends StatelessWidget {
  final TestPrerequisiteCheck prerequisiteCheck;

  const PrerequisiteCheckDialog({super.key, required this.prerequisiteCheck});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        clipBehavior: Clip.none,
        constraints: BoxConstraints(maxWidth: 640, maxHeight: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main content with image and text
            Expanded(
              child: Row(
                children: [
                  // Left side - Image with orange background
                  Container(
                    clipBehavior: Clip.none,
                    width: 240,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xffFF8C00),
                          Color(0xffFFDD00),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none, // Allow overflow to be visible
                      children: [
                        Positioned(
                          left: -53,
                          top: 27,
                          child: Image.asset(
                            prerequisiteCheck.imagePath,
                            width: 295,
                            height: 360,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right side - Text content
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Test name/title
                          Text(
                            prerequisiteCheck.title,
                            style: AppTypography.largeTitle(
                              color: Colors.black,
                              weight: AppTypographyWeight.medium,
                            ),
                          ),

                          const SizedBox(height: 44),

                          // Question
                          Text(
                            prerequisiteCheck.question,
                            style: AppTypography.body(
                              color: Colors.black,
                              weight: AppTypographyWeight.semibold,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Description
                          Text(
                            prerequisiteCheck.description,
                            style: AppTypography.body(
                              color: Colors.black,
                              weight: AppTypographyWeight.regular,
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: AusaButton(
                                  text: prerequisiteCheck.secondaryButtonText,
                                  size: ButtonSize.lg,
                                  onPressed: () {
                                    // For blood glucose, secondary button "No" means they can proceed
                                    // For other tests, secondary button means "don't proceed" or "take later"
                                    bool canProceed =
                                        !prerequisiteCheck
                                            .primaryButtonMeansCanProceed;
                                    Get.back(result: canProceed);
                                  },
                                  variant: ButtonVariant.secondary,
                                  borderColor: AppColors.primary700,
                                  textColor: AppColors.primary700,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: AusaButton(
                                  size: ButtonSize.lg,
                                  onPressed: () {
                                    // Return based on what the primary button means for this test
                                    Get.back(
                                      result:
                                          prerequisiteCheck
                                              .primaryButtonMeansCanProceed,
                                    );
                                  },
                                  variant: ButtonVariant.primary,
                                  backgroundColor: AppColors.primary700,
                                  textColor: Colors.white,
                                  text: prerequisiteCheck.primaryButtonText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
