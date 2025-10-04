import 'package:flutter/material.dart';

import './GradientText.dart';

class HaveAccountComponent extends StatelessWidget {
  const HaveAccountComponent({
    super.key,
    required this.onPressed,
    required this.text,
    required this.actionText,
    this.color,
  });

  final Function() onPressed;
  final String text;
  final Color? color;
  final String actionText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: color ?? Theme.of(context).colorScheme.primary,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: GradientText(
            actionText,
            style: TextStyle(
              color: color ?? Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

