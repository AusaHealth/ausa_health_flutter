import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class FamilyController extends GetxController {
  RxBool hideKeyboard = false.obs;

  final shortNameController = TextEditingController();
  final fullNameController = TextEditingController();
  final relationshipController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  final shortNameFocus = FocusNode();
  final fullNameFocus = FocusNode();
  final relationshipFocus = FocusNode();
  final phoneFocus = FocusNode();
  final emailFocus = FocusNode();
  final addressFocus = FocusNode();

  final shortNameError = Rx<String?>(null);
  final fullNameError = Rx<String?>(null);
  final relationshipError = Rx<String?>(null);
  final phoneError = Rx<String?>(null);
  final emailError = Rx<String?>(null);
  final addressError = Rx<String?>(null);

  final Rx<VirtualKeyboardType> keyboardType =
      VirtualKeyboardType.Alphanumeric.obs;

  // Track the last focused field (for custom keyboard)
  String _lastFocusedField = 'shortName';

  void setupKeyboardListeners(void Function() onFocusChange) {
    shortNameFocus.addListener(() => _handleFocusChange(onFocusChange));
    fullNameFocus.addListener(() => _handleFocusChange(onFocusChange));
    relationshipFocus.addListener(() => _handleFocusChange(onFocusChange));
    phoneFocus.addListener(() => _handleFocusChange(onFocusChange));
    emailFocus.addListener(() => _handleFocusChange(onFocusChange));
    addressFocus.addListener(() => _handleFocusChange(onFocusChange));
  }

  // Call this in dispose of EditContactPage
  void removeKeyboardListeners(void Function() onFocusChange) {
    shortNameFocus.removeListener(() => _handleFocusChange(onFocusChange));
    fullNameFocus.removeListener(() => _handleFocusChange(onFocusChange));
    relationshipFocus.removeListener(() => _handleFocusChange(onFocusChange));
    phoneFocus.removeListener(() => _handleFocusChange(onFocusChange));
    emailFocus.removeListener(() => _handleFocusChange(onFocusChange));
    addressFocus.removeListener(() => _handleFocusChange(onFocusChange));
  }

  void _handleFocusChange(void Function() onFocusChange) {
    if (shortNameFocus.hasFocus) {
      keyboardType.value = VirtualKeyboardType.Alphanumeric;
      _lastFocusedField = 'shortName';
    } else if (emailFocus.hasFocus) {
      keyboardType.value = VirtualKeyboardType.Alphanumeric;
      _lastFocusedField = 'email';
    } else if (addressFocus.hasFocus) {
      keyboardType.value = VirtualKeyboardType.Alphanumeric;
      _lastFocusedField = 'address';
    } else if (fullNameFocus.hasFocus) {
      keyboardType.value = VirtualKeyboardType.Alphanumeric;
      _lastFocusedField = 'fullName';
    }
    if (relationshipFocus.hasFocus) {
      keyboardType.value = VirtualKeyboardType.Alphanumeric;
      _lastFocusedField = 'relationship';
    }
    if (phoneFocus.hasFocus) {
      keyboardType.value = VirtualKeyboardType.Numeric;
      _lastFocusedField = 'phone';
    }

    onFocusChange();
  }

  TextEditingController get currentController {
    switch (_lastFocusedField) {
      case 'shortName':
        return shortNameController;
      case 'fullName':
        return fullNameController;
      case 'relationship':
        return relationshipController;
      case 'phone':
        return phoneController;
      case 'email':
        return emailController;
      case 'address':
        return addressController;
      default:
        return addressController;
    }
  }

  // Get the current keyboard type (reactive)
  VirtualKeyboardType get currentKeyboardType => keyboardType.value;
}
