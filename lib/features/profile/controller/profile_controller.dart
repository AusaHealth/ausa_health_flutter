import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class ProfileController extends GetxController {
  // Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final genderController = TextEditingController();
  final feetController = TextEditingController();
  final inchesController = TextEditingController();
  final weightController = TextEditingController();
  final weightUnitController = TextEditingController();

  final emailInviteController = TextEditingController();
  final isLbs = false.obs;

  // Birthday field for EditPersonalPage
  DateTime? birthday;
  final birthdayController = TextEditingController();

  RxBool hideKeyboard = false.obs;
  RxBool isFeet = false.obs;
  // Focus nodes
  final nameFocus = FocusNode();
  final phoneFocus = FocusNode();
  final emailFocus = FocusNode();
  final addressFocus = FocusNode();
  final genderFocus = FocusNode();
  final feetFocus = FocusNode();
  final inchesFocus = FocusNode();
  final weightFocus = FocusNode();
  final weightUnitFocus = FocusNode();

  // Error strings
  String? phoneError;
  String? emailError;
  String? addressError;
  String? nameError;
  String? genderError;

  // --- EditContactPage: Keyboard logic ---
  // Track which field is focused
  final Rx<VirtualKeyboardType> keyboardType = VirtualKeyboardType.Numeric.obs;

  // Track the last focused field (for custom keyboard)
  String _lastFocusedField = 'phone';

  // Call this in initState of EditContactPage
  void setupKeyboardListeners(void Function() onFocusChange) {
    nameFocus.addListener(() => _handleFocusChange(onFocusChange));
    phoneFocus.addListener(() => _handleFocusChange(onFocusChange));
    emailFocus.addListener(() => _handleFocusChange(onFocusChange));
    addressFocus.addListener(() => _handleFocusChange(onFocusChange));
  }

  // Call this in dispose of EditContactPage
  void removeKeyboardListeners(void Function() onFocusChange) {
    nameFocus.removeListener(() => _handleFocusChange(onFocusChange));
    phoneFocus.removeListener(() => _handleFocusChange(onFocusChange));
    emailFocus.removeListener(() => _handleFocusChange(onFocusChange));
    addressFocus.removeListener(() => _handleFocusChange(onFocusChange));
  }

  // Internal: update keyboard type and last focused field, then notify
  void _handleFocusChange(void Function() onFocusChange) {
    if (phoneFocus.hasFocus) {
      keyboardType.value = VirtualKeyboardType.Numeric;
      _lastFocusedField = 'phone';
    } else if (emailFocus.hasFocus) {
      keyboardType.value = VirtualKeyboardType.Alphanumeric;
      _lastFocusedField = 'email';
    } else if (addressFocus.hasFocus) {
      keyboardType.value = VirtualKeyboardType.Alphanumeric;
      _lastFocusedField = 'address';
    } else if (nameFocus.hasFocus) {
      keyboardType.value = VirtualKeyboardType.Alphanumeric;
      _lastFocusedField = 'name';
    }
    if (feetFocus.hasFocus) {
      keyboardType.value = VirtualKeyboardType.Numeric;
      _lastFocusedField = 'feet';
    } else if (inchesFocus.hasFocus) {
      keyboardType.value = VirtualKeyboardType.Numeric;
      _lastFocusedField = 'inches';
    }
    if (weightFocus.hasFocus) {
      keyboardType.value = VirtualKeyboardType.Numeric;
      _lastFocusedField = 'weight';
    } else if (weightUnitFocus.hasFocus) {
      keyboardType.value = VirtualKeyboardType.Numeric;
      _lastFocusedField = 'weightUnit';
    }
    onFocusChange();
  }

  // Get the current controller for the last focused field (EditContactPage)
  TextEditingController get currentController {
    switch (_lastFocusedField) {
      case 'phone':
        return phoneController;
      case 'email':
        return emailController;
      case 'address':
      case 'name':
        return nameController;
      case 'feet':
        return feetController;
      case 'inches':
        return inchesController;
      case 'weight':
        return weightController;
      case 'weightUnit':
        return weightUnitController;
      default:
        return addressController;
    }
  }

  // Get the current keyboard type (reactive)
  VirtualKeyboardType get currentKeyboardType => keyboardType.value;

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    birthdayController.dispose();
    feetController.dispose();
    inchesController.dispose();
    nameFocus.dispose();
    phoneFocus.dispose();
    emailFocus.dispose();
    addressFocus.dispose();

    super.onClose();
  }
}
