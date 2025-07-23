import 'dart:async';

import 'package:ausa/features/appointments/controller/appointments_controller.dart';
import 'package:ausa/features/appointments/model/appointment.dart';
import 'package:ausa/features/appointments/model/time_slot.dart';
import 'package:get/get.dart';

class AppointmentSchedulingController extends GetxController {
  // Private observable state
  final RxBool _isMonthView = false.obs;
  final RxInt _currentStep = 1.obs;
  final Rx<DateTime> _selectedDate = DateTime.now().obs;
  final Rx<TimeSlot?> _selectedTimeSlot = Rx<TimeSlot?>(null);
  final RxString _symptomsText = ''.obs;
  final RxBool _isRecording = false.obs;
  final RxBool _isLoading = false.obs;
  final RxList<TimeSlot> _availableTimeSlots = <TimeSlot>[].obs;
  final RxBool _showSuccessPopup = false.obs;
  final RxMap<String, List<TimeSlot>> _timeSlotsCache =
      <String, List<TimeSlot>>{}.obs;
  Timer? _autoNavigateTimer;

  // Public getters
  bool get isMonthView => _isMonthView.value;
  int get currentStep => _currentStep.value;
  DateTime get selectedDate => _selectedDate.value;
  TimeSlot? get selectedTimeSlot => _selectedTimeSlot.value;
  String get symptomsText => _symptomsText.value;
  bool get isRecording => _isRecording.value;
  bool get isLoading => _isLoading.value;
  List<TimeSlot> get availableTimeSlots => _availableTimeSlots;
  bool get showSuccessPopup => _showSuccessPopup.value;
  bool get canFinish => _selectedTimeSlot.value != null;

  @override
  void onInit() {
    super.onInit();
    _loadTimeSlots();
  }

  @override
  void onClose() {
    _cancelAutoNavigateTimer();
    super.onClose();
  }

  // Private update methods
  void _updateIsMonthView(bool value) => _isMonthView.value = value;
  void _updateCurrentStep(int step) => _currentStep.value = step;
  void _updateSelectedDate(DateTime date) => _selectedDate.value = date;
  void _updateSelectedTimeSlot(TimeSlot? timeSlot) =>
      _selectedTimeSlot.value = timeSlot;
  void _updateSymptomsText(String text) => _symptomsText.value = text;
  void _updateIsRecording(bool recording) => _isRecording.value = recording;
  void _updateIsLoading(bool loading) => _isLoading.value = loading;
  void _updateAvailableTimeSlots(List<TimeSlot> slots) =>
      _availableTimeSlots
        ..assignAll(slots)
        ..refresh();
  void _updateShowSuccessPopup(bool show) => _showSuccessPopup.value = show;

  // Public action methods
  void toggleMonthView() {
    _updateIsMonthView(!_isMonthView.value);
    if (_isMonthView.value) {
      _updateCurrentStep(1);
    }
  }

  void goToStep2() {
    if (_selectedTimeSlot.value != null) {
      _updateCurrentStep(2);
    }
  }

  void goBackToStep1() {
    _updateCurrentStep(1);
  }

  void handleBackPressed() {
    Get.back();
  }

  void selectDate(DateTime date) {
    _updateSelectedDate(date);
    _updateSelectedTimeSlot(null);
    _loadTimeSlots();
  }

  void selectTimeSlot(TimeSlot timeSlot) {
    if (timeSlot.isAvailable) {
      _updateSelectedTimeSlot(timeSlot);
    }
  }

  void updateSymptomsText(String text) {
    _updateSymptomsText(text);
  }

  void clearSymptomsText() {
    _updateSymptomsText('');
  }

  void startRecording() {
    _updateIsRecording(true);
    // Simulate recording
    Future.delayed(const Duration(seconds: 2), () {
      _updateIsRecording(false);
      _updateSymptomsText('Severe headache and fatigue since last 2 days.');
    });
  }

  void stopRecording() {
    _updateIsRecording(false);
  }

