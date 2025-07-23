import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/constants.dart';
import 'package:ausa/constants/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MealTimesController extends GetxController {
  // Private observable state
  final RxInt _selectedMealIndex = 0.obs; // 0: Breakfast, 1: Lunch, 2: Dinner

  // Time observables
  final RxString _breakfastTime = '7:00 AM'.obs;
  final RxString _lunchTime = '12:30 PM'.obs;
  final RxString _dinnerTime = '8:00 PM'.obs;

  // Original times for comparison (to detect changes)
  final RxString _originalBreakfastTime = '7:00 AM'.obs;
  final RxString _originalLunchTime = '12:30 PM'.obs;
  final RxString _originalDinnerTime = '8:00 PM'.obs;

  // Dialog state
  final RxBool _isDialogShowing = false.obs;

  // Scroll controllers for time picker
  FixedExtentScrollController? _hourScrollController;
  FixedExtentScrollController? _minuteScrollController;
  FixedExtentScrollController? _periodScrollController;

  // AM/PM observable for each meal (only dinner is interactive)
  final RxString _breakfastPeriod = 'AM'.obs; // Fixed
  final RxString _lunchPeriod = 'PM'.obs; // Fixed
  final RxString _dinnerPeriod = 'PM'.obs; // Interactive

  // Time picker state
  final RxInt _selectedHour = 7.obs;
  final RxInt _selectedMinute = 0.obs;
  final RxString _selectedPeriod = 'AM'.obs;

  // Public getters
  int get selectedMealIndex => _selectedMealIndex.value;
  String get breakfastTime => _breakfastTime.value;
  String get lunchTime => _lunchTime.value;
  String get dinnerTime => _dinnerTime.value;
  String get originalBreakfastTime => _originalBreakfastTime.value;
  String get originalLunchTime => _originalLunchTime.value;
  String get originalDinnerTime => _originalDinnerTime.value;
  int get selectedHour => _selectedHour.value;
  int get selectedMinute => _selectedMinute.value;
  String get selectedPeriod => _selectedPeriod.value;
  String get breakfastPeriod => _breakfastPeriod.value;
  String get lunchPeriod => _lunchPeriod.value;
  String get dinnerPeriod => _dinnerPeriod.value;

  // Scroll controller getters
  FixedExtentScrollController? get hourScrollController =>
      _hourScrollController;
  FixedExtentScrollController? get minuteScrollController =>
      _minuteScrollController;
  FixedExtentScrollController? get periodScrollController =>
      _periodScrollController;

  // Meals data with SVG icons
  List<Map<String, dynamic>> get meals => [
    {
      'name': 'Breakfast',
      'iconPath': AusaIcons.sunSetting01,
      'time': '7:00 AM',
    },
    {'name': 'Lunch', 'iconPath': AusaIcons.cloudSun02, 'time': '12:30 PM'},
    {'name': 'Dinner', 'iconPath': AusaIcons.moon01, 'time': '8:00 PM'},
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeTime();
    _initializeScrollControllers();
  }

  @override
  void onClose() {
    _hourScrollController?.dispose();
    _minuteScrollController?.dispose();
    _periodScrollController?.dispose();
    super.onClose();
  }

  // Initialize scroll controllers
  void _initializeScrollControllers() {
    _hourScrollController = FixedExtentScrollController(
      initialItem: currentHourIndex,
    );
    _minuteScrollController = FixedExtentScrollController(
      initialItem: currentMinuteIndex,
    );
    _periodScrollController = FixedExtentScrollController(
      initialItem: currentPeriodIndex,
    );
  }

  // Update scroll controllers to center the selected values
  void _updateScrollControllers() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_hourScrollController?.hasClients == true) {
        _hourScrollController!.animateToItem(
          currentHourIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      if (_minuteScrollController?.hasClients == true) {
        _minuteScrollController!.animateToItem(
          currentMinuteIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      if (_periodScrollController?.hasClients == true) {
        _periodScrollController!.animateToItem(
          currentPeriodIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // Private update methods
  void _updateSelectedMealIndex(int index) => _selectedMealIndex.value = index;
  void _updateBreakfastTime(String time) => _breakfastTime.value = time;
  void _updateLunchTime(String time) => _lunchTime.value = time;
  void _updateDinnerTime(String time) => _dinnerTime.value = time;
  void _updateSelectedHour(int hour) => _selectedHour.value = hour;
  void _updateSelectedMinute(int minute) => _selectedMinute.value = minute;
  void _updateSelectedPeriod(String period) => _selectedPeriod.value = period;

  void _initializeTime() {
    // Store original times
    _originalBreakfastTime.value = _breakfastTime.value;
    _originalLunchTime.value = _lunchTime.value;
    _originalDinnerTime.value = _dinnerTime.value;

    // Initialize time picker with current breakfast time
    updateTimePickerFromMeal(0);
  }

  // Method to update initial times (useful when navigating from other screens)
  void updateInitialTimes({
    String? breakfastTime,
    String? lunchTime,
    String? dinnerTime,
  }) {
    if (breakfastTime != null) {
      _breakfastTime.value = breakfastTime;
      _originalBreakfastTime.value = breakfastTime;
      meals[0]['time'] = breakfastTime;
    }
    if (lunchTime != null) {
      _lunchTime.value = lunchTime;
      _originalLunchTime.value = lunchTime;
      meals[1]['time'] = lunchTime;
    }
    if (dinnerTime != null) {
      _dinnerTime.value = dinnerTime;
      _originalDinnerTime.value = dinnerTime;
      meals[2]['time'] = dinnerTime;
    }

    // Update time picker if needed
    updateTimePickerFromMeal(_selectedMealIndex.value);
    _updateScrollControllers();
  }

  // Check if any meal times have been changed
  bool get hasChanges {
    return _breakfastTime.value != _originalBreakfastTime.value ||
        _lunchTime.value != _originalLunchTime.value ||
        _dinnerTime.value != _originalDinnerTime.value;
  }

  // Get list of changed meal times for the confirmation dialog
  List<Map<String, String>> get changedMealTimes {
    List<Map<String, String>> changes = [];

    if (_breakfastTime.value != _originalBreakfastTime.value) {
      changes.add({'name': 'Breakfast', 'time': _breakfastTime.value});
    }

    if (_lunchTime.value != _originalLunchTime.value) {
      changes.add({'name': 'Lunch', 'time': _lunchTime.value});
    }

    if (_dinnerTime.value != _originalDinnerTime.value) {
      changes.add({'name': 'Dinner', 'time': _dinnerTime.value});
    }

    return changes;
  }

  // Handle back button press
  void handleBackPress() {
    if (_isDialogShowing.value) return; // Prevent multiple dialogs

    if (hasChanges) {
      _showConfirmationDialog();
    } else {
      Get.back();
    }
  }

  // Show confirmation dialog
  void _showConfirmationDialog() {
    final changes = changedMealTimes;

    _isDialogShowing.value = true;
    Get.dialog(
      _buildConfirmationDialog(changes),
      barrierDismissible: false,
    ).then((_) {
      _isDialogShowing.value = false;
    });
  }

  // Build confirmation dialog widget
  Widget _buildConfirmationDialog(List<Map<String, String>> changes) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 440,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl6,
          vertical: AppSpacing.xl4,
        ),
        decoration: BoxDecoration(
          color: Color(0xffF0F0F0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 96,
              height: 96,
              padding: EdgeInsets.all(AppSpacing.xl4),
              decoration: BoxDecoration(
                color: AppColors.primary700.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(color: AppColors.primary100, width: 1),
              ),
              child: SvgPicture.asset(
                AusaIcons.save03,
                colorFilter: ColorFilter.mode(
                  AppColors.primary700,
                  BlendMode.srcIn,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              'Save Changes?',
              style: AppTypography.headline(
                color: AppColors.primary700,
                weight: AppTypographyWeight.medium,
              ),
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              'You\'ve edited the following meal times, do you want to save these changes?',
              textAlign: TextAlign.left,
              style: AppTypography.body(
                color: AppColors.gray700,
                weight: AppTypographyWeight.medium,
              ),
            ),

            const SizedBox(height: 16),

            // Changed meal times list
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xl3,
                vertical: AppSpacing.xl4,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.xl3),
              ),
              child: Column(
                children:
                    changes
                        .map(
                          (change) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  change['name']!,
                                  style: AppTypography.body(
                                    color: AppColors.gray700,
                                    weight: AppTypographyWeight.medium,
                                  ),
                                ),
                                Text(
                                  change['time']!,
                                  style: AppTypography.body(
                                    color: AppColors.gray700,
                                    weight: AppTypographyWeight.medium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Cancel button
                AusaButton(
                  text: 'Cancel',
                  onPressed: () {
                    Get.back(); // Close dialog
                    _discardChanges();
                    Get.back(); // Go back to previous screen
                  },
                  variant: ButtonVariant.secondary,
                  size: ButtonSize.lg,
                ),

                const SizedBox(width: 12),

                AusaButton(
                  text: 'Confirm',
                  onPressed: () {
                    Get.back(); // Close dialog
                    _saveChanges();
                    Get.back(); // Go back to previous screen
                  },
                  variant: ButtonVariant.primary,
                  size: ButtonSize.lg,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Discard changes and restore original times
  void _discardChanges() {
    _breakfastTime.value = _originalBreakfastTime.value;
    _lunchTime.value = _originalLunchTime.value;
    _dinnerTime.value = _originalDinnerTime.value;

    // Update meals list
    meals[0]['time'] = _originalBreakfastTime.value;
    meals[1]['time'] = _originalLunchTime.value;
    meals[2]['time'] = _originalDinnerTime.value;
  }

  // Save changes and update original times
  void _saveChanges() {
    _originalBreakfastTime.value = _breakfastTime.value;
    _originalLunchTime.value = _lunchTime.value;
    _originalDinnerTime.value = _dinnerTime.value;

    // Show success message
    Get.snackbar(
      'Success',
      'Meal times updated successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void selectMeal(int index) {
    _updateSelectedMealIndex(index);
    updateTimePickerFromMeal(index);
    _validateAndAdjustTime();
    _updateScrollControllers();
  }

  void updateTimePickerFromMeal(int mealIndex) {
    String timeString;
    switch (mealIndex) {
      case 0:
        timeString = _breakfastTime.value;
        break;
      case 1:
        timeString = _lunchTime.value;
        break;
      case 2:
        timeString = _dinnerTime.value;
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

    _updateSelectedHour(hour);
    _updateSelectedMinute(minute);
    _updateSelectedPeriod(period);
  }

  void updateHour(int hour) {
    _updateSelectedHour(hour);
    _updateCurrentMealTime();
  }

  void updateMinute(int minute) {
    _updateSelectedMinute(minute);
    _updateCurrentMealTime();
  }

  void updatePeriod(String period) {
    _updateSelectedPeriod(period);
    _updateCurrentMealTime();
  }

  void _updateCurrentMealTime() {
    String formattedTime;

    switch (_selectedMealIndex.value) {
      case 0: // Breakfast - only AM, no period shown
        formattedTime =
            '${_selectedHour.value}:${_selectedMinute.value.toString().padLeft(2, '0')} AM';
        _updateBreakfastTime(formattedTime);
        meals[0]['time'] = formattedTime;
        break;
      case 1: // Lunch - only PM, no period shown
        formattedTime =
            '${_selectedHour.value}:${_selectedMinute.value.toString().padLeft(2, '0')} PM';
        _updateLunchTime(formattedTime);
        meals[1]['time'] = formattedTime;
        break;
      case 2: // Dinner - can be AM or PM
        formattedTime =
            '${_selectedHour.value}:${_selectedMinute.value.toString().padLeft(2, '0')} ${_selectedPeriod.value}';
        _updateDinnerTime(formattedTime);
        meals[2]['time'] = formattedTime;
        break;
    }
  }

  String get currentMealName {
    return meals[_selectedMealIndex.value]['name'];
  }

  // Get available hours for current meal
  List<int> get availableHours {
    switch (_selectedMealIndex.value) {
      case 0: // Breakfast: 4:00 AM - 11:59 AM
        return List.generate(
          8,
          (index) => index + 4,
        ); // 4, 5, 6, 7, 8, 9, 10, 11
      case 1: // Lunch: 12:00 PM - 4:59 PM
        return [12, 1, 2, 3, 4]; // 12 PM, 1 PM, 2 PM, 3 PM, 4 PM
      case 2: // Dinner: 5:00 PM - 3:59 AM
        if (_selectedPeriod.value == 'PM') {
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
    switch (_selectedMealIndex.value) {
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
    return _selectedMealIndex.value == 2; // Only show for dinner
  }

  // Get display hour (12-hour format)
  int get displayHour {
    final hour = _selectedHour.value;
    switch (_selectedMealIndex.value) {
      case 0: // Breakfast - use hour as is (4-11)
        return hour;
      case 1: // Lunch - use hour as is (12, 1, 2, 3, 4)
        return hour;
      case 2: // Dinner - handle 12-hour format
        if (_selectedPeriod.value == 'PM') {
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
    return minutes.indexOf(_selectedMinute.value).clamp(0, minutes.length - 1);
  }

  // Get current period index
  int get currentPeriodIndex {
    final periods = availablePeriods;
    return periods.indexOf(_selectedPeriod.value).clamp(0, periods.length - 1);
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
    if (!hours.contains(_selectedHour.value)) {
      _updateSelectedHour(hours.first);
    }

    // Validate minute
    if (!minutes.contains(_selectedMinute.value)) {
      _updateSelectedMinute(minutes.first);
    }

    // Validate period
    if (!periods.contains(_selectedPeriod.value)) {
      _updateSelectedPeriod(periods.first);
    }

    _updateCurrentMealTime();
  }
}
