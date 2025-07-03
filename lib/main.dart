import 'package:ausa/features/appointments/controller/appointments_controller.dart';
import 'package:ausa/features/appointments/controller/appointment_scheduling_controller.dart';
import 'package:ausa/features/appointments/page/appointment_scheduling_page.dart';
import 'package:ausa/features/appointments/page/appointment_edit_page.dart';
import 'package:ausa/features/appointments/page/scheduled_appointments_page.dart';
import 'package:ausa/features/appointments/service/appointment_service.dart';
import 'package:ausa/features/health_schedule/controller/meal_times_controller.dart';
import 'package:ausa/features/health_schedule/page/health_schedule_page.dart';
import 'package:ausa/features/health_schedule/page/meal_times_page.dart';
import 'package:ausa/features/vitals_history/page/vitals_history_page.dart';
import 'package:ausa/constants/dimensions.dart';
import 'package:ausa/features/onboarding/view/splash_page.dart';


import 'package:ausa/features/teleconsultation/controller/teleconsultation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set full screen mode
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [],
  );

  runApp(
    Container(
      alignment: Alignment.center,
      color: Colors.grey[200],
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Dimensions.onboardingContainerWidth,
          maxHeight: Dimensions.onboardingContainerHeight,
        ),
        child: MyApp(),
      ),
    ),
  );

  // Dependency injection - Register services first
  _initializeDependencies();

  runApp(MyApp());
}

void _initializeDependencies() {
  // Register services
  Get.put<AppointmentService>(AppointmentServiceImpl(), permanent: true);

  // Register controllers
  Get.put(TeleconsultationController(), permanent: true);
  Get.put(AppointmentsController(), permanent: true);

  // Note: Other controllers (AppointmentSchedulingController, AppointmentEditController, MealTimesController, VitalsHistoryController)
  // are created on-demand when their respective pages are accessed
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ausa Health',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
        ),
      ),
      // Define routes for better navigation management
      initialRoute: '/vitals-history',
      getPages: [
        GetPage(
          name: '/appointments/schedule',
          page: () => const AppointmentSchedulingPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => AppointmentSchedulingController());
          }),
        ),
        GetPage(
          name: '/appointments/scheduled',
          page: () => const ScheduledAppointmentsPage(),
          // AppointmentsController is already registered globally
        ),
        GetPage(
          name: '/appointments/edit',
          page: () => const AppointmentEditPage(),
          // AppointmentEditController is created in the page with the appointment argument
        ),
        GetPage(
          name: '/health-schedule',
          page: () => const HealthSchedulePage(),
        ),
        GetPage(
          name: '/health-schedule/meal-times',
          page: () => const MealTimesPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => MealTimesController());
          }),
        ),
        GetPage(
          name: '/vitals-history',
          page: () => const VitalsHistoryPage(),
          // VitalsHistoryController is created in the page with Get.put()
        ),
      ],
      // Fallback for unknown routes
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const AppointmentSchedulingPage(),
      ),
      home: SplashPage(),
    );
  }
}
