import 'package:voicegpt/data/constant.dart';
import 'package:voicegpt/view/setting_page/components/setting_row_item.dart';
import 'package:flutter/material.dart';

class SettingDropdown<T> extends StatefulWidget {
  const SettingDropdown({super.key, required this.label, required this.list, required this.value, required this.onChanged, required this.textDropdown});
  final String label;
  final List<T> list;
  final T value;
  final void Function(T?) onChanged;
  final String Function(T model) textDropdown;

  @override
  State<SettingDropdown<T>> createState() => _SettingDropdownState<T>();
}

class _SettingDropdownState<T> extends State<SettingDropdown<T>> {
  late T _currentValue;

  @override
  void initState() {
    _currentValue = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SettingRowItem(
        label: widget.label,
        item: DropdownButton<T>(
          items: widget.list.map<DropdownMenuItem<T>>((T value) {
            String strCallBack = widget.textDropdown(value);
            bool isSelect = value == _currentValue;
            return DropdownMenuItem<T>(
              value: value,
              child: Text(strCallBack,
                  style: TextStyle(
                      color: isSelect
                          ? Colors.white
                          : const Color.fromARGB(255, 216, 202, 202),
                      fontWeight: isSelect ? FontWeight.bold : null,
                      fontSize: isSelect ? 17 : 16)),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) {
              setState(() {
                _currentValue = v;
              });
            }
            widget.onChanged(v);
          },
          dropdownColor: scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          alignment: Alignment.centerRight,
          elevation: 3,
          icon: const Icon(Icons.arrow_drop_down),
          value: _currentValue,
        ));
  }
}