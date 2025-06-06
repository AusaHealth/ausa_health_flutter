import 'package:flutter/material.dart';

class BaseStatefulPage extends StatefulWidget {
  const BaseStatefulPage({super.key});

  @override
  State<BaseStatefulPage> createState() => _BaseStatefulPageState();
}

class _BaseStatefulPageState extends State<BaseStatefulPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}