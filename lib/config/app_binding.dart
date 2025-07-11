import 'package:ausa/features/appointments/controller/appointments_controller.dart';
import 'package:ausa/features/appointments/service/appointment_service.dart';
import 'package:ausa/features/onboarding/controller/onboarding_controller.dart';
import 'package:ausa/features/profile/controller/family_controller.dart';
import 'package:ausa/features/profile/controller/profile_controller.dart';
import 'package:ausa/features/settings/controller/setting_controller.dart';
import 'package:ausa/features/teleconsultation/controller/teleconsultation_controller.dart';
import 'package:ausa/features/tests/controller/test_controller.dart';
import 'package:ausa/features/home/controller/home_controller.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Register services
    Get.put<AppointmentService>(AppointmentServiceImpl(), permanent: true);

    // Register controllers
    Get.put(HomeController(), permanent: true);
    Get.put(TeleconsultationController(), permanent: true);
    Get.put(AppointmentsController(), permanent: true);
    Get.put(TestController(), permanent: true);
    Get.put(OnboardingController());
    Get.put(ProfileController());
    Get.put(FamilyController());
    Get.put(SettingController());

    // Note: Other controllers (AppointmentSchedulingController, AppointmentEditController, MealTimesController, VitalsHistoryController)
    // are created on-demand when their respective pages are accessed
  }
}
