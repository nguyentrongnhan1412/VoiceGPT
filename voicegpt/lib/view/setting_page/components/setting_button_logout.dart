import 'package:flutter/material.dart';

class SettingButton extends StatelessWidget {
  const SettingButton({super.key, required this.onPressed, required this.text, this.color = Colors.blueAccent});
  final VoidCallback onPressed;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Colors.black)),
      color: color,
      child: Text(
        text,
        style:
        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}