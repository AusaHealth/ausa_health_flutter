import 'package:ausa/common/widget/custom_header.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final Color backgroundColor;

  /// Main content of the screen (placed **above** [background]).
  final Widget body;

  /// Optional widget that will be rendered underneath the entire scaffold
  /// (including header) – useful for full-screen AR previews.
  /// If `null`, a simple coloured background is used instead.
  final Widget? background;

  const BaseScaffold({
    super.key,

    this.backgroundColor = AppColors.gray50,

    this.background,

    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    // If a full-screen background is provided, we need to layer the UI using a
    // [Stack] so that [background] sits underneath the header/body column.
    final Widget scaffoldBody = Stack(
      children: [
        if (background != null) Positioned.fill(child: background!),
        Column(children: [CustomHeader(), Expanded(child: body)]),
      ],
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      // When a background widget is set, we want the scaffold itself to be
      // transparent so the background can be seen. Otherwise, default colour.
      body: scaffoldBody,
    );
  }
}
