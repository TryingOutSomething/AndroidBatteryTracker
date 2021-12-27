import 'package:flutter/material.dart';

class ErrorAlert extends StatelessWidget {
  final String error;

  const ErrorAlert({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('An Error Occurred'),
      content: Text(error),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ok'))
      ],
    );
  }
}
