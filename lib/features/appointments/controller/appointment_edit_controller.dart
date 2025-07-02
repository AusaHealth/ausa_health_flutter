import 'package:ausa/features/appointments/model/appointment.dart';
import 'package:ausa/features/appointments/model/time_slot.dart';
import 'package:ausa/features/appointments/service/appointment_service.dart';
import 'package:get/get.dart';

class AppointmentEditController extends GetxController {
  final Appointment appointment;
  final AppointmentService _appointmentService = Get.find<AppointmentService>();

  AppointmentEditController(this.appointment);

  // Observable state
  final RxBool _isMonthView = false.obs;
  final RxInt _currentStep = 1.obs;
  final Rx<DateTime> _selectedDate = DateTime.now().obs;
  final Rx<TimeSlot?> _selectedTimeSlot = Rx<TimeSlot?>(null);
  final RxString _symptomsText = ''.obs;
  final RxBool _isRecording = false.obs;
  final RxBool _isLoading = false.obs;
  final RxList<TimeSlot> _availableTimeSlots = <TimeSlot>[].obs;
  final RxBool _showDiscardDialog = false.obs;
  final RxBool _showCancelDialog = false.obs;

  // Original values for change tracking
  String? _originalSymptomsText;
  TimeSlot? _originalTimeSlot;
  DateTime? _originalDate;

  // Getters
  bool get isMonthView => _isMonthView.value;
  int get currentStep => _currentStep.value;
  DateTime get selectedDate => _selectedDate.value;
  TimeSlot? get selectedTimeSlot => _selectedTimeSlot.value;
  String get symptomsText => _symptomsText.value;
  bool get isRecording => _isRecording.value;
  bool get isLoading => _isLoading.value;
  List<TimeSlot> get availableTimeSlots => _availableTimeSlots;
  bool get showDiscardDialog => _showDiscardDialog.value;
  bool get showCancelDialog => _showCancelDialog.value;

  bool get canFinish => _selectedTimeSlot.value != null;

  bool get hasChanges {
    return _symptomsText.value != _originalSymptomsText ||
        _selectedTimeSlot.value?.id != _originalTimeSlot?.id ||
        !_isSameDay(_selectedDate.value, _originalDate ?? DateTime.now());
  }

  @override
  void onInit() {
    super.onInit();
    _initializeFromAppointment();
    _loadTimeSlots();
  }

  void _initializeFromAppointment() {
    _originalSymptomsText = appointment.symptoms;
    _originalDate = appointment.dateTime;

    _updateSymptomsText(appointment.symptoms);
    _updateSelectedDate(appointment.dateTime);
    _updateIsMonthView(true);
    _updateCurrentStep(1);

    // Find and set the matching time slot after loading
    Future.delayed(const Duration(milliseconds: 100), () {
      final matchingSlot = _availableTimeSlots.firstWhere(
        (slot) =>
            slot.dateTime.hour == appointment.dateTime.hour &&
            slot.dateTime.minute == appointment.dateTime.minute,
        orElse:
            () => TimeSlot(
              id: 'original_${appointment.id}',
              dateTime: appointment.dateTime,
              isAvailable: true,
            ),
      );
      _originalTimeSlot = matchingSlot;
      _updateSelectedTimeSlot(matchingSlot);
    });
  }

  // Event-based state updates (no direct state changes)
  void _updateIsMonthView(bool value) => _isMonthView.value = value;
  void _updateCurrentStep(int step) => _currentStep.value = step;
  void _updateSelectedDate(DateTime date) => _selectedDate.value = date;
  void _updateSelectedTimeSlot(TimeSlot? timeSlot) =>
      _selectedTimeSlot.value = timeSlot;
  void _updateSymptomsText(String text) => _symptomsText.value = text;
  void _updateIsRecording(bool recording) => _isRecording.value = recording;
  void _updateIsLoading(bool loading) => _isLoading.value = loading;
  void _updateAvailableTimeSlots(List<TimeSlot> slots) =>
      _availableTimeSlots.value = slots;
  void _updateShowDiscardDialog(bool show) => _showDiscardDialog.value = show;
  void _updateShowCancelDialog(bool show) => _showCancelDialog.value = show;

  // Navigation methods
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
    if (hasChanges) {
      showDiscardChangesDialog();
    } else {
      Get.back();
    }
  }

  // Date and time selection
  void selectDate(DateTime date) {
    _updateSelectedDate(date);
    _updateSelectedTimeSlot(null);
    _loadTimeSlots();
  }

  void selectTimeSlot(TimeSlot timeSlot) {
    if (timeSlot.isAvailable) {
      _updateSelectedTimeSlot(timeSlot);
      _updateSelectedDate(timeSlot.dateTime);
    }
  }

  // Symptoms management
  void updateSymptomsText(String text) {
    _updateSymptomsText(text);
  }

  void clearSymptomsText() {
    _updateSymptomsText('');
  }

  // Voice recording
  void startRecording() {
    _updateIsRecording(true);
    // Simulate recording
    Future.delayed(const Duration(seconds: 2), () {
      _updateIsRecording(false);
      _updateSymptomsText("Updated symptoms from voice input.");
    });
  }

  void stopRecording() {
    _updateIsRecording(false);
  }

  // Dialog management
  void showDiscardChangesDialog() {
    _updateShowDiscardDialog(true);
  }

  void hideDiscardChangesDialog() {
    _updateShowDiscardDialog(false);
  }

  void discardChanges() {
    _updateShowDiscardDialog(false);
    Get.back();
  }

  void showCancelAppointmentDialog() {
    _updateShowCancelDialog(true);
  }

  void hideCancelAppointmentDialog() {
    _updateShowCancelDialog(false);
  }

  // Business logic
  Future<void> updateAppointment() async {
    if (!canFinish) return;

    try {
      _updateIsLoading(true);

      final updatedAppointment = Appointment(
        id: appointment.id,
        dateTime: _selectedTimeSlot.value!.dateTime,
        doctorName: appointment.doctorName,
        doctorType: appointment.doctorType,
        symptoms:
            _symptomsText.value.trim().isEmpty
                ? 'No symptoms specified'
                : _symptomsText.value,
        status: appointment.status,
        doctorImageUrl: appointment.doctorImageUrl,
      );

      await _appointmentService.updateAppointment(updatedAppointment);

      Get.back(result: updatedAppointment);
      Get.snackbar(
        'Success',
        'Your appointment has been updated successfully.',
        backgroundColor: Get.theme.colorScheme.surface,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update appointment. Please try again.',
        backgroundColor: Get.theme.colorScheme.error,
      );
    } finally {
      _updateIsLoading(false);
    }
  }

  Future<void> cancelAppointment() async {
    try {
      _updateIsLoading(true);
      _updateShowCancelDialog(false);

      await _appointmentService.cancelAppointment(appointment.id);

      Get.back(result: 'cancelled');
      Get.snackbar(
        'Cancelled',
        'Your appointment has been cancelled successfully.',
        backgroundColor: Get.theme.colorScheme.surface,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to cancel appointment. Please try again.',
        backgroundColor: Get.theme.colorScheme.error,
      );
    } finally {
      _updateIsLoading(false);
    }
  }

  Future<void> _loadTimeSlots() async {
    try {
      final slots = await _appointmentService.getAvailableTimeSlots(
        _selectedDate.value,
      );
      _updateAvailableTimeSlots(slots);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load available time slots.',
        backgroundColor: Get.theme.colorScheme.error,
      );
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
