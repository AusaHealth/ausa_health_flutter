import 'package:ausa/common/widget/custom_header.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final Color backgroundColor;

  final Widget body;

  const BaseScaffold({
    super.key,

    this.backgroundColor = AppColors.gray50,

    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          CustomHeader(),
          SizedBox(height: AppSpacing.xl2),
          Expanded(child: body),
        ],
      ),
    );
  }
}
