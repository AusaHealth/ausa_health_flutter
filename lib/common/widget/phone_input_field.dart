import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneInputField extends StatelessWidget {
  final String countryCode;
  final TextEditingController controller;
  final String? errorText;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;

  const PhoneInputField({
    Key? key,
    this.countryCode = '+1',
    required this.controller,
    this.errorText,
    this.onChanged,
    this.focusNode,
  }) : super(key: key);

  String _formatNumber(String input) {
    // Remove all non-digit characters
    final digits = input.replaceAll(RegExp(r'\D'), '');
    String formatted = '';
    if (digits.length >= 1) {
      formatted += '(';
      formatted += digits.substring(0, digits.length >= 3 ? 3 : digits.length);
    }
    if (digits.length >= 4) {
      formatted += ')';
      formatted += '-';
      formatted += digits.substring(3, digits.length >= 6 ? 6 : digits.length);
    }
    if (digits.length >= 7) {
      formatted += ' ';
      formatted += digits.substring(
        6,
        digits.length >= 10 ? 10 : digits.length,
      );
    }
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(40),
        // boxShadow: [
        //   BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        // ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Row(
        children: [
          Text(
            countryCode,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              style: TextStyle(
                fontSize: 24,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '(000)-000 0000',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
                isCollapsed: true,
                errorText: errorText,
              ),
              onChanged: (value) {
                // Optionally format as user types
                if (onChanged != null) onChanged!(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
