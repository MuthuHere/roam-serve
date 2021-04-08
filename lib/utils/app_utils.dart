
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showFailureToast(message, {String title, Duration duration}) {
  Get.snackbar(title, message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      borderRadius: 0,
      duration: duration ?? Duration(seconds: 3),
      margin: EdgeInsets.all(0.0),
      padding: EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15));
}

showSuccessToast(message, {String title, Duration duration}) {
  Get.snackbar(title, message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: 0,
      duration: duration ?? Duration(seconds: 3),
      margin: EdgeInsets.all(0.0),
      padding: EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15));
}
