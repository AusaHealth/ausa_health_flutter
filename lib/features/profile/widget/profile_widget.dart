import 'package:ausa/features/profile/page/edit_personal_page.dart';
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
            child: Stack(
              children: [
                // Gradient background
                // Positioned.fill(
                //   child: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(40),
                //       gradient: const LinearGradient(
                //         begin: Alignment.bottomLeft,
                //         end: Alignment.topRight,
                //         colors: [Color(0xFF00C6FB), Color(0xFF005BEA)],
                //       ),
                //     ),
                //   ),
                // ),
                // Card content
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 0),
                  padding: const EdgeInsets.all(32),
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
                      // Tabs and Edit button row
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE0B2),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Row(
                              children: [
                                _ProfileTabButton(
                                  label: 'Personal',
                                  selected: showPersonal,
                                  onTap:
                                      () => setState(() => showPersonal = true),
                                ),
                                _ProfileTabButton(
                                  label: 'Contact',
                                  selected: !showPersonal,
                                  onTap:
                                      () =>
                                          setState(() => showPersonal = false),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Color(0xFF2196F3),
                            ),
                            onPressed: () {
                              Get.to(() => EditPersonalPage());
                            },
                          ),
                          const Text(
                            'Edit',
                            style: TextStyle(
                              color: Color(0xFF2196F3),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Details
                      if (showPersonal)
                        _PersonalDetails()
                      else
                        _ContactDetails(),
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
        // Left column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _ProfileDetail(
                label: 'Name',
                value: 'Lucy O.',
                bold: true,
                large: true,
              ),
              _ProfileDetail(label: 'Age', value: '67', large: true),
              _ProfileDetail(
                label: 'Height',
                value: '5\'8\"',
                bold: true,
                large: true,
              ),
              _ProfileDetail(
                label: 'BMI',
                value: '26.8',
                color: Color(0xFF2196F3),
                large: true,
              ),
            ],
          ),
        ),
        // Right column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _ProfileDetail(
                label: 'Birthday',
                value: 'July 23, 1980',
                bold: true,
                large: true,
              ),
              _ProfileDetail(label: 'Gender', value: 'F', large: true),
              _ProfileDetail(
                label: 'Weight',
                value: '176 lbs',
                bold: true,
                large: true,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _ContactDetail(
                label: 'Phone',
                value: '+1 555-123-4567',
                bold: true,
              ),
              SizedBox(height: 32),
              _ContactDetail(
                label: 'Address',
                value: '123 Maplewood Lane\nSpringfield, IL 62704',
                bold: true,
              ),
            ],
          ),
        ),
        // Right column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _ContactDetail(
                label: 'Email',
                value: 'olucy@gmail.com',
                bold: true,
              ),
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
  final bool bold;
  final bool large;
  final Color? color;

  const _ProfileDetail({
    required this.label,
    required this.value,
    this.bold = false,
    this.large = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 16),
          ),

          Text(
            value,
            style: TextStyle(
              color: color ?? Colors.black,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: large ? 20 : 14,
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
  final bool bold;

  const _ContactDetail({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black54, fontSize: 16),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontSize: 22,
          ),
        ),
      ],
    );
  }
}
