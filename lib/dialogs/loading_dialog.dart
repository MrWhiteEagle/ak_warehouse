import 'package:flutter/material.dart';

class LoadingDialog {
  static Future<void> show(context, List<Future<void>> functions) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text('Zapis...'),
            content: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
    );
    try {
      await Future.wait(functions);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      hide(context);
    }
  }

  static void hide(context) {
    Navigator.pop(context);
  }
}
