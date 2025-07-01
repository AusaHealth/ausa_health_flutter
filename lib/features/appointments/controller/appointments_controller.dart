import 'package:ausa/features/appointments/model/appointment.dart';
import 'package:ausa/features/appointments/model/time_slot.dart';
import 'package:get/get.dart';

enum AppointmentViewMode { scheduling, viewAppointments }

class AppointmentsController extends GetxController {
  // Observable variables
  final RxBool _isMonthView = false.obs;
  final RxInt _currentStep = 1.obs;
  final Rx<DateTime> _selectedDate = DateTime.now().obs;
  final Rx<TimeSlot?> _selectedTimeSlot = Rx<TimeSlot?>(null);
  final RxString _symptomsText = ''.obs;
  final RxBool _isRecording = false.obs;
  final RxBool _isLoading = false.obs;
  final RxList<Appointment> _appointments = <Appointment>[].obs;
  final RxList<TimeSlot> _availableTimeSlots = <TimeSlot>[].obs;
  final RxBool _showSuccessPopup = false.obs;
  final Rx<AppointmentViewMode> _viewMode = AppointmentViewMode.scheduling.obs;

  // Edit appointment variables
  final RxBool _isEditMode = false.obs;
  final Rx<Appointment?> _editingAppointment = Rx<Appointment?>(null);
  final RxBool _showDiscardDialog = false.obs;
  final RxBool _showCancelDialog = false.obs;

  // Original values for tracking changes
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
  List<Appointment> get appointments => _appointments;
  List<TimeSlot> get availableTimeSlots => _availableTimeSlots;
  bool get showSuccessPopup => _showSuccessPopup.value;
  AppointmentViewMode get viewMode => _viewMode.value;
  bool get isViewingAppointments =>
      _viewMode.value == AppointmentViewMode.viewAppointments;
  bool get isEditMode => _isEditMode.value;
  Appointment? get editingAppointment => _editingAppointment.value;
  bool get showDiscardDialog => _showDiscardDialog.value;
  bool get showCancelDialog => _showCancelDialog.value;

  // Check if finish button should be enabled
  bool get canFinish =>
      _selectedTimeSlot.value != null && _symptomsText.value.trim().isNotEmpty;

  // Check if changes have been made
  bool get hasChanges {
    if (!_isEditMode.value || _editingAppointment.value == null) return false;

    return _symptomsText.value != _originalSymptomsText ||
        _selectedTimeSlot.value?.id != _originalTimeSlot?.id ||
        !_isSameDay(_selectedDate.value, _originalDate ?? DateTime.now());
  }

  @override
  void onInit() {
    super.onInit();
    _loadDummyAppointments();
    _loadTimeSlots();
  }

  // Edit appointment methods
  void startEditingAppointment(Appointment appointment) {
    _isEditMode.value = true;
    _editingAppointment.value = appointment;
    _viewMode.value = AppointmentViewMode.scheduling;

    // Store original values
    _originalSymptomsText = appointment.symptoms;
    _originalDate = appointment.dateTime;

    // Set current values to appointment values
    _symptomsText.value = appointment.symptoms;
    _selectedDate.value = appointment.dateTime;

    // Load time slots and find the matching time slot
    _loadTimeSlots();

    // Find and set the original time slot
    Future.delayed(Duration(milliseconds: 100), () {
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
      _selectedTimeSlot.value = matchingSlot;
    });

    // Start in month view step 1
    _isMonthView.value = true;
    _currentStep.value = 1;
  }

  void showDiscardChangesDialog() {
    _showDiscardDialog.value = true;
  }

  void hideDiscardChangesDialog() {
    _showDiscardDialog.value = false;
  }

  void discardChanges() {
    _showDiscardDialog.value = false;
    _exitEditMode();
  }

  void showCancelAppointmentDialog() {
    _showCancelDialog.value = true;
  }

  void hideCancelAppointmentDialog() {
    _showCancelDialog.value = false;
  }

  Future<void> cancelAppointment() async {
    if (_editingAppointment.value == null) return;

    _isLoading.value = true;
    _showCancelDialog.value = false;

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    // Remove appointment from list
    _appointments.removeWhere((apt) => apt.id == _editingAppointment.value!.id);

    _isLoading.value = false;
    _exitEditMode();

    // Show success message or navigate back
    Get.snackbar(
      'Appointment Cancelled',
      'Your appointment has been successfully cancelled.',
      backgroundColor: Get.theme.colorScheme.surface,
    );
  }

  void _exitEditMode() {
    _isEditMode.value = false;
    _editingAppointment.value = null;
    _originalSymptomsText = null;
    _originalTimeSlot = null;
    _originalDate = null;
    _viewMode.value = AppointmentViewMode.viewAppointments;
    _resetForm();
  }

  void handleBackPressed() {
    if (_isEditMode.value && hasChanges) {
      showDiscardChangesDialog();
    } else if (_isEditMode.value) {
      _exitEditMode();
    } else {
      // Normal back navigation
      if (_viewMode.value == AppointmentViewMode.viewAppointments) {
        goBackToScheduling();
      } else {
        Get.back();
      }
    }
  }

  // Helper method to check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // View mode methods
  void toggleViewMode() {
    if (_viewMode.value == AppointmentViewMode.scheduling) {
      _viewMode.value = AppointmentViewMode.viewAppointments;
    } else {
      _viewMode.value = AppointmentViewMode.scheduling;
      // Reset to normal view when going back to scheduling
      _isMonthView.value = false;
      _currentStep.value = 1;
    }
  }

