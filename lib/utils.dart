import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orbit/colors.dart';

toastMessage(String m) {
  Fluttertoast.showToast(
      msg: m,
      timeInSecForIosWeb: 1,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.primaryColor,
      textColor: Colors.white,
      fontSize: 16.0);
}
void showSnackbar(
    BuildContext context,
    String message, {
      Color backgroundColor = Colors.black87, // Default color
      Duration duration = const Duration(seconds: 3),
    }) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
    backgroundColor: backgroundColor,
    duration: duration,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  // Show the Snackbar using the ScaffoldMessenger
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
