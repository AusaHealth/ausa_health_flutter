import 'package:ausa/di.dart';
import 'package:ausa/features/appointments/page/appointment_scheduling_page.dart';
import 'package:ausa/features/settings/page/setting_page.dart';
import 'package:ausa/constants/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  DependencyInject().init();
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
      // initialRoute: '/vitals-history',
      // getPages: [
      //   GetPage(
      //     name: '/appointments/schedule',
      //     page: () => const AppointmentSchedulingPage(),
      //     binding: BindingsBuilder(() {
      //       Get.lazyPut(() => AppointmentSchedulingController());
      //     }),
      //   ),
      //   GetPage(
      //     name: '/appointments/scheduled',
      //     page: () => const ScheduledAppointmentsPage(),
      //     // AppointmentsController is already registered globally
      //   ),
      //   GetPage(
      //     name: '/appointments/edit',
      //     page: () => const AppointmentEditPage(),
      //     // AppointmentEditController is created in the page with the appointment argument
      //   ),
      //   GetPage(
      //     name: '/health-schedule',
      //     page: () => const HealthSchedulePage(),
      //   ),
      //   GetPage(
      //     name: '/health-schedule/meal-times',
      //     page: () => const MealTimesPage(),
      //     binding: BindingsBuilder(() {
      //       Get.lazyPut(() => MealTimesController());
      //     }),
      //   ),
      //   GetPage(
      //     name: '/vitals-history',
      //     page: () => const VitalsHistoryPage(),
      //     // VitalsHistoryController is created in the page with Get.put()
      //   ),
      // ],
      // Fallback for unknown routes
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const AppointmentSchedulingPage(),
      ),
      home: SettingsPage(),
    );
  }
}
