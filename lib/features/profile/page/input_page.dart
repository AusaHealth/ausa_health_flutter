import 'dart:ui';
import 'package:ausa/common/custom_keyboard.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/common/widget/close_button_widget.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/constants/utils.dart';
import 'package:ausa/features/profile/widget/birthday_pickup_dialoge.dart';
import 'package:ausa/features/profile/widget/bottom_sheet_modal.dart';
import 'package:ausa/features/profile/widget/height_weight_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'input_model.dart';

class InputPage extends StatefulWidget {
  final bool isOtherWifiNetwork;
  final List<InputModel> inputs;
  final String? initialFocusFieldName;
  const InputPage({
    super.key,
    required this.inputs,
    this.isOtherWifiNetwork = false,
    this.initialFocusFieldName,
  });

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  late List<InputModel> _inputs;
  int? focusedIndex;

  final List<FocusNode> _focusNodes = [];
  final List<TextEditingController> _controllers = [];

  bool isEmailValid = false;
  bool isEmailDirty = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _inputs = widget.inputs.map((e) => e.copyWith()).toList();

    _focusNodes.addAll(List.generate(_inputs.length, (_) => FocusNode()));
    _controllers.addAll(
      List.generate(_inputs.length, (i) {
        return TextEditingController(text: _inputs[i].value?.toString() ?? '');
      }),
    );

    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          setState(() {
            focusedIndex = i;
          });
        }
      });
    }

    // Set initial focus if specified
    if (widget.initialFocusFieldName != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final initialFocusIndex = _inputs.indexWhere(
          (input) => input.name == widget.initialFocusFieldName,
        );
        if (initialFocusIndex != -1) {
          setState(() {
            focusedIndex = initialFocusIndex;
          });

          final inputType = _inputs[initialFocusIndex].inputType;
          if (inputType == InputTypeEnum.text ||
              inputType == InputTypeEnum.number ||
              inputType == InputTypeEnum.password) {
            FocusScope.of(context).requestFocus(_focusNodes[initialFocusIndex]);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildInputCard(InputModel model, int index) {
    final isFocused = focusedIndex == index;
    final isKeyboardField =
        model.inputType == InputTypeEnum.text ||
        model.inputType == InputTypeEnum.number ||
        model.inputType == InputTypeEnum.password;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.xl6,
            right: index == _inputs.length - 1 ? AppSpacing.xl6 : 0,
            bottom: AppSpacing.mdLarge,
          ),
          child: Text(
            model.label,
            style: AppTypography.body(color: Colors.white),
          ),
        ),
        if (model.inputType != InputTypeEnum.height &&
            model.inputType != InputTypeEnum.weight)
          GestureDetector(
            onTap: () async {
              setState(() => focusedIndex = index);
              if (isKeyboardField) {
                FocusScope.of(context).requestFocus(_focusNodes[index]);
              } else {
                FocusScope.of(context).unfocus();
              }

              if (model.inputType == InputTypeEnum.selector) {
                final selected = await showBottomSheetModal(
                  inputs: _inputs,
                  isOtherWifiNetwork: widget.isOtherWifiNetwork,
                  context,
                  selected: model.value?.toString(),
                  listItems:
                      model.inputSource?.map((e) => e.toString()).toList() ??
                      [],
                );
                if (selected != null) {
                  setState(() {
                    model.value = selected;
                    _controllers[index].text = selected.toString();
                  });
                }
                setState(() => focusedIndex = index);
              }

              if (model.inputType == InputTypeEnum.date) {
                Utils.showBlurredDialog(
                  context,
                  BirthdayPickerDialouge(
                    initialDate: model.value is DateTime ? model.value : null,
                    onDone: (date) {
                      setState(() {
                        model.value = date;
                      });
                    },
                  ),
                );
                setState(() => focusedIndex = index);
              }
            },
            child: AnimatedContainer(
              height: DesignScaleManager.scaleValue(256),
              duration: Duration(milliseconds: 200),
              width: DesignScaleManager.scaleValue(512),
              margin: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              padding: EdgeInsets.all(AppSpacing.xl4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(AppRadius.xl2),
                border: Border.all(
                  color: isFocused ? Color(0xFFFF9900) : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 12,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isKeyboardField)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() => focusedIndex = index);
                        FocusScope.of(context).requestFocus(_focusNodes[index]);
                      },
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType:
                            model.inputType == InputTypeEnum.number
                                ? TextInputType.number
                                : TextInputType.text,
                        obscureText:
                            model.inputType == InputTypeEnum.password
                                ? _obscureText
                                : false,
                        onChanged: (v) {
                          model.value = v;
                        },
                        style: AppTypography.body(
                          weight: AppTypographyWeight.regular,
                          color: AppColors.bodyTextColor,
                        ),
                        decoration: InputDecoration(
                          prefixText:
                              model.inputType == InputTypeEnum.number
                                  ? '+1 '
                                  : null,
                          suffixIcon:
                              (model.inputType == InputTypeEnum.password)
                                  ? IconButton(
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
                                  )
                                  : null,
                          border: InputBorder.none,
                          hintMaxLines: 4,
                          hintText: _getHint(model.name),
                          hintStyle: AppTypography.body(
                            weight: AppTypographyWeight.regular,
                            color: AppColors.bodyTextColor,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    )
                  else if (model.inputType == InputTypeEnum.selector)
                    Text(
                      model.value?.toString().isNotEmpty == true
                          ? model.value.toString()
                          : 'Select',
                      style: AppTypography.body(
                        weight: AppTypographyWeight.regular,
                        color: AppColors.bodyTextColor,
                      ),
                    )
                  else if (model.inputType == InputTypeEnum.date)
                    Text(
                      model.value is DateTime
                          ? _formatDate(model.value)
                          : 'YYYY/MM/DD',
                      style: AppTypography.body(
                        weight: AppTypographyWeight.regular,
                        color: AppColors.bodyTextColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
        if (model.inputType == InputTypeEnum.height)
          HeightInput(
            value: model.value?.toString() ?? '',
            label: model.label,
            onChanged: (value) {
              setState(() {
                model.value = value;
              });
            },
          ),
        if (model.inputType == InputTypeEnum.weight)
          WeightInput(
            value: model.value?.toString() ?? '',
            label: model.label,
            onChanged: (value) {
              setState(() {
                model.value = value;
              });
            },
          ),
      ],
    );
  }

  String _getHint(String name) {
    switch (name) {
      case "phone":
        return "+1 (000) 000 - 0000";
      case "email":
        return "johndoe@email.com";
      case "address":
        return "1234 Maplewood Lane,\n Springfield, IL 62704";
      case "name":
        return "Type your name";
      case "shortName":
        return "John";
      case "fullName":
        return "John Doe";
      case "networkName":
        return "Network Name";
      case "Password":
        return "Password...";
      case "security":
        return "Security";
      default:
        return "";
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final showKeyboard =
        focusedIndex != null &&
        (_inputs[focusedIndex!].inputType == InputTypeEnum.text ||
            _inputs[focusedIndex!].inputType == InputTypeEnum.number ||
            _inputs[focusedIndex!].inputType == InputTypeEnum.password);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTapDown: (TapDownDetails details) {
          if (showKeyboard) {
            if (details.globalPosition.dy <
                Get.height - DesignScaleManager.keyboardHeight) {
              setState(() => focusedIndex = null);
              FocusScope.of(context).unfocus();
            }
          } else {
            setState(() => focusedIndex = null);
            FocusScope.of(context).unfocus();
          }
        },
        behavior: HitTestBehavior.translucent,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 31.2, sigmaY: 31.2),
          child: Container(
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(14, 36, 87, 0.80),
            ),
            child: Column(
              children: [
                InputPageCloseButton(),
                if (widget.isOtherWifiNetwork) ...[
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
                          'Other Networks',
                          style: AppTypography.headline(
                            weight: AppTypographyWeight.medium,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl2),
                ],
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      _inputs.length,
                      (index) => _buildInputCard(_inputs[index], index),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: AppSpacing.xl8,
                    right: AppSpacing.xl3,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AusaButton(
                        size: ButtonSize.lg,
                        onPressed: () {
                          Get.back(result: _inputs);
                        },
                        text: 'Save',
                      ),
                    ],
                  ),
                ),
                Spacer(),
                if (showKeyboard)
                  AbsorbPointer(
                    absorbing: false,
                    child: Container(
                      color: Colors.white,
                      child: CustomKeyboard(
                        fontSize: 16,
                        height: DesignScaleManager.keyboardHeight.toDouble(),
                        textColor: Colors.black,
                        keyboardType:
                            _inputs[focusedIndex!].inputType ==
                                    InputTypeEnum.number
                                ? CustomKeyboardType.numeric
                                : CustomKeyboardType.alphanumeric,
                        onKeyPressed: (v) {
                          final controller = _controllers[focusedIndex!];
                          controller.text += v;
                          controller.selection = TextSelection.collapsed(
                            offset: controller.text.length,
                          );
                          _inputs[focusedIndex!].value = controller.text;
                        },
                        onBackspacePressed: () {
                          final index = focusedIndex!;
                          final controller = _controllers[index];
                          if (controller.text.isNotEmpty) {
                            controller.text = controller.text.substring(
                              0,
                              controller.text.length - 1,
                            );
                            controller.selection = TextSelection.collapsed(
                              offset: controller.text.length,
                            );
                            _inputs[index].value = controller.text;
                          }
                        },
                        initialNumericVisible: false,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InputPageCloseButton extends StatelessWidget {
  const InputPageCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.xl3, right: AppSpacing.xl3),
      child: Align(alignment: Alignment.topRight, child: CloseButtonWidget()),
    );
  }
}
