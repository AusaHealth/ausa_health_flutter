import 'package:ausa/features/appointments/model/appointment.dart';
import 'package:ausa/features/appointments/model/time_slot.dart';

abstract class AppointmentService {
  Future<List<Appointment>> getScheduledAppointments();
  Future<List<TimeSlot>> getAvailableTimeSlots(DateTime date);
  Future<Appointment> createAppointment(Appointment appointment);
  Future<Appointment> updateAppointment(Appointment appointment);
  Future<void> cancelAppointment(String appointmentId);
}

class AppointmentServiceImpl implements AppointmentService {
  // TODO: Inject HTTP client or API service

  @override
  Future<List<Appointment>> getScheduledAppointments() async {
    // TODO: Replace with actual API call
    // return await _apiClient.get('/appointments');

    // Dummy data for now
    await Future.delayed(const Duration(milliseconds: 500));
    return [
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
  }

  @override
  Future<List<TimeSlot>> getAvailableTimeSlots(DateTime date) async {
    // TODO: Replace with actual API call
    // return await _apiClient.get('/appointments/available-slots', params: {'date': date});

    await Future.delayed(const Duration(milliseconds: 300));
    return TimeSlot.generateDummySlots(date);
  }

  @override
  Future<Appointment> createAppointment(Appointment appointment) async {
    // TODO: Replace with actual API call
    // return await _apiClient.post('/appointments', data: appointment.toJson());

    await Future.delayed(const Duration(seconds: 1));
    return appointment;
  }

  @override
  Future<Appointment> updateAppointment(Appointment appointment) async {
    // TODO: Replace with actual API call
    // return await _apiClient.put('/appointments/${appointment.id}', data: appointment.toJson());

    await Future.delayed(const Duration(seconds: 1));
    return appointment;
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    // TODO: Replace with actual API call
    // await _apiClient.delete('/appointments/$appointmentId');

    await Future.delayed(const Duration(seconds: 1));
  }
}
