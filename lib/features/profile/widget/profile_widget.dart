import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/constants.dart';
import 'package:ausa/features/profile/page/edit_contact_page.dart';
import 'package:ausa/features/profile/page/edit_personal_page.dart';
import 'package:ausa/features/profile/widget/horizontal_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool showPersonal = true;

  @override
  Widget build(BuildContext context) {
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
                        height: DesignScaleManager.scaleValue(100),
                        onPressed: () {
                          if (showPersonal) {
                            Get.to(() => EditPersonalPage());
                          } else {
                            Get.to(() => EditContactPage());
                          }
                        },
                        variant: ButtonVariant.tertiary,
                        leadingIcon: Icon(
                          Icons.edit,
                          size: 16,
                          color: AppColors.primary500,
                        ),

                        text: 'Edit',
                      ),

                      // InkWell(
                      //   onTap: () {
                      //
                      //   },
                      //   child: Row(
                      //     children: [
                      //       Icon(
                      //         Icons.edit,
                      //         color: Colors.blue,
                      //         size: AppSpacing.xl,
                      //       ),
                      //       SizedBox(width: AppSpacing.sm),
                      //       Text(
                      //         'Edit',
                      //         style: AppTypography.callout(
                      //           color: Colors.blue,
                      //           fontWeight: FontWeight.w500,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
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
class _ProfileTabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ProfileTabButton({
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
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfileDetail(label: 'Name', value: 'Lucy O.'),

              _ProfileDetail(label: 'Age', value: '67'),

              _ProfileDetail(label: 'Height', value: '5\'8\"'),

              _ProfileDetail(label: 'BMI', value: '26.8', isLast: true),
            ],
          ),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _ProfileDetail(label: 'Birthday', value: 'July 23, 1980'),
              _ProfileDetail(label: 'Gender', value: 'F'),
              _ProfileDetail(label: 'Weight', value: '176 lbs', isLast: true),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ProfileDetail(label: 'Phone', value: '+1 555-123-4567'),
              SizedBox(height: AppSpacing.xl),
              const _ProfileDetail(
                label: 'Address',
                value: '123 Maplewood Lane\nSpringfield, IL 62704',
              ),
            ],
          ),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _ProfileDetail(label: 'Email', value: 'olucy@gmail.com'),
            ],
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

  const _ProfileDetail({
    required this.label,
    required this.value,
    this.isLast = false,
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
        Text(
          value,
          style: AppTypography.body(weight: AppTypographyWeight.semibold),
        ),
        if (!isLast) SizedBox(height: AppSpacing.xl2),
      ],
    );
  }
}
