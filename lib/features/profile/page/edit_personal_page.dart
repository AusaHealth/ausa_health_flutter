import 'dart:ui';

import 'package:ausa/common/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class EditPersonalPage extends StatefulWidget {
  const EditPersonalPage({super.key});

  @override
  State<EditPersonalPage> createState() => _EditPersonalPageState();
}

class _EditPersonalPageState extends State<EditPersonalPage> {
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  final phoneFocus = FocusNode();
  final emailFocus = FocusNode();
  final addressFocus = FocusNode();

  String? phoneError;
  String? emailError;
  String? addressError;

  @override
  void initState() {
    super.initState();
    // Automatically focus the first field when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add a longer delay to ensure the widget is fully built and rendered
      Future.delayed(const Duration(milliseconds: 500), () {
        _forceKeyboardToShow();
      });
    });
  }

  void _forceKeyboardToShow() {
    print('Attempting to show keyboard...');
    // Force focus and ensure keyboard shows
    phoneFocus.requestFocus();

    // Trigger a selection change to ensure keyboard appears
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: phoneController.text.length),
    );

    // Additional attempts to show keyboard
    Future.delayed(const Duration(milliseconds: 100), () {
      phoneFocus.requestFocus();
      print('First retry - focus requested');
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      phoneFocus.requestFocus();
      // Try to force keyboard visibility
      SystemChannels.textInput.invokeMethod('TextInput.show');
      print('Second retry - focus and show keyboard requested');
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      phoneFocus.requestFocus();
      print('Third retry - focus requested');
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    phoneFocus.dispose();
    emailFocus.dispose();
    addressFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          backgroundColor: const Color(0xFF18181A),
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              // Blurred background
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: Container(
                      color: const Color(0xFF19346A).withOpacity(0.92),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'Edit Personal Information',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Spacer(),
                          // Debug button to test keyboard
                          IconButton(
                            icon: const Icon(
                              Icons.keyboard,
                              color: Colors.white,
                              size: 24,
                            ),
                            onPressed: () {
                              _forceKeyboardToShow();
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Card with fields
                    Expanded(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 32,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Phone
                              SizedBox(
                                width: 300,
                                child: CustomTextField(
                                  label: 'Phone',
                                  hint: '+1 (456) 789 - 1234',
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  errorText: phoneError,
                                  isFocused: phoneFocus.hasFocus,
                                  focusNode: phoneFocus,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.isEmpty) {
                                        phoneError = null;
                                      } else if (!RegExp(
                                        r'^\+1 \(\d{3}\) \d{3} - \d{4}$',
                                      ).hasMatch(value)) {
                                        phoneError = 'Invalid number';
                                      } else {
                                        phoneError = null;
                                      }
                                    });
                                  },
                                  onFieldSubmitted: (_) {
                                    emailFocus.requestFocus();
                                  },
                                ),
                              ),
                              const SizedBox(width: 32),
                              // Email
                              SizedBox(
                                width: 300,
                                child: CustomTextField(
                                  label: 'Email',
                                  hint: 'Type an email address',
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  errorText: emailError,
                                  isFocused: emailFocus.hasFocus,
                                  focusNode: emailFocus,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.isEmpty) {
                                        emailError = null;
                                      } else if (!RegExp(
                                        r'^[\w\.-]+@[\w\.-]+\.\w+$',
                                      ).hasMatch(value)) {
                                        emailError = 'Invalid email';
                                      } else {
                                        emailError = null;
                                      }
                                    });
                                  },
                                  onFieldSubmitted: (_) {
                                    addressFocus.requestFocus();
                                  },
                                ),
                              ),
                              const SizedBox(width: 32),
                              // Address
                              SizedBox(
                                width: 300,
                                child: CustomTextField(
                                  label: 'Address',
                                  hint: 'Type your address',
                                  controller: addressController,
                                  multiline: true,
                                  errorText: addressError,
                                  isFocused: addressFocus.hasFocus,
                                  focusNode: addressFocus,
                                  onChanged: (value) {
                                    setState(() {
                                      addressError = null;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 32),
                              // Save button
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2196F3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 20,
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Keyboard gap
                    SizedBox(
                      height:
                          isKeyboardVisible
                              ? MediaQuery.of(context).viewInsets.bottom
                              : 0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
