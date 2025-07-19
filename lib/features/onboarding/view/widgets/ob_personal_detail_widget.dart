import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/common/widget/toast.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/helpers.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/onboarding/controller/onboarding_controller.dart';
import 'package:ausa/features/profile/page/input_model.dart';
import 'package:ausa/features/profile/page/input_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ObPersonalDetailWidget extends StatelessWidget {
  const ObPersonalDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: AppSpacing.xl4,
            left: AppSpacing.xl6,
            right: AppSpacing.xl6,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Details',
                style: AppTypography.headline(
                  weight: AppTypographyWeight.semibold,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Let’s this device to your name.',
                style: AppTypography.callout(),
              ),
              SizedBox(height: AppSpacing.xl2),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: controller.firstNameController.value,
                      label: 'First name*',
                      placeholder: 'Enter',
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _buildTextField(
                      controller: controller.lastNameController.value,
                      label: 'Last name*',
                      placeholder: 'Enter',
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _buildTextField(
                      controller: controller.nickNameController.value,
                      label: 'Nickname',
                      placeholder: 'Enter',
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xl4),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: controller.emailIdController.value,
                      label: 'Email ID',
                      placeholder: 'Enter',
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _buildTextField(
                      controller: controller.birthDateController.value,
                      label: 'Birthday',
                      placeholder: 'Enter',
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _buildTextField(
                      controller: controller.ageController.value,
                      label: 'Age',
                      placeholder: 'Auto',
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xl4),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: controller.heightController.value,
                      label: 'Height',
                      placeholder: 'Enter',
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _buildTextField(
                      controller: controller.weightController.value,
                      label: 'Weight',
                      placeholder: 'Enter',
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _buildTextField(
                      controller: controller.genderController.value,
                      label: 'Gender',
                      placeholder: 'Enter',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(child: SizedBox()),
        Padding(
          padding: EdgeInsets.only(
            bottom: AppSpacing.xl4,
            right: AppSpacing.xl3,
          ),
          child: Align(
            alignment: Alignment.bottomRight,
            child: AusaButton(
              size: ButtonSize.lg,
              trailingIcon: SvgPicture.asset(
                AusaIcons.arrowRight,
                width: DesignScaleManager.scaleValue(40),
                height: DesignScaleManager.scaleValue(40),
                colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
              ),
              onPressed: () {
                controller.completeStep(OnboardingStep.personalDetails);
                controller.goToStep(OnboardingStep.terms);
              },
              text: 'Proceed',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppSpacing.xl),
          child: Text(
            label,
            style: AppTypography.callout(color: AppColors.textColor),
          ),
        ),
        SizedBox(height: AppSpacing.smMedium),
        Container(
          // height: DesignScaleManager.scaleValue(80),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl2),
          ),
          child: TextFormField(
            onTap: () async {
              final inputs = [
                InputModel(
                  name: 'firstName',
                  label: 'First Name',
                  inputType: InputTypeEnum.text,
                  value: '',
                ),
                InputModel(
                  name: 'lastName',
                  label: 'Last Name',
                  inputType: InputTypeEnum.text,
                  value: '',
                ),
                InputModel(
                  name: 'nickName',
                  label: 'Nickname',
                  inputType: InputTypeEnum.text,
                  value: '',
                ),
                InputModel(
                  name: 'email',
                  label: 'Email',
                  inputType: InputTypeEnum.text,
                  value: '',
                ),
                InputModel(
                  name: 'birthDate',
                  label: 'Birthday',
                  inputType: InputTypeEnum.date,
                  value: '',
                ),
                InputModel(
                  name: 'age',
                  label: 'Age',
                  inputType: InputTypeEnum.number,
                  value: '',
                ),
                InputModel(
                  name: 'height',
                  label: 'Height',
                  inputType: InputTypeEnum.height,
                  value: '',
                ),
                InputModel(
                  name: 'weight',
                  label: 'Weight',
                  inputType: InputTypeEnum.weight,
                  value: '',
                ),
                InputModel(
                  name: 'gender',
                  label: 'Gender',
                  inputType: InputTypeEnum.selector,
                  value: '',
                  inputSource: Helpers.genderOptions,
                ),
              ];

              final result = await Get.to(
                () => InputPage(
                  inputs: inputs,
                  initialFocusFieldName:
                      'firstName', // Pass the focus field name
                ),
              );
              if (result != null) {
                CustomToast.show(
                  message: 'Personal details updated',
                  type: ToastType.success,
                );
              }
            },
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              border: InputBorder.none,
            ),
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
