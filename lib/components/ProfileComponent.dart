import 'package:flutter/material.dart';

class ProfileDetail extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  final int? maxLines;

  const ProfileDetail({
    required this.label,
    this.value,
    required this.icon, this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      margin: const EdgeInsets.only(left: 30),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                Text(
                  value ?? 'N/A',
                  // style: Theme.of(context).textTheme.bodyText1,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
