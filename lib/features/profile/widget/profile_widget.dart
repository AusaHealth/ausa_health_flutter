import 'package:ausa/constants/typography.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ).copyWith(bottom: 44, top: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Image.asset(
              'assets/images/profile.png',
              width: 500,
              height: 500,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 24),

          // Profile Details Card with Gradient Background
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.width * 0.28,
                  child: HorizontalTabBar(
                    items: ['Personal', 'Contact'],
                    selectedIndex: showPersonal ? 0 : 1,
                    onSelected:
                        (index) => setState(() => showPersonal = index == 0),
                  ),
                ),

                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 4, left: 0),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
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
                            SizedBox(height: 20),
                            // Details
                            if (showPersonal)
                              _PersonalDetails()
                            else
                              _ContactDetails(),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 32,
                        top: 24,
                        child: InkWell(
                          onTap: () {
                            if (showPersonal) {
                              Get.to(() => EditPersonalPage());
                            } else {
                              Get.to(() => EditContactPage());
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.blue, size: 16),
                              SizedBox(width: 8),
                              Text(
                                'Edit',
                                style: AppTypography.callout(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
              SizedBox(height: 4),
              _ProfileDetail(label: 'Age', value: '67'),
              SizedBox(height: 4),
              _ProfileDetail(label: 'Height', value: '5\'8\"'),
              SizedBox(height: 4),
              _ProfileDetail(label: 'BMI', value: '26.8'),
            ],
          ),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _ProfileDetail(label: 'Birthday', value: 'July 23, 1980'),
              _ProfileDetail(label: 'Gender', value: 'F'),
              _ProfileDetail(label: 'Weight', value: '176 lbs'),
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
            children: const [
              _ContactDetail(label: 'Phone', value: '+1 555-123-4567'),
              SizedBox(height: 32),
              _ContactDetail(
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
              _ContactDetail(label: 'Email', value: 'olucy@gmail.com'),
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

  const _ProfileDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.callout(
              color: Colors.black,
              fontWeight: FontWeight.w300,
            ).copyWith(color: Color(0xff1C1C1C)),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: AppTypography.body(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Contact Detail
class _ContactDetail extends StatelessWidget {
  final String label;
  final String value;

  const _ContactDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.callout(
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ).copyWith(color: Color(0xff1C1C1C)),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTypography.body(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
