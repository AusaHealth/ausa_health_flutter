import 'package:ausa/common/widget/app_back_header.dart';
import 'package:ausa/common/widget/app_main_container.dart';
import 'package:ausa/common/widget/base_scaffold.dart';
import 'package:ausa/common/widget/custom_nav.dart';
import 'package:ausa/common/widget/custom_header.dart';
import 'package:ausa/constants/app_images.dart';

import 'package:ausa/features/profile/controller/family_controller.dart';
import 'package:ausa/features/profile/page/add_photo_page.dart';
import 'package:ausa/features/profile/page/family_input_page.dart';
import 'package:ausa/features/profile/widget/bottom_sheet_modal.dart';
import 'package:flutter/material.dart';
import 'package:ausa/constants/constants.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AddNewMember extends StatelessWidget {
  const AddNewMember({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FamilyController>();
    return BaseScaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBackHeader(title: 'Add new member'),
                Spacer(),
                Image.asset(
                  ProfileIcons.ausaLogo,
                  height: DesignScaleManager.scaleValue(130),
                  width: DesignScaleManager.scaleValue(130),
                ),
              ],
            ),
          ),
          Expanded(
            child: AppMainContainer(
              backgroundColor: const Color(0xffE6E2DC).withOpacity(0.2),
              // ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.all(AppSpacing.smMedium),
                      // margin: EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xl3),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // Avatar container
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => AddPhotoPage());
                              },
                              child: Container(
                                padding: EdgeInsets.all(AppSpacing.smMedium),

                                decoration: BoxDecoration(
                                  color: const Color(0xFFC2EFFF),
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.xl3,
                                  ),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    AppImages.addPhoto,
                                    height: 200,
                                    width: 200,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: AppSpacing.lg),

                          // Add profile photo button
                          Container(
                            margin: EdgeInsets.all(AppSpacing.lg),
                            padding: EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                AppRadius.xl3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: GestureDetector(
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.lg),
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.xl3),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 16,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl4,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: AppSpacing.xl4),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.shortNameController,
                                    label: 'Short Name',
                                    placeholder: 'Enter',
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.fullNameController,
                                    label: 'Full name',
                                    placeholder: 'Enter',
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: _buildTextField(
                                    controller:
                                        controller.relationshipController,
                                    label: 'Relation',
                                    placeholder: 'Enter',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSpacing.xl),

                            // Second row - Phone Number, Email
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.phoneController,
                                    label: 'Phone Number',
                                    placeholder: '+1 (000) 000-0000',
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.emailController,
                                    label: 'Email',
                                    placeholder: 'Enter',
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(height: AppSpacing.xl),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: controller.addressController,
                                    label: 'Address',
                                    placeholder: 'Enter',
                                  ),
                                ),

                                Spacer(),
                                Spacer(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
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
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(AppRadius.xl2),
          // border: Border.all(color: Colors.grey[300]!),
        ),
        child: TextFormField(
          onTap: () {
            Get.to(() => FamilyInputPage());
          },
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: InputBorder.none,
          ),
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    ],
  );
}

class AddNewMemberForm extends StatelessWidget {
  const AddNewMemberForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(),
            SizedBox(height: AppSpacing.xl),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Expanded(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [const CustomNav(title: 'Add new member')],
            //       ),
            //     ),
            //     Image.asset(ProfileIcons.ausaLogo, height: 80, width: 100),
            //   ],
            // ),

            // Expanded(
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(
            //       horizontal: AppSpacing.xl3,
            //       vertical: AppSpacing.xl2,
            //     ),
            //     child: Container(
            //       padding: EdgeInsets.symmetric(
            //         horizontal: AppSpacing.xl3,
            //         vertical: AppSpacing.xl2,
            //       ),
            //       decoration: BoxDecoration(
            //         color: Colors.white.withOpacity(0.1),
            //         borderRadius: BorderRadius.circular(80),
            //       ),
            // child: Row(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.all(24.0),
            //       child: Row(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           // Left side - Avatar section
            // Expanded(
            //   flex: 2,
            //   child: Column(
            //     children: [
            //       // Avatar container
            //       Container(
            //         width: 250,
            //         height: 400,
            //         decoration: BoxDecoration(
            //           color: const Color(0xFFE3F2FD),
            //           borderRadius: BorderRadius.circular(24),
            //         ),
            //         child: Column(
            //           mainAxisAlignment:
            //               MainAxisAlignment.center,
            //           children: [
            //             // Avatar circle
            //             Container(
            //               width: 120,
            //               height: 120,
            //               decoration: BoxDecoration(
            //                 color: Colors.white.withOpacity(
            //                   0.7,
            //                 ),
            //                 shape: BoxShape.circle,
            //               ),
            //               child: Icon(
            //                 Icons.person_outline,
            //                 size: 60,
            //                 color: Colors.grey[400],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),

            //       const SizedBox(height: 20),

            //       // Add profile photo button
            //       GestureDetector(
            //         onTap: () {
            //           // Handle photo selection
            //           print('Add profile photo tapped');
            //         },
            //         child: Row(
            //           mainAxisAlignment:
            //               MainAxisAlignment.center,
            //           children: [
            //             Icon(
            //               Icons.add_photo_alternate_outlined,
            //               color: const Color(0xFF2196F3),
            //               size: 20,
            //             ),
            //             const SizedBox(width: 8),
            //             const Text(
            //               'Add a profile photo',
            //               style: TextStyle(
            //                 color: Color(0xFF2196F3),
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w500,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            //           const SizedBox(width: 40),
            //         ],
            //       ),
            //     ),
            //           SizedBox(width: 16),
            //           Expanded(
            //             flex: 4,
            //             child: Container(
            //               padding: EdgeInsets.symmetric(
            //                 horizontal: 24,
            //                 vertical: 24,
            //               ),
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(40),
            //                 gradient: const LinearGradient(
            //                   colors: [Color(0xFFF8FBFD), Color(0xFFB6F3F3)],
            //                   begin: Alignment.topLeft,
            //                   end: Alignment.bottomRight,
            //                 ),
            //                 boxShadow: [
            //                   BoxShadow(
            //                     color: Colors.black12,
            //                     blurRadius: 16,
            //                     offset: Offset(0, 4),
            //                   ),
            //                 ],
            //               ),
            //               child: // // Right side - Form fields
            //                   Column(
            //                 children: [
            //                   // First row - Short Name, Full Name, Relation
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl3),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.mdLarge,
                  vertical: AppSpacing.mdLarge,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.xl3),
                ),
                child: Row(
                  children: [
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
