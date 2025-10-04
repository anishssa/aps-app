import 'package:flutter/material.dart';

class FloatButtonComponent extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final double size;
  final double elevation;
  final double margin;
  final double padding;

  const FloatButtonComponent({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.size = 30,
    this.elevation = 0,
    this.margin = 0,
    this.padding = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin),
      child: FloatingActionButton(
        onPressed: () => onPressed(),
       backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          size: size,
          color: Colors.yellow,
        ),
      ),
    );
  }
}
