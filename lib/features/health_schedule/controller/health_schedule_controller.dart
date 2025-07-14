import 'package:get/get.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import '../model/health_activity.dart';
import '../model/health_time_slot.dart';
import '../page/meal_times_page.dart';

class HealthScheduleController extends GetxController {
  // Private observable state
  final RxInt _currentTabIndex = 0.obs; // 0: Routine, 1: Medication
  final RxInt _selectedTimeFilter =
      0.obs; // 0: All day, 1: Morning, 2: Afternoon, 3: Evening
  final RxInt _selectedMedicationFilter = 0.obs;
  final RxList<HealthTimeSlot> _timeSlots = <HealthTimeSlot>[].obs;
  final RxList<HealthActivity> _allActivities = <HealthActivity>[].obs;
  final RxList<HealthActivity> _medications = <HealthActivity>[].obs;
  final RxBool _showFloatingCTA = false.obs;
  final RxString _floatingCTAText = ''.obs;

  // ScrollController for timeline auto-scrolling
  late ScrollController timelineScrollController;

  // Public getters
  int get currentTabIndex => _currentTabIndex.value;
  int get selectedTimeFilter => _selectedTimeFilter.value;
  int get selectedMedicationFilter => _selectedMedicationFilter.value;
  List<HealthTimeSlot> get timeSlots => _timeSlots;
  List<HealthActivity> get allActivities => _allActivities;
  List<HealthActivity> get medications => _medications;
  bool get showFloatingCTA => _showFloatingCTA.value;
  String get floatingCTAText => _floatingCTAText.value;

  // Tab names
  final List<String> tabs = ['Routine', 'Medication'];

  // Time filter names
  final List<String> timeFilters = [
    'All day',
    'Morning',
    'Afternoon',
    'Evening',
  ];

  // Medication filter names
  final List<String> medicationFilters = [
    'All',
    'Hypertension',
    'Type II Diabetes',
    'Hyperlipidemia',
  ];

  @override
  void onInit() {
    super.onInit();
    timelineScrollController = ScrollController();
    _initializeMockData();
    _checkForPendingTests();
  }

  @override
  void onClose() {
    timelineScrollController.dispose();
    super.onClose();
  }

  /// Determines the current time slot index based on the current time of day
  int getCurrentTimeSlotIndex(List<HealthTimeSlot> timeSlots) {
    final now = DateTime.now();
    final currentHour = now.hour;

    // Define time ranges based on meal times
    // Morning: 4 AM - 12 PM (Breakfast period)
    // Mid-Day: 12 PM - 5 PM (Lunch period)
    // Evening: 5 PM - 4 AM (Dinner period)

    TimeOfDay currentTimeOfDay;

    if (currentHour >= 4 && currentHour < 12) {
      currentTimeOfDay = TimeOfDay.morning;
    } else if (currentHour >= 12 && currentHour < 17) {
      currentTimeOfDay = TimeOfDay.midDay;
    } else {
      currentTimeOfDay = TimeOfDay.evening;
    }

    // Find the first time slot that matches the current time of day
    for (int i = 0; i < timeSlots.length; i++) {
      if (timeSlots[i].timeOfDay == currentTimeOfDay) {
        return i;
      }
    }

    // Default to first time slot if no match found
    return 0;
  }

