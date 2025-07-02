import 'package:ausa/features/appointments/model/appointment.dart';
import 'package:ausa/features/appointments/model/time_slot.dart';
import 'package:ausa/features/appointments/service/appointment_service.dart';
import 'package:ausa/features/appointments/controller/appointments_controller.dart';
import 'package:get/get.dart';

class AppointmentSchedulingController extends GetxController {
  final AppointmentService _appointmentService = Get.find<AppointmentService>();

  // Observable state
  final RxBool _isMonthView = false.obs;
  final RxInt _currentStep = 1.obs;
  final Rx<DateTime> _selectedDate = DateTime.now().obs;
  final Rx<TimeSlot?> _selectedTimeSlot = Rx<TimeSlot?>(null);
  final RxString _symptomsText = ''.obs;
  final RxBool _isRecording = false.obs;
  final RxBool _isLoading = false.obs;
  final RxList<TimeSlot> _availableTimeSlots = <TimeSlot>[].obs;
  final RxBool _showSuccessPopup = false.obs;

  // Getters
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
  void _updateShowSuccessPopup(bool show) => _showSuccessPopup.value = show;

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
    Get.back();
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
      _updateSymptomsText("Severe headache and fatigue since last 2 days.");
    });
  }

  void stopRecording() {
    _updateIsRecording(false);
  }

  // Business logic
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

      await _appointmentService.createAppointment(newAppointment);

      // Add the new appointment to the global appointments list
      final appointmentsController = Get.find<AppointmentsController>();
      appointmentsController.addNewAppointment(newAppointment);

      _updateShowSuccessPopup(true);
      _resetForm();
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
    _updateShowSuccessPopup(false);
  }

  void navigateToScheduledAppointments() {
    Get.toNamed('/appointments/scheduled');
  }

  void _resetForm() {
    _updateSelectedTimeSlot(null);
    _updateSymptomsText('');
    _updateCurrentStep(1);
    _updateIsMonthView(false);
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
}
