// import 'package:ausa/constants/typography.dart';
// import 'package:ausa/features/profile/controller/profile_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

// class HeightInput extends StatefulWidget {
//   const HeightInput({super.key, required this.controller});
//   final ProfileController controller;

//   @override
//   State<HeightInput> createState() => _HeightInputState();
// }

// class _HeightInputState extends State<HeightInput> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 300,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Height', style: AppTypography.body(color: Colors.white)),
//           const SizedBox(height: 8),
//           Container(
//             decoration: BoxDecoration(
//               color: const Color(0xFFE8E8E8),
//               borderRadius: BorderRadius.circular(24),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Input Container
//                 Container(
//                   margin: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 8,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(24),
//                     border: Border.all(
//                       color: const Color(0xFFFF7F50), // Orange border
//                       width: 2,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Feet Input
//                       SizedBox(
//                         width: 60,
//                         child: TextField(
//                           controller: widget.controller.feetController,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.black,
//                           ),
//                           keyboardType: TextInputType.number,
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                             contentPadding: EdgeInsets.zero,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       const Text(
//                         'ft',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(width: 40),
//                       // Inches Input
//                       SizedBox(
//                         width: 60,
//                         child: TextField(
//                           controller: widget.controller.inchesController,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.grey,
//                           ),
//                           keyboardType: TextInputType.number,
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                             contentPadding: EdgeInsets.zero,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       const Text(
//                         'in',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Toggle Buttons
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12.0,
//                     vertical: 8,
//                   ),
//                   child: Row(
//                     children: [
//                       // Feet Button
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               widget.controller.isFeet.value = true;
//                             });
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             decoration: BoxDecoration(
//                               color:
//                                   widget.controller.isFeet.value
//                                       ? const Color(0xFF1A1A2E)
//                                       : Colors.transparent,
//                               borderRadius: BorderRadius.circular(24),
//                             ),
//                             child: Text(
//                               'feet',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                                 color:
//                                     widget.controller.isFeet.value
//                                         ? Colors.white
//                                         : Colors.grey[600],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 16),

//                       // Inches Button
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               widget.controller.isFeet.value = false;
//                             });
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             decoration: BoxDecoration(
//                               color:
//                                   !widget.controller.isFeet.value
//                                       ? const Color(0xFF1A1A2E)
//                                       : Colors.transparent,
//                               borderRadius: BorderRadius.circular(24),
//                             ),
//                             child: Text(
//                               'inches',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                                 color:
//                                     !widget.controller.isFeet.value
//                                         ? const Color(0xFF4A90E2)
//                                         : const Color(0xFF4A90E2),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class WeightInput extends StatefulWidget {
//   const WeightInput({super.key, required this.controller});
//   final ProfileController controller;

//   @override
//   State<WeightInput> createState() => _WeightInputState();
// }

// class _WeightInputState extends State<WeightInput> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 300,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Weight', style: AppTypography.body(color: Colors.white)),
//           const SizedBox(height: 8),
//           Container(
//             decoration: BoxDecoration(
//               color: const Color(0xFFE8E8E8),
//               borderRadius: BorderRadius.circular(24),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Input Container
//                 Container(
//                   margin: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 8,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(24),
//                     border: Border.all(
//                       color: const Color(0xFFFF7F50), // Orange border
//                       width: 2,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         width: 60,
//                         child: TextField(
//                           controller: widget.controller.weightController,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.black,
//                           ),
//                           keyboardType: TextInputType.number,
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                             contentPadding: EdgeInsets.zero,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),

//                       Obx(
//                         () => Text(
//                           widget.controller.isLbs.value ? 'lbs' : 'kg',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Toggle Buttons
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12.0,
//                     vertical: 8,
//                   ),
//                   child: Row(
//                     children: [
//                       // Feet Button
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               widget.controller.isLbs.value = true;
//                             });
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             decoration: BoxDecoration(
//                               color:
//                                   widget.controller.isLbs.value
//                                       ? const Color(0xFF1A1A2E)
//                                       : Colors.transparent,
//                               borderRadius: BorderRadius.circular(24),
//                             ),
//                             child: Text(
//                               'lbs',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                                 color:
//                                     widget.controller.isLbs.value
//                                         ? Colors.white
//                                         : Colors.grey[600],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 16),

//                       // Inches Button
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               widget.controller.isLbs.value = false;
//                             });
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             decoration: BoxDecoration(
//                               color:
//                                   !widget.controller.isLbs.value
//                                       ? const Color(0xFF1A1A2E)
//                                       : Colors.transparent,
//                               borderRadius: BorderRadius.circular(24),
//                             ),
//                             child: Text(
//                               'kg',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                                 color:
//                                     !widget.controller.isLbs.value
//                                         ? const Color(0xFF4A90E2)
//                                         : const Color(0xFF4A90E2),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
