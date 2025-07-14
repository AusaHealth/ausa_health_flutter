import 'package:ausa/common/widget/app_back_header.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/features/tests/controller/test_controller.dart';
import 'package:ausa/features/teleconsultation/widget/animated_test_timer.dart';
import 'package:ausa/common/enums/test_status.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/features/tests/widget/category_selection_dialog.dart';
import 'package:ausa/features/tests/widget/prerequisite_check_dialog.dart';
import 'package:ausa/features/tests/widget/test_instructions_widget.dart';
import 'package:ausa/features/tests/model/test_prerequisites.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestExecutionPage extends StatefulWidget {
  const TestExecutionPage({super.key});

  @override
  State<TestExecutionPage> createState() => _TestExecutionPageState();
}

class _TestExecutionPageState extends State<TestExecutionPage> {
  final TestController controller = Get.find<TestController>();
  bool _isShowingDialogs = false;
  bool _pendingDialogRequest =
      false; // Track if a dialog request came in while another is active
  bool _allDialogsCompleted =
      false; // Track if all required dialogs are completed
  late Worker
  _dialogWorker; // Worker to manage the ever listener and dispose properly

  @override
  void initState() {
    super.initState();

    // Kick-off dialog flow if needed once the first frame is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowDialogs();
    });

    // Listen for changes so we can trigger dialogs for subsequent tests.
    _dialogWorker = ever(controller.shouldShowDialogsRx, (bool shouldShow) {
      if (shouldShow) {
        _checkAndShowDialogs();
      }
    });
  }

  void _checkAndShowDialogs() {
    // Reset dialog completion state for new test
    _allDialogsCompleted = false;

    // Check if current test needs any dialogs
    final currentTest = controller.currentTest;
    if (currentTest == null) {
      _allDialogsCompleted = true;
      setState(() {});
      return;
    }

    final needsCategory =
        currentTest.hasCategories && currentTest.selectedCategory == null;
    final needsPrerequisites = currentTest.hasPrerequisites;

    // If no dialogs are needed, mark as completed immediately
    if (!needsCategory && !needsPrerequisites) {
      _allDialogsCompleted = true;
      setState(() {});
      return;
    }

    // If dialogs are needed, show them (keep _allDialogsCompleted = false)
    setState(() {});
    if (controller.shouldShowDialogs) {
      _showTestDialogs();
    }
  }

  Future<void> _showTestDialogs() async {
    // If a dialog is already being presented, simply mark that another request
    // is pending and return. When the current sequence completes, we'll check
    // this flag and immediately process the queued request without spinning
    // the micro-task loop that could starve the UI thread.
    if (_isShowingDialogs) {
      _pendingDialogRequest = true;
      return;
    }

    // Guard clauses – return early if dialogs are not required or we are not
    // in a valid state to present them.
    if (!controller.shouldShowDialogs || controller.currentTest == null) {
      return;
    }

    // Ensure we are still in the correct state to present dialogs.
    if (controller.currentTestStatus != TestStatus.ready) {
      return;
    }

    // Lock so no other sequence can start while this one is active.
    _isShowingDialogs = true;
    // Immediately mark the dialogs as handled to prevent re-triggers while this sequence is in progress.
    controller.markDialogsAsShown();

    final currentTest = controller.currentTest!;

    // 1. Category selection (if required)
    if (currentTest.hasCategories && currentTest.selectedCategory == null) {
      final selectedCategory = await Get.dialog<String>(
        CategorySelectionDialog(test: currentTest),
        barrierDismissible: false,
      );

      if (selectedCategory == null) {
        // User cancelled category selection – abort session.
        _isShowingDialogs = false;
        _allDialogsCompleted = false;
        setState(() {});
        controller.cancelSession();
        // A session cancel means no further dialogs will be needed.
        return;
      }

      // Update the test with the selected category.
      controller.selectTestCategory(currentTest, selectedCategory);
    }

    // 2. Prerequisite check (if required)
    if (controller.currentTest!.hasPrerequisites) {
      final prerequisiteCheck =
          TestPrerequisitesFactory.getPrerequisiteCheckForTest(
            controller.currentTest!.type,
          );

      if (prerequisiteCheck != null) {
        final prereqsMet = await Get.dialog<bool>(
          PrerequisiteCheckDialog(prerequisiteCheck: prerequisiteCheck),
          barrierDismissible: false,
        );

        if (prereqsMet != true) {
          // Prerequisites not met – abort session.
          _isShowingDialogs = false;
          _allDialogsCompleted = false;
          setState(() {});
          controller.cancelSession();
          // No further dialogs in this session.
          return;
        }
      }
    }

    // All required dialogs completed successfully
    _allDialogsCompleted = true;
    // Unlock – dialog sequence finished.
    _isShowingDialogs = false;
    setState(() {});

    // Process any queued dialog request.
    if (_pendingDialogRequest) {
      _pendingDialogRequest = false;
      // Defer to the next frame to ensure the previous dialog stack has been
      // fully dismissed before we start a new sequence.
      WidgetsBinding.instance.addPostFrameCallback((_) => _showTestDialogs());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: Column(
        children: [
          Obx(
            () => AppBackHeader(
              title: controller.currentTest?.name ?? 'Your Tests',
              onBackPressed: () => controller.cancelSession(),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.currentTest == null) {
                return const Center(child: Text('No test available'));
              }

              switch (controller.currentTestStatus) {
                case TestStatus.ready:
                case TestStatus.requested:
                  return _buildTestReady();
                case TestStatus.started:
                case TestStatus.completed:
                  return _buildTestInProgress();
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTestReady() {
    final test = controller.currentTest!;

    // Determine if AR should be shown
    bool usesAR = test.usesAR;
    if (!usesAR && test.selectedCategory != null && test.categories != null) {
      final matchedCat = test.categories!.firstWhere(
        (c) => c.id == test.selectedCategory,
        orElse: () => test.categories!.first,
      );
      usesAR = matchedCat.metadata?['usesAR'] == true;
    }

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (usesAR)
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          // height: 200,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'AR View Placeholder',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: Image.asset(
                          controller.currentTest!.image,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 32),

                    if (controller.currentTest!.selectedCategory != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary700.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary700.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          'Category: ${controller.currentTest!.selectedCategory}',
                          style: AppTypography.callout(
                            color: AppColors.primary700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_allDialogsCompleted)
                    AusaButton(
                      text: 'Start Test',
                      onPressed: () => controller.startCurrentTest(),
                      variant: ButtonVariant.primary,
                    ),
                ],
              ),
            ],
          ),
        ),

        // Instructions button positioned at bottom left, outside layout flow
        if (_allDialogsCompleted)
          Positioned(bottom: 16, left: 16, child: _buildInstructionsButton()),
      ],
    );
  }

  Widget _buildInstructionsButton() {
    return TestInstructionsWidget(test: controller.currentTest!);
  }

  Widget _buildTestInProgress() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.gray50,
      child: Column(
        children: [
          // const Spacer(),
          Expanded(
            flex: 1,
            child: AnimatedTestTimerWidget(
              duration: 10,
              centerWidget: Image.asset(controller.currentTest!.image),
              completedWidget: const Icon(Icons.check, color: Colors.green),
              onCompleted: () {
                // Complete the current test with mock result
                // The controller will handle showing the "continue to next test" dialog
                controller.completeCurrentTestWithMockResult();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Only show stop button when test is in progress, not completed
                Obx(
                  () =>
                      controller.currentTestStatus == TestStatus.started
                          ? AusaButton(
                            onPressed: () => controller.cancelCurrentTest(),
                            variant: ButtonVariant.primary,
                            backgroundColor: Colors.orange,
                            textColor: Colors.white,
                            text: "Stop Test",
                          )
                          : const SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the worker to prevent multiple listeners accumulating
    _dialogWorker.dispose();
    super.dispose();
  }
}
