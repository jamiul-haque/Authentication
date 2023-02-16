import 'package:flutter/material.dart';

void openSnackbar(context, snackMessage) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    action: SnackBarAction(label: "OK", onPressed: () {}),
    content: Text(
      snackMessage,
      style: const TextStyle(fontSize: 14),
    ),
  ));
}
