import 'package:ausa/features/appointments/model/appointment.dart';
import 'package:get/get.dart';

class AppointmentsController extends GetxController {
  // Private observable state
  final RxBool _isLoading = false.obs;
  final RxList<Appointment> _appointments = <Appointment>[].obs;
  final RxString _errorMessage = ''.obs;

  // Public getters
  bool get isLoading => _isLoading.value;
  List<Appointment> get appointments => _appointments;
  String get errorMessage => _errorMessage.value;
  bool get hasAppointments => _appointments.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }

  // Private update methods
  void _updateIsLoading(bool loading) => _isLoading.value = loading;
  void _updateAppointments(List<Appointment> appointments) =>
      _appointments
        ..assignAll(appointments)
        ..refresh();
  void _updateErrorMessage(String message) => _errorMessage.value = message;
  void _addAppointment(Appointment appointment) =>
      _appointments.add(appointment);
  void _removeAppointment(String appointmentId) {
    _appointments.removeWhere((apt) => apt.id == appointmentId);
  }

  void _updateAppointment(Appointment updatedAppointment) {
    final index = _appointments.indexWhere(
      (apt) => apt.id == updatedAppointment.id,
    );
    if (index != -1) {
      _appointments[index] = updatedAppointment;
    }
  }

  // Public action methods
  Future<void> loadAppointments() async {
    try {
      _updateIsLoading(true);
      _updateErrorMessage('');

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      final appointments = _generateMockAppointments();
      _updateAppointments(appointments);
    } catch (e) {
      _updateErrorMessage('Failed to load appointments');
      Get.snackbar(
        'Error',
        'Failed to load appointments. Please try again.',
        backgroundColor: Get.theme.colorScheme.error,
      );
    } finally {
      _updateIsLoading(false);
    }
  }

  Future<void> refreshAppointments() async {
    await loadAppointments();
  }

  void addNewAppointment(Appointment appointment) {
    _addAppointment(appointment);
  }

  void navigateToScheduleAppointment() {
    Get.toNamed('/appointments/schedule');
  }

  Future<void> editAppointment(Appointment appointment) async {
    final result = await Get.toNamed(
      '/appointments/edit',
      arguments: appointment,
    );

    if (result != null) {
      if (result == 'cancelled') {
        _removeAppointment(appointment.id);
      } else if (result is Appointment) {
        _updateAppointment(result);
      }
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    try {
      _updateIsLoading(true);

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      _removeAppointment(appointmentId);

      Get.snackbar(
        'Success',
        'Appointment cancelled successfully.',
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

  void navigateToAppointmentDetails(Appointment appointment) {
    Get.toNamed('/appointments/details', arguments: appointment);
  }

  // Helper methods
  List<Appointment> getAppointmentsByStatus(AppointmentStatus status) {
    return _appointments.where((apt) => apt.status == status).toList();
  }

  List<Appointment> getUpcomingAppointments() {
    final now = DateTime.now();
    return _appointments.where((apt) => apt.dateTime.isAfter(now)).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  List<Appointment> getPastAppointments() {
    final now = DateTime.now();
    return _appointments.where((apt) => apt.dateTime.isBefore(now)).toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  // Mock data generation
  List<Appointment> _generateMockAppointments() {
    final now = DateTime.now();

    return [
      Appointment(
        id: '1',
        dateTime: DateTime(now.year, now.month, now.day + 2, 10, 30),
        doctorName: 'Dr. Grace Williams',
        doctorType: 'General Medicine',
        symptoms: 'Severe headache & fatigue',
        status: AppointmentStatus.confirmed,
      ),
      Appointment(
        id: '2',
        dateTime: DateTime(now.year, now.month, now.day + 5, 14, 0),
        doctorName: 'Dr. Michael Smith',
        doctorType: 'Cardiology',
        symptoms: 'Chest pain and shortness of breath during exercise',
        status: AppointmentStatus.pending,
      ),
      Appointment(
        id: '3',
        dateTime: DateTime(now.year, now.month, now.day + 7, 11, 15),
        doctorName: 'Dr. Sarah Johnson',
        doctorType: 'Dermatology',
        symptoms: 'Skin rash on arms and legs',
        status: AppointmentStatus.confirmed,
      ),
      Appointment(
        id: '4',
        dateTime: DateTime(now.year, now.month, now.day + 10, 15, 30),
        doctorName: 'Dr. Robert Davis',
        doctorType: 'Orthopedics',
        symptoms: 'Knee pain after jogging',
        status: AppointmentStatus.confirmed,
      ),
      Appointment(
        id: '5',
        dateTime: DateTime(now.year, now.month, now.day + 14, 9, 45),
        doctorName: 'Dr. Emily Chen',
        doctorType: 'Endocrinology',
        symptoms: 'Diabetes follow-up and blood sugar monitoring',
        status: AppointmentStatus.pending,
      ),
      // Past appointment for testing
      Appointment(
        id: '6',
        dateTime: DateTime(now.year, now.month, now.day - 3, 16, 0),
        doctorName: 'Dr. James Wilson',
        doctorType: 'General Medicine',
        symptoms: 'Annual health checkup',
        status: AppointmentStatus.confirmed,
      ),
    ];
  }
}