  /// Auto-scrolls to the current time section in the timeline
  void autoScrollToCurrentTime() {
    if (!timelineScrollController.hasClients) return;

    final currentIndex = getCurrentTimeSlotIndex(filteredTimeSlots);

    // Calculate approximate scroll position
    // Each time slot widget is roughly 200 pixels tall (this is an estimate)
    const double estimatedTimeSlotHeight = 200.0;
    final double targetOffset = currentIndex * estimatedTimeSlotHeight;

    // Animate to the calculated position
    timelineScrollController.animateTo(
      targetOffset,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  // Private update methods
  void _updateCurrentTabIndex(int index) => _currentTabIndex.value = index;
  void _updateSelectedTimeFilter(int index) =>
      _selectedTimeFilter.value = index;
  void _updateSelectedMedicationFilter(int index) =>
      _selectedMedicationFilter.value = index;
  void _updateTimeSlots(List<HealthTimeSlot> slots) =>
      _timeSlots.assignAll(slots);
  void _updateAllActivities(List<HealthActivity> activities) =>
      _allActivities.assignAll(activities);
  void _updateMedications(List<HealthActivity> meds) =>
      _medications.assignAll(meds);
  void _updateShowFloatingCTA(bool show) => _showFloatingCTA.value = show;
  void _updateFloatingCTAText(String text) => _floatingCTAText.value = text;
  void _updateActivityAtIndex(int index, HealthActivity activity) =>
      _allActivities[index] = activity;

  // Public action methods
  void switchTab(int index) {
    _updateCurrentTabIndex(index);

    // Auto-scroll to current time when switching to Routine tab
    if (index == 0) {
      // Add a small delay to ensure the UI has been built
      Future.delayed(Duration(milliseconds: 100), () {
        autoScrollToCurrentTime();
      });
    }
  }

  void setTimeFilter(int index) {
    _updateSelectedTimeFilter(index);

    // Auto-scroll to current time section when filter changes
    Future.delayed(Duration(milliseconds: 100), () {
      autoScrollToCurrentTime();
    });
  }

  void setMedicationFilter(int index) {
    _updateSelectedMedicationFilter(index);
  }

  void setMedicationFilterSafe(int index) {
    final maxIndex = dynamicMedicationFilters.length - 1;
    if (index >= 0 && index <= maxIndex) {
      _updateSelectedMedicationFilter(index);
    } else {
      // Reset to "All" if index is out of bounds
      _updateSelectedMedicationFilter(0);
    }
  }

  List<HealthTimeSlot> get filteredTimeSlots {
    if (_selectedTimeFilter.value == 0) {
      // All day - show all slots
      return _timeSlots;
    }

    final filterMap = {
      1: TimeOfDay.morning,
      2: TimeOfDay.midDay,
      3: TimeOfDay.evening,
    };

    final selectedTimeOfDay = filterMap[_selectedTimeFilter.value];
    if (selectedTimeOfDay == null) return _timeSlots;

    return _timeSlots
        .where((slot) => slot.timeOfDay == selectedTimeOfDay)
        .toList();
  }

  List<HealthActivity> get filteredActivities {
    if (_currentTabIndex.value == 0) {
      // Routine tab - show all non-medication activities
      return _allActivities
          .where((activity) => activity.type != HealthActivityType.medication)
          .toList();
    } else {
      // Medication tab - show only medication activities
      return _allActivities
          .where((activity) => activity.type == HealthActivityType.medication)
          .toList();
    }
  }

  List<HealthActivity> get filteredMedications {
    if (_selectedMedicationFilter.value == 0) {
      // All - show all medications
      return _medications;
    }

    // Get the dynamic filter list and selected condition
    final filters = dynamicMedicationFilters;

    // Ensure the selected index is within bounds
    if (_selectedMedicationFilter.value >= filters.length) {
      return _medications;
    }

    final selectedCondition = filters[_selectedMedicationFilter.value];

    // Filter medications by the selected condition
    return _medications
        .where((medication) => medication.condition == selectedCondition)
        .toList();
  }

  void completeActivity(String activityId) {
    final activityIndex = _allActivities.indexWhere(
      (activity) => activity.id == activityId,
    );
    if (activityIndex != -1) {
      final updatedActivity = _allActivities[activityIndex].copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
      );
      _updateActivityAtIndex(activityIndex, updatedActivity);
      _checkForPendingTests();
    }
  }

  void undoCompleteActivity(String activityId) {
    final activityIndex = _allActivities.indexWhere(
      (activity) => activity.id == activityId,
    );
    if (activityIndex != -1) {
      final updatedActivity = _allActivities[activityIndex].copyWith(
        isCompleted: false,
        completedAt: null,
      );
      _updateActivityAtIndex(activityIndex, updatedActivity);
      _checkForPendingTests();
    }
  }

  void onEditMealTimes() {
    // Navigate to meal times editing screen
    Get.to(() => const MealTimesPage());
  }

  void onFloatingCTAPressed() {
    // Handle the floating CTA action (e.g., Take Glucose Test)
    Get.snackbar('Test Reminder', 'Redirecting to glucose test...');
  }

  void onActivityCTA(String activityId) {
    // Handle individual activity CTA actions
    final activity = _allActivities.firstWhere(
      (activity) => activity.id == activityId,
      orElse: () => throw Exception('Activity not found'),
    );

    switch (activityId) {
      case 'bp_morning_before':
      case 'bp_midday_before':
      case 'bp_midday_after':
      case 'bp_evening_after':
        Get.snackbar(
          'Blood Pressure Monitor',
          'Opening blood pressure measurement...',
          snackPosition: SnackPosition.TOP,
        );
        break;
      case 'blood_sugar_morning':
        Get.snackbar(
          'Blood Sugar Test',
          'Opening glucose meter...',
          snackPosition: SnackPosition.TOP,
        );
        break;
      case 'exercise_evening':
        Get.snackbar(
          'Exercise Tracker',
          'Starting exercise session...',
          snackPosition: SnackPosition.TOP,
        );
        break;
      default:
        Get.snackbar(
          activity.title,
          'CTA action for ${activity.title}',
          snackPosition: SnackPosition.TOP,
        );
    }
  }

  void _checkForPendingTests() {
    // Check if there are any pending blood sugar tests
    final pendingBloodSugarTests =
        _allActivities
            .where(
              (activity) =>
                  activity.type == HealthActivityType.bloodSugarCheck &&
                  !activity.isCompleted,
            )
            .toList();

    if (pendingBloodSugarTests.isNotEmpty) {
      _updateShowFloatingCTA(true);
      _updateFloatingCTAText('Take Glucose Test');
    } else {
      _updateShowFloatingCTA(false);
      _updateFloatingCTAText('');
    }
  }

  void _initializeMockData() {
    // Initialize with mock data matching the UI images
    final mockActivities = [
      // Morning - Before Meal
      HealthActivity(
        id: 'bp_morning_before',
        title: 'Check Blood Pressure',
        type: HealthActivityType.bloodPressureCheck,
        targetRange: '<130/80 mm Hg',
        condition: 'Hypertension',
      ),
      HealthActivity(
        id: 'bg_morning_before',
        title: 'Check asd Glucose',
        type: HealthActivityType.bloodPressureCheck,
        targetRange: '<130/80 mm Hg',
        // condition: 'Hypertension',
      ),
      HealthActivity(
        id: 'lisinopril_morning',
        title: 'Take Lisinopril',
        type: HealthActivityType.medication,
        dosage: '10-40 mg',
        condition: 'Hypertension',
      ),

      // Morning - After Meal
      HealthActivity(
        id: 'blood_sugar_morning',
        title: 'Check Fasting Blood Sugar',
        type: HealthActivityType.bloodSugarCheck,
        targetRange: '80-130 mg/dL',
        ctaText: 'Take glucose test',
        ctaIcon: Icons.arrow_forward,
      ),
      HealthActivity(
        id: 'atorvastatin_morning',
        title: 'Atorvastatin',
        type: HealthActivityType.medication,
        targetRange: '80-130 mg/dL',
        condition: 'Type II Diabetes',
      ),

      // Mid-Day - Before Lunch
      HealthActivity(
        id: 'bp_midday_before',
        title: 'Check Blood Pressure',
        type: HealthActivityType.bloodPressureCheck,
        targetRange: '<130/80 mm Hg',
      ),

      // Mid-Day
      HealthActivity(
        id: 'balanced_meal',
        title: 'Eat Balanced Meal',
        type: HealthActivityType.meal,
        description: 'Low Sodium and Sugar',
      ),

      // Mid-Day - After Lunch
      HealthActivity(
        id: 'bp_midday_after',
        title: 'Check Blood Pressure',
        type: HealthActivityType.bloodPressureCheck,
        targetRange: '<130/80 mm Hg',
      ),
      HealthActivity(
        id: 'atorvastatin_midday',
        title: 'Atorvastatin',
        type: HealthActivityType.medication,
        targetRange: '80-130 mg/dL',
        condition: 'Insomnia',
      ),

      // Evening - Before Meal
      HealthActivity(
        id: 'exercise_evening',
        title: 'Exercise (30 minute or equivalent)',
        type: HealthActivityType.exercise,
        description: 'Maintain Fitness',
      ),

      // Evening - After Meal
      HealthActivity(
        id: 'bp_evening_after',
        title: 'Check Blood Pressure',
        type: HealthActivityType.bloodPressureCheck,
        targetRange: '<130/80 mm Hg',
      ),
      HealthActivity(
        id: 'atorvastatin_evening',
        title: 'Atorvastatin',
        type: HealthActivityType.medication,
        targetRange: '80-130 mg/dL',
        condition: 'Insomnia',
      ),
    ];

    // Initialize medications data
    final mockMedications = [
      HealthActivity(
        id: 'hydrochlorothiazide_1',
        title: 'Hydrochlorothiazide',
        subtitle: '2 tablets before lunch, 1 tablet before dinner.',
        type: HealthActivityType.medication,
        dosage: '13.5 mg',
        condition: 'Hypertension',
      ),
      HealthActivity(
        id: 'hydrochlorothiazide_2',
        title: 'Hydrochlorothiazide',
        subtitle: '2 tablets before lunch, 1 tablet before dinner.',
        type: HealthActivityType.medication,
        dosage: '13.5 mg',
        condition: 'Hypertension',
      ),
      HealthActivity(
        id: 'hydrochlorothiazide_3',
        title: 'Hydrochlorothiazide',
        subtitle: '2 tablets before lunch, 1 tablet before dinner.n',
        type: HealthActivityType.medication,
        dosage: '13.5 mg',
        condition: 'Hypertension',
      ),
      HealthActivity(
        id: 'metformin_1',
        title: 'Metformin',
        subtitle: '2 tablets before lunch, 1 tablet before dinner.',
        type: HealthActivityType.medication,
        dosage: '500 mg',
        condition: 'Type II Diabetes',
      ),
      HealthActivity(
        id: 'metformin_2',
        title: 'Metformin',
        subtitle: '2 tablets before lunch, 1 tablet before dinner.',
        type: HealthActivityType.medication,
        dosage: '850 mg',
        condition: 'Type II Diabetes',
      ),
      HealthActivity(
        id: 'simvastatin_1',
        title: 'Simvastatin',
        subtitle: '2 tablets before lunch, 1 tablet before dinner.',
        type: HealthActivityType.medication,
        dosage: '20 mg',
        condition: 'Hyperlipidemia',
      ),
      HealthActivity(
        id: 'simvastatin_2',
        title: 'Simvastatin',
        subtitle: '2 tablets before lunch, 1 tablet before dinner.',
        type: HealthActivityType.medication,
        dosage: '40 mg',
        condition: 'Hyperlipidemia',
      ),
      // Additional conditions to demonstrate dynamic filtering
      HealthActivity(
        id: 'levothyroxine_1',
        title: 'Levothyroxine',
        subtitle: '2 tablets before lunch, 1 tablet before dinner.',
        type: HealthActivityType.medication,
        dosage: '75 mcg',
        condition: 'Hypothyroidism',
      ),
      HealthActivity(
        id: 'omeprazole_1',
        title: 'Omeprazole',
        subtitle: '2 tablets before lunch, 1 tablet before dinner.',
        type: HealthActivityType.medication,
        dosage: '20 mg',
        condition: 'GERD',
      ),
      HealthActivity(
        id: 'albuterol_1',
        title: 'Albuterol Inhaler',
        subtitle: '2 tablets before lunch, 1 tablet before dinner.',
        type: HealthActivityType.medication,
        dosage: '90 mcg',
        condition: 'Asthma',
      ),
    ];

    final mockTimeSlots = [
      HealthTimeSlot(
        id: 'morning_before_meal',
        title: 'Morning - Before Meal',
        type: TimeSlotType.beforeMeal,
        timeOfDay: TimeOfDay.morning,
        mealTiming: MealTiming.beforeBreakfast,
        activities: [
          mockActivities.firstWhere((a) => a.id == 'bp_morning_before'),
          mockActivities.firstWhere((a) => a.id == 'bg_morning_before'),
          mockActivities.firstWhere((a) => a.id == 'lisinopril_morning'),
        ],
      ),
      HealthTimeSlot(
        id: 'morning_after_meal',
        title: 'Morning - After Meal',
        type: TimeSlotType.afterMeal,
        timeOfDay: TimeOfDay.morning,
        mealTiming: MealTiming.afterBreakfast,
        activities: [
          mockActivities.firstWhere((a) => a.id == 'blood_sugar_morning'),
          mockActivities.firstWhere((a) => a.id == 'atorvastatin_morning'),
        ],
      ),
      HealthTimeSlot(
        id: 'midday_before_lunch',
        title: 'Mid-Day - Before Lunch',
        type: TimeSlotType.beforeMeal,
        timeOfDay: TimeOfDay.midDay,
        mealTiming: MealTiming.beforeLunch,
        activities: [
          mockActivities.firstWhere((a) => a.id == 'bp_midday_before'),
        ],
      ),
      HealthTimeSlot(
        id: 'midday',
        title: 'Mid-Day',
        type: TimeSlotType.general,
        timeOfDay: TimeOfDay.midDay,
        activities: [mockActivities.firstWhere((a) => a.id == 'balanced_meal')],
      ),
      HealthTimeSlot(
        id: 'midday_after_lunch',
        title: 'Mid-Day - After Lunch',
        type: TimeSlotType.afterMeal,
        timeOfDay: TimeOfDay.midDay,
        mealTiming: MealTiming.afterLunch,
        activities: [
          mockActivities.firstWhere((a) => a.id == 'bp_midday_after'),
          mockActivities.firstWhere((a) => a.id == 'atorvastatin_midday'),
        ],
      ),
      HealthTimeSlot(
        id: 'evening_before_meal',
        title: 'Evening - Before Meal',
        type: TimeSlotType.beforeMeal,
        timeOfDay: TimeOfDay.evening,
        mealTiming: MealTiming.beforeDinner,
        activities: [
          mockActivities.firstWhere((a) => a.id == 'exercise_evening'),
        ],
      ),
      HealthTimeSlot(
        id: 'evening_after_meal',
        title: 'Evening - After Meal',
        type: TimeSlotType.afterMeal,
        timeOfDay: TimeOfDay.evening,
        mealTiming: MealTiming.afterDinner,
        activities: [
          mockActivities.firstWhere((a) => a.id == 'bp_evening_after'),
          mockActivities.firstWhere((a) => a.id == 'atorvastatin_evening'),
        ],
      ),
    ];

    _updateAllActivities(mockActivities);
    _updateMedications(mockMedications);
    _updateTimeSlots(mockTimeSlots);
  }

  // Dynamic medication filters based on actual patient conditions
  List<String> get dynamicMedicationFilters {
    // Get unique conditions from medications
    final conditions =
        _medications
            .map((med) => med.condition)
            .where((condition) => condition != null)
            .cast<String>()
            .toSet()
            .toList();

    // Sort conditions alphabetically for consistent UI
    conditions.sort();

    // Always include "All" as the first option
    return ['All', ...conditions];
  }
}
