import 'dart:ui';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/profile/widget/birthday_pickup_dialoge.dart';
import 'package:ausa/features/profile/widget/bottom_sheet_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
import 'input_model.dart';

class InputPage extends StatefulWidget {
  final List<InputModel> inputs;
  const InputPage({Key? key, required this.inputs}) : super(key: key);

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  late List<InputModel> _inputs;
  int? focusedIndex;
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    _inputs = widget.inputs.map((e) => e.copyWith()).toList();
    _focusNodes.addAll(List.generate(_inputs.length, (_) => FocusNode()));
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Widget _buildInputCard(InputModel model, int index) {
    final isFocused = focusedIndex == index;
    final isKeyboardField =
        model.inputType == InputTypeEnum.text ||
        model.inputType == InputTypeEnum.number;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? AppSpacing.xl10 : AppSpacing.xl6,
            right: index == _inputs.length - 1 ? AppSpacing.xl6 : 0,
            bottom: AppSpacing.mdLarge,
          ),
          child: Text(
            model.label,
            style: AppTypography.body(color: Colors.white),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? AppSpacing.xl6 : 0,
            right: index == _inputs.length - 1 ? AppSpacing.xl6 : 0,
          ),
          child: GestureDetector(
            onTap: () async {
              setState(() => focusedIndex = index);
              if (isKeyboardField) {
                FocusScope.of(context).requestFocus(_focusNodes[index]);
              }
              if (model.inputType == InputTypeEnum.selector) {
                final selected = await showBottomSheetModal(
                  context,
                  selected: model.value?.toString(),
                  listItems:
                      model.inputSource?.map((e) => e.toString()).toList() ??
                      [],
                );
                if (selected != null) {
                  setState(() {
                    model.value = selected;
                  });
                }
              }
              if (model.inputType == InputTypeEnum.date) {
                showDialog<DateTime>(
                  context: context,
                  builder:
                      (context) => BirthdayPickerDialog(
                        initialDate:
                            model.value is DateTime ? model.value : null,
                        onDone: (date) {
                          print(date);
                          setState(() => model.value = date);
                          // Navigator.of(context).pop(date);
                        },
                      ),
                );
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
                    TextField(
                      focusNode: _focusNodes[index],
                      controller: TextEditingController(
                          text: model.value?.toString() ?? "",
                        )
                        ..selection = TextSelection.collapsed(
                          offset: (model.value?.toString() ?? "").length,
                        ),
                      onChanged: (v) => setState(() => model.value = v),
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: _getHint(model.name),
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    )
                  else if (model.inputType == InputTypeEnum.selector)
                    Text(
                      model.value?.toString().isNotEmpty == true
                          ? model.value.toString()
                          : 'Select',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    )
                  else if (model.inputType == InputTypeEnum.date)
                    Text(
                      model.value is DateTime
                          ? _formatDate(model.value)
                          : 'MM/DD/YYYY',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onKeyboardInput(VirtualKeyboardKey key) {
    if (focusedIndex == null) return;
    final model = _inputs[focusedIndex!];
    String value = model.value?.toString() ?? '';
    if (key.keyType == VirtualKeyboardKeyType.String) {
      value += key.text ?? '';
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      if (key.action == VirtualKeyboardKeyAction.Backspace &&
          value.isNotEmpty) {
        value = value.substring(0, value.length - 1);
      }
    }
    setState(() {
      model.value = value;
    });
  }

  String _getHint(String name) {
    switch (name) {
      case "phone":
        return "+1 (000) 000 - 0000";
      case "email":
        return "Type an email address";
      case "address":
        return "Type your address";
      case "name":
        return "Type your name";
      case "shortName":
        return "John";
      case "fullName":
        return "John Doe";
      default:
        return "";
    }
  }

  String _formatDate(DateTime date) {
    return "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year.toString().padLeft(4, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final showKeyboard =
        focusedIndex != null &&
        (_inputs[focusedIndex!].inputType == InputTypeEnum.text ||
            _inputs[focusedIndex!].inputType == InputTypeEnum.number);
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
            mainAxisSize: MainAxisSize.min,
            children: [
              InputPageCloseButton(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < _inputs.length; i++)
                      _buildInputCard(_inputs[i], i),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  top: AppSpacing.xl8,
                  right: AppSpacing.xl3,
                ),
                child: InputPageSaveButton(inputs: _inputs),
              ),
              if (showKeyboard)
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: VirtualKeyboard(
                      fontSize: 16,
                      // height: 250,
                      textColor: Colors.black,
                      defaultLayouts: [VirtualKeyboardDefaultLayouts.English],
                      type:
                          _inputs[focusedIndex!].inputType ==
                                  InputTypeEnum.number
                              ? VirtualKeyboardType.Numeric
                              : VirtualKeyboardType.Alphanumeric,
                      postKeyPress: _onKeyboardInput,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputPageSaveButton extends StatelessWidget {
  final List<InputModel> inputs;
  const InputPageSaveButton({super.key, required this.inputs});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AusaButton(
          size: ButtonSize.lg,
          text: 'Save',
          onPressed: () {
            Get.back(result: inputs);
          },
        ),
      ],
    );
  }
}

class InputPageCloseButton extends StatelessWidget {
  const InputPageCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.xl,
        ),
        child: Align(
          alignment: Alignment.topRight,
          child: SvgPicture.asset(
            AusaIcons.xClose,
            width: DesignScaleManager.scaleValue(40),
            height: DesignScaleManager.scaleValue(40),
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
