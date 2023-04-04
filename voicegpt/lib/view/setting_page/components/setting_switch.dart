import 'package:flutter/material.dart';

class SettingSwitch extends StatefulWidget {
  const SettingSwitch({super.key, required this.initValue, required this.onChanged, required this.label});
  final bool initValue;
  final Function(bool) onChanged;
  final String label;

  @override
  State<SettingSwitch> createState() => _SettingSwitchState();
}

class _SettingSwitchState extends State<SettingSwitch> {
  late bool _value;

  @override
  void initState() {
    _value = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      value: _value,
      onChanged: (v) {
        widget.onChanged(v);
        setState(() {
          _value = v;
        });
      },
      title: Text(
        widget.label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}