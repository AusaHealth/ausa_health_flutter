import 'package:ausa/common/model/user.dart';
import 'package:ausa/common/widget/auto_hide_container.dart';
import 'package:ausa/features/tests/controller/test_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeleconsultationController extends GetxController {
  final Rx<User?> _doctor = Rx<User?>(
    User(
      id: '1',
      name: 'Dr. John Doe',
      photoUrl: 'https://via.placeholder.com/150',
      specialization: 'Cardiologist',
    ),
  );
  // final Rx<User?> _doctor = Rx<User?>(null);
  final RxBool _isVideoOn = true.obs;
  final RxBool _isMicOn = true.obs;
  final RxBool _showDoctorInfo = true.obs;

  final GlobalKey<AutoHideContainerState> _actionBarKey =
      GlobalKey<AutoHideContainerState>();

  // Test Controller integration
  TestController? _testController;

  GlobalKey<AutoHideContainerState> get actionBarKey => _actionBarKey;

  bool get isVideoOn => _isVideoOn.value;
  bool get isMicOn => _isMicOn.value;
  bool get showDoctorInfo => _showDoctorInfo.value;

  void setShowDoctorInfo(bool value) {
    _showDoctorInfo.value = value;
  }

  void setIsVideoOn(bool value) {
    _isVideoOn.value = value;
  }

  void setIsMicOn(bool value) {
    _isMicOn.value = value;
  }

  User? get doctor => _doctor.value;

  void setDoctor(User doctor) {
    _doctor.value = doctor;
  }

  void clearDoctor() {
    _doctor.value = null;
  }

  void resumeActionBar() {
    _actionBarKey.currentState?.resume();
  }

  void pauseActionBar() {
    _actionBarKey.currentState?.pause();
  }

  void showActionBar() {
    _actionBarKey.currentState?.showBar();
  }

  // Test integration methods
  void navigateToTests() {
    _testController ??= Get.find<TestController>();
    _testController!.navigateToTestSelection();
  }

  bool get hasActiveTestSession {
    _testController ??= Get.find<TestController>();
    return _testController!.currentSession != null;
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize test controller if needed
    try {
      _testController = Get.find<TestController>();
    } catch (e) {
      // Test controller not initialized yet
    }
  }
}
