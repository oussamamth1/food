import 'package:intl/intl.dart';

class Validations {
  String? validateName(String value) {
    if (value.isEmpty) return "Name is required.";
    final RegExp nameExp = RegExp(r'^[A-za-z ]+$');
    if (!nameExp.hasMatch(value)) {
      return "Please enter only alphabetical characters.";
    }
    return null;
  }

  String? validateEmail(String value) {
    if (value.isEmpty) return "Email is required.";
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp nameExp = RegExp(pattern);
    if (!nameExp.hasMatch(value)) return "Invalid email address";
    return null;
  }

  String? validateDate(DateTime value) {
    if (value.toString().isEmpty) return "Field is required.";
    return null;
  }

  String? validateText(String value) {
    if (value.isEmpty) return "Field is required.";
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return "Please choose a password.";
    if (value.length < 6) {
      return "The password must be 6 characters long or more.";
    }
    return null;
  }

  String? validatePhone(String value) {
    if (value.isEmpty) return "Phone is required.";
    if (value.isEmpty == false) {
      final RegExp nameExp = RegExp(r'^[0-9]+$');
      if (!nameExp.hasMatch(value)) {
        return "Please enter only numeric characters.";
      }
      return null;
    }
    return null;
  }

  String? validateNumber(String value) {
    if (value.isEmpty) return "Field is required.";
    if (value.isEmpty == false) {
      final RegExp nameExp = RegExp(r'^[0-9]+$');
      if (!nameExp.hasMatch(value)) {
        return "Please enter only numeric characters.";
      }
      return null;
    }
    return null;
  }

  String? validateURL(String value) {
    if (value.isEmpty) return "Field is required.";
    String pattern =
        r"^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)";
    final RegExp nameExp = RegExp(pattern);
    if (!nameExp.hasMatch(value)) return "Invalid URL";
    return null;
  }

  DateTime convertDateTimeToDate(DateTime date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date.toString());
    final String formatted = serverFormater.format(displayDate);
    return DateTime.parse(formatted);
  }
}

Validations validations = Validations();