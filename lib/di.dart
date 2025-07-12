import 'package:ausa/features/appointments/controller/appointments_controller.dart';
import 'package:ausa/features/appointments/controller/appointment_scheduling_controller.dart';
import 'package:ausa/features/appointments/service/appointment_service.dart';
import 'package:ausa/features/auth/controller/auth_controller.dart';
import 'package:ausa/features/health_schedule/controller/health_schedule_controller.dart';
import 'package:ausa/features/health_schedule/controller/meal_times_controller.dart';
import 'package:ausa/features/home/controller/home_controller.dart';
import 'package:ausa/features/onboarding/controller/onboarding_controller.dart';
import 'package:ausa/features/profile/controller/family_controller.dart';
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
    // Register services
    Get.put<AppointmentService>(AppointmentServiceImpl(), permanent: true);

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
    Get.put(FamilyController());
    Get.put(AppointmentSchedulingController());


    // Register lazy-loaded controllers
    Get.lazyPut(() => MealTimesController());
    Get.lazyPut(() => HealthScheduleController());
    Get.lazyPut(() => VitalsHistoryController());
    Get.lazyPut(() => MediaTestHistoryController());
    Get.lazyPut(() => WifiController());

    // Note: AppointmentEditController is created on-demand with parameters in the page
    // Other specialized controllers are created when their respective pages are accessed
  }
}
