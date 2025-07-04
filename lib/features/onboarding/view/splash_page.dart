import 'dart:async';

import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/features/onboarding/view/onboarding_wrapper.dart';
import 'package:get/get.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Get.offAll(() => const OnboardingWrapper());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Neumorphic(
              padding: const EdgeInsets.all(16),
              style: const NeumorphicStyle(
                color: AppColors.splashBackground,
                depth: 1.0,
                boxShape: NeumorphicBoxShape.circle(),
                shape: NeumorphicShape.concave,
              ),
              textStyle: const TextStyle(
                fontSize: 18, //customize size here
                // AND others usual text style properties (fontFamily, fontWeight, ...)
              ),
              child: Neumorphic(
                padding: const EdgeInsets.all(48),
                style: const NeumorphicStyle(
                  color: AppColors.splashBackground,
                  depth: 2.0,
                  boxShape: NeumorphicBoxShape.circle(),
                  shape: NeumorphicShape.concave,
                ),
                textStyle: const TextStyle(fontSize: 18),
                child: Column(
                  children: [
                    Image.asset(AppImages.splashlogo, width: 250, height: 250),
                    const SizedBox(height: 24),
                    Text(
                      'Connecting...',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
