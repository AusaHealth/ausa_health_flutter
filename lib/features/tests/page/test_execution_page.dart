import 'package:ausa/common/enums/test_status.dart';
import 'package:ausa/common/model/test.dart';
import 'package:ausa/common/widget/base_scaffold.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/tests/controller/test_controller.dart';
import 'package:ausa/features/tests/model/test_prerequisites.dart';
import 'package:ausa/features/tests/page/test_interrupted_page.dart';
import 'package:ausa/features/tests/widget/animated_test_timer.dart';
import 'package:ausa/features/tests/widget/ecg_timer_widgets.dart';
import 'package:ausa/features/tests/widget/prerequisite_check_dialog.dart';
import 'package:ausa/features/tests/widget/subtype_selection_dialog.dart';
import 'package:ausa/features/tests/widget/test_image_display.dart';
import 'package:ausa/features/tests/widget/test_instructions_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

/// Visual progress indicator for multi-select groups (Body Sounds, ENT).
class _GroupStepper extends StatelessWidget {
  final int total;
  final int index;

  const _GroupStepper({required this.total, required this.index});

  @override
  Widget build(BuildContext context) {
    if (total <= 1) return const SizedBox.shrink();

    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Get.find<TestController>().currentTest?.name ?? '',
            style: AppTypography.body(
              color: Colors.white,
              weight: AppTypographyWeight.medium,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(total, (i) {
              final bool active = i <= index;
              return Expanded(
                child: Container(
                  // width: 28,
                  height: 4,
                  margin: EdgeInsets.only(right: i < total - 1 ? 6 : 0),
                  decoration: BoxDecoration(
                    color: active ? AppColors.accent : Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

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

  // ---------------- ECG 6-Lead stepper state ----------------
  TestType? _previousTestType; // Track when the current test changes
  int _ecgStepIndex = 0; // 0-based index of the current ECG step (0-2)
  bool _ecgStepCompleted = false; // Has the timer finished for this step?

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
      controller.markDialogsAsShown();
      setState(() {});
      return;
    }

    final needsSubType =
        currentTest.hasSubTypes && currentTest.selectedSubTypeIds.isEmpty;
    final needsPrerequisites = currentTest.hasPrerequisites;
    if (!needsSubType && !needsPrerequisites) {
      _allDialogsCompleted = true;
      controller.markDialogsAsShown();
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
    debugPrint('[DEBUG] showTestDialogs for ${controller.currentTest?.type}');

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

    // 1. Sub-type selection (if required)
    if (currentTest.hasSubTypes && currentTest.selectedSubTypeIds.isEmpty) {
      final selectedIds = await Get.dialog<List<String>>(
        SubTypeSelectionDialog(test: currentTest),
        barrierDismissible: false,
      );

      if (selectedIds == null || selectedIds.isEmpty) {
        // User cancelled selection – abort session.
        _isShowingDialogs = false;
        _allDialogsCompleted = false;
        setState(() {});
        await controller.skipCurrentTest();
        // Continue flow with next test instead of cancelling session.
        return;
      }

      controller.selectTestSubTypes(currentTest, selectedIds);
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
          await controller.skipCurrentTest();
          // Continue with next test.
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

  void _handleCancel() {
    // Interrupt current test and navigate to interruption screen.
    controller.interruptCurrentTest();
    // Replace the current execution page with the interruption screen so the
    // old page (and its reactive listeners) are disposed. This prevents
    // hidden dialogs appearing behind new screens.
    Get.off(() => TestInterruptedPage());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Reset ECG stepper when navigating to a new test --------------------
      if (controller.currentTest?.type != _previousTestType) {
        _previousTestType = controller.currentTest?.type;
        _ecgStepIndex = 0;
        _ecgStepCompleted = false;
      }

      if (controller.currentTest == null) {
        // Empty state – simple scaffold
        return BaseScaffold(
          body: Column(
            children: [
              _buildHeader(),
              const Expanded(child: Center(child: Text('No test available'))),
            ],
          ),
        );
      }

      final test = controller.currentTest!;

      // Determine AR usage
      final bool usesArDuring =
          test.arUsage == ARUsageType.duringTestOnly ||
          test.arUsage == ARUsageType.both;
      final bool usesArInstructions =
          test.arUsage == ARUsageType.instructionsOnly ||
          test.arUsage == ARUsageType.both;

      final bool isReadyState =
          controller.currentTestStatus == TestStatus.ready ||
          controller.currentTestStatus == TestStatus.requested;
      final bool isRunningState =
          controller.currentTestStatus == TestStatus.started ||
          controller.currentTestStatus == TestStatus.completed;

      final bool showFullScreenAr =
          (usesArDuring && isRunningState) ||
          (usesArInstructions && isReadyState);

      // Decide background widget
      final Widget? backgroundWidget =
          showFullScreenAr
              ? Image.asset('assets/sample/ar.jpg', fit: BoxFit.cover)
              : null;

      Widget content;
      switch (controller.currentTestStatus) {
        case TestStatus.ready:
        case TestStatus.requested:
          content = _buildTestReady();
          break;
        case TestStatus.started:
        case TestStatus.completed:
          content = _buildTestInProgress();
          break;
        default:
          content = const Center(child: CircularProgressIndicator());
      }

      return BaseScaffold(
        background: backgroundWidget,
        backgroundColor: showFullScreenAr ? Colors.black : AppColors.gray50,
        body: Column(children: [_buildHeader(), Expanded(child: content)]),
      );
    });
  }

  // ---------------------------------------------------------------------------
  /// Lightweight header that replaces `AppBackHeader`.
  /// Shows a back button and either the test name or the group stepper.
  Widget _buildHeader() {
    return Obx(() {
      final ctrl = controller;
      final bool isEcg6Lead = ctrl.currentTest?.type == TestType.ecg6Lead;
      final bool showGroupStepper = ctrl.isCurrentGroupMultiSelect;
      final bool showStepper = showGroupStepper || isEcg6Lead;
      final bool isTestStarted =
          ctrl.currentTestStatus == TestStatus.started ||
          ctrl.currentTestStatus == TestStatus.completed;

      Widget titleWidget;
      if (showStepper) {
        if (showGroupStepper) {
          titleWidget = _GroupStepper(
            total: ctrl.currentGroupStepTotal,
            index: ctrl.currentGroupStepIndex,
          );
        } else {
          // ECG 6-Lead internal 3-step flow
          titleWidget = _GroupStepper(total: 3, index: _ecgStepIndex);
        }
      } else {
        titleWidget = Text(
          ctrl.currentTest?.name ?? 'Your Tests',
          style: AppTypography.headline(),
        );
      }

      return Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Back button - only show when test is not started
            if (!isTestStarted) ...[
              GestureDetector(
                onTap: () => {controller.resetSelections(), Get.back()},
                child: Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    AusaIcons.chevronLeft,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
            titleWidget,
          ],
        ),
      );
    });
  }

  Widget _buildTestReady() {
    final test = controller.currentTest!;

    // Determine if AR should be shown based on arUsage
    final bool usesAR =
        test.arUsage == ARUsageType.instructionsOnly ||
        test.arUsage == ARUsageType.both;

    return Stack(
      children: [
        // Foreground controls / content
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!usesAR)
                      Expanded(
                        child: Image.asset(
                          controller.currentTest!.image,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_allDialogsCompleted && !controller.shouldShowDialogs)
                    AusaButton(
                      text: 'Start Test',
                      onPressed: () => controller.startCurrentTest(),
                      variant: ButtonVariant.primary,
                      size: ButtonSize.lg,
                    ),
                ],
              ),
            ],
          ),
        ),

        // Instructions button positioned at bottom left, outside layout flow
        if (_allDialogsCompleted && !controller.shouldShowDialogs)
          Positioned(bottom: 16, left: 16, child: _buildInstructionsButton()),

        // Inline Next button for multi-select group flow (after completion)
        Obx(() {
          if (!controller.awaitingNextInGroup) return const SizedBox.shrink();

          final nextName = controller.nextTestInGroup?.name ?? 'Next';
          return Positioned(
            bottom: 26,
            right: 24,
            child: Row(
              children: [
                AusaButton(
                  text: 'Cancel',
                  onPressed: () => _handleCancel(),
                  variant: ButtonVariant.secondary,
                  borderColor: AppColors.primary700,
                  textColor: AppColors.primary700,
                  size: ButtonSize.lg,
                ),
                const SizedBox(width: 16),
                AusaButton(
                  text: 'Next: $nextName',
                  onPressed: () => controller.continueToNextInGroup(),
                  variant: ButtonVariant.primary,
                  size: ButtonSize.lg,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  /// Bottom-right control row shown during in-progress tests.
  Widget _buildBottomControls() {
    // Special handling for ECG 6-Lead internal 3-step flow ------------------
    if (controller.currentTest?.type == TestType.ecg6Lead &&
        _ecgStepIndex < 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AusaButton(
            text: 'Cancel',
            size: ButtonSize.lg,
            onPressed: () => _handleCancel(),
            variant: ButtonVariant.secondary,
            borderColor: AppColors.primary700,
            textColor: AppColors.primary700,
          ),
          const SizedBox(width: 16),
          AusaButton(
            text: 'Next Step',
            onPressed:
                _ecgStepCompleted
                    ? () {
                      setState(() {
                        _ecgStepIndex++;
                        _ecgStepCompleted = false;
                      });
                    }
                    : null,
            variant: ButtonVariant.primary,
            size: ButtonSize.lg,
            isEnabled: _ecgStepCompleted,
          ),
        ],
      );
    }

    // If session completed – show Finish button
    if (controller.isSessionCompleted) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AusaButton(
            text: 'Cancel',
            size: ButtonSize.lg,
            onPressed: () => _handleCancel(),
            variant: ButtonVariant.secondary,
            borderColor: AppColors.primary700,
            textColor: AppColors.primary700,
          ),
          const SizedBox(width: 16),
          AusaButton(
            text: 'Finish',
            onPressed: () => controller.navigateToResults(),
            variant: ButtonVariant.primary,
            size: ButtonSize.lg,
          ),
        ],
      );
    }

    // If this is the last test (no further tests after the current one) and the
    // overall session has not yet been marked as completed, we want to show a
    // disabled "Finish" button (instead of "Next Test"). Once the test
    // finishes, `isSessionCompleted` will flip to true and the block above
    // will take precedence, enabling the button.

    final bool isLastTestRunning =
        controller.isLastTestInSession && !controller.isSessionCompleted;

    if (isLastTestRunning) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AusaButton(
            text: 'Cancel',
            size: ButtonSize.lg,
            onPressed: () => _handleCancel(),
            variant: ButtonVariant.secondary,
            borderColor: AppColors.primary700,
            textColor: AppColors.primary700,
          ),
          const SizedBox(width: 16),
          AusaButton(
            text: 'Finish',
            onPressed: null,
            variant: ButtonVariant.primary,
            size: ButtonSize.lg,
            isEnabled: false,
          ),
        ],
      );
    }

    // If there are more tests queued after the current one, continue with
    // existing logic.
    final bool hasNextTest = controller.currentSession?.hasMoreTests ?? false;

    if (!hasNextTest && !controller.isSessionCompleted) {
      // Fallback safety: should not be reached due to isLastTestRunning but
      // retained for robustness.
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AusaButton(
            text: 'Cancel',
            size: ButtonSize.lg,
            onPressed: () => _handleCancel(),
            variant: ButtonVariant.secondary,
            borderColor: AppColors.primary700,
            textColor: AppColors.primary700,
          ),
          const SizedBox(width: 16),
          AusaButton(
            text: 'Finish',
            onPressed: null,
            variant: ButtonVariant.primary,
            size: ButtonSize.lg,
            isEnabled: false,
          ),
        ],
      );
    }