  void goBackToScheduling() {
    _viewMode.value = AppointmentViewMode.scheduling;
    _isMonthView.value = false;
    _currentStep.value = 1;
  }

  // View toggle methods
  void toggleMonthView() {
    _isMonthView.value = !_isMonthView.value;
    if (_isMonthView.value) {
      _currentStep.value = 1;
    }
  }

  void goToStep2() {
    if (_selectedTimeSlot.value != null) {
      _currentStep.value = 2;
    }
  }

  void goBackToStep1() {
    _currentStep.value = 1;
  }

  // Date and time selection
  void selectDate(DateTime date) {
    _selectedDate.value = date;
    _selectedTimeSlot.value = null;
    _loadTimeSlots();
  }

  void selectTimeSlot(TimeSlot timeSlot) {
    if (timeSlot.isAvailable) {
      _selectedTimeSlot.value = timeSlot;
      _selectedDate.value = timeSlot.dateTime;
    }
  }

  // Symptoms input
  void updateSymptomsText(String text) {
    _symptomsText.value = text;
  }

  void clearSymptomsText() {
    _symptomsText.value = '';
  }

  // Voice recording (placeholder for future implementation)
  void startRecording() {
    _isRecording.value = true;
    // TODO: Implement voice-to-text API integration

    // Simulate recording for demo
    Future.delayed(Duration(seconds: 2), () {
      _isRecording.value = false;
      _symptomsText.value = "Severe headache and fatigue since last 2 days.";
    });
  }

  void stopRecording() {
    _isRecording.value = false;
    // TODO: Process recorded audio and convert to text
  }

  // Appointment scheduling
  Future<void> scheduleAppointment() async {
    if (!canFinish) return;

    _isLoading.value = true;

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    if (_isEditMode.value && _editingAppointment.value != null) {
      // Update existing appointment
      final updatedAppointment = Appointment(
        id: _editingAppointment.value!.id,
        dateTime: _selectedTimeSlot.value!.dateTime,
        doctorName: _editingAppointment.value!.doctorName,
        doctorType: _editingAppointment.value!.doctorType,
        symptoms: _symptomsText.value,
        status: _editingAppointment.value!.status,
        doctorImageUrl: _editingAppointment.value!.doctorImageUrl,
      );

      // TODO: Replace with actual API call
      // await _appointmentService.updateAppointment(updatedAppointment);

      // Update in local list
      final index = _appointments.indexWhere(
        (apt) => apt.id == updatedAppointment.id,
      );
      if (index != -1) {
        _appointments[index] = updatedAppointment;
      }

      _isLoading.value = false;
      _exitEditMode();

      // Show success message
      Get.snackbar(
        'Appointment Updated',
        'Your appointment has been successfully updated.',
        backgroundColor: Get.theme.colorScheme.surface,
      );
    } else {
      // Create new appointment
      final newAppointment = Appointment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        dateTime: _selectedTimeSlot.value!.dateTime,
        doctorName: 'Primary Care Physician',
        doctorType: 'General Medicine',
        symptoms: _symptomsText.value,
        status: AppointmentStatus.confirmed,
      );

      // TODO: Replace with actual API call
      // await _appointmentService.scheduleAppointment(newAppointment);

      _appointments.add(newAppointment);
      _isLoading.value = false;
      _showSuccessPopup.value = true;

      // Reset form
      _resetForm();
    }
  }

  void _resetForm() {
    _selectedTimeSlot.value = null;
    _symptomsText.value = '';
    _currentStep.value = 1;
    _isMonthView.value = false;
  }

  void closeSuccessPopup() {
    _showSuccessPopup.value = false;
  }

  // Data loading methods (replace with actual API calls)
  void _loadDummyAppointments() {
    final List<Appointment> dummyAppointments = [
      Appointment(
        id: '1',
        dateTime: DateTime(2025, 1, 10, 10, 30),
        doctorName: 'Dr. Grace',
        doctorType: 'General Medicine',
        symptoms: 'Severe headache & fatigue',
        status: AppointmentStatus.confirmed,
      ),
      Appointment(
        id: '2',
        dateTime: DateTime(2025, 1, 12, 14, 0),
        doctorName: 'Dr. Smith',
        doctorType: 'Cardiology',
        symptoms: 'Chest pain and shortness of breath',
        status: AppointmentStatus.pending,
      ),
    ];

    _appointments.value = dummyAppointments;
  }

  void _loadTimeSlots() {
    // TODO: Replace with actual API call
    // final slots = await _appointmentService.getAvailableTimeSlots(_selectedDate.value);
    _availableTimeSlots.value = TimeSlot.generateDummySlots(
      _selectedDate.value,
    );
  }

  // Future API integration methods (placeholders)
  Future<List<TimeSlot>> fetchAvailableTimeSlots(DateTime date) async {
    // TODO: Implement API call to Node.js server
    // return await _apiService.get('/appointments/available-slots', params: {'date': date});
    return TimeSlot.generateDummySlots(date);
  }

  Future<void> saveAppointment(Appointment appointment) async {
    // TODO: Implement API call to Node.js server
    // return await _apiService.post('/appointments', data: appointment.toJson());
  }

  Future<List<Appointment>> fetchScheduledAppointments() async {
    // TODO: Implement API call to Node.js server
    // return await _apiService.get('/appointments/scheduled');
    return _appointments;
  }
}
