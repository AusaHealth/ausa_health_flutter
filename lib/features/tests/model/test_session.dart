import 'package:ausa/common/model/test.dart';
import 'package:ausa/features/tests/model/test_result.dart';

/// Status of a test session
enum TestSessionStatus { created, started, completed, cancelled }

class TestSession {
  final String id;
  final List<Test> tests;
  final List<TestResult> results;
  final TestSessionStatus status;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;

  // Internal pointer to current test index
  int _currentIndex;

  TestSession({
    required this.id,
    required this.tests,
    List<TestResult>? results,
    this.status = TestSessionStatus.created,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    int currentIndex = 0,
  }) : results = results ?? <TestResult>[],
       _currentIndex = currentIndex;

  // Copy with helper
  TestSession copyWith({
    String? id,
    List<Test>? tests,
    List<TestResult>? results,
    TestSessionStatus? status,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    int? currentIndex,
  }) {
    return TestSession(
      id: id ?? this.id,
      tests: tests ?? this.tests,
      results: results ?? List<TestResult>.from(this.results),
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      currentIndex: currentIndex ?? _currentIndex,
    );
  }

  /// Total tests in this session
  int get totalTests => tests.length;

  /// Number of completed tests (based on results length)
  int get completedTests => results.length;

  /// Progress as a fraction between 0 and 1
  double get progress => totalTests == 0 ? 0.0 : completedTests / totalTests;

  /// Whether more tests remain to be taken
  bool get hasMoreTests => _currentIndex < tests.length;

  /// The next test to perform
  Test? get nextTest => hasMoreTests ? tests[_currentIndex] : null;

  /// Move the pointer to the next test
  void moveToNextTest() {
    if (hasMoreTests) {
      _currentIndex += 1;
    }
  }

  /// Add a result for a completed test
  void addResult(TestResult result) {
    results.add(result);
  }
}
