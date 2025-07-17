import 'package:ausa/constants/color.dart';
import 'package:flutter/material.dart';

class ScrollWidget extends StatefulWidget {
  final Widget child;
  const ScrollWidget({super.key, required this.child});

  @override
  State<ScrollWidget> createState() => _ScrollWidgetState();
}

class _ScrollWidgetState extends State<ScrollWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.primary300),
        trackColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        thickness: 4,
        radius: const Radius.circular(8),
        trackVisibility: false,
        interactive: true,
        scrollbarOrientation: ScrollbarOrientation.right,
        child: widget.child,
      ),
    );
  }
}
