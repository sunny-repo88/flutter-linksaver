import 'package:flutter/material.dart';
import 'package:link_saver/helpers/restart_app_management.dart';

showRestartDialog(BuildContext context) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(
            margin: EdgeInsets.only(left: 15, right: 8),
            child: Text('Restarting the app ...')),
      ],
    ),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
