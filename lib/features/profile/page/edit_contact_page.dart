import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/common/widget/custom_text_field.dart';
import 'package:ausa/common/widget/input_bg_container.dart';
import 'package:ausa/common/widget/on_screen_keyboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/profile_controller.dart';

class EditContactPage extends StatefulWidget {
  const EditContactPage({super.key});

  @override
  State<EditContactPage> createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  final ProfileController controller = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    controller.setupKeyboardListeners(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.removeKeyboardListeners(() {
      setState(() {});
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InputBgContainer(
      child: Stack(
        children: [
          Positioned(
            top: 80,
            left: 32,
            right: 32,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phone
                    SizedBox(
                      width: 300,
                      child: CustomTextField(
                        multiline: true,
                        label: 'Phone',
                        hint: '+1 (456) 789 - 1234',
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        errorText: controller.phoneError,
                        isFocused: controller.phoneFocus.hasFocus,
                        focusNode: controller.phoneFocus,
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              controller.phoneError = null;
                            } else if (!RegExp(
                              r'^\+1 \(\d{3}\) \d{3} - \d{4}$',
                            ).hasMatch(value)) {
                              controller.phoneError = 'Invalid number';
                            } else {
                              controller.phoneError = null;
                            }
                          });
                        },
                        onFieldSubmitted: (_) {
                          controller.emailFocus.requestFocus();
                        },
                      ),
                    ),
                    const SizedBox(width: 32),
                    // Email
                    SizedBox(
                      width: 300,
                      child: CustomTextField(
                        multiline: true,
                        label: 'Email',
                        hint: 'Type an email address',
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        errorText: controller.emailError,
                        isFocused: controller.emailFocus.hasFocus,
                        focusNode: controller.emailFocus,
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              controller.emailError = null;
                            } else if (!RegExp(
                              r'^[\w\.-]+@[\w\.-]+\.\w+$',
                            ).hasMatch(value)) {
                              controller.emailError = 'Invalid email';
                            } else {
                              controller.emailError = null;
                            }
                          });
                        },
                        onFieldSubmitted: (_) {
                          controller.addressFocus.requestFocus();
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
                        controller: controller.addressController,
                        multiline: true,
                        errorText: controller.addressError,
                        isFocused: controller.addressFocus.hasFocus,
                        focusNode: controller.addressFocus,
                        onChanged: (value) {
                          setState(() {
                            controller.addressError = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 240,
            left: 32,
            right: 32,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PrimaryButton(
                    borderRadius: 60,
                    onPressed: () {
                      Get.back();
                    },
                    text: 'Save',
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: OnScreenKeyboardWidget(
                key: ValueKey(controller.currentController),
                controller: controller.currentController,
                type: controller.currentKeyboardType,
                color: Color(0xffE3E6EE),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
