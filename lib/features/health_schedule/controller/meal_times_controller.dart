import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MealTimesController extends GetxController {
  // Observable state
  final RxInt selectedMealIndex = 0.obs; // 0: Breakfast, 1: Lunch, 2: Dinner

  // Meal times
  final RxString breakfastTime = '7:00 AM'.obs;
  final RxString lunchTime = '12:30 PM'.obs;
  final RxString dinnerTime = '8:00 PM'.obs;

  // Time picker state
  final RxInt selectedHour = 7.obs;
  final RxInt selectedMinute = 0.obs;
  final RxString selectedPeriod = 'AM'.obs;

  // Meal data
  final List<Map<String, dynamic>> meals = [
    {'name': 'Breakfast', 'icon': Icons.wb_sunny_outlined, 'time': '7:00 AM'},
    {'name': 'Lunch', 'icon': Icons.lunch_dining, 'time': '12:30 PM'},
    {'name': 'Dinner', 'icon': Icons.brightness_3_outlined, 'time': '8:00 PM'},
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeTime();
  }

  void _initializeTime() {
    // Initialize time picker with current breakfast time
    updateTimePickerFromMeal(0);
  }

  void selectMeal(int index) {
    selectedMealIndex.value = index;
    updateTimePickerFromMeal(index);
    _validateAndAdjustTime();
  }

  void updateTimePickerFromMeal(int mealIndex) {
    String timeString;
    switch (mealIndex) {
      case 0:
        timeString = breakfastTime.value;
        break;
      case 1:
        timeString = lunchTime.value;
        break;
      case 2:
        timeString = dinnerTime.value;
        break;
      default:
        timeString = '7:00 AM';
    }

    _parseTimeString(timeString);
  }

  void _parseTimeString(String timeString) {
    // Parse time string like "7:00 AM" or "12:30 PM"
    final parts = timeString.split(' ');
    final period = parts.length > 1 ? parts[1] : 'AM'; // AM or PM
    final timeParts = parts[0].split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    selectedHour.value = hour;
    selectedMinute.value = minute;
    selectedPeriod.value = period;
  }

  void updateHour(int hour) {
    selectedHour.value = hour;
    _updateCurrentMealTime();
  }

  void updateMinute(int minute) {
    selectedMinute.value = minute;
    _updateCurrentMealTime();
  }

  void updatePeriod(String period) {
    selectedPeriod.value = period;
    _updateCurrentMealTime();
  }

  void _updateCurrentMealTime() {
    String formattedTime;

    switch (selectedMealIndex.value) {
      case 0: // Breakfast - only AM, no period shown
        formattedTime =
            '${selectedHour.value}:${selectedMinute.value.toString().padLeft(2, '0')} AM';
        breakfastTime.value = formattedTime;
        meals[0]['time'] = formattedTime;
        break;
      case 1: // Lunch - only PM, no period shown
        formattedTime =
            '${selectedHour.value}:${selectedMinute.value.toString().padLeft(2, '0')} PM';
        lunchTime.value = formattedTime;
        meals[1]['time'] = formattedTime;
        break;
      case 2: // Dinner - can be AM or PM
        formattedTime =
            '${selectedHour.value}:${selectedMinute.value.toString().padLeft(2, '0')} ${selectedPeriod.value}';
        dinnerTime.value = formattedTime;
        meals[2]['time'] = formattedTime;
        break;
    }
  }

  String get currentMealName {
    return meals[selectedMealIndex.value]['name'];
  }

  // Get available hours for current meal
  List<int> get availableHours {
    switch (selectedMealIndex.value) {
      case 0: // Breakfast: 4:00 AM - 11:59 AM
        return List.generate(
          8,
          (index) => index + 4,
        ); // 4, 5, 6, 7, 8, 9, 10, 11
      case 1: // Lunch: 12:00 PM - 4:59 PM
        return [12, 1, 2, 3, 4]; // 12 PM, 1 PM, 2 PM, 3 PM, 4 PM
      case 2: // Dinner: 5:00 PM - 3:59 AM
        if (selectedPeriod.value == 'PM') {
          return [5, 6, 7, 8, 9, 10, 11, 12]; // 5 PM to 12 AM
        } else {
          return [1, 2, 3]; // 1 AM, 2 AM, 3 AM
        }
      default:
        return [7];
    }
  }

  // Get available minutes (every 5 minutes)
  List<int> get availableMinutes {
    return List.generate(12, (index) => index * 5); // 0, 5, 10, 15, ..., 55
  }

  // Get available periods for current meal
  List<String> get availablePeriods {
    switch (selectedMealIndex.value) {
      case 0: // Breakfast - only AM
        return ['AM'];
      case 1: // Lunch - only PM
        return ['PM'];
      case 2: // Dinner - both AM and PM
        return ['PM', 'AM'];
      default:
        return ['AM'];
    }
  }

  // Check if AM/PM selector should be shown
  bool get shouldShowPeriodSelector {
    return selectedMealIndex.value == 2; // Only show for dinner
  }

  // Get display hour (12-hour format)
  int get displayHour {
    final hour = selectedHour.value;
    switch (selectedMealIndex.value) {
      case 0: // Breakfast - use hour as is (4-11)
        return hour;
      case 1: // Lunch - use hour as is (12, 1, 2, 3, 4)
        return hour;
      case 2: // Dinner - handle 12-hour format
        if (selectedPeriod.value == 'PM') {
          return hour; // 5-12 PM
        } else {
          return hour; // 1-3 AM
        }
      default:
        return hour;
    }
  }

  // Get current hour index in available hours list
  int get currentHourIndex {
    final hours = availableHours;
    final currentHour = displayHour;
    return hours.indexOf(currentHour).clamp(0, hours.length - 1);
  }

  // Get current minute index in available minutes list
  int get currentMinuteIndex {
    final minutes = availableMinutes;
    return minutes.indexOf(selectedMinute.value).clamp(0, minutes.length - 1);
  }

  // Get current period index
  int get currentPeriodIndex {
    final periods = availablePeriods;
    return periods.indexOf(selectedPeriod.value).clamp(0, periods.length - 1);
  }

  void saveMealTimes() {
    // TODO: Save meal times to storage/backend
    Get.back();
    Get.snackbar(
      'Success',
      'Meal times updated successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _validateAndAdjustTime() {
    final hours = availableHours;
    final minutes = availableMinutes;
    final periods = availablePeriods;

    // Validate hour
    if (!hours.contains(selectedHour.value)) {
      selectedHour.value = hours.first;
    }

    // Validate minute
    if (!minutes.contains(selectedMinute.value)) {
      selectedMinute.value = minutes.first;
    }

    // Validate period
    if (!periods.contains(selectedPeriod.value)) {
      selectedPeriod.value = periods.first;
    }

    _updateCurrentMealTime();
  }
}
