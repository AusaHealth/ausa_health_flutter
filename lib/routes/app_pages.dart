import 'package:ausa/features/appointments/controller/appointment_scheduling_controller.dart';
import 'package:ausa/features/appointments/page/appointment_scheduling_page.dart';
import 'package:ausa/features/appointments/page/appointment_edit_page.dart';
import 'package:ausa/features/appointments/page/scheduled_appointments_page.dart';
import 'package:ausa/features/demo/page/demo_page.dart';
import 'package:ausa/features/health_schedule/controller/meal_times_controller.dart';
import 'package:ausa/features/health_schedule/page/health_schedule_page.dart';
import 'package:ausa/features/health_schedule/page/meal_times_page.dart';
import 'package:ausa/features/vitals_history/page/vitals_history_page.dart';
import 'package:ausa/features/vitals_history/page/media_test_history_page.dart';
import 'package:ausa/features/teleconsultation/page/base_teleconsultation_page.dart';
import 'package:ausa/features/tests/page/test_selection_page.dart';
import 'package:ausa/features/tests/page/test_execution_page.dart';
import 'package:ausa/features/tests/page/test_results_page.dart';
import 'package:ausa/features/home/page/home_page.dart';
import 'package:ausa/routes/app_routes.dart';
import 'package:get/get.dart';

abstract class AppPages {
  static const String initialRoute = AppRoutes.home;

  static final List<GetPage> pages = [
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
    GetPage(
      name: AppRoutes.demo,
      page: () => const DemoPage(),
      // DemoController is created in the page with Get.put()
    ),
    GetPage(
      name: AppRoutes.appointmentSchedule,
      page: () => const AppointmentSchedulingPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AppointmentSchedulingController());
      }),
    ),
    GetPage(
      name: AppRoutes.appointmentScheduled,
      page: () => const ScheduledAppointmentsPage(),
      // AppointmentsController is already registered globally
    ),
    GetPage(
      name: AppRoutes.appointmentEdit,
      page: () => const AppointmentEditPage(),
      // AppointmentEditController is created in the page with the appointment argument
    ),
    GetPage(
      name: AppRoutes.healthSchedule,
      page: () => const HealthSchedulePage(),
    ),
    GetPage(
      name: AppRoutes.mealTimes,
      page: () => const MealTimesPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MealTimesController());
      }),
    ),
    GetPage(
      name: AppRoutes.vitalsHistory,
      page: () => const VitalsHistoryPage(),
      // VitalsHistoryController is created in the page with Get.put()
    ),
    GetPage(
      name: AppRoutes.mediaTestHistory,
      page: () => const MediaTestHistoryPage(),
      // MediaTestHistoryController is created in the page with Get.put()
    ),
    GetPage(
      name: AppRoutes.testSelection,
      page: () => TestSelectionPage(),
      // TestController is already registered globally
    ),
    GetPage(
      name: AppRoutes.testExecution,
      page: () => TestExecutionPage(),
      // TestController is already registered globally
    ),
    GetPage(
      name: AppRoutes.testResults,
      page: () => TestResultsPage(),
      // TestController is already registered globally
    ),
    GetPage(
      name: AppRoutes.teleconsultation,
      page: () => BaseTeleconsultationPage(),
      // TeleconsultationController is already registered globally
    ),
  ];

  static final GetPage unknownRoute = GetPage(
    name: AppRoutes.notFound,
    page: () => const HomePage(),
  );
}
