import 'dart:async';

import 'package:flutter/material.dart';

class AutoHideContainer extends StatefulWidget {
  final Widget child;
  const AutoHideContainer({super.key, required this.child});

  @override
  AutoHideContainerState createState() => AutoHideContainerState();
}

class AutoHideContainerState extends State<AutoHideContainer> {
  bool _visible = true;
  Timer? _hideTimer;
  bool _autoHidePaused = false;

  void _startHideTimer() {
    _hideTimer?.cancel();
    if (_autoHidePaused) return;

    _hideTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _visible = false;
        });
      }
    });
  }

  void _showBar() {
    if (!_visible) {
      setState(() {
        _visible = true;
      });
    }
    _startHideTimer();
  }

  void pauseAutoHide() {
    _hideTimer?.cancel();
    _autoHidePaused = true;
  }

  void resumeAutoHide() {
    _autoHidePaused = false;
    _startHideTimer();
  }

  @override
  void initState() {
    super.initState();
    _startHideTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.pointerRouter.addGlobalRoute(_handlePointerEvent);
    });
  }

  void _handlePointerEvent(PointerEvent event) {
    if (event is PointerDownEvent) {
      _showBar();
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    WidgetsBinding.instance.pointerRouter.removeGlobalRoute(_handlePointerEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _visible ? Offset.zero : const Offset(0, 0.8),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: widget.child,
      ),
    );
  }

  // External controls
  void showBar() => _showBar();
  void pause() => pauseAutoHide();
  void resume() => resumeAutoHide();
}
