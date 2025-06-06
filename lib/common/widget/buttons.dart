import 'package:flutter/material.dart';

class AusaButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  final double? borderRadius;
  final double? padding;
  final double? margin;
  final double? width;
  final double? height;
  final FontWeight? fontWeight;
  final double? borderWidth;
  final Color? borderColor;

  const AusaButton({super.key, required this.text, required this.onPressed, this.color = Colors.blueAccent, this.textColor = Colors.white, this.fontSize = 12, this.borderRadius = 32, this.padding = 8, this.margin = 0, this.width = 120, this.height = 48, this.fontWeight = FontWeight.normal, this.borderWidth = 0, this.borderColor = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.all(margin ?? 0),
        padding: EdgeInsets.all(padding ?? 0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
          border: Border.all(color: borderColor ?? Colors.transparent, width: borderWidth ?? 0),
        ),
        child: Center(child: Text(text, style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: fontWeight),)),
      ),
    );
  }
}
