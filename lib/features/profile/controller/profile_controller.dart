import 'package:ausa/common/widget/toast.dart';
import 'package:ausa/features/profile/model/care_model.dart';
import 'package:ausa/features/profile/model/condition_model.dart';
import 'package:ausa/features/profile/model/family_model.dart';
import 'package:ausa/features/profile/model/user_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
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
    weight: '176',
    phone: '555-123-4567',
  );

  final RxList<FamilyModel> familyMembers =
      <FamilyModel>[
        FamilyModel(
          shortName: 'Chris',
          fullName: 'Christopher Chavez',
          phone: '+1 555-123-4567',
          email: 'johndoes@clinic.com',
          relationship: 'Friend',
          address: '1234 Maplewood Lane Springfield, IL 62704',
        ),
        FamilyModel(
          shortName: 'Jenny',
          fullName: 'Jenny Doe',
          phone: '+1 555-123-4568',
          email: 'jennydoe@clinic.com',
          relationship: 'Mother',
          address: '1234 Maplewood Lane Springfield, IL 62704',
        ),
        FamilyModel(
          shortName: 'John',
          fullName: 'John Doe',
          phone: '+1 555-123-4569',
          email: 'johndoe@clinic.com',
          relationship: 'Father',
          address: '1234 Maplewood Lane Springfield, IL 62704',
        ),
      ].obs;

  void addFamilyMember(FamilyModel member) {
    familyMembers.add(member);
  }

  void removeFamilyMember(FamilyModel member) {
    familyMembers.remove(member);
    CustomToast.show(message: 'Member removed');
  }
}
