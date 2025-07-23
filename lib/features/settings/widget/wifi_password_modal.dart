import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class WifiPasswordModal extends StatefulWidget {
  final void Function(String password) onSubmit;
  final VoidCallback onClose;
  final String networkName;
  const WifiPasswordModal({
    super.key,
    required this.onSubmit,
    required this.onClose,
    required this.networkName,
  });

  @override
  State<WifiPasswordModal> createState() => _WifiPasswordModalState();
}

class _WifiPasswordModalState extends State<WifiPasswordModal> {
  final TextEditingController _controller = TextEditingController();
  bool _obscure = true;
  final FocusNode _focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final bool hasText = _controller.text.isNotEmpty;
    final double borderRadius = 48;
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        _focus.addListener(() {
          if (_focus.hasFocus) {
            isKeyboardVisible = true;
          } else {
            isKeyboardVisible = false;
          }
        });
        return Stack(
          children: [
            // Blurred blue background
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    color: const Color(0xFF19346A).withOpacity(0.92),
                  ),
                ),
              ),
            ),
            Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 36),
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.wifi,
                                color: Colors.white,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.networkName,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Enter password',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(48),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    focusNode: _focus,
                                    controller: _controller,
                                    obscureText: _obscure,
                                    autofocus: true,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: const Color(0xFF091227),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Type...',
                                      hintStyle: TextStyle(
                                        color: const Color(0xFF717680),
                                        fontSize: 20,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 0,
                                      ),
                                    ),
                                    onChanged: (_) => setState(() {}),
                                  ),
                                ),
                                if (hasText)
                                  IconButton(
                                    icon: Icon(
                                      _obscure
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: const Color(0xFF717680),
                                    ),
                                    onPressed:
                                        () => setState(
                                          () => _obscure = !_obscure,
                                        ),
                                  ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    hasText
                                        ? const Color(0xFF00267E)
                                        : const Color(0xFFB3C6E0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    borderRadius,
                                  ),
                                ),
                                elevation: 0,
                                padding: EdgeInsets.zero,
                              ),
                              onPressed:
                                  hasText
                                      ? () => widget.onSubmit(_controller.text)
                                      : null,
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Close button
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: widget.onClose,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
