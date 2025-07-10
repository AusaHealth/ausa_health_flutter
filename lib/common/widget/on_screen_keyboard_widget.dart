import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class OnScreenKeyboardWidget extends StatefulWidget {
  final TextEditingController controller;
  final VirtualKeyboardType type;
  final Color color;
  const OnScreenKeyboardWidget({
    super.key,
    required this.controller,
    required this.type,
    required this.color,
  });

  @override
  State<OnScreenKeyboardWidget> createState() => _OnScreenKeyboardWidgetState();
}

class _OnScreenKeyboardWidgetState extends State<OnScreenKeyboardWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  void didUpdateWidget(covariant OnScreenKeyboardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller = widget.controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: VirtualKeyboard(
        fontSize: 16,
        height: 300,
        textColor: Colors.black,
        textController: _controller,
        defaultLayouts: [VirtualKeyboardDefaultLayouts.English],
        type: widget.type,
        postKeyPress: (key) {
          print(key);
        },
      ),
    );
  }
}
