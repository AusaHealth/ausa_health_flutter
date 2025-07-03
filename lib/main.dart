import 'package:ausa/constants/dimensions.dart';
import 'package:ausa/features/onboarding/controller/onboarding_controller.dart';
import 'package:ausa/features/onboarding/view/splash_page.dart';
import 'package:ausa/features/profile/page/profile_page.dart';

import 'package:ausa/features/teleconsultation/controller/teleconsultation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put(TeleconsultationController());
  Get.put(OnboardingController());

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
      ),
      home: SplashPage(),
    );
  }
}