    final bool isMulti =
        controller.isCurrentGroupMultiSelect ||
        (controller.currentTest != null
            ? _isBodySoundOrEntTest(controller.currentTest!.type)
            : false);

    if (isMulti) {
      // Determine label
      final bool waitingGroup = controller.awaitingNextInGroup;

      final String? nextSame = controller.nextTestSameGroup?.name;
      // Always show the concrete upcoming test name (if available) so users
      // know what is coming next.
      final String nextLabel =
          (nextSame != null && nextSame.isNotEmpty)
              ? 'Next: $nextSame'
              : 'Next Test';

      // For body sounds and ENT tests, always enable the Next button
      // since there's no timer - user can press Next anytime
      final bool nextEnabled = true;

      return Row(
        children: [
          AusaButton(
            text: 'Cancel',
            size: ButtonSize.lg,
            onPressed: () => _handleCancel(),
            variant: ButtonVariant.secondary,
            borderColor: AppColors.primary700,
            textColor: AppColors.primary700,
          ),
          const SizedBox(width: 16),
          AusaButton(
            text: nextLabel,
            onPressed: () {
              if (waitingGroup) {
                controller.continueToNextInGroup();
              } else {
                controller.continueToNextSingle();
              }
            },
            variant: ButtonVariant.primary,
            size: ButtonSize.lg,
            isEnabled: nextEnabled,
          ),
        ],
      );
    }

