import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showNotification({
  required BuildContext context,
  required String text,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {},
      ),
    ),
  );
}

void showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String cancel,
  required Text submit,
  required Function onPressed,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        actions: <Widget>[
          TextButton(
            child: Text(
              cancel,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: submit,
            onPressed: () {
              Navigator.pop(context);
              onPressed();
            },
          ),
        ],
      );
    },
  );
}
