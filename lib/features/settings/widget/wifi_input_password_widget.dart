import 'dart:ui';

import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/profile/page/input_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class WifiInputPasswordWidget extends StatefulWidget {
  const WifiInputPasswordWidget({super.key});

  @override
  State<WifiInputPasswordWidget> createState() =>
      _WifiInputPasswordWidgetState();
}

class _WifiInputPasswordWidgetState extends State<WifiInputPasswordWidget> {
  bool _obscureText = true;
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 31.2, sigmaY: 31.2),
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(14, 36, 87, 0.80),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              InputPageCloseButton(),
              SizedBox(height: AppSpacing.xl2),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl3),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AusaIcons.wifi,
                      width: DesignScaleManager.scaleValue(40),
                      height: DesignScaleManager.scaleValue(40),
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: AppSpacing.smMedium),
                    Text(
                      'DIRECT_37129t4bg937',
                      style: AppTypography.headline(
                        weight: AppTypographyWeight.medium,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xl2),
              Padding(
                padding: EdgeInsets.only(left: AppSpacing.xl7),
                child: Text(
                  'Enter Password',
                  style: AppTypography.body(
                    weight: AppTypographyWeight.regular,
                    color: AppColors.white,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.mdLarge),
              AnimatedContainer(
                height: DesignScaleManager.scaleValue(304),
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.orange,
                    width: 3,
                  ), // Orange border
                ),
                child: Center(
                  child: TextField(
                    controller: _controller,
                    obscureText: _obscureText,
                    style: const TextStyle(fontSize: 18, color: Colors.black87),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // AnimatedContainer(
              //   height: DesignScaleManager.scaleValue(304),
              //   duration: Duration(milliseconds: 200),

              //   margin: EdgeInsets.symmetric(horizontal: AppSpacing.xl3),
              //   padding: EdgeInsets.all(AppSpacing.xl4),
              //   decoration: BoxDecoration(
              //     color: Colors.white.withOpacity(0.85),
              //     borderRadius: BorderRadius.circular(AppRadius.xl2),
              //     border: Border.all(color: Colors.transparent, width: 2),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withOpacity(0.07),
              //         blurRadius: 12,
              //         offset: Offset(0, 2),
              //       ),
              //     ],
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       TextField(
              //         focusNode: FocusNode(),
              //         controller: TextEditingController(text: "")
              //           ..selection = TextSelection.collapsed(offset: 0),
              //         onChanged: (v) => {},
              //         style: TextStyle(fontSize: 18, color: Colors.black87),
              //         decoration: InputDecoration(
              //           border: InputBorder.none,
              //           hintText: 'Enter Password',
              //           hintStyle: TextStyle(color: Colors.grey[400]),
              //           isDense: true,
              //           contentPadding: EdgeInsets.zero,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(
                  top: AppSpacing.xl8,
                  right: AppSpacing.xl3,
                ),
                child: InputPageSaveButton(inputs: []),
              ),
              // if (showKeyboard)
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: VirtualKeyboard(
                    textController: _controller,
                    fontSize: 16,
                    // height: DesignScaleManager.keyboardHeight.toDouble(),
                    textColor: Colors.black,
                    defaultLayouts: [VirtualKeyboardDefaultLayouts.English],
                    type: VirtualKeyboardType.Alphanumeric,
                    postKeyPress: (v) {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
