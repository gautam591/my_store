import 'package:flutter/material.dart';

class Alerts {
  static BuildContext? _context;

  static void setContext(BuildContext context) {
    _context = context;
  }

  static void showGeneral(String message, {int duration = 4}) {
    _showSnackBar(message, duration);
  }

  static void showSuccess(String message, {int duration = 4}) {
    _showSnackBar(message, duration, Colors.green);
  }

  static void showError(String message, {int duration = 4}) {
    _showSnackBar(message, duration, Colors.red);
  }

  static void showWarning(String message, {int duration = 4}) {
    _showSnackBar(message, duration, Colors.orange);
  }

  static void _showSnackBar(String message, int duration, [Color? color]) {
    if (_context == null) {
      print('Context is not set. Call setContext(BuildContext context) first.');
      return;
    }

    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      duration: Duration(seconds: duration),
      action: duration > 0
          ?  SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          // Do something when the user presses OK, if needed.
        },
      )
          : null,
    );

    ScaffoldMessenger.of(_context!).showSnackBar(snackBar);
  }
}
