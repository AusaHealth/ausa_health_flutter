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

  // Check if finish button should be enabled
  bool get canFinish =>
      _selectedTimeSlot.value != null && _symptomsText.value.trim().isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _loadDummyAppointments();
    _loadTimeSlots();
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
      // Commenting out dummy data to show empty state initially
      // Appointment(
      //   id: '1',
      //   dateTime: DateTime(2025, 1, 10, 10, 30),
      //   doctorName: 'Primary Care Physician',
      //   doctorType: 'General Medicine',
      //   symptoms: 'Severe headache and fatigue...',
      //   status: AppointmentStatus.confirmed,
      // ),
      // Appointment(
      //   id: '2',
      //   dateTime: DateTime(2025, 1, 10, 10, 30),
      //   doctorName: 'Primary Care Physician',
      //   doctorType: 'General Medicine',
      //   symptoms: 'Severe headache and fatigue...',
      //   status: AppointmentStatus.pending,
      // ),
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
