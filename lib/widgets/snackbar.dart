import 'package:flutter/material.dart';
import 'package:googleapis/cloudbuild/v1.dart';

SnackBar createSnackbar(
  BuildContext context,
  String title,
  bool hasError,
) {
  SnackBar snackBar = SnackBar(
    content: Row(
      children: <Widget>[
        hasError
            ? Icon(
                Icons.error_rounded,
                color: Colors.red,
              )
            : Icon(
                Icons.check_circle_outline_outlined,
                color: Colors.green,
              ),
        Flexible(child: Text(title)),
      ],
    ),
    action: SnackBarAction(
      label: 'Dissmiss',
      textColor: Colors.grey,
      onPressed: () {
        try {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        } catch (e) {}
      },
    ),
  );
  return snackBar;
}
