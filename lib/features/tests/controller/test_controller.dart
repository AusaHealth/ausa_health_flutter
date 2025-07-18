import 'package:ausa/common/enums/test_status.dart';
import 'package:ausa/common/model/test.dart';
import 'package:ausa/common/model/test_error.dart';
import 'package:ausa/common/enums/test_error_type.dart';
import 'package:ausa/constants/test_definitions.dart';
import 'package:ausa/features/tests/model/test_session.dart';
import 'package:ausa/features/tests/model/test_result.dart';
import 'package:ausa/features/tests/model/test_prerequisites.dart';
import 'package:ausa/features/tests/page/test_selection_page.dart';
import 'package:ausa/features/tests/page/test_execution_page.dart';
import 'package:ausa/features/tests/page/test_results_page.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:ausa/features/tests/model/test_group.dart';
import 'package:ausa/features/tests/widget/subtype_selection_dialog.dart';
import 'package:ausa/features/tests/widget/prerequisite_check_dialog.dart';

class TestController extends GetxController {
  // Test Selection State
  final RxList<Test> _availableTests = <Test>[].obs;
  final RxList<Test> _selectedTests = <Test>[].obs;
  final RxBool _isLoading = false.obs;

  // Test Session State
  final Rx<TestSession?> _currentSession = Rx<TestSession?>(null);
  final Rx<TestStatus> _currentTestStatus = Rx<TestStatus>(TestStatus.none);
  final Rx<Test?> _currentTest = Rx<Test?>(null);
  final Rx<TestError?> _currentTestError = Rx<TestError?>(null);

  // Flag to trigger dialogs on test execution page
  // Starts as `false` and will be toggled to `true` by `_moveToNextTest` when
  // the UI is ready to present the category / prerequisite dialogs.
  final RxBool _shouldShowDialogs = false.obs;

  // Prerequisites State
  final RxBool _prerequisitesMet = false.obs;

  // Results State
  final RxList<TestResult> _sessionResults = <TestResult>[].obs;
  final RxList<TestResult> _allResults = <TestResult>[].obs;

  // Mock Data State
  final RxBool _useMockData = true.obs;
  final RxBool _demoMode = true.obs;

  // Group Selection State (new flow)
  final RxList<TestGroup> _availableGroups = <TestGroup>[].obs;
  final RxList<TestGroup> _selectedGroups = <TestGroup>[].obs;
  final Rx<TestGroup?> _currentGroup = Rx<TestGroup?>(null);

  // ----- Multi-select group inline-flow state -----------------------------------------------
  final RxBool _awaitingNextInGroup =
      false.obs; // true when user must tap "Next: ..."
  Test? _nextTestInGroup; // cached next test while waiting
  final Rx<Test?> _nextTestSameGroup = Rx<Test?>(null);

  // Session completion flag (UI shows Finish button instead of auto-nav)
  final RxBool _sessionCompleted = false.obs;

  // ----- Single-select flow state (replaces legacy next-test dialog) -------
  final RxBool _awaitingNextSingle = false.obs;
  Test? _nextTestSingle;

  // Getters
  List<Test> get availableTests => _availableTests;
  List<Test> get selectedTests => _selectedTests;
  bool get isLoading => _isLoading.value;

  // Multi-select helpers
  bool get awaitingNextInGroup => _awaitingNextInGroup.value;
  Test? get nextTestInGroup => _nextTestInGroup;
  Test? get nextTestSameGroup => _nextTestSameGroup.value;

  bool get awaitingNextSingle => _awaitingNextSingle.value;
  Test? get nextTestSingle => _nextTestSingle;

  bool get isSessionCompleted => _sessionCompleted.value;

  /// True when the currently running/ready test is the final one remaining
  /// in the session. This is derived by comparing the total number of tests
  /// queued in the session against the number of results that have already
  /// been collected. We deliberately use the reactive `_sessionResults` list
  /// so that the UI rebuilds automatically when a test completes and a new
  /// result is pushed.
  bool get isLastTestInSession {
    // Requires an active session and a current test.
    if (currentSession == null || currentTest == null) return false;

    // Locate the index of the current test within the session queue. Because
    // concrete `Test` instances are unique (they are mutated copies, not the
    // shared `TestDefinitions` objects) we can rely on object identity.
    final idx = currentSession!.tests.indexOf(currentTest!);

    // If for some reason the test is not found (should never happen), fall
    // back to conservative `false` to avoid prematurely showing Finish.
    if (idx == -1) return false;

    return idx == currentSession!.tests.length - 1;
  }

