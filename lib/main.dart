import 'package:ausa/features/appointments/controller/appointments_controller.dart';
import 'package:ausa/features/appointments/page/appointment_scheduling_page.dart';
import 'package:ausa/features/teleconsultation/controller/teleconsultation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put(TeleconsultationController());
  Get.put(AppointmentsController());

  runApp(
    MaterialApp(
      home: Builder(
        builder: (context) {
          final width = MediaQuery.of(context).size.width;
          return Container(
            color: Colors.grey[200],
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 1200,
                  maxWidth: width <= 1920 ? width : 1920,
                ),
                child: MyApp(),
              ),
            ),
          );
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ausa Health',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AppointmentSchedulingPage(),
    );
  }
}
