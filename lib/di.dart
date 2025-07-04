import 'package:ausa/features/appointments/controller/appointments_controller.dart';
import 'package:ausa/features/appointments/service/appointment_service.dart';
import 'package:ausa/features/onboarding/controller/onboarding_controller.dart';
import 'package:ausa/features/teleconsultation/controller/teleconsultation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DependencyInject {
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Register services
    Get.put<AppointmentService>(AppointmentServiceImpl(), permanent: true);

    // Register controllers
    Get.put(TeleconsultationController(), permanent: true);
    Get.put(AppointmentsController(), permanent: true);
    Get.put(OnboardingController());
  }
}
