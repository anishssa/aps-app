import 'package:flutter/material.dart';

class InputComponent extends StatelessWidget {
  const InputComponent({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.validator,
    this.onChanged,
    this.onTap,
    this.suffixIcon,
    this.suffixIconPressed,
    this.prefixIcon,
    this.prefixIconPressed,
    this.focusNode,
    this.onEditingComplete,
    this.onSaved,
    this.initialValue,
    this.readOnly = false,
    this.textAlign,
    this.textDirection,
    this.autofocus = false,
    this.enabled = true,
    this.minLines,
    this.maxLines,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function()? onTap;
  final IconData? suffixIcon;
  final Function()? suffixIconPressed;
  final IconData? prefixIcon;
  final Function()? prefixIconPressed;

  final FocusNode? focusNode;
  final Function()? onEditingComplete;
  final Function(String?)? onSaved;
  final String? initialValue;
  final bool readOnly;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool autofocus;
  final bool enabled;

  final int? minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            labelText: label,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintText: hintText,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(suffixIcon, color: Theme.of(context).colorScheme.primary,),
                    onPressed: suffixIconPressed)
                : null,
            prefixIcon: prefixIcon != null
                ? IconButton(
                    icon: Icon(prefixIcon, color: Theme.of(context).colorScheme.primary),
                    onPressed: prefixIconPressed)
                : null,
          ),
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          onSaved: onSaved,
          initialValue: initialValue,
          readOnly: readOnly,
          textCapitalization: TextCapitalization.none,
          textDirection: textDirection,
          autofocus: autofocus,
          enabled: enabled,
          minLines: minLines ?? 1,
          maxLines: maxLines ?? 1,
          keyboardType: maxLines != null
              ? TextInputType.multiline
              : keyboardType ?? TextInputType.text,
        ),
      ],
    );
  }
}
