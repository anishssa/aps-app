import 'package:flutter/material.dart';

class DropDownComponent extends StatelessWidget {
  const DropDownComponent({
    super.key,
    required this.data,
    required this.label,
    this.prefixIcon,
    this.loading = false,
    this.hintText,
    this.value,
    this.onChanged,
    this.validator,
  });

  final List<dynamic> data;
  final String label;
  final String? value;
  final IconData? prefixIcon;
  final String? hintText;
  final bool loading;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField(
            itemHeight: null,
            isExpanded: true,
            validator: validator,
            decoration: InputDecoration(
              labelText: label,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              hintText: hintText,
              suffixIcon: loading
                  ? IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: null)
                  : null,
              prefixIcon: prefixIcon != null
                  ? IconButton(
                  icon: Icon(prefixIcon,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: null)
                  : null,
            ),
            value: value != null && data.any((d) => d['id'].toString() == value)
                ? value
                : null,
            items: data.map((d) {
              return DropdownMenuItem(
                value: d['id'].toString(),
                child: Text(d['name'] ?? ''),
              );
            }).toList(),
            onChanged: onChanged,
            onSaved: onChanged,
          ),
        ],
      ),
    );
  }
}

