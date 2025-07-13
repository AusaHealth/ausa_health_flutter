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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 600, maxHeight: 350),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main content with image and text
            Expanded(
              child: Row(
                children: [
                  // Left side - Image with orange background
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.orange.shade400,
                          Colors.orange.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Image.asset(
                          prerequisiteCheck.imagePath,
                          width: 300,
                          height: 300,
                          fit: BoxFit.contain,
                        ),
                      ),
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

                          const SizedBox(height: 24),

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

                          const SizedBox(height: 20),

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
