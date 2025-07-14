import 'package:ausa/common/widget/app_sub_parent_container.dart';
import 'package:ausa/constants/app_images.dart';
import 'package:flutter/material.dart';

class AusaConnect extends StatelessWidget {
  const AusaConnect({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Image.asset(AppImages.ausaConnect));
  }
}
