import 'package:flutter/material.dart';
import 'package:get/get.dart';

showErrorToast(String message, {Color color = Colors.red}) {
  if (message.isNotEmpty)
    Get.snackbar('OneView', message,
        backgroundColor: color, colorText: Colors.white);
}

showSuccessToast(String message, {Color color = Colors.green}) {
  if (message.isNotEmpty)
    Get.snackbar('OneView', message,
        backgroundColor: color, colorText: Colors.white);
}

void log(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}