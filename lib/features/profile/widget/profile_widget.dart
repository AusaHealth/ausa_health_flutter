import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/common/widget/toast.dart';
import 'package:ausa/constants/constants.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/utils.dart';
import 'package:ausa/features/profile/controller/profile_controller.dart';
import 'package:ausa/features/profile/page/input_model.dart';
import 'package:ausa/features/profile/page/input_page.dart';
import 'package:ausa/features/profile/widget/horizontal_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool showPersonal = true;

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl3),
            child: Image.asset(
              'assets/images/profile.png',
              fit: BoxFit.fill,
              height: 760,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.lg),

        // Profile Details Card with Gradient Background
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: DesignScaleManager.scaleValue(96),
                width: DesignScaleManager.scaleValue(488),
                child: HorizontalTabBar(
                  items: ['Personal', 'Contact'],
                  selectedIndex: showPersonal ? 0 : 1,
                  onSelected:
                      (index) => setState(() => showPersonal = index == 0),
                ),
              ),

              SizedBox(height: AppSpacing.xl),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        left: AppSpacing.xl4,
                        right: AppSpacing.xl4,
                        top: AppSpacing.xl4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xl3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Details
                          if (showPersonal)
                            _PersonalDetails()
                          else
                            _ContactDetails(),
                        ],
                      ),
                    ),
                    Positioned(
                      right: AppSpacing.xl,
                      top: 14,
                      child: AusaButton(
                        height: DesignScaleManager.scaleValue(80),
                        onPressed: () async {
                          if (showPersonal) {
                            List<InputModel> inputs = [
                              InputModel(
                                name: 'name',
                                label: 'Name',
                                inputType: InputTypeEnum.text,
                                value: profileController.user.name,
                              ),
                              InputModel(
                                name: 'birthday',
                                label: 'Birthday',
                                inputType: InputTypeEnum.date,
                                // value: profileController.user.dateOfBirth,
                              ),
                              InputModel(
                                name: 'gender',
                                label: 'Gender',
                                inputType: InputTypeEnum.selector,
                                value: profileController.user.gender,
                                inputSource: ['Male', 'Female', 'Other'],
                              ),
                              InputModel(
                                name: 'height',
                                label: 'Height',
                                inputType: InputTypeEnum.height,
                                value: profileController.user.height,
                              ),
                              InputModel(
                                name: 'weight',
                                label: 'Weight',
                                inputType: InputTypeEnum.weight,
                                value: profileController.user.weight,
                              ),
                            ];
                            final result = await Get.to(
                              () => InputPage(inputs: inputs),
                            );

                            if (result != null && result is List<InputModel>) {
                              profileController.user.updateFromInputs(result);
                              CustomToast.show(
                                message: 'Profile updated',
                                type: ToastType.success,
                              );
                              setState(() {});
                            }
                          } else {
                            List<InputModel> inputs = [
                              InputModel(
                                name: 'phone',
                                label: 'Phone',
                                inputType: InputTypeEnum.number,
                                value: profileController.user.phone,
                              ),
                              InputModel(
                                name: 'email',
                                label: 'Email',
                                inputType: InputTypeEnum.text,
                                value: profileController.user.email,
                              ),
                              InputModel(
                                name: 'address',
                                label: 'Address',
                                inputType: InputTypeEnum.text,
                                value: profileController.user.address,
                              ),
                            ];
                            final result = await Get.to(
                              () => InputPage(inputs: inputs),
                            );

                            if (result != null && result is List<InputModel>) {
                              profileController.user.updateFromInputs(result);
                              CustomToast.show(
                                message: 'Profile updated',
                                type: ToastType.success,
                              );
                              setState(() {});
                            }
                          }
                        },
                        variant: ButtonVariant.tertiary,
                        leadingIcon: SvgPicture.asset(
                          height: DesignScaleManager.scaleValue(24),
                          width: DesignScaleManager.scaleValue(24),
                          AusaIcons.edit01,
                          colorFilter: ColorFilter.mode(
                            AppColors.primary500,
                            BlendMode.srcIn,
                          ),
                        ),

                        text: 'Edit',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Tab Button
class ProfileTabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ProfileTabButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFA726) : Colors.transparent,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

// Personal Details Card
class _PersonalDetails extends StatelessWidget {
  final ProfileController profileController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfileDetail(label: 'Name', value: profileController.user.name),

              _ProfileDetail(
                label: 'Age',
                value:
                    Utils.calculateAge(
                      profileController.user.dateOfBirth,
                    ).toString(),
              ),

              _ProfileDetail(
                label: 'Height',
                value: profileController.user.height,
              ),

              _ProfileDetail(
                label: 'BMI',
                value: Utils.calculateBMI(
                  weightKg: double.parse(profileController.user.weight),
                  heightCm: Utils.inchesToCm(
                    double.parse(profileController.user.height),
                  ),
                ).toStringAsFixed(1),
              ),
            ],
          ),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfileDetail(
                label: 'Birthday',
                value: Utils.formatDate(profileController.user.dateOfBirth),
              ),
              _ProfileDetail(
                label: 'Gender',
                value: profileController.user.gender,
              ),
              _ProfileDetail(
                label: 'Weight',
                value: '${profileController.user.weight} lbs',
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Contact Details Card
class _ContactDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfileDetail(
                label: 'Phone',
                value: profileController.user.phone,
              ),
              SizedBox(height: AppSpacing.xl),
              _ProfileDetail(
                isAddress: true,
                label: 'Address',
                value: profileController.user.address,
              ),
            ],
          ),
        ),

        Expanded(
          child: _ProfileDetail(
            label: 'Email',
            value: profileController.user.email,
          ),
        ),
      ],
    );
  }
}

// Profile Detail (Personal)
class _ProfileDetail extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  final bool isAddress;

  const _ProfileDetail({
    required this.label,
    required this.value,
    this.isLast = false,
    this.isAddress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.callout(weight: AppTypographyWeight.regular),
        ),
        SizedBox(height: AppSpacing.mdLarge),
        SizedBox(
          width: isAddress ? 160 : null,
          child: Text(
            value,
            style: AppTypography.body(weight: AppTypographyWeight.semibold),
          ),
        ),
        if (!isLast) SizedBox(height: AppSpacing.xl2),
      ],
    );
  }
}
