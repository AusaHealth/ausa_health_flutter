import 'package:ausa/features/profile/model/care_model.dart';
import 'package:ausa/features/profile/model/condition_model.dart';
import 'package:ausa/features/profile/model/family_model.dart';
import 'package:ausa/features/profile/model/user_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Controllers

  RxBool showSummary = false.obs;

  RxBool hideKeyboard = false.obs;
  RxBool isFeet = false.obs;

  final emailInviteController = TextEditingController();

  final FamilyModel member = FamilyModel();

  final CareModel care = CareModel(
    careProviderName: 'Dr. John Doe, Endocrinologist',
    phone: '+1555-123-4567',
    email: 'john.doe@example.com',
    address: '123 Main St, Los Angeles, CA 90001',
    nextAvailability: 'Today 10:00 AM',
  );

  final ConditionModel condition = ConditionModel(
    diagonedWith: 'Diabetes heart condition, Cholesterol',
    bloodPressure: BloodPressure(systolic: '120', diastolic: '80'),
    bloodSugar: BloodSugar(fasting: '100', postPrandial: '120'),
    bodyTemperature: BodyTemperature(temperatureF: '98.6', temperatureC: '37'),
    heartRate: HeartRate(heartRate: '98'),
  );

  final UserModel user = UserModel(
    name: 'John Doe',
    email: 'john.doe@example.com',
    address: '123 Main St, Los Angeles, CA 90001',
    dateOfBirth: DateTime(1980, 6, 15),
    gender: 'Male',
    height: '180',
    weight: "176",
    phone: '+1555-123-4567',
  );
}
