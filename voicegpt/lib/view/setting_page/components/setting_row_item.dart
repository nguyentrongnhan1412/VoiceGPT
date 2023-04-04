import 'package:flutter/material.dart';

class SettingRowItem extends StatelessWidget {
  const SettingRowItem({super.key, required this.label, required this.item});

  final String label;
  final Widget item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 17),
            )),
        const SizedBox(width: 8),
        item
      ],
    );
  }
}