  Future<void> scheduleAppointment() async {
    if (!canFinish) return;

    try {
      _updateIsLoading(true);

      final newAppointment = Appointment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        dateTime: _selectedTimeSlot.value!.dateTime,
        doctorName: 'Primary Care Physician',
        doctorType: 'General Medicine',
        symptoms:
            _symptomsText.value.trim().isEmpty
                ? 'No symptoms specified'
                : _symptomsText.value,
        status: AppointmentStatus.confirmed,
      );

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Add the new appointment to the global appointments list
      final appointmentsController = Get.find<AppointmentsController>();
      appointmentsController.addNewAppointment(newAppointment);

      _updateShowSuccessPopup(true);
      _resetForm();

      // Start auto-navigation timer
      _startAutoNavigateTimer();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to schedule appointment. Please try again.',
        backgroundColor: Get.theme.colorScheme.error,
      );
    } finally {
      _updateIsLoading(false);
    }
  }

  void closeSuccessPopup() {
    _cancelAutoNavigateTimer();
    _updateShowSuccessPopup(false);
    navigateToScheduledAppointments();
  }

  void navigateToScheduledAppointments() {
    Get.toNamed('/appointments/scheduled');
  }

  void _startAutoNavigateTimer() {
    _cancelAutoNavigateTimer(); // Cancel any existing timer
    _autoNavigateTimer = Timer(const Duration(seconds: 10), () {
      if (showSuccessPopup) {
        closeSuccessPopup();
      }
    });
  }

  void _cancelAutoNavigateTimer() {
    _autoNavigateTimer?.cancel();
    _autoNavigateTimer = null;
  }

  // Check if a date has available time slots (for calendar border feature)
  bool hasAvailableTimeSlots(DateTime date) {
    final dateKey = _getDateKey(date);
    if (_timeSlotsCache.containsKey(dateKey)) {
      return _timeSlotsCache[dateKey]!.any((slot) => slot.isAvailable);
    }

    // Generate slots for this date to check availability
    final slots = _generateTimeSlotsForDate(date);
    _timeSlotsCache[dateKey] = slots;
    return slots.any((slot) => slot.isAvailable);
  }

  void _resetForm() {
    _updateSelectedTimeSlot(null);
    _updateSymptomsText('');
    _updateCurrentStep(1);
    _updateIsMonthView(false);
  }

  void _loadTimeSlots() {
    try {
      final dateKey = _getDateKey(_selectedDate.value);

      List<TimeSlot> slots;
      if (_timeSlotsCache.containsKey(dateKey)) {
        slots = _timeSlotsCache[dateKey]!;
      } else {
        slots = _generateTimeSlotsForDate(_selectedDate.value);
        _timeSlotsCache[dateKey] = slots;
      }

      _updateAvailableTimeSlots(slots);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load available time slots.',
        backgroundColor: Get.theme.colorScheme.error,
      );
    }
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  List<TimeSlot> _generateTimeSlotsForDate(DateTime selectedDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    // No slots for past dates
    if (targetDate.isBefore(today)) {
      return [];
    }

    // Different availability patterns based on day of week and date
    final dayOfWeek = selectedDate.weekday;
    final dayOfMonth = selectedDate.day;

    // Weekend has limited availability
    if (dayOfWeek == 6 || dayOfWeek == 7) {
      return _generateWeekendSlots(selectedDate);
    }

    // Weekday patterns
    if (dayOfMonth % 7 == 0) {
      // Every 7th day has no availability (doctor off)
      return [];
    } else if (dayOfMonth % 3 == 0) {
      // Every 3rd day has limited morning slots only
      return _generateMorningOnlySlots(selectedDate);
    } else if (dayOfMonth % 5 == 0) {
      // Every 5th day has afternoon slots only
      return _generateAfternoonOnlySlots(selectedDate);
    } else {
      // Regular days have full availability with some slots booked
      return _generateRegularSlots(selectedDate);
    }
  }

  List<TimeSlot> _generateWeekendSlots(DateTime selectedDate) {
    final slots = <TimeSlot>[];
    // Weekend: Only morning emergency slots
    final timeSlots = ['09:00 AM', '10:00 AM', '11:00 AM'];

    for (int i = 0; i < timeSlots.length; i++) {
      final timeParts = timeSlots[i].split(' ');
      final hourMinute = timeParts[0].split(':');
      int hour = int.parse(hourMinute[0]);
      final minute = int.parse(hourMinute[1]);
      final period = timeParts[1];

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      final slotDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        hour,
        minute,
      );

      slots.add(
        TimeSlot(
          id: 'weekend_slot_${selectedDate.millisecondsSinceEpoch}_$i',
          dateTime: slotDateTime,
          isAvailable: i < 2, // Only first 2 slots available
          doctorId: 'emergency_doctor',
        ),
      );
    }

    return slots;
  }

  List<TimeSlot> _generateMorningOnlySlots(DateTime selectedDate) {
    final slots = <TimeSlot>[];
    final timeSlots = ['10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM'];

    for (int i = 0; i < timeSlots.length; i++) {
      final timeParts = timeSlots[i].split(' ');
      final hourMinute = timeParts[0].split(':');
      int hour = int.parse(hourMinute[0]);
      final minute = int.parse(hourMinute[1]);
      final period = timeParts[1];

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      final slotDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        hour,
        minute,
      );

      slots.add(
        TimeSlot(
          id: 'morning_slot_${selectedDate.millisecondsSinceEpoch}_$i',
          dateTime: slotDateTime,
          isAvailable: i != 1, // Second slot is booked
          doctorId: 'doctor_morning',
        ),
      );
    }

    return slots;
  }

  List<TimeSlot> _generateAfternoonOnlySlots(DateTime selectedDate) {
    final slots = <TimeSlot>[];
    final timeSlots = [
      '02:00 PM',
      '02:30 PM',
      '03:00 PM',
      '03:30 PM',
      '04:00 PM',
    ];

    for (int i = 0; i < timeSlots.length; i++) {
      final timeParts = timeSlots[i].split(' ');
      final hourMinute = timeParts[0].split(':');
      int hour = int.parse(hourMinute[0]);
      final minute = int.parse(hourMinute[1]);
      final period = timeParts[1];

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      final slotDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        hour,
        minute,
      );

      slots.add(
        TimeSlot(
          id: 'afternoon_slot_${selectedDate.millisecondsSinceEpoch}_$i',
          dateTime: slotDateTime,
          isAvailable: i != 2 && i != 3, // 3rd and 4th slots booked
          doctorId: 'doctor_afternoon',
        ),
      );
    }

    return slots;
  }

  List<TimeSlot> _generateRegularSlots(DateTime selectedDate) {
    final slots = <TimeSlot>[];
    final timeSlots = [
      '10:00 AM',
      '10:30 AM',
      '11:00 AM',
      '11:30 AM',
      '12:00 PM',
      '12:30 PM',
      '02:00 PM',
      '02:30 PM',
      '03:00 PM',
      '03:30 PM',
      '04:00 PM',
    ];

    for (int i = 0; i < timeSlots.length; i++) {
      final timeParts = timeSlots[i].split(' ');
      final hourMinute = timeParts[0].split(':');
      int hour = int.parse(hourMinute[0]);
      final minute = int.parse(hourMinute[1]);
      final period = timeParts[1];

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      final slotDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        hour,
        minute,
      );

      // Random availability pattern - about 70% available
      final isAvailable =
          ![2, 4, 7, 9].contains(i); // Some specific slots are booked

      slots.add(
        TimeSlot(
          id: 'regular_slot_${selectedDate.millisecondsSinceEpoch}_$i',
          dateTime: slotDateTime,
          isAvailable: isAvailable,
          doctorId: 'doctor_primary',
        ),
      );
    }

    return slots;
  }
}
