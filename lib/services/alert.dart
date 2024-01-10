import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:fitfood/style.dart';

class Alert {
  void showInSnackBar(
      {required GlobalKey<ScaffoldState> scaffoldKey,
      required String message,
      String? type,
      String? title}) {
    var mainColor = mainColor5;
    var textColor = Colors.white;
    if (type == 'danger') {
      mainColor = Colors.red.shade100;
      textColor = Colors.black;
    } else if (type == 'success') {
      mainColor = Colors.green;
    } else if (type == 'warning') {
      mainColor = colorDarkOrange;
    }
    Flushbar(
      backgroundColor: mainColor,
      title: title ?? 'FitFood',
      titleColor: textColor,
      message: message,
      messageColor: textColor,
      icon: const Icon(
        Icons.info_outline,
        size: 30,
        color: Colors.red,
      ),
      duration: const Duration(seconds: 3),
      leftBarIndicatorColor: mainColor,
    ).show(scaffoldKey.currentContext!);
  }
}
