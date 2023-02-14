import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:link_saver/backup_restore/googledriveappdata.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:link_saver/helpers/restart_app_management.dart';
import 'package:link_saver/main.dart';
import 'package:link_saver/theme/theme.dart';
import 'package:link_saver/widgets/snackbar.dart';
import 'package:sqflite_links/sqflite_links.dart';
import 'package:path_provider/path_provider.dart';

class BackUpRestore extends StatefulWidget {
  const BackUpRestore({super.key});

  @override
  State<BackUpRestore> createState() => _BackUpRestoreState();

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const BackUpRestore(),
    );
  }
}

class _BackUpRestoreState extends State<BackUpRestore> {
  final GoogleDriveAppData _googleDriveAppData = GoogleDriveAppData();
  GoogleSignInAccount? _googleUser;
  drive.DriveApi? _driveApi;
  drive.File? appFile;
  late GoogleSignInAccount? user = _googleUser;
  late String lastBackupDate = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      login(init: true);
    });
  }

  void login({bool init = false}) async {
    try {
      if (!await _googleDriveAppData.isSignedIn() && init == true) return;
      if (_googleUser == null) {
        _googleUser = await _googleDriveAppData.signInGoogle();
        if (_googleUser != null) {
          _driveApi = await _googleDriveAppData.getDriveApi(_googleUser!);
        }
        appFile = await _googleDriveAppData.getDriveFile(
            _driveApi!, SqfliteLinks().getDatabaseName());
        setState(() {
          user = _googleUser;
          if (appFile != null && init) {
            updateLastBackupDate();
          }
        });
      }
    } catch (e) {
      print('Failed to login');
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          createSnackbar(
            context,
            'Something went wrong. Make sure you are connected to internet and try again',
            true,
          ),
        );
    }
  }

  void updateLastBackupDate() {
    final DateFormat formatter = DateFormat('yyyy/MM/dd HH:mm:ss');
    final String formatted =
        formatter.format(appFile!.modifiedTime!.toUtc().toLocal());
    lastBackupDate = formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Backup & Restore"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.cloud_upload,
                    color: Theme.of(context).brightness == Brightness.light
                        ? LinkSaverLighTheme().color
                        : LinkSaverDarkTheme().color,
                  ),
                  SizedBox(width: 50), // give it width

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Last Backup',
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? LinkSaverLighTheme().color
                                  : LinkSaverDarkTheme().color,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                              'Last Backup Date : ${lastBackupDate != '' ? lastBackupDate : 'None'}'),
                        ),
                        Text(
                            'Back up your links to Google Drive. You can restore them when you reinstall SaveLinker. Your Links will also back up to your phones\'s internal storage.'),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    showLoadingDialog(context,
                                        'Back Up data in progress ...');
                                    if (_googleUser == null) {
                                      _googleUser = await _googleDriveAppData
                                          .signInGoogle();
                                      _driveApi = await _googleDriveAppData
                                          .getDriveApi(_googleUser!);
                                      ;
                                    }
                                    final File file = File(
                                        await SqfliteLinks().getDatabasePath());
                                    // login();
                                    appFile = await _googleDriveAppData
                                        .uploadDriveFile(
                                      driveApi: _driveApi!,
                                      file: file,
                                    );
                                    appFile =
                                        await _googleDriveAppData.getDriveFile(
                                            _driveApi!,
                                            SqfliteLinks().getDatabaseName());
                                  } catch (e) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        createSnackbar(
                                          context,
                                          'Something went wrong when back up the links. Make sure you\'re connected to the internet and try again ',
                                          true,
                                        ),
                                      );
                                  }
                                  setState(() {
                                    if (appFile != null) {
                                      updateLastBackupDate();
                                      Navigator.pop(context);
                                      showDbUploadedSuccesfulDialog(context);
                                    }
                                  });
                                },
                                child: Text('Upload'),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    showLoadingDialog(
                                        context, 'Restoring data ...');
                                    if (_googleUser == null) {
                                      _googleUser = await _googleDriveAppData
                                          .signInGoogle();
                                      _driveApi = await _googleDriveAppData
                                          .getDriveApi(_googleUser!);
                                      ;
                                    }
                                    appFile =
                                        await _googleDriveAppData.getDriveFile(
                                            _driveApi!,
                                            SqfliteLinks().getDatabaseName());

                                    // await SqfliteLinks().restoreDb();
                                    final path =
                                        await SqfliteLinks().getDatabasePath();

                                    await _googleDriveAppData.restoreDriveFile(
                                        driveApi: _driveApi!,
                                        driveFile: appFile!,
                                        targetLocalPath: path);
                                    Navigator.pop(context);
                                    await showDbRestoredSuccesfulDialog(
                                        context);
                                    await Restart(context);
                                    Navigator.pop(context);
                                  } catch (e) {
                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        createSnackbar(
                                          context,
                                          'Something went wrong when restoring data. Please try again ',
                                          true,
                                        ),
                                      );
                                  }
                                },
                                child: Text('Restore'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.login,
                    color: Theme.of(context).brightness == Brightness.light
                        ? LinkSaverLighTheme().color
                        : LinkSaverDarkTheme().color,
                  ),
                  SizedBox(width: 50), // give it width

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Google Account',
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? LinkSaverLighTheme().color
                                  : LinkSaverDarkTheme().color,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(user != null ? user!.email : 'None'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_googleUser == null) {
                                login();
                              } else {
                                // await _googleDriveAppData.signOut();
                                await _googleDriveAppData.disconnect();
                                _googleUser = null;
                                _driveApi = null;
                              }
                              ;
                              setState(() {
                                user = _googleUser;
                              });
                            },
                            child: Text(user != null ? 'Logout' : 'Login'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

showLoadingDialog(BuildContext context, String message) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(
            margin: EdgeInsets.only(left: 15, right: 8), child: Text(message)),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showDbRestoredSuccesfulDialog(BuildContext context) {
  // set up the button

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "Data restored",
      style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light
              ? LinkSaverLighTheme().color
              : LinkSaverDarkTheme().color),
    ),
    content: Row(
      children: [
        CircularProgressIndicator(),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child:
                Text("Your Links has been restored. Restarting the app  ...."),
          ),
        ),
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

showDbUploadedSuccesfulDialog(BuildContext context) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Data uploaded",
        style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? LinkSaverLighTheme().color
                : LinkSaverDarkTheme().color)),
    content: Row(
      children: [
        Flexible(
          child: Text("Your Links has been back up successfully. "),
        ),
      ],
    ),
    actions: [
      ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Ok'),
      ),
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
