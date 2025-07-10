import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool multiline;
  final bool isValid;
  final bool isFocused;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final double? height;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.multiline = false,
    this.isValid = false,
    this.isFocused = false,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        errorText != null
            ? Colors.deepOrange
            : isFocused
            ? Colors.deepOrange
            : Colors.transparent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null && label!.isNotEmpty)
          Text(
            label ?? '',

            style: AppTypography.body(
              color: errorText != null ? Colors.deepOrange : Colors.white,
            ).copyWith(
              decoration:
                  errorText == null && isFocused
                      ? TextDecoration.underline
                      : null,
              decorationColor: Colors.deepPurple,
              decorationThickness: 2,
            ),
          ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            // Ensure focus and keyboard show when tapping anywhere on the field
            if (focusNode != null) {
              focusNode!.requestFocus();
            }
            // Move cursor to end of text
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length),
            );
          },
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7FA),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor, width: 2),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: keyboardType,
              maxLines: multiline ? null : 1,
              minLines: multiline ? 4 : 1,
              style: const TextStyle(color: Colors.black, fontSize: 18),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: onChanged,
              onSubmitted: onFieldSubmitted,
              onTap: () {
                // Ensure keyboard shows when tapped
                if (focusNode != null) {
                  focusNode!.requestFocus();
                }
                // Move cursor to end of text
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length),
                );
              },
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.deepOrange, fontSize: 14),
            ),
          ),
      ],
    );
  }
}
