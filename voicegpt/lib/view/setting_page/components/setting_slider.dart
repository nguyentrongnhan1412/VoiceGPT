import 'package:voicegpt/view/setting_page/components/setting_row_item.dart';
import 'package:flutter/material.dart';

class SettingSlider extends StatefulWidget {
  const SettingSlider({super.key, required this.value, required this.onchanged, required this.label,
  });

  final double value;
  final Function(double value) onchanged;
  final String label;

  @override
  State<SettingSlider> createState() => _SettingSliderState();
}

class _SettingSliderState extends State<SettingSlider> {
  late double _currentValue;

  @override
  void initState() {
    _currentValue = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SettingRowItem(
      label: widget.label,
      item: Slider(
        value: _currentValue,
        onChanged: (newValue) {
          widget.onchanged(newValue);
          setState(() {
            _currentValue = newValue;
          });
        },
        min: 0,
        max: 1.0,
        divisions: 10,
        label: (_currentValue * 10).toString(),
        activeColor: Colors.red,
      ),
    );
  }
}