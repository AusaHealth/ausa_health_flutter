import 'package:ausa/common/enums/test_status.dart';
import 'package:ausa/common/model/test.dart';
import 'package:ausa/common/model/test_error.dart';
import 'package:ausa/common/enums/test_error_type.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/constants/test_definitions.dart';
import 'package:ausa/features/tests/model/test_session.dart';
import 'package:ausa/features/tests/model/test_result.dart';
import 'package:ausa/features/tests/model/test_prerequisites.dart';
import 'package:ausa/features/tests/page/test_selection_page.dart';
import 'package:ausa/features/tests/page/test_execution_page.dart';
import 'package:ausa/features/tests/page/test_results_page.dart';
import 'package:ausa/features/tests/widget/category_selection_dialog.dart';
import 'package:ausa/features/tests/widget/prerequisite_check_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'dart:async';

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

  // Getters
  List<Test> get availableTests => _availableTests;
  List<Test> get selectedTests => _selectedTests;
  bool get isLoading => _isLoading.value;

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

  // Computed Properties
  int get selectedTestsCount => _selectedTests.length;
  bool get hasSelectedTests => _selectedTests.isNotEmpty;
  bool get canStartSession => hasSelectedTests && !isLoading;

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

  // Category Selection Methods
  void selectTestCategory(Test test, String categoryId) {
    final updatedTest = test.copyWith(selectedCategory: categoryId);

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

  Future<void> showCategorySelectionDialog(Test test) async {
    if (!test.hasCategories) return;

    final selectedCategory = await Get.dialog<String>(
      CategorySelectionDialog(test: test),
      barrierDismissible: false,
    );

    if (selectedCategory != null) {
      selectTestCategory(test, selectedCategory);
    }
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
      _currentSession.value = TestSession(
        id: sessionId,
        tests: List.from(_selectedTests),
        createdAt: DateTime.now(),
        status: TestSessionStatus.started,
        startedAt: DateTime.now(),
      );

      _sessionResults.clear();
      await _moveToNextTest();

      // Navigate to test execution
      Get.to(() => TestExecutionPage());
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

  Future<void> _moveToNextTest() async {
    if (currentSession == null) return;

    if (currentSession!.hasMoreTests) {
      final nextTest = currentSession!.nextTest;
      if (nextTest == null) {
        _completeSession();
        return;
      }

      // Reset state for new test
      _currentTest.value = nextTest;
      _currentTestStatus.value = TestStatus.ready;
      _prerequisitesMet.value = false; // Reset prerequisites state
      _currentTestError.value = null; // Clear any previous errors

      // Delay showing dialogs to allow proper UI transition
      Future.delayed(Duration(milliseconds: 500), () {
        if (_currentTest.value == nextTest) {
          // Ensure test hasn't changed
          if (!_shouldShowDialogs.value) {
            // Trigger dialogs only if they are not already scheduled.
            _shouldShowDialogs.value = true;
          }
        }
      });
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

    _currentTest.value = null;
    _currentTestStatus.value = TestStatus.completed;

    // Navigate to results
    Get.off(() => TestResultsPage());
  }

  // Test Execution Methods
  Future<void> startCurrentTest() async {
    if (currentTest == null) return;

    _currentTestStatus.value = TestStatus.started;

    // For demo mode, simulate test execution
    if (demoMode) {
      await _simulateTestExecution();
    }
  }

  Future<void> _simulateTestExecution() async {
    // Capture the test that is being simulated at the time of invocation
    if (currentTest == null) return;
    final Test runningTest = currentTest!;

    final duration = TestDefinitions.getEstimatedDuration(
      runningTest.type,
      category: runningTest.selectedCategory,
    );

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

    _sessionResults.add(result);
    _allResults.add(result);

    currentSession!.addResult(result);
    currentSession!.moveToNextTest();

    _currentTestStatus.value = TestStatus.completed;

    // Show completion dialog and ask for next test
    Future.delayed(Duration(seconds: 2), () {
      if (currentSession!.hasMoreTests) {
        _showNextTestDialog();
      } else {
        _completeSession();
      }
    });
  }

  void _showNextTestDialog() {
    if (currentSession == null) return;

    final nextTest = currentSession!.nextTest;
    if (nextTest == null) {
      _completeSession();
      return;
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: _NextTestDialogContent(
          nextTest: nextTest,
          onCancel: () {
            Get.back();
            _completeSession();
          },
          onContinue: () async {
            Get.back();
            await _moveToNextTest();
          },
        ),
      ),
      barrierDismissible: false,
    );
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

  void navigateToResults() {
    Get.to(() => TestResultsPage());
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
    if (currentSession != null) {
      _selectedTests.clear();
      _selectedTests.addAll(currentSession!.tests);
      _updateTestSelectionState();
      startTestSession();
    }
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
          category: test.selectedCategory,
        );

      case TestType.bloodGlucose:
        return TestResultFactory.createBloodGlucoseResult(
          id: _generateResultId(),
          completedAt: now,
          glucose: 80.0 + random.nextDouble() * 100,
          heartRate: 60 + random.nextInt(40),
          category: test.selectedCategory ?? 'fasting',
        );

      case TestType.bloodOxygen:
        return TestResultFactory.createBloodOxygenResult(
          id: _generateResultId(),
          completedAt: now,
          oxygenSaturation: 95 + random.nextInt(5),
          pulseRate: 60 + random.nextInt(40),
          pulsePressure: 40 + random.nextInt(30),
          meanArterialPressure: 85 + random.nextInt(20),
          category: test.selectedCategory,
        );

      case TestType.ecg:
        return TestResultFactory.createEcgResult(
          id: _generateResultId(),
          completedAt: now,
          heartRate: 60 + random.nextInt(40),
          rhythm: random.nextBool() ? 'Normal' : 'Irregular',
          category: test.selectedCategory ?? '6_lead',
        );

      case TestType.bodySound:
        return TestResultFactory.createBodySoundResult(
          id: _generateResultId(),
          completedAt: now,
          soundQuality: random.nextBool() ? 'Normal' : 'Abnormal',
          category: test.selectedCategory ?? 'heart',
        );

      case TestType.ent:
        return TestResultFactory.createEntResult(
          id: _generateResultId(),
          completedAt: now,
          findings: random.nextBool() ? 'Normal' : 'Congested',
          category: test.selectedCategory ?? 'ear',
        );

      case TestType.bodyTemperature:
        return TestResultFactory.createBodyTemperatureResult(
          id: _generateResultId(),
          completedAt: now,
          temperature: 97.0 + random.nextDouble() * 5.0, // 97.0 to 102.0°F
          category: test.selectedCategory,
        );

      default:
        // Generic result for other test types
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
          category: test.selectedCategory,
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

  // Public method to move to next test (called from UI)
  Future<void> moveToNextTest() async {
    await _moveToNextTest();
  }

  // Settings Methods
  void setUseMockData(bool use) {
    _useMockData.value = use;
  }

  void setDemoMode(bool demo) {
    _demoMode.value = demo;
  }

  bool testHasCategories(TestType testType) {
    final test = TestDefinitions.getTestByType(testType);
    return test?.hasCategories ?? false;
  }

  // Mark dialogs as shown
  void markDialogsAsShown() {
    _shouldShowDialogs.value = false;
  }

  // Debug method to check selection state
  void debugSelection() {
    // Debug logging removed for production
    // Use this method to troubleshoot selection state if needed
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
    _initializeTests();
    _shouldShowDialogs.value = false;
  }
}

class _NextTestDialogContent extends StatefulWidget {
  final Test nextTest;
  final VoidCallback onCancel;
  final VoidCallback onContinue;

  const _NextTestDialogContent({
    required this.nextTest,
    required this.onCancel,
    required this.onContinue,
  });

  @override
  State<_NextTestDialogContent> createState() => _NextTestDialogContentState();
}

class _NextTestDialogContentState extends State<_NextTestDialogContent> {
  int _countdown = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        widget.onContinue();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFE8E8E8)],
          stops: [0.0002, 2.3065],
        ),
      ),
      width: 500,
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Next Test',
            style: AppTypography.callout(),
            textAlign: TextAlign.center,
          ),
          Text(
            widget.nextTest.name,
            style: AppTypography.title1(),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          // Test illustration
          Container(
            height: 100,
            child: Image.asset(
              'assets/images/test_ins.png',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  _timer?.cancel();
                  widget.onCancel();
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 34),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: BorderSide(color: AppColors.primary700),
                  ),
                ),
                child: Text(
                  'cancel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary700,
                  ),
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  _timer?.cancel();
                  widget.onContinue();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary700,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'in $_countdown seconds',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