    // Non-multi-select flow --------------------------------------------------
    final bool nextEnabled =
        controller.awaitingNextSingle &&
        controller.currentTestStatus == TestStatus.completed;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AusaButton(
          text: 'Cancel',
          size: ButtonSize.lg,
          onPressed: () => _handleCancel(),
          variant: ButtonVariant.secondary,
          borderColor: AppColors.primary700,
          textColor: AppColors.primary700,
        ),
        const SizedBox(width: 16),
        AusaButton(
          text: 'Next Test',
          onPressed:
              nextEnabled ? () => controller.continueToNextSingle() : null,
          variant: ButtonVariant.primary,
          size: ButtonSize.lg,
          isEnabled: nextEnabled,
        ),
      ],
    );
  }

  Widget _buildInstructionsButton() {
    return TestInstructionsWidget(
      test: controller.currentTest!,
      onClose: () => controller.startCurrentTest(),
    );
  }

  Widget _buildTestInProgress() {
    final test = controller.currentTest!;
    final bool usesArDuring =
        test.arUsage == ARUsageType.duringTestOnly ||
        test.arUsage == ARUsageType.both;

    // Check if this is a body sounds or ENT test (either as individual or multi-select)
    final bool isMultiSelectTest =
        controller.isCurrentGroupMultiSelect ||
        _isBodySoundOrEntTest(test.type);

    // Helper to build the animated timer with ECG stepper awareness
    Widget buildTimerWidget() {
      // Use specialized ECG timers for ECG tests
      if (test.type == TestType.ecg2Lead) {
        return Ecg2LeadTimerWidget(
          key: ValueKey('${controller.currentTest?.type}_$_ecgStepIndex'),
          duration: 5,
          completedWidget: const Icon(Icons.check, color: Colors.green),
          onCompleted: () {
            controller.completeCurrentTestWithMockResult();
          },
        );
      } else if (test.type == TestType.ecg6Lead) {
        return Ecg6LeadTimerWidget(
          key: ValueKey('${controller.currentTest?.type}_$_ecgStepIndex'),
          duration: 5,
          currentStep: _ecgStepIndex,
          completedWidget: const Icon(Icons.check, color: Colors.green),
          onCompleted: () {
            if (_ecgStepIndex < 2) {
              // Mark current step finished – wait for user to press "Next Step"
              setState(() {
                _ecgStepCompleted = true;
              });
            } else {
              // Regular completion flow
              controller.completeCurrentTestWithMockResult();
            }
          },
        );
      } else {
        // Use default timer for other tests
        return AnimatedTestTimerWidget(
          key: ValueKey('${controller.currentTest?.type}_$_ecgStepIndex'),
          duration: 2,
          centerWidget: Image.asset(test.image),
          completedWidget: const Icon(Icons.check, color: Colors.green),
          onCompleted: () {
            if (test.type == TestType.ecg6Lead && _ecgStepIndex < 2) {
              // Mark current step finished – wait for user to press "Next Step"
              setState(() {
                _ecgStepCompleted = true;
              });
            } else {
              // Regular completion flow
              controller.completeCurrentTestWithMockResult();
            }
          },
        );
      }
    }

    // Helper to build the image display widget for body sounds and ENT tests
    Widget buildImageDisplayWidget() {
      return TestImageDisplayWidget(
        key: ValueKey('${controller.currentTest?.type}_$_ecgStepIndex'),
        imagePath: test.image,
        width: 200,
        height: 200,
      );
    }

    if (usesArDuring) {
      // ---------------- Full-screen AR preview --------------------------
      return Stack(
        children: [
          // (Stepper removed – now part of header)

          // Timer or Image Display (top-right)
          Positioned(
            top: 16,
            right: 27,
            child: SizedBox(
              width: test.type == TestType.ecg6Lead ? 160 : 300,
              child:
                  isMultiSelectTest
                      ? buildImageDisplayWidget()
                      : buildTimerWidget(),
            ),
          ),

          // Bottom controls (Cancel / Next or Stop)
          Positioned(
            bottom: 16,
            right: 16,
            child: Obx(() => _buildBottomControls()),
          ),
        ],
      );
    }

    // ---------------- Standard (non-AR) layout --------------------------
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.gray50,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child:
                  isMultiSelectTest
                      ? buildImageDisplayWidget()
                      : buildTimerWidget(),
            ),
          ),

          // Unified bottom controls for non-AR layout
          Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() => _buildBottomControls()),
          ),
        ],
      ),
    );
  }

  // Helper method to check if a test is a body sound or ENT test
  bool _isBodySoundOrEntTest(TestType testType) {
    return testType == TestType.bodySoundHeart ||
        testType == TestType.bodySoundLungs ||
        testType == TestType.bodySoundStomach ||
        testType == TestType.bodySoundBowel ||
        testType == TestType.entEar ||
        testType == TestType.entNose ||
        testType == TestType.entThroat;
  }

  @override
  void dispose() {
    // Dispose the worker to prevent multiple listeners accumulating
    _dialogWorker.dispose();
    super.dispose();
  }
}
