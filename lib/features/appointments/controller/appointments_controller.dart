import 'package:ausa/features/appointments/model/appointment.dart';
import 'package:ausa/features/appointments/service/appointment_service.dart';
import 'package:get/get.dart';

class AppointmentsController extends GetxController {
  final AppointmentService _appointmentService = Get.find<AppointmentService>();

  // Observable state
  final RxBool _isLoading = false.obs;
  final RxList<Appointment> _appointments = <Appointment>[].obs;
  final RxString _errorMessage = ''.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<Appointment> get appointments => _appointments;
  String get errorMessage => _errorMessage.value;
  bool get hasAppointments => _appointments.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }

  // Event-based state updates 
  void _updateIsLoading(bool loading) => _isLoading.value = loading;
  void _updateAppointments(List<Appointment> appointments) =>
      _appointments.value = appointments;
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

  // Business logic
  Future<void> loadAppointments() async {
    try {
      _updateIsLoading(true);
      _updateErrorMessage('');

      final appointments = await _appointmentService.getScheduledAppointments();
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

  // Add new appointment to the list (called from scheduling controller)
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

      await _appointmentService.cancelAppointment(appointmentId);
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
}
