import 'package:ausa/common/widget/snackbar.dart';
import 'package:flutter/material.dart';

class CustomSnackbarController {
  static final CustomSnackbarController _instance = CustomSnackbarController._internal();
  factory CustomSnackbarController() => _instance;
  CustomSnackbarController._internal();

  OverlayEntry? _entry;
  AnimationController? _animationController;

  bool get isShown => _entry != null;

  void show({
    required BuildContext context,
    required Widget leading,
    required Widget body,
    Color backgroundColor = Colors.blueAccent,
    bool keepShown = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (_entry != null) return; // prevent duplicate

    final overlay = Overlay.of(context);

    final tickerProvider = Navigator.of(context);
    _animationController = AnimationController(
      vsync: tickerProvider,
      duration: const Duration(milliseconds: 500),
    );

    final animation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController!, curve: Curves.easeOutBack));

    _entry = OverlayEntry(
      builder: (_) => Positioned(
        top: 40,
        left: 20,
        right: 20,
        child: SlideTransition(
          position: animation,
          child: Material(
            color: Colors.transparent,
            child: CustomSnackbar(
              leading: leading,
              body: body,
              backgroundColor: backgroundColor,
            ),
          ),
        ),
      ),
    );

    overlay.insert(_entry!);
    _animationController!.forward();

    if (!keepShown) {
      Future.delayed(duration + const Duration(milliseconds: 500), () => dismiss());
    }
  }

  Future<void> dismiss() async {
    if (_animationController == null || _entry == null) return;

    await _animationController!.reverse();
    _entry!.remove();
    _entry = null;
    _animationController!.dispose();
    _animationController = null;
  }
}