  // -------------------------------------------------------------------------------------------------
  // Standard getters that were inadvertently removed in the previous refactor -----------------------
  TestSession? get currentSession => _currentSession.value;
  TestStatus get currentTestStatus => _currentTestStatus.value;
  Test? get currentTest => _currentTest.value;
  TestError? get currentTestError => _currentTestError.value;

  bool get shouldShowDialogs => _shouldShowDialogs.value;
  RxBool get shouldShowDialogsRx => _shouldShowDialogs;

  bool get prerequisitesMet => _prerequisitesMet.value;

  List<TestResult> get sessionResults => _sessionResults;
  List<TestResult> get allResults => _allResults;

  bool get useMockData => _useMockData.value;
  bool get demoMode => _demoMode.value;

  // Getters for new flow (group selection)
  List<TestGroup> get availableGroups => _availableGroups;
  List<TestGroup> get selectedGroups => _selectedGroups;

  // Indicates we are inside a multi-select group (Body Sounds, ENT) and that
  // more than one concrete test exists for the group.
  bool get isCurrentGroupMultiSelect {
    if (currentTest == null) return false;
    return TestGroupFactory.isMultiSelectGroup(currentTest!.group) &&
        currentSession != null &&
        currentSession!.tests
                .where((t) => t.group == currentTest!.group)
                .length >
            1;
  }

  int get currentGroupStepIndex {
    if (!isCurrentGroupMultiSelect ||
        currentSession == null ||
        currentTest == null) {
      return 0;
    }
    int idx = 0;
    for (final t in currentSession!.tests) {
      if (t.group == currentTest!.group) {
        if (t.type == currentTest!.type) {
          return idx;
        }
        idx++;
      }
    }
    return 0;
  }

  int get currentGroupStepTotal {
    if (!isCurrentGroupMultiSelect || currentSession == null) return 0;
    return currentSession!.tests
        .where((t) => t.group == currentTest!.group)
        .length;
  }

  TestGroup? get currentGroup => _currentGroup.value;

  // Computed Properties
  int get selectedGroupsCount => _selectedGroups.length;
  bool get hasSelectedGroups => _selectedGroups.isNotEmpty;
  bool get canStartSession => hasSelectedGroups && !isLoading;

  // Compatibility getters for legacy UI components (teleconsutltion page)
  bool get hasSelectedTests => hasSelectedGroups;
  int get selectedTestsCount => selectedGroupsCount;

  double get sessionProgress {
    if (currentSession == null) return 0.0;
    return currentSession!.progress;
  }

  @override
  void onInit() {
    super.onInit();
    _initializeTests();
  }

  void _initializeTests() {
    _availableTests.value = TestDefinitions.availableTests;
    _availableGroups.value = TestGroupFactory.getGroups();
  }

  // Test Selection Methods
  void toggleTestSelection(Test test) {
    // Use test type for comparison instead of object equality
    final index = _selectedTests.indexWhere((t) => t.type == test.type);
    if (index != -1) {
      _selectedTests.removeAt(index);
      // Deselected test
    } else {
      _selectedTests.add(test);
      // Selected test
    }
    _updateTestSelectionState();
    debugSelection(); // Debug selection state
  }

  void _updateTestSelectionState() {
    // Update selection state in available tests
    for (int i = 0; i < _availableTests.length; i++) {
      final test = _availableTests[i];
      final isSelected = _selectedTests.any(
        (selected) => selected.type == test.type,
      );
      if (test.isSelected != isSelected) {
        _availableTests[i] = test.copyWith(isSelected: isSelected);
      }
    }
  }

  void clearSelection() {
    _selectedTests.clear();
    _updateTestSelectionState();
  }

