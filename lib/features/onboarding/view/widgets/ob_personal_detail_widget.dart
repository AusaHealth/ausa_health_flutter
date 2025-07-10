import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/onboarding/controller/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ObPersonalDetailWidget extends StatelessWidget {
  const ObPersonalDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Details',
          style: AppTypography.body(
            color: AppColors.bodyTextLightColor,
          ).copyWith(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text('Let’s this device to your name.', style: AppTypography.callout()),
        SizedBox(height: AppSpacing.xl4),
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
        // SizedBox(height: AppSpacing.xl7),
        Expanded(child: SizedBox()),
        Align(
          alignment: Alignment.bottomRight,
          child: PrimaryButton(
            width: 130,
            borderRadius: 60,
            onPressed: () {
              // Accept logic
            },
            text: 'Proceed',
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
        Text(label, style: AppTypography.callout(color: AppColors.textColor)),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl2),
            // border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextFormField(
            onTap: () {
              // Get.to(() => FamilyInputPage());
            },
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
            ),
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
