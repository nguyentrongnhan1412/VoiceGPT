import 'package:voicegpt/view/resources/widget/text_widget.dart';
import 'package:flutter/material.dart';

class SnackBarError extends SnackBar{
  SnackBarError({super.key, required String content}) : super(content: TextWidget(label: content), backgroundColor: Colors.red);
}