  void selectAllTests() {
    _selectedTests.clear();
    _selectedTests.addAll(_availableTests);
    _updateTestSelectionState();
  }

  // Prerequisites Methods
  Future<bool> checkPrerequisites(Test test) async {
    if (!test.hasPrerequisites) return true;

    final prerequisiteCheck =
        TestPrerequisitesFactory.getPrerequisiteCheckForTest(test.type);

    if (prerequisiteCheck == null) return true;

    final result = await Get.dialog<bool>(
      PrerequisiteCheckDialog(prerequisiteCheck: prerequisiteCheck),
      barrierDismissible: false,
    );

    _prerequisitesMet.value = result ?? false;
    return _prerequisitesMet.value;
  }

  // Session Management Methods
  Future<void> startTestSession() async {
    if (!canStartSession) return;

    _setLoading(true);

    try {
      // Create new session
      final sessionId = _generateSessionId();
      final builtTests = await _buildTestsFromGroups();
      if (builtTests.isEmpty) {
        _setLoading(false);
        return;
      }

      _currentSession.value = TestSession(
        id: sessionId,
        tests: builtTests,
        createdAt: DateTime.now(),
        status: TestSessionStatus.started,
        startedAt: DateTime.now(),
      );

      _sessionResults.clear();
      _sessionCompleted.value = false;
      await _moveToNextTest();

      // Navigate to test execution only if a test is available (e.g., user did
      // not cancel the very first sub-type/prerequisite dialog).
      if (_currentTest.value != null) {
        Get.to(() => TestExecutionPage());
      } else {
        // If no test, reset selections and stay on selection page.
        resetSelections();
      }
    } catch (e) {
      _setCurrentTestError(
        TestError(
          type: TestErrorType.error,
          title: 'Session Start Error',
          message: 'Failed to start test session: $e',
          code: 'SESSION_START_ERROR',
        ),
      );
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _moveToNextTest({bool skipDialogs = false}) async {
    if (currentSession == null) return;

    if (currentSession!.hasMoreTests) {
      final nextTest = currentSession!.nextTest;

      // If the next item is a placeholder for a multi-select group, prompt the
      // user to choose concrete tests *now*, replace the placeholder, and
      // restart this method so the first chosen test becomes currentTest.
      if (nextTest != null &&
          nextTest.isGroupPlaceholder &&
          nextTest.selectedSubTypeIds.isEmpty) {
        final selectedIds = await Get.dialog<List<String>>(
          SubTypeSelectionDialog(test: nextTest),
          barrierDismissible: false,
        );

        if (selectedIds == null || selectedIds.isEmpty) {
          //kip this User cancelled – s group and move on to the next test.
          currentSession!.tests.remove(nextTest);
          if (!currentSession!.hasMoreTests) {
            // Session finished – navigate appropriately.
            _completeSession();
          } else {
            await _moveToNextTest(skipDialogs: skipDialogs);
          }
          return;
        }

        final concrete =
            selectedIds
                .map((id) => TestType.values.byName(id))
                .map((tt) => TestDefinitions.getTestByType(tt))
                .whereType<Test>()
                .toList();

        final idx = currentSession!.tests.indexOf(nextTest);
        if (idx != -1) {
          currentSession!.tests
            ..removeAt(idx)
            ..insertAll(idx, concrete);
        }

        // Restart to load the first concrete test just inserted, maintaining the skipDialogs flag.
        await _moveToNextTest(skipDialogs: skipDialogs);
        return;
      }

      if (nextTest == null) {
        _completeSession();
        return;
      }

      // Reset state for new test
      _currentTest.value = nextTest;
      _currentTestStatus.value = TestStatus.ready;
      _prerequisitesMet.value = false; // Reset prerequisites state
      _currentTestError.value = null; // Clear any previous errors
      _awaitingNextSingle.value = false;
      _nextTestSingle = null;

      // Determine upcoming test in same group for UI preview.
      _nextTestSameGroup.value = null;
      if (currentSession != null && nextTest.group.isNotEmpty) {
        final idx = currentSession!.tests.indexOf(nextTest);
        if (idx != -1 && idx + 1 < currentSession!.tests.length) {
          final upcoming = currentSession!.tests[idx + 1];
          if (upcoming.group == nextTest.group) {
            _nextTestSameGroup.value = upcoming;
          }
        }
      }

      if (!skipDialogs) {
        // Trigger dialogs immediately to ensure Start button isn't briefly visible.
        _shouldShowDialogs.value = true;
      }
    } else {
      _completeSession();
    }
  }

  void _completeSession() {
    if (currentSession == null) return;

    _currentSession.value = currentSession!.copyWith(
      status: TestSessionStatus.completed,
      completedAt: DateTime.now(),
    );

    // Keep the last test data so UI can still show it along with Finish button.
    _currentTestStatus.value = TestStatus.completed;

    // Mark session completed; UI will handle Finish navigation.
    _sessionCompleted.value = true;

    // Do NOT navigate automatically. If no results at all, return to
    // selection page to avoid empty results.
    if (_sessionResults.isEmpty) {
      resetSelections();
      Get.off(() => TestSelectionPage());
    }
  }

  // Test Execution Methods
  Future<void> startCurrentTest() async {
    if (currentTest == null) return;

    _currentTestStatus.value = TestStatus.started;

    // Check if this is a multi-select test (body sounds, ENT) or individual body sound/ENT test
    final bool isMultiSelectTest =
        TestGroupFactory.isMultiSelectGroup(currentTest!.group) ||
        _isBodySoundOrEntTest(currentTest!.type);

    if (isMultiSelectTest) {
      // For multi-select tests, immediately complete without timer
      // since user can press Next anytime
      final result = _generateMockResult(currentTest!);
      _completeCurrentTest(result);
    } else {
      // For demo mode, simulate test execution with timer
      if (demoMode) {
        await _simulateTestExecution();
      }
    }
  }

  Future<void> _simulateTestExecution() async {
    // Capture the test that is being simulated at the time of invocation
    if (currentTest == null) return;
    final Test runningTest = currentTest!;

    final duration = TestDefinitions.getEstimatedDuration(runningTest.type);

    await Future.delayed(Duration(seconds: duration));

    // If the user cancelled the test or started a new one before the delay
    // completes, the currentTest reference will have changed or the status
    // will no longer be `started`. In that case, we silently abort.
    if (_currentTestStatus.value != TestStatus.started ||
        currentTest != runningTest) {
      return;
    }

    // Generate mock result using the captured test instance
    final result = _generateMockResult(runningTest);
    _completeCurrentTest(result);
  }

  void _completeCurrentTest(TestResult result) {
    if (currentSession == null) return;
    // Ensure we only keep the most recent reading for a given test (and
    // sub-category). Any prior results that match the same `testType` and
    // `category` are removed before we add the new one. This prevents extra
    // readings from being logged when a user cancels and then retries the
    // same test.
    _sessionResults.removeWhere(
      (r) => r.testType == result.testType && (r.category == result.category),
    );
    _allResults.removeWhere(
      (r) => r.testType == result.testType && (r.category == result.category),
    );
    currentSession!.results.removeWhere(
      (r) => r.testType == result.testType && (r.category == result.category),
    );

    _sessionResults.add(result);
    _allResults.add(result);

    currentSession!.addResult(result);
    currentSession!.moveToNextTest();

    _currentTestStatus.value = TestStatus.completed;

    // For multi-select tests (body sounds, ENT), immediately set awaiting state
    // since there's no timer - user can press Next anytime
    final completedGroup = _currentTest.value?.group;
    final bool isMultiSelectGroup =
        TestGroupFactory.isMultiSelectGroup(completedGroup ?? '') ||
        _isBodySoundOrEntTest(_currentTest.value!.type);

    if (isMultiSelectGroup) {
      // For multi-select groups, immediately set awaiting state without delay
      if (currentSession!.hasMoreTests) {
        final nextTest = currentSession!.nextTest;
        final bool isSameGroup =
            completedGroup != null &&
            nextTest != null &&
            nextTest.group == completedGroup;

        if (isSameGroup) {
          // Inline flow: wait for the user to tap the inline "Next" button.
          _awaitingNextInGroup.value = true;
          _nextTestInGroup = nextTest;
        } else {
          // Different group – wait for user to tap Next Test button.
          _awaitingNextSingle.value = true;
          _nextTestSingle = nextTest;
        }
      } else {
        _completeSession();
      }
    } else {
      // For non-multi-select tests, use the original timer-based logic
      Future.delayed(Duration(seconds: 2), () {
        if (currentSession!.hasMoreTests) {
          final nextTest = currentSession!.nextTest;
          final bool isSameGroup =
              completedGroup != null &&
              nextTest != null &&
              nextTest.group == completedGroup;

          if (isSameGroup) {
            // Non-multi-select group – advance automatically.
            _moveToNextTest(skipDialogs: true);
          } else {
            // Different group – wait for user to tap Next Test button.
            _awaitingNextSingle.value = true;
            _nextTestSingle = nextTest;
          }
        } else {
          _completeSession();
        }
      });
    }
  }

  /// Called from the execution UI when the user taps the inline
  /// "Next: Test" button during a multi-select group flow.
  Future<void> continueToNextInGroup() async {
    if (!_awaitingNextInGroup.value) return;
    _awaitingNextInGroup.value = false;
    _nextTestInGroup = null;
    // Load the next concrete test without showing dialogs.
    await _moveToNextTest(skipDialogs: true);

    // Immediately begin the test to skip the instructions screen.
    // This applies only to multi-select group flows (Body Sounds, ENT).
    if (currentTest != null) {
      startCurrentTest();
    }
  }

  /// Called from execution UI when user taps "Next Test" in single-select flow.
  Future<void> continueToNextSingle() async {
    if (!_awaitingNextSingle.value) return;
    _awaitingNextSingle.value = false;
    _nextTestSingle = null;
    await _moveToNextTest();
  }

  void cancelCurrentTest() {
    // Mark the test as cancelled and reset relevant state
    _currentTestStatus.value = TestStatus.none;
    _currentTest.value = null;
    _currentTestError.value = null;

    // Cancel any session-specific simulation by changing status (handled in _simulateTestExecution)

    // Clear selections so user starts fresh
    resetSelections();

    // Navigate back to selection screen
    Get.back();
  }

  void cancelSession() {
    if (currentSession != null) {
      _currentSession.value = currentSession!.copyWith(
        status: TestSessionStatus.cancelled,
      );
    }

    _currentTest.value = null;
    _currentTestStatus.value = TestStatus.cancelled;
    _clearSession();

    // Clear any selected tests/categories
    resetSelections();

    // Navigate back to selection
    Get.back();
  }

  // Navigation Methods
  void navigateToTestSelection() {
    resetSelections();
    Get.to(() => TestSelectionPage());
  }

  /// Navigate to the results screen while **replacing** the current page on
  /// the navigation stack. This guarantees that the just-finished execution
  /// page gets disposed (along with its reactive listeners) and therefore
  /// cannot receive events from any subsequent sessions.
  ///
  /// Using `Get.off` instead of `Get.to` fixes the issue where dialog boxes
  /// (sub-type selection / prerequisite checks) from an *old* execution page
  /// were still being triggered when the user tapped “Check Again” or
  /// “Take another Test”. The old page remained in the stack and its
  /// `ever()` worker was reacting to the new session’s `shouldShowDialogs`
  /// flag, causing the dialog to open *behind* the current page. Replacing
  /// the route ensures that only the **active** execution page listens for
  /// dialog events.
  void navigateToResults() {
    Get.off(() => TestResultsPage());
  }

  void retakeTest(TestType testType) {
    // Find the test and add it to selection
    final test = TestDefinitions.getTestByType(testType);
    if (test != null) {
      _selectedTests.clear();
      _selectedTests.add(test);
      _updateTestSelectionState();
      startTestSession();
    }
  }

  void retakeAllTests() {
    if (currentSession == null) return;

    // Clear previous selections
    _selectedGroups.clear();

    final Set<String> groupNames =
        currentSession!.tests.map((t) => t.group).toSet();

    // Map group names back to TestGroup objects
    for (final name in groupNames) {
      final grp = _availableGroups.firstWhereOrNull((g) => g.name == name);
      if (grp != null) _selectedGroups.add(grp);
    }

    // Fallback: if group mapping failed, fall back to legacy test selection
    if (_selectedGroups.isEmpty) {
      _selectedTests.clear();
      _selectedTests.addAll(currentSession!.tests);
      _updateTestSelectionState();
    }

    startTestSession();
  }

  // Mock Data Methods
  TestResult _generateMockResult(Test test) {
    final random = math.Random();
    final now = DateTime.now();

    switch (test.type) {
      case TestType.bloodPressure:
        return TestResultFactory.createBloodPressureResult(
          id: _generateResultId(),
          completedAt: now,
          systolic: 120 + random.nextInt(40),
          diastolic: 80 + random.nextInt(20),
          pulse: 40 + random.nextInt(40),
          meanArterialPressure: 90 + random.nextInt(20),
          category: test.firstSelectedSubTypeId,
        );

      case TestType.bloodGlucoseFasting:
      case TestType.bloodGlucosePostMeal:
        return TestResultFactory.createBloodGlucoseResult(
          id: _generateResultId(),
          completedAt: now,
          glucose: 80.0 + random.nextDouble() * 100,
          heartRate: 60 + random.nextInt(40),
          category:
              test.type == TestType.bloodGlucosePostMeal
                  ? 'post_meal'
                  : 'fasting',
        );

      case TestType.bloodOxygen:
        return TestResultFactory.createBloodOxygenResult(
          id: _generateResultId(),
          completedAt: now,
          oxygenSaturation: 95 + random.nextInt(5),
          pulseRate: 60 + random.nextInt(40),
          pulsePressure: 40 + random.nextInt(30),
          meanArterialPressure: 85 + random.nextInt(20),
          category: test.firstSelectedSubTypeId,
        );

      case TestType.ecg2Lead:
      case TestType.ecg6Lead:
        return TestResultFactory.createEcgResult(
          id: _generateResultId(),
          completedAt: now,
          heartRate: 60 + random.nextInt(40),
          rhythm: random.nextBool() ? 'Normal' : 'Irregular',
          category: test.type == TestType.ecg6Lead ? '6_lead' : '2_lead',
        );

      case TestType.bodySoundHeart:
        return TestResultFactory.createBodySoundResult(
          id: _generateResultId(),
          completedAt: now,
          soundQuality: random.nextBool() ? 'Normal' : 'Abnormal',
          category: 'heart',
        );
      case TestType.bodySoundLungs:
        return TestResultFactory.createBodySoundResult(
          id: _generateResultId(),
          completedAt: now,
          soundQuality: random.nextBool() ? 'Normal' : 'Abnormal',
          category: 'lungs',
        );
      case TestType.bodySoundStomach:
        return TestResultFactory.createBodySoundResult(
          id: _generateResultId(),
          completedAt: now,
          soundQuality: random.nextBool() ? 'Normal' : 'Abnormal',
          category: 'stomach',
        );
      case TestType.bodySoundBowel:
        return TestResultFactory.createBodySoundResult(
          id: _generateResultId(),
          completedAt: now,
          soundQuality: random.nextBool() ? 'Normal' : 'Abnormal',
          category: 'bowel',
        );

      case TestType.entEar:
        return TestResultFactory.createEntResult(
          id: _generateResultId(),
          completedAt: now,
          findings: random.nextBool() ? 'Normal' : 'Congested',
          category: 'ear',
        );
      case TestType.entNose:
        return TestResultFactory.createEntResult(
          id: _generateResultId(),
          completedAt: now,
          findings: random.nextBool() ? 'Normal' : 'Congested',
          category: 'nose',
        );
      case TestType.entThroat:
        return TestResultFactory.createEntResult(
          id: _generateResultId(),
          completedAt: now,
          findings: random.nextBool() ? 'Normal' : 'Congested',
          category: 'throat',
        );

      case TestType.bodyTemperature:
        return TestResultFactory.createBodyTemperatureResult(
          id: _generateResultId(),
          completedAt: now,
          temperature: 97.0 + random.nextDouble() * 5.0, // 97.0 to 102.0°F
          category: test.firstSelectedSubTypeId,
        );

      default:
        return TestResult(
          id: _generateResultId(),
          testType: test.type,
          testName: test.name,
          completedAt: now,
          parameters: [
            TestResultParameter(
              name: 'Result',
              value: 'Normal',
              unit: '',
              isAbnormal: false,
            ),
          ],
          category: test.firstSelectedSubTypeId,
        );
    }
  }

  // Utility Methods
  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }

  void _setCurrentTestError(TestError? error) {
    _currentTestError.value = error;
  }

  void _clearSession() {
    _currentSession.value = null;
    _currentTest.value = null;
    _currentTestStatus.value = TestStatus.none;
    _currentTestError.value = null;
    _sessionResults.clear();

    _awaitingNextInGroup.value = false;
    _nextTestInGroup = null;
  }

  String _generateSessionId() {
    return 'session_${DateTime.now().millisecondsSinceEpoch}';
  }

  String _generateResultId() {
    return 'result_${DateTime.now().millisecondsSinceEpoch}_${math.Random().nextInt(1000)}';
  }

  // Public method to complete current test (called from UI)
  void completeCurrentTestWithMockResult() {
    if (currentTest != null) {
      final result = _generateMockResult(currentTest!);
      _completeCurrentTest(result);
    }
  }

  // Public method to force complete session and go to results
  void forceCompleteSession() {
    _completeSession();
  }

  /// Skip the current test and move directly to the next one without adding
  /// a result. Used when the user cancels prerequisite/sub-type dialogs.
  Future<void> skipCurrentTest() async {
    if (currentSession == null) return;

    // Advance pointer to next test.
    currentSession!.moveToNextTest();

    // Load the next test as usual (dialogs will show if necessary).
    await _moveToNextTest();

    // If there is no next test (session ended), go back to selection instead
    // of leaving the execution page in an empty state.
    if (_currentTest.value == null) {
      resetSelections();
      Get.off(() => TestSelectionPage());
    }
  }

  // Public method to move to next test (called from UI)
  Future<void> moveToNextTest() async {
    await _moveToNextTest();
  }

  /// Interrupt the currently running test without discarding the overall
  /// session. This sets the status to `cancelled` so any ongoing simulated
  /// execution is aborted, but keeps [_currentTest] intact so the user can
  /// retry or skip it later from the interruption screen.
  void interruptCurrentTest() {
    if (_currentTest.value == null) return;
    _currentTestStatus.value = TestStatus.cancelled;
  }

  /// Restart the existing current test after it has been interrupted. This
  /// resets the status back to `ready` then immediately begins the test
  /// execution so the user resumes the flow seamlessly.
  void restartCurrentTest() {
    if (_currentTest.value == null) return;
    _currentTestStatus.value = TestStatus.ready;
    startCurrentTest();
  }

  // Settings Methods
  void setUseMockData(bool use) {
    _useMockData.value = use;
  }

  void setDemoMode(bool demo) {
    _demoMode.value = demo;
  }

  // Removed legacy testHasCategories

  // Mark dialogs as shown
  void markDialogsAsShown() {
    _shouldShowDialogs.value = false;
  }

  // Debug method to check selection state
  void debugSelection() {
    // Debug logging removed for production
    // Use this method to troubleshoot selection state if needed
  }

  // -------------- Group Selection (new) -------------------------------------------------------
  void selectGroup(TestGroup group) {
    _currentGroup.value = group;
    // Automatically pre-fill available tests based on group (single-select flow)
    final tests =
        group.testTypes
            .map((tt) => TestDefinitions.getTestByType(tt))
            .whereType<Test>()
            .toList();
    _availableTests.value = tests;
    clearSelection();
  }

  void backToGroups() {
    _currentGroup.value = null;
    _availableTests.value = TestDefinitions.availableTests;
    clearSelection();
  }

  // Sub-Type Selection ------------------------------------------------------
  void selectTestSubTypes(Test test, List<String> subTypeIds) {
    final updatedTest = test.copyWith(selectedSubTypeIds: subTypeIds);

    // Update in selected tests
    final index = _selectedTests.indexWhere((t) => t.type == test.type);
    if (index != -1) {
      _selectedTests[index] = updatedTest;
    }

    // Update in available tests
    final availableIndex = _availableTests.indexWhere(
      (t) => t.type == test.type,
    );
    if (availableIndex != -1) {
      _availableTests[availableIndex] = updatedTest;
    }
  }

  Future<void> showSubTypeSelectionDialog(Test test) async {
    if (!test.hasSubTypes) return;

    final selectedIds = await Get.dialog<List<String>>(
      SubTypeSelectionDialog(test: test),
      barrierDismissible: false,
    );

    if (selectedIds != null && selectedIds.isNotEmpty) {
      selectTestSubTypes(test, selectedIds);
    }
  }

  // Group Selection Methods
  void toggleGroupSelection(TestGroup group) {
    final exists = _selectedGroups.any((g) => g.id == group.id);
    if (exists) {
      _selectedGroups.removeWhere((g) => g.id == group.id);
    } else {
      _selectedGroups.add(group);
    }
  }

  // Cleanup
  @override
  void onClose() {
    _clearSession();
    super.onClose();
  }

  // Reset all selections and categories back to default state
  void resetSelections() {
    _selectedTests.clear();
    _selectedGroups.clear();
    _currentGroup.value = null;

    _initializeTests();
    _shouldShowDialogs.value = false;

    _awaitingNextInGroup.value = false;
    _nextTestInGroup = null;
    _sessionCompleted.value = false;
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

  // Reset entire flow including session state and selections.
  void resetFlow() {
    _clearSession();
    resetSelections();
    _sessionCompleted.value = false;
  }

  // Creates a lightweight placeholder Test used to prompt the user for the
  // concrete variants of a multi-select group when that group begins.
  Test _createPlaceholder(TestGroup group) {
    final concreteTests =
        group.testTypes
            .map((tt) => TestDefinitions.getTestByType(tt))
            .whereType<Test>()
            .toList();

    return Test(
      type: concreteTests.first.type, // any valid enum (placeholder)
      group: group.name,
      name: group.name,
      description: 'Select variants',
      image: group.image,
      subTypes:
          concreteTests
              .map(
                (t) => TestSubType(
                  id: t.type.name,
                  name: t.name,
                  description: t.description,
                ),
              )
              .toList(),
      selectionType:
          TestGroupFactory.isMultiSelectGroup(group.name)
              ? TestSelectionType.multiple
              : TestSelectionType.single,
      isGroupPlaceholder: true,
    );
  }

  Future<List<Test>> _buildTestsFromGroups() async {
    final List<Test> queue = [];

    for (final group in _selectedGroups) {
      final concreteTests =
          group.testTypes
              .map((tt) => TestDefinitions.getTestByType(tt))
              .whereType<Test>()
              .toList();

      if (concreteTests.isEmpty) continue;

      // Multi-select groups (Body Sounds, ENT) – insert placeholder and defer
      // variant selection until execution time.
      if (TestGroupFactory.isMultiSelectGroup(group.name)) {
        queue.add(_createPlaceholder(group));
        continue;
      }

      // Non-multi groups: if only one concrete test, add directly; otherwise
      // ask user upfront to pick exactly one variant *only* if this will be
      // the very first test in the queue. Otherwise, insert a placeholder so
      // that the selection dialog appears later (when the test is reached via
      // the "Next Test" button).
      if (concreteTests.length == 1) {
        queue.add(concreteTests.first);
      } else {
        if (queue.isEmpty) {
          // First test – select variant immediately.
          final ids = await Get.dialog<List<String>>(
            SubTypeSelectionDialog(test: _createPlaceholder(group)),
            barrierDismissible: false,
          );

          if (ids == null || ids.isEmpty) {
            return [];
          }

          final chosen = TestType.values.byName(ids.first);
          final t = TestDefinitions.getTestByType(chosen);
          if (t != null) queue.add(t);
        } else {
          // Not the first – defer selection by inserting a placeholder.
          queue.add(_createPlaceholder(group));
        }
      }
    }

    return queue;
  }
}
