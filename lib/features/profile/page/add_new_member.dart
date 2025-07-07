import 'package:ausa/common/widget/custom_nav.dart';
import 'package:ausa/common/widget/settings_header.dart';
import 'package:ausa/constants/app_images.dart';
import 'package:ausa/features/profile/controller/profile_controller.dart';
import 'package:ausa/features/profile/widget/bottom_sheet_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AddNewMember extends StatelessWidget {
  const AddNewMember({super.key});

  @override
  Widget build(BuildContext context) {
    final shortNameController = TextEditingController();
    final fullNameController = TextEditingController();
    final relationController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final addressController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader(),
                const SizedBox(height: 8),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [const CustomNav(title: 'Add new member')],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 12.0),
                      child: Image.asset(
                        ProfileIcons.ausaLogo,
                        height: 80,
                        width: 100,
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side - Avatar section
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            // Avatar container
                            Container(
                              width: 250,
                              height: 400,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Avatar circle
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.person_outline,
                                      size: 60,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Add profile photo button
                            GestureDetector(
                              onTap: () {
                                // Handle photo selection
                                print('Add profile photo tapped');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    color: const Color(0xFF2196F3),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Add a profile photo',
                                    style: TextStyle(
                                      color: Color(0xFF2196F3),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 40),

                      // // Right side - Form fields
                      // Expanded(
                      //   child: Column(
                      //     children: [
                      //       // First row - Short Name, Full Name, Relation
                      //       Row(
                      //         children: [
                      //           Expanded(
                      //             child: _buildInputField(
                      //               'Short Name',
                      //               'Enter',
                      //               shortNameController,
                      //             ),
                      //           ),
                      //           const SizedBox(width: 20),
                      //           Expanded(
                      //             child: _buildInputField(
                      //               'Full name',
                      //               'Enter',
                      //               fullNameController,
                      //             ),
                      //           ),
                      //           const SizedBox(width: 20),
                      //           Expanded(
                      //             child: _buildDropdownField(
                      //               'Relation',
                      //               'Select',
                      //               relationController,
                      //               context,
                      //             ),
                      //           ),
                      //         ],
                      //       ),

                      //       const SizedBox(height: 24),

                      //       // Second row - Phone Number, Email
                      //       Row(
                      //         children: [
                      //           Expanded(child: _buildPhoneField()),
                      //           const SizedBox(width: 20),
                      //           Expanded(
                      //             child: _buildInputField(
                      //               'Email',
                      //               'Enter',
                      //               emailController,
                      //             ),
                      //           ),
                      //           const SizedBox(width: 20),
                      //           Expanded(
                      //             child: Container(),
                      //           ), // Empty space to maintain alignment
                      //         ],
                      //       ),

                      //       const SizedBox(height: 24),

                      //       // Third row - Address
                      //       Row(
                      //         children: [
                      //           Expanded(
                      //             flex: 2,
                      //             child: _buildInputField(
                      //               'Address',
                      //               'Enter',
                      //               addressController,
                      //             ),
                      //           ),
                      //           Expanded(child: Container()), // Empty space
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String placeholder,
    TextEditingController controller,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: GestureDetector(
            onTap: () async {
              final selected = await showBottomSheetModal(
                context,
                selected: controller.text,
                listItems: [
                  'Spouse',
                  'Child',
                  'Grandchild',
                  'Parent',
                  'Friend',
                  'Other',
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    String placeholder,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    final controller = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone Number',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: '+1 (000) 000-0000',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
