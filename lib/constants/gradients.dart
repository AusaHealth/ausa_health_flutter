import 'dart:math';

import 'package:flutter/material.dart';

class Gradients {
  static const gradient1 = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
      Color(0xFFE5E4E7),
      Color(0xFFF6F7F8),
    ],
  );
  static const gradient2 = LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.bottomLeft,
            stops: [0.0, 0.5],
            transform: GradientRotation(7*pi/4),
            colors: [
      Color.fromARGB(150, 165, 199, 255),
      Color(0xFFFFFFFF),
    ],
  );
}
