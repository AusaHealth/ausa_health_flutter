import 'dart:ui';
import 'package:ausa/common/custom_keyboard.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/profile/page/input_page.dart';
import 'package:ausa/features/settings/controller/wifi_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class WifiInputPasswordWidget extends StatefulWidget {
  const WifiInputPasswordWidget({super.key});

  @override
  State<WifiInputPasswordWidget> createState() =>
      _WifiInputPasswordWidgetState();
}

class _WifiInputPasswordWidgetState extends State<WifiInputPasswordWidget> {
  bool _obscureText = true;
  final TextEditingController _controller = TextEditingController();
  final WifiController controller = Get.find<WifiController>();
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
                margin: EdgeInsets.symmetric(horizontal: AppSpacing.xl3),
                padding: EdgeInsets.all(AppSpacing.xl3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(AppRadius.xl2),
                  border: Border.all(
                    color: Colors.orange,
                    width: 2,
                  ), // Orange border
                ),
                child: TextField(
                  readOnly: true,
                  controller: _controller,
                  obscureText: _obscureText,
                  style: AppTypography.body(
                    weight: AppTypographyWeight.regular,
                    color: AppColors.black,
                  ),
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
              SizedBox(height: AppSpacing.xl2),
              Expanded(
                child: CustomKeyboard(
                  height: DesignScaleManager.keyboardHeight.toDouble(),
                  fontSize: 14,
                  keyboardType: CustomKeyboardType.alphanumeric,
                  onKeyPressed: (v) {
                    _controller.text += v;
                  },
                  onEnterPressed: () {
                    controller.submitPassword(_controller.text);
                  },
                  onBackspacePressed: () {
                    _controller.text = _controller.text.substring(
                      0,
                      _controller.text.length - 1,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
