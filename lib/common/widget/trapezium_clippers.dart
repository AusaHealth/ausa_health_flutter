import 'package:ausa/constants/gradients.dart';
import 'package:flutter/material.dart';

class TrapeziumBackground extends StatelessWidget {
  final Widget? child;
  final double curveHeight;
  final double topInset;
  final double horizontalPadding;
  final double verticalPadding;
  const TrapeziumBackground({super.key, this.child, this.curveHeight=36, this.topInset=8, this.horizontalPadding=24, this.verticalPadding=16});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TrapeziumClipper(curveHeight: curveHeight, topInset: topInset),
      child: Container(
        decoration: const BoxDecoration(
          gradient: Gradients.gradient1,
          ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          child: child,
        ),
      ),
    );
  }
}

class TrapeziumClipper extends CustomClipper<Path> {
  final double curveHeight;
  final double topInset;
  TrapeziumClipper({this.curveHeight=36, this.topInset=8});
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(topInset + curveHeight, 0); // start after top-left curve
    path.quadraticBezierTo(topInset, 0, topInset, curveHeight); // top-left corner
    path.lineTo(0, size.height); // bottom-left
    path.lineTo(size.width, size.height); // bottom-right
    path.lineTo(size.width - topInset, curveHeight); // up to top-right curve
    path.quadraticBezierTo(
        size.width - topInset, 0, size.width - topInset - curveHeight, 0); // top-right corner
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TopEntryTrapeziumClipper extends CustomClipper<Path> {
  final double curveHeight;
  final double topInset;
  TopEntryTrapeziumClipper({this.curveHeight = 16.0, this.topInset = 4.0});
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(topInset + curveHeight, size.height); // bottom-left curve start
    path.quadraticBezierTo(topInset, size.height, topInset, size.height - curveHeight); // bottom-left curve
    path.lineTo(0, 0); // top-left
    path.lineTo(size.width, 0); // top-right
    path.lineTo(size.width - topInset, size.height - curveHeight); // down to bottom-right curve
    path.quadraticBezierTo(
        size.width - topInset, size.height, size.width - topInset - curveHeight, size.height); // bottom-right curve
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BottomNipClipper extends CustomClipper<Path> {
  final double nipWidth;
  final double nipHeight;
  BottomNipClipper({this.nipWidth = 20, this.nipHeight = 10});
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - nipHeight);
    path.lineTo(size.width / 2 + nipWidth / 2, size.height - nipHeight);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width / 2 - nipWidth / 2, size.height - nipHeight);
    path.lineTo(0, size.height - nipHeight);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
