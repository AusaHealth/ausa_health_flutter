import 'package:ausa/common/enums/test_status.dart';
import 'package:ausa/common/model/test_error.dart';
import 'package:ausa/common/model/user.dart';
import 'package:ausa/common/widget/auto_hide_container.dart';
import 'package:ausa/common/model/test.dart';
import 'package:ausa/features/teleconsultation/page/test_page.dart';
import 'package:ausa/features/teleconsultation/widget/test_coming_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeleconsultationController extends GetxController {
  final Rx<User?> _doctor = Rx<User?>(User(id: '1', name: 'Dr. John Doe', photoUrl: 'https://via.placeholder.com/150', specialization: 'Cardiologist'));
  // final Rx<User?> _doctor = Rx<User?>(null);
  final _tests = <Test>[].obs;
  final RxBool _isVideoOn = true.obs;
  final RxBool _isMicOn = true.obs;
  final RxBool _showDoctorInfo = true.obs;
  final Rx<Test?> _currentTest = Rx<Test?>(null);
  final Rx<TestStatus> _currentTestStatus = Rx<TestStatus>(TestStatus.none);
  final Rx<TestError?> _currentTestError = Rx<TestError?>(null);

  TestStatus get currentTestStatus => _currentTestStatus.value;

  TestError? get currentTestError => _currentTestError.value;

  void setCurrentTestError(TestError? error) {
    _currentTestError.value = error;
  }

  void setCurrentTestStatus(TestStatus status) {
    _currentTestStatus.value = status;
  }

  Test? get currentTest => _currentTest.value;

  void setCurrentTest(Test test) {
    _currentTest.value = test;
  }

  final GlobalKey<AutoHideContainerState> _actionBarKey = GlobalKey<AutoHideContainerState>();

  GlobalKey<AutoHideContainerState> get actionBarKey => _actionBarKey;
  bool get hasIncompleteTests => _tests.any((test) => !test.isDone);

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

  void setTests(List<Test> tests) {
    _tests.value = tests;
    if (hasIncompleteTests) {
      _actionBarKey.currentState?.pause();
    } else {
      _actionBarKey.currentState?.resume();
    }
  }

  List<Test> get tests => _tests;

  void resumeActionBar() {
    _actionBarKey.currentState?.resume();
  }

  void pauseActionBar() {
    _actionBarKey.currentState?.pause();
  }

  void showActionBar() {
    _actionBarKey.currentState?.showBar();
  }

  void startTests() {
    _currentTest.value = _tests.firstWhere((test) => test.isDone == false);
    if(_currentTest.value!=null){
      Get.dialog(TestComingUpDialog(controller: this));
    }
  }

  void requestTest() {
    setCurrentTestStatus(TestStatus.requested);
    Get.to(() => TestPage(controller: this));
  }

  void startTest() {
    setCurrentTestStatus(TestStatus.started);
  }

  void cancelTest() {
    _currentTest.value = null;
    setCurrentTestStatus(TestStatus.none);
  }

  void completeTest() {
    // TODO: Fetch results from the server
    List<Test> tests = _tests.toList();
    final index = tests.indexOf(currentTest!);
    currentTest!.isDone = true;
    tests.removeAt(index);
    tests.insert(index, currentTest!);
    setTests(tests);
    _currentTest.value = null;
    Future.delayed(Duration(seconds: 1), () {
      startTests();
    });
  }

  void declineTests() {
    setTests([]);
  }
}
