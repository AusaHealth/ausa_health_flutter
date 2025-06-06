import 'package:ausa/common/widget/base_scaffold.dart';
import 'package:flutter/material.dart';

class BaseStatelessPage extends StatelessWidget {
  final Widget? body;
  final Color backgroundColor;
  final PreferredSizeWidget? appBar;
  const BaseStatelessPage({super.key, this.body, this.backgroundColor = Colors.white, this.appBar});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: body,
      backgroundColor: backgroundColor,
      appBar: appBar,
    );
  }
}
