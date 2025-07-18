import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';

enum CustomKeyboardType { numeric, alphanumeric }

class CustomKeyboard extends StatefulWidget {
  final CustomKeyboardType keyboardType;
  final Function(String) onKeyPressed;
  final VoidCallback? onEnterPressed;
  final VoidCallback? onBackspacePressed;
  final double? fontSize;
  final Color? keyColor;
  final Color? enterColor;
  final Color? textColor;
  final String? enterText;
  final double height;
  final bool initialNumericVisible;

  CustomKeyboard({
    super.key,
    required this.keyboardType,
    required this.onKeyPressed,
    this.onEnterPressed,
    this.onBackspacePressed,
    this.fontSize = 20.0,
    this.keyColor = Colors.white,
    this.enterColor = Colors.blue,
    this.textColor = Colors.black,
    this.enterText = "Submit",
    this.height = 300,
    this.initialNumericVisible = false,
  });

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  late List<List<String>> _keyLayout;
  late List<List<String>> _specialCharLayout;
  bool isCapitalized = false;
  late bool isNumericVisible;

  @override
  void initState() {
    super.initState();
    isNumericVisible = widget.initialNumericVisible;
    _initializeKeyLayout();
    _initializeSpecialCharLayout();
  }

  void _initializeSpecialCharLayout() {
    _specialCharLayout = [
      ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '_', '+'],
      ['!', '@', '#', '\$', '%', '^', '&', '*', '(', ')', '-', '=', '\\'],
      ['[', ']', '{', '}', '|', '~', '`', '<', '>', ':', ';'],
      ['/', '?', '"', '\'', ',', '.', '≈', '≠', '±', '÷', '×'],
    ];
  }

  void _initializeKeyLayout() {
    if (widget.keyboardType == CustomKeyboardType.numeric) {
      _keyLayout = [
        ['1', '2', '3'],
        ['4', '5', '6'],
        ['7', '8', '9'],
        ['+', '0', '*'],
      ];
    } else {
      _keyLayout = [
        ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '='],
        ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '[', ']', '\\'],
        ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':', ';'],
        ['Z', 'X', 'C', 'V', 'B', 'N', 'M', '<', '>', '?', '/'],
      ];
    }
  }

  String _getDisplayKey(String key) {
    if (!isCapitalized) {
      return key.toLowerCase();
    }
    return key;
  }

  Widget _buildKey(String key, [int flex = 1]) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: widget.keyColor,
          elevation: 2,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () => widget.onKeyPressed(_getDisplayKey(key)),
            borderRadius: BorderRadius.circular(8),
            child: Center(
              child: Text(
                _getDisplayKey(key),
                style: AppTypography.callout(
                  color: widget.textColor,
                  weight: AppTypographyWeight.medium,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialKey(
    String text,
    VoidCallback onTap, [
    double flex = 1.5,
  ]) {
    // Check if this is the caps lock button and apply special styling
    final bool isCapsLock = text.toLowerCase() == 'caps lock';
    final bool shouldHighlight = isCapsLock && isCapitalized;

    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: shouldHighlight ? AppColors.primary500 : Colors.grey[300],
          elevation: 2,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: widget.fontSize! * 0.8,
                  color: shouldHighlight ? Colors.white : widget.textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.keyboardType == CustomKeyboardType.numeric) {
      return Container(
        height: widget.height,
        color: Colors.grey[200],
        child: Column(
          children: [
            ..._keyLayout.map(
              (row) => Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: DesignScaleManager.scaleValue(540),
                    ), // For centering
                    ...row
                        .map(
                          (key) => Expanded(
                            child: Container(
                              margin: EdgeInsets.all(8),
                              child: Material(
                                color: widget.keyColor,
                                elevation: 2,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.xl3,
                                ),
                                child: InkWell(
                                  onTap: () => widget.onKeyPressed(key),
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.xl3,
                                  ),
                                  child: Center(
                                    child: Text(
                                      key,
                                      style: AppTypography.callout(
                                        color: widget.textColor,
                                        weight: AppTypographyWeight.medium,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    SizedBox(
                      width: DesignScaleManager.scaleValue(540),
                    ), // For centering
                  ],
                ),
              ),
            ),
            // Bottom row with backspace and enter
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: DesignScaleManager.scaleValue(540)), // For
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Material(
                        color: widget.keyColor,
                        elevation: 2,
                        borderRadius: BorderRadius.circular(AppRadius.xl3),
                        child: InkWell(
                          onTap: widget.onBackspacePressed,
                          borderRadius: BorderRadius.circular(AppRadius.xl3),
                          child: Center(
                            child: Icon(
                              Icons.backspace_outlined,
                              color: widget.textColor,
                              size: widget.fontSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Material(
                        color: widget.enterColor,
                        elevation: 2,
                        borderRadius: BorderRadius.circular(AppRadius.xl3),
                        child: InkWell(
                          onTap: widget.onEnterPressed,
                          borderRadius: BorderRadius.circular(AppRadius.xl3),
                          child: Center(
                            child: Text(
                              widget.enterText!,
                              style: AppTypography.callout(
                                color: Colors.white,
                                weight: AppTypographyWeight.medium,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: DesignScaleManager.scaleValue(540)), // For
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Return existing alphanumeric keyboard layout
    final currentLayout = isNumericVisible ? _specialCharLayout : _keyLayout;
    return Container(
      height: widget.height,
      color: Colors.grey[200],
      child: Column(
        children: [
          // First row with numbers
          Expanded(
            child: Row(
              children: [
                _buildSpecialKey('tab', () {}, 1.5),
                ...currentLayout[0].map((key) => _buildKey(key)),
                _buildSpecialKey(
                  'delete',
                  widget.onBackspacePressed ?? () {},
                  1.5,
                ),
              ],
            ),
          ),
          // Second row
          Expanded(
            child: Row(
              children: [
                _buildSpecialKey('caps lock', () {
                  setState(() {
                    isCapitalized = !isCapitalized;
                  });
                }, 2),
                ...currentLayout[1].map((key) => _buildKey(key)),
              ],
            ),
          ),
          // Third row
          Expanded(
            child: Row(
              children: [
                _buildSpecialKey('shift', () {
                  setState(() {
                    isCapitalized = !isCapitalized;
                  });
                }, 2),
                ...currentLayout[2].map((key) => _buildKey(key)),
                _buildSpecialKey(widget.enterText!, () {
                  widget.onEnterPressed?.call();
                }, 2),
              ],
            ),
          ),
          // Fourth row
          Expanded(
            child: Row(
              children: [
                _buildSpecialKey('shift', () {
                  setState(() {
                    isCapitalized = !isCapitalized;
                  });
                }, 2),
                ...currentLayout[3].map((key) => _buildKey(key)),
                _buildSpecialKey('shift', () {
                  setState(() {
                    isCapitalized = !isCapitalized;
                  });
                }, 2),
              ],
            ),
          ),
          // Bottom row with space
          Expanded(
            child: Row(
              children: [
                _buildSpecialKey('.?123', () {
                  setState(() {
                    isNumericVisible = !isNumericVisible;
                  });
                }, 1.5),
                _buildSpecialKey('😊', () {}, 1),
                _buildKey(' ', 6), // Space bar
                _buildSpecialKey(isNumericVisible ? 'ABC' : '.?123', () {
                  setState(() {
                    isNumericVisible = !isNumericVisible;
                  });
                }, 1.5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
