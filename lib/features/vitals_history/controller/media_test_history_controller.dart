import 'dart:math' as math;

import 'package:ausa/features/tests/model/test_result.dart';
import 'package:ausa/features/vitals_history/model/media_test_reading.dart';
import 'package:get/get.dart';

class MediaTestHistoryController extends GetxController {
  // Current selected tab (Body Sounds vs ENT)
  final RxInt currentTabIndex = 0.obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Selected reading for detailed view
  final Rx<MediaTestReading?> selectedReading = Rx<MediaTestReading?>(null);

  // Media test data storage
  final RxList<MediaTestReading> bodySoundReadings = <MediaTestReading>[].obs;
  final RxList<MediaTestReading> entReadings = <MediaTestReading>[].obs;

  // All readings combined for search/filter
  final RxList<MediaTestReading> allReadings = <MediaTestReading>[].obs;

  // Tab configuration
  final List<Map<String, dynamic>> tabs = [
    {'title': 'Body sounds', 'type': MediaTestType.bodySound},
    {'title': 'ENT', 'type': MediaTestType.ent},
  ];

  // Selected readings for bulk operations
  final RxList<String> selectedReadingIds = <String>[].obs;

  // Selection mode
  final RxBool isSelectionMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDummyData();
    _updateAllReadings();
  }

  // Switch between tabs
  void switchTab(int index) {
    currentTabIndex.value = index;
    clearSelection();
  }

  // Get current media test type
  MediaTestType get currentMediaType => tabs[currentTabIndex.value]['type'];

  // Get current readings based on selected tab
  List<MediaTestReading> get currentReadings {
    switch (currentMediaType) {
      case MediaTestType.bodySound:
        return bodySoundReadings;
      case MediaTestType.ent:
        return entReadings;
    }
  }

  // Check if current readings are empty
  bool get hasNoReadings => currentReadings.isEmpty;

  // Get latest reading for current media type
  MediaTestReading? get latestReading {
    final readings = currentReadings;
    if (readings.isEmpty) return null;
    return readings.first;
  }

  // Select/deselect reading
  void toggleReadingSelection(String readingId) {
    if (selectedReadingIds.contains(readingId)) {
      selectedReadingIds.remove(readingId);
    } else {
      selectedReadingIds.add(readingId);
    }

    // Exit selection mode if no items selected
    if (selectedReadingIds.isEmpty) {
      isSelectionMode.value = false;
    }
  }

  // Check if reading is selected
  bool isReadingSelected(String readingId) {
    return selectedReadingIds.contains(readingId);
  }

  // Enter selection mode
  void enterSelectionMode() {
    isSelectionMode.value = true;
  }

  // Exit selection mode
  void exitSelectionMode() {
    isSelectionMode.value = false;
    selectedReadingIds.clear();
  }

  // Clear selection
  void clearSelection() {
    selectedReading.value = null;
    selectedReadingIds.clear();
    isSelectionMode.value = false;
  }

  // Select reading for detailed view
  void selectReadingForDetail(MediaTestReading reading) {
    selectedReading.value = reading;
  }

  // Delete selected readings
  Future<void> deleteSelectedReadings() async {
    if (selectedReadingIds.isEmpty) return;

    try {
      isLoading.value = true;

      // Remove from appropriate lists
      for (final id in selectedReadingIds) {
        bodySoundReadings.removeWhere((r) => r.id == id);
        entReadings.removeWhere((r) => r.id == id);
      }

      _updateAllReadings();
      clearSelection();

      // TODO: Implement actual deletion via API
      await Future.delayed(Duration(milliseconds: 500));
    } catch (e) {
      // Handle error
      // TODO: Show error message
    } finally {
      isLoading.value = false;
    }
  }

  // Add new media test reading (from test result)
  void addMediaTestReading(TestResult testResult) {
    try {
      final reading = MediaTestReading.fromTestResult(testResult);

      switch (reading.type) {
        case MediaTestType.bodySound:
          bodySoundReadings.insert(0, reading);
          break;
        case MediaTestType.ent:
          entReadings.insert(0, reading);
          break;
      }

      _updateAllReadings();
    } catch (e) {
      // Handle error
      // TODO: Show error message
    }
  }

  // Update all readings list
  void _updateAllReadings() {
    allReadings.clear();
    allReadings.addAll(bodySoundReadings);
    allReadings.addAll(entReadings);

    // Sort by timestamp (newest first)
    allReadings.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // Initialize dummy data
  void _initializeDummyData() {
    _generateDummyBodySoundData();
    _generateDummyEntData();
  }

  void _generateDummyBodySoundData() {
    final now = DateTime.now();
    final random = math.Random();

    bodySoundReadings.value = [
      MediaTestReading(
        id: 'bs_1',
        timestamp: now,
        type: MediaTestType.bodySound,
        status: MediaTestStatus.normal,
        category: 'heart',
        duration: 30,
        recordingPath: 'assets/sample/audio.mp3',
        parameters: [
          MediaTestParameter(
            name: 'Heart Sounds',
            value: 'Normal',
            unit: '',
            isAbnormal: false,
          ),
          MediaTestParameter(
            name: 'Examination Area',
            value: 'Heart',
            unit: '',
            isAbnormal: false,
          ),
        ],
        findings: 'Normal heart sounds',
      ),
      MediaTestReading(
        id: 'bs_2',
        timestamp: now.subtract(Duration(hours: 2)),
        type: MediaTestType.bodySound,
        status: MediaTestStatus.normal,
        category: 'lungs',
        duration: 45,
        recordingPath: 'assets/sample/audio.mp3',
        parameters: [
          MediaTestParameter(
            name: 'Lung Sounds',
            value: 'Normal',
            unit: '',
            isAbnormal: false,
          ),
          MediaTestParameter(
            name: 'Examination Area',
            value: 'Lungs',
            unit: '',
            isAbnormal: false,
          ),
        ],
        findings: 'Clear lung sounds',
      ),
      MediaTestReading(
        id: 'bs_3',
        timestamp: now.subtract(Duration(days: 1)),
        type: MediaTestType.bodySound,
        status: MediaTestStatus.abnormal,
        category: 'stomach',
        duration: 60,
        recordingPath: 'assets/sample/audio.mp3',
        parameters: [
          MediaTestParameter(
            name: 'Stomach Sounds',
            value: 'Hyperactive',
            unit: '',
            isAbnormal: true,
          ),
          MediaTestParameter(
            name: 'Examination Area',
            value: 'Stomach',
            unit: '',
            isAbnormal: false,
          ),
        ],
        findings: 'Hyperactive bowel sounds detected',
      ),
      MediaTestReading(
        id: 'bs_4',
        timestamp: now.subtract(Duration(days: 2)),
        type: MediaTestType.bodySound,
        status: MediaTestStatus.normal,
        category: 'bowel',
        duration: 40,
        recordingPath: 'assets/sample/audio.mp3',
        parameters: [
          MediaTestParameter(
            name: 'Bowel Sounds',
            value: 'Normal',
            unit: '',
            isAbnormal: false,
          ),
          MediaTestParameter(
            name: 'Examination Area',
            value: 'Bowel',
            unit: '',
            isAbnormal: false,
          ),
        ],
        findings: 'Normal bowel sounds',
      ),
    ];
  }

  void _generateDummyEntData() {
    final now = DateTime.now();
    final random = math.Random();

    entReadings.value = [
      MediaTestReading(
        id: 'ent_1',
        timestamp: now.subtract(Duration(minutes: 30)),
        type: MediaTestType.ent,
        status: MediaTestStatus.normal,
        category: 'ear',
        duration: 20,
        recordingPath: 'assets/sample/video.mp4',
        parameters: [
          MediaTestParameter(
            name: 'Otoscopic Examination',
            value: 'Normal',
            unit: '',
            isAbnormal: false,
          ),
          MediaTestParameter(
            name: 'Examination Area',
            value: 'Ear',
            unit: '',
            isAbnormal: false,
          ),
        ],
        findings: 'Normal ear examination',
      ),
      MediaTestReading(
        id: 'ent_2',
        timestamp: now.subtract(Duration(hours: 4)),
        type: MediaTestType.ent,
        status: MediaTestStatus.abnormal,
        category: 'nose',
        duration: 35,
        recordingPath: 'assets/sample/video.mp4',
        parameters: [
          MediaTestParameter(
            name: 'Rhinoscopic Examination',
            value: 'Congested',
            unit: '',
            isAbnormal: true,
          ),
          MediaTestParameter(
            name: 'Examination Area',
            value: 'Nose',
            unit: '',
            isAbnormal: false,
          ),
        ],
        findings: 'Mild nasal congestion observed',
      ),
      MediaTestReading(
        id: 'ent_3',
        timestamp: now.subtract(Duration(days: 1, hours: 3)),
        type: MediaTestType.ent,
        status: MediaTestStatus.normal,
        category: 'throat',
        duration: 25,
        recordingPath: 'assets/sample/video.mp4',
        parameters: [
          MediaTestParameter(
            name: 'Pharyngoscopic Examination',
            value: 'Normal',
            unit: '',
            isAbnormal: false,
          ),
          MediaTestParameter(
            name: 'Examination Area',
            value: 'Throat',
            unit: '',
            isAbnormal: false,
          ),
        ],
        findings: 'Normal throat examination',
      ),
    ];
  }

  // API methods (ready for backend integration)
  Future<void> fetchMediaTests() async {
    try {
      isLoading.value = true;
      // TODO: Implement API call to fetch media tests
      // final response = await MediaTestService.fetchMediaTests();
      await Future.delayed(Duration(seconds: 1));
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }

  // Get readings by category
  List<MediaTestReading> getReadingsByCategory(String category) {
    return currentReadings.where((r) => r.category == category).toList();
  }

  // Get categories for current type
  List<String> get availableCategories {
    switch (currentMediaType) {
      case MediaTestType.bodySound:
        return ['heart', 'lungs', 'stomach', 'bowel'];
      case MediaTestType.ent:
        return ['ear', 'nose', 'throat'];
    }
  }

  // Cleanup
  @override
  void onClose() {
    clearSelection();
    super.onClose();
  }
}
