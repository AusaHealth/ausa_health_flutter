import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/common/widget/custom_text_field.dart';
import 'package:ausa/common/widget/input_bg_container.dart';
import 'package:ausa/common/widget/on_screen_keyboard_widget.dart';
import 'package:ausa/features/profile/widget/birthday_pickup_dialoge.dart';
import 'package:ausa/features/profile/widget/bottom_sheet_modal.dart';
import 'package:ausa/features/profile/widget/height_weight_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/profile_controller.dart';

class EditPersonalPage extends StatefulWidget {
  const EditPersonalPage({super.key});

  @override
  State<EditPersonalPage> createState() => _EditPersonalPageState();
}

class _EditPersonalPageState extends State<EditPersonalPage> {
  final ProfileController controller = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    controller.setupKeyboardListeners(() {});
  }

  @override
  void dispose() {
    controller.removeKeyboardListeners(() {});
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      SizedBox(
                        width: 300,
                        child: CustomTextField(
                          multiline: true,
                          label: 'Name',
                          hint: 'Type your name',
                          controller: controller.nameController,
                          keyboardType: TextInputType.name,
                          errorText: controller.nameError,
                          isFocused: controller.nameFocus.hasFocus,
                          focusNode: controller.nameFocus,
                          onChanged: (value) {
                            setState(() {
                              controller.nameError = null;
                            });
                          },
                          onFieldSubmitted: (_) {
                            controller.phoneFocus.requestFocus();
                          },
                        ),
                      ),
                      const SizedBox(width: 32),
                      // Email
                      SizedBox(
                        width: 300,
                        child: GestureDetector(
                          onTap: () async {
                            final picked = await showDialog<DateTime>(
                              context: context,
                              builder:
                                  (context) => BirthdayPickerDialog(
                                    initialDate: controller.birthday,
                                    onDone: (date) {
                                      controller.birthday = date;
                                      controller.birthdayController.text =
                                          "${date.month}/${date.day}/${date.year}";
                                    },
                                  ),
                            );
                          },
                          child: AbsorbPointer(
                            child: CustomTextField(
                              multiline: true,
                              label: 'Birthday',
                              hint: 'MM/DD/YYYY',
                              controller: controller.birthdayController,
                              keyboardType: TextInputType.none,
                              errorText: controller.emailError,
                              isFocused: controller.emailFocus.hasFocus,
                              focusNode: controller.emailFocus,
                              onChanged: (value) {
                                setState(() {
                                  controller.emailError = null;
                                });
                              },
                              onFieldSubmitted: (_) {
                                controller.addressFocus.requestFocus();
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      // Address
                      SizedBox(
                        width: 300,
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              controller.hideKeyboard.value = true;
                            });

                            final selected = await showBottomSheetModal(
                              context,
                              selected: controller.genderController.text,
                              listItems: ['Male', 'Female', 'Other'],
                            );
                            if (selected != null) {
                              setState(() {
                                controller.genderController.text = selected;
                                controller.hideKeyboard.value = false;
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: CustomTextField(
                              multiline: true,
                              label: 'Gender',
                              hint: 'Select gender',
                              controller: controller.genderController,

                              keyboardType: TextInputType.none,
                              errorText: controller.genderError,
                              isFocused: controller.genderFocus.hasFocus,
                              focusNode: controller.genderFocus,
                              onChanged: (value) {
                                setState(() {
                                  controller.genderError = null;
                                });
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 32),
                      HeightInput(controller: controller),
                      const SizedBox(width: 32),
                      WeightInput(controller: controller),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 300,
            left: 32,
            right: 32,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AusaButton(
                    width: 100,

                    onPressed: () {
                      Get.back();
                    },
                    text: 'Save',
                  ),
                ],
              ),
            ),
          ),

          if ((!controller.hideKeyboard.value))
            Obx(() {
              return Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: OnScreenKeyboardWidget(
                  key: ValueKey(controller.currentController),
                  controller: controller.currentController,
                  type: controller.currentKeyboardType,
                  color: Color(0xffE3E6EE),
                ),
              );
            }),
        ],
      ),
    );
  }
}
