import 'package:ausa/common/widget/base_scaffold.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/tests/controller/test_controller.dart';
import 'package:ausa/features/tests/page/test_execution_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Page shown when the user interrupts (cancels) a test mid-flow. It offers
/// two choices:
/// 1. Retry – restart the same test while keeping existing session context.
/// 2. Next / Finish – skip the current test and move on. If this was the last
///    test in the queue we replace the primary action label with *Finish* so
///    users can end the session.
class TestInterruptedPage extends StatelessWidget {
  TestInterruptedPage({super.key});

  final TestController _controller = Get.find<TestController>();

  @override
  Widget build(BuildContext context) {
    final bool isLastTest = _controller.isLastTestInSession;
    final String testName = _controller.currentTest?.name ?? '';

    return BaseScaffold(
      backgroundColor: AppColors.gray50,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.error50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.accent,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Test Interrupted',
                  style: AppTypography.headline(color: AppColors.accent),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'The $testName test was interrupted before completion.',
                  style: AppTypography.body(color: AppColors.gray600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AusaButton(
                      text: 'Retry',
                      onPressed: () {
                        // Restart the same test and return to execution page.
                        _controller.restartCurrentTest();
                        Get.off(() => const TestExecutionPage());
                      },
                      variant: ButtonVariant.secondary,
                      size: ButtonSize.lg,
                    ),
                    const SizedBox(width: 24),
                    AusaButton(
                      text: isLastTest ? 'Finish' : 'Next Test',
                      onPressed: () async {
                        if (isLastTest) {
                          // Complete the session and go straight to the
                          // results screen – no additional reading should be
                          // created.
                          _controller.forceCompleteSession();
                          _controller.navigateToResults();
                        } else {
                          // Skip the interrupted test and continue with the
                          // remaining queue.
                          await _controller.skipCurrentTest();
                          Get.off(() => const TestExecutionPage());
                        }
                      },
                      variant: ButtonVariant.primary,
                      size: ButtonSize.lg,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
