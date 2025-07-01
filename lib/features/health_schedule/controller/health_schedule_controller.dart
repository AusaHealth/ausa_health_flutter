import 'package:get/get.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import '../model/health_activity.dart';
import '../model/health_time_slot.dart';
import '../page/meal_times_page.dart';

class HealthScheduleController extends GetxController {
  // Observable state
  final RxInt currentTabIndex = 0.obs; // 0: Routine, 1: Medication
  final RxInt selectedTimeFilter =
      0.obs; // 0: All day, 1: Morning, 2: Afternoon, 3: Evening
  final RxInt selectedMedicationFilter =
      0.obs; // 0: All, 1: Hypertension, 2: Type II Diabetes, 3: Hyperlipidemia
  final RxList<HealthTimeSlot> timeSlots = <HealthTimeSlot>[].obs;
  final RxList<HealthActivity> allActivities = <HealthActivity>[].obs;
  final RxList<HealthActivity> medications = <HealthActivity>[].obs;
  final RxBool showFloatingCTA = false.obs;
  final RxString floatingCTAText = ''.obs;

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
    _initializeMockData();
    _checkForPendingTests();
  }

  void switchTab(int index) {
    currentTabIndex.value = index;
  }

  void setTimeFilter(int index) {
    selectedTimeFilter.value = index;
  }

  void setMedicationFilter(int index) {
    selectedMedicationFilter.value = index;
  }

  void setMedicationFilterSafe(int index) {
    final maxIndex = dynamicMedicationFilters.length - 1;
    if (index >= 0 && index <= maxIndex) {
      selectedMedicationFilter.value = index;
    } else {
      // Reset to "All" if index is out of bounds
      selectedMedicationFilter.value = 0;
    }
  }

  List<HealthTimeSlot> get filteredTimeSlots {
    if (selectedTimeFilter.value == 0) {
      // All day - show all slots
      return timeSlots;
    }

    final filterMap = {
      1: TimeOfDay.morning,
      2: TimeOfDay.midDay,
      3: TimeOfDay.evening,
    };

    final selectedTimeOfDay = filterMap[selectedTimeFilter.value];
    if (selectedTimeOfDay == null) return timeSlots;

    return timeSlots
        .where((slot) => slot.timeOfDay == selectedTimeOfDay)
        .toList();
  }

  List<HealthActivity> get filteredActivities {
    if (currentTabIndex.value == 0) {
      // Routine tab - show all non-medication activities
      return allActivities
          .where((activity) => activity.type != HealthActivityType.medication)
          .toList();
    } else {
      // Medication tab - show only medication activities
      return allActivities
          .where((activity) => activity.type == HealthActivityType.medication)
          .toList();
    }
  }

  List<HealthActivity> get filteredMedications {
    if (selectedMedicationFilter.value == 0) {
      // All - show all medications
      return medications;
    }

    // Get the dynamic filter list and selected condition
    final filters = dynamicMedicationFilters;

    // Ensure the selected index is within bounds
    if (selectedMedicationFilter.value >= filters.length) {
      return medications;
    }

    final selectedCondition = filters[selectedMedicationFilter.value];

    // Filter medications by the selected condition
    return medications
        .where((medication) => medication.condition == selectedCondition)
        .toList();
  }

  void completeActivity(String activityId) {
    final activityIndex = allActivities.indexWhere(
      (activity) => activity.id == activityId,
    );
    if (activityIndex != -1) {
      allActivities[activityIndex] = allActivities[activityIndex].copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
      );
      _checkForPendingTests();
    }
  }

  void undoCompleteActivity(String activityId) {
    final activityIndex = allActivities.indexWhere(
      (activity) => activity.id == activityId,
    );
    if (activityIndex != -1) {
      allActivities[activityIndex] = allActivities[activityIndex].copyWith(
        isCompleted: false,
        completedAt: null,
      );
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
    final activity = allActivities.firstWhere(
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
        allActivities
            .where(
              (activity) =>
                  activity.type == HealthActivityType.bloodSugarCheck &&
                  !activity.isCompleted,
            )
            .toList();

    if (pendingBloodSugarTests.isNotEmpty) {
      showFloatingCTA.value = true;
      floatingCTAText.value = 'Take Glucose Test';
    } else {
      showFloatingCTA.value = false;
      floatingCTAText.value = '';
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
        subtitle: 'Dr. Adnan',
        type: HealthActivityType.medication,
        dosage: '13.5 mg',
        condition: 'Hypertension',
      ),
      HealthActivity(
        id: 'hydrochlorothiazide_2',
        title: 'Hydrochlorothiazide',
        subtitle: 'Dr. Adnan',
        type: HealthActivityType.medication,
        dosage: '13.5 mg',
        condition: 'Hypertension',
      ),
      HealthActivity(
        id: 'hydrochlorothiazide_3',
        title: 'Hydrochlorothiazide',
        subtitle: 'Dr. Adnan',
        type: HealthActivityType.medication,
        dosage: '13.5 mg',
        condition: 'Hypertension',
      ),
      HealthActivity(
        id: 'metformin_1',
        title: 'Metformin',
        subtitle: 'Dr. Smith',
        type: HealthActivityType.medication,
        dosage: '500 mg',
        condition: 'Type II Diabetes',
      ),
      HealthActivity(
        id: 'metformin_2',
        title: 'Metformin',
        subtitle: 'Dr. Smith',
        type: HealthActivityType.medication,
        dosage: '850 mg',
        condition: 'Type II Diabetes',
      ),
      HealthActivity(
        id: 'simvastatin_1',
        title: 'Simvastatin',
        subtitle: 'Dr. Johnson',
        type: HealthActivityType.medication,
        dosage: '20 mg',
        condition: 'Hyperlipidemia',
      ),
      HealthActivity(
        id: 'simvastatin_2',
        title: 'Simvastatin',
        subtitle: 'Dr. Johnson',
        type: HealthActivityType.medication,
        dosage: '40 mg',
        condition: 'Hyperlipidemia',
      ),
      // Additional conditions to demonstrate dynamic filtering
      HealthActivity(
        id: 'levothyroxine_1',
        title: 'Levothyroxine',
        subtitle: 'Dr. Brown',
        type: HealthActivityType.medication,
        dosage: '75 mcg',
        condition: 'Hypothyroidism',
      ),
      HealthActivity(
        id: 'omeprazole_1',
        title: 'Omeprazole',
        subtitle: 'Dr. Davis',
        type: HealthActivityType.medication,
        dosage: '20 mg',
        condition: 'GERD',
      ),
      HealthActivity(
        id: 'aspirin_1',
        title: 'Aspirin',
        subtitle: 'Dr. Wilson',
        type: HealthActivityType.medication,
        dosage: '81 mg',
        condition: 'Cardiovascular Disease',
      ),
      HealthActivity(
        id: 'albuterol_1',
        title: 'Albuterol Inhaler',
        subtitle: 'Dr. Garcia',
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

    allActivities.assignAll(mockActivities);
    medications.assignAll(mockMedications);
    timeSlots.assignAll(mockTimeSlots);
  }

  // Dynamic medication filters based on actual patient conditions
  List<String> get dynamicMedicationFilters {
    // Get unique conditions from medications
    final conditions =
        medications
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
