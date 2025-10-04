import 'package:flutter/material.dart';

Widget buildNavIcon(IconData icon) {
  return ShaderMask(
    shaderCallback: (Rect bounds) {
      return const LinearGradient(
        colors: <Color>[Color(0xFF0F1B2A), Color(0xFFD50009)],
      ).createShader(bounds);
    },
    child: Icon(
      icon,
      color: Colors.white,
      size: 24,
    ),
  );
}

