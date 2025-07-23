import 'package:ausa/features/appointments/controller/appointment_scheduling_controller.dart';
import 'package:ausa/features/appointments/controller/appointments_controller.dart';
import 'package:ausa/features/auth/controller/auth_controller.dart';
import 'package:ausa/features/health_schedule/controller/health_schedule_controller.dart';
import 'package:ausa/features/health_schedule/controller/meal_times_controller.dart';
import 'package:ausa/features/home/controller/home_controller.dart';
import 'package:ausa/features/onboarding/controller/onboarding_controller.dart';
import 'package:ausa/features/profile/controller/profile_controller.dart';
import 'package:ausa/features/settings/controller/setting_controller.dart';
import 'package:ausa/features/settings/controller/wifi_controller.dart';
import 'package:ausa/features/teleconsultation/controller/teleconsultation_controller.dart';
import 'package:ausa/features/tests/controller/test_controller.dart';
import 'package:ausa/features/vitals_history/controller/media_test_history_controller.dart';
import 'package:ausa/features/vitals_history/controller/vitals_history_controller.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Register core controllers (permanent)
    Get.put(HomeController(), permanent: true);
    Get.put(TeleconsultationController(), permanent: true);
    Get.put(AppointmentsController(), permanent: true);
    Get.put(TestController(), permanent: true);

    // Register feature controllers
    Get.put(AuthController(), permanent: true);
    Get.put(OnboardingController());
    Get.put(SettingController());
    Get.put(ProfileController());

    Get.put(AppointmentSchedulingController());
    Get.put(HealthScheduleController());
    Get.put(MealTimesController());
    Get.put(VitalsHistoryController());
    Get.put(MediaTestHistoryController());
    Get.put(WifiController());

    // Note: AppointmentEditController is created on-demand with parameters in the page
    // Other specialized controllers are created when their respective pages are accessed
  }
}
