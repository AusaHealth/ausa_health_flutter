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
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main content with image and text
            Expanded(
              child: Row(
                children: [
                  // Left side - Image with orange background
                  Container(
                    width: 250,
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
                            style: AppTypography.headline(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade900,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Question
                          Text(
                            prerequisiteCheck.question,
                            style: AppTypography.callout(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Description
                          Text(
                            prerequisiteCheck.description,
                            style: AppTypography.callout(
                              color: Colors.grey.shade600,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: AusaButton(
                                  text: prerequisiteCheck.secondaryButtonText,
                                  onPressed: () {
                                    // For blood glucose, secondary button "No" means they can proceed
                                    // For other tests, secondary button means "don't proceed" or "take later"
                                    bool canProceed =
                                        !prerequisiteCheck
                                            .primaryButtonMeansCanProceed;
                                    Get.back(result: canProceed);
                                  },
                                  variant: ButtonVariant.secondary,
                                  borderRadius: 25,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: AusaButton(
                                  onPressed: () {
                                    // Return based on what the primary button means for this test
                                    Get.back(
                                      result:
                                          prerequisiteCheck
                                              .primaryButtonMeansCanProceed,
                                    );
                                  },
                                  variant: ButtonVariant.primary,
                                  borderRadius: 25,
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
