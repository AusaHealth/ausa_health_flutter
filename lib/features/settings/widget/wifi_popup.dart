import 'package:flutter/material.dart';

enum WifiPopupType { connecting, connected, wrongPassword }

class WifiPopup extends StatelessWidget {
  final WifiPopupType type;
  final VoidCallback? onClose;
  const WifiPopup({super.key, required this.type, this.onClose});

  @override
  Widget build(BuildContext context) {
    String message;
    Color bgColor;
    IconData icon;
    Color iconColor;
    switch (type) {
      case WifiPopupType.connecting:
        message = 'Connecting...';
        bgColor = const Color(0xFFFFF7E0);
        icon = Icons.wifi;
        iconColor = const Color(0xFFFFC107);
        break;
      case WifiPopupType.connected:
        message = 'Connected!';
        bgColor = const Color(0xFFE6F9E6);
        icon = Icons.check_circle;
        iconColor = const Color(0xFF4CAF50);
        break;
      case WifiPopupType.wrongPassword:
        message = 'Wrong password';
        bgColor = const Color(0xFFFFE6E6);
        icon = Icons.error;
        iconColor = const Color(0xFFFF5252);
        break;
    }
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: 32),
              const SizedBox(width: 16),
              Text(
                message,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
              if (type == WifiPopupType.wrongPassword && onClose != null) ...[
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black54),
                  onPressed: onClose,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
} 