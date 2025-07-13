import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/common/widget/custom_text_field.dart';
import 'package:ausa/common/widget/input_bg_container.dart';
import 'package:ausa/common/widget/on_screen_keyboard_widget.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/features/profile/controller/family_controller.dart';
import 'package:ausa/features/profile/widget/bottom_sheet_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FamilyInputPage extends StatefulWidget {
  const FamilyInputPage({super.key});

  @override
  State<FamilyInputPage> createState() => _FamilyInputPageState();
}

class _FamilyInputPageState extends State<FamilyInputPage> {
  final controller = Get.find<FamilyController>();

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
            left: 16,
            right: 16,
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 300,
                        child: CustomTextField(
                          multiline: true,
                          label: 'Short Name',
                          hint: 'John',
                          controller: controller.shortNameController,
                          keyboardType: TextInputType.name,
                          errorText: controller.shortNameError.value,
                          isFocused: controller.shortNameFocus.hasFocus,
                          focusNode: controller.shortNameFocus,
                          onChanged: (value) {
                            setState(() {
                              controller.shortNameError.value = null;
                            });
                          },
                          onFieldSubmitted: (_) {
                            controller.fullNameFocus.requestFocus();
                          },
                        ),
                      ),
                      SizedBox(width: AppSpacing.xl4),
                      SizedBox(
                        width: 300,
                        child: CustomTextField(
                          onChanged: (value) {
                            setState(() {
                              controller.fullNameError.value = null;
                            });
                          },
                          multiline: true,
                          label: 'Full Name',
                          hint: 'John Doe',
                          controller: controller.fullNameController,
                          keyboardType: TextInputType.name,
                          errorText: controller.fullNameError.value,
                          isFocused: controller.fullNameFocus.hasFocus,
                          focusNode: controller.fullNameFocus,
                          onFieldSubmitted: (_) {
                            controller.phoneFocus.requestFocus();
                          },
                        ),
                      ),
                      SizedBox(width: AppSpacing.xl4),

                      SizedBox(
                        width: 300,
                        child: CustomTextField(
                          multiline: true,
                          label: 'Phone',
                          hint: '+1 (202) 555-0198',
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          errorText: controller.phoneError.value,
                          isFocused: controller.phoneFocus.hasFocus,
                          focusNode: controller.phoneFocus,
                        ),
                      ),
                      SizedBox(width: AppSpacing.xl4),
                      SizedBox(
                        width: 300,
                        child: CustomTextField(
                          multiline: true,
                          label: 'Email',
                          hint: 'johndoe@email.com',
                          controller: controller.emailController,
                          keyboardType: TextInputType.name,
                          errorText: controller.emailError.value,
                          isFocused: controller.emailFocus.hasFocus,
                          focusNode: controller.emailFocus,
                        ),
                      ),
                      SizedBox(width: AppSpacing.xl4),
                      SizedBox(
                        width: 300,
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              controller.hideKeyboard.value = true;
                            });

                            final selected = await showBottomSheetModal(
                              context,
                              selected: controller.relationshipController.text,
                              listItems: [
                                'Spouse',
                                'Child',
                                'Grandchild',
                                'Parent',
                                'Friend',
                                'Other',
                              ],
                            );
                            if (selected != null) {
                              setState(() {
                                controller.relationshipController.text =
                                    selected;
                                controller.hideKeyboard.value = false;
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: CustomTextField(
                              multiline: true,
                              label: 'Relationship',
                              hint:
                                  'Type ‘other’ relation here or tap on this box again to select from options.',
                              controller: controller.relationshipController,

                              keyboardType: TextInputType.none,
                              errorText: controller.relationshipError.value,
                              isFocused: controller.relationshipFocus.hasFocus,
                              focusNode: controller.relationshipFocus,
                              onChanged: (value) {
                                setState(() {
                                  controller.relationshipError.value = null;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.xl4),

                      SizedBox(
                        width: 300,
                        child: CustomTextField(
                          multiline: true,
                          label: 'Address',
                          hint: '1234 Maplewood Lane, Springfield, IL 62704',
                          controller: controller.addressController,
                          keyboardType: TextInputType.name,
                          errorText: controller.addressError.value,
                          isFocused: controller.addressFocus.hasFocus,
                          focusNode: controller.addressFocus,
                        ),
                      ),
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
