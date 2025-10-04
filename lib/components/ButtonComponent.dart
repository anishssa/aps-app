import 'package:flutter/material.dart';

class ButtonComponent extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color textColor;
  final double width;
  final double height;
  final double fontSize;
  final double borderRadius;
  final double elevation;
  final double margin;
  final double padding;

  const ButtonComponent({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.height = 50,
    this.fontSize = 16,
    this.borderRadius = 20,
    this.elevation = 0,
    this.margin = 0,
    this.padding = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F1B2A), Color(0xFFD50009)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(width, height),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: elevation,
          padding: EdgeInsets.all(padding),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: fontSize),
        ),
      ),
    );
  }
}
