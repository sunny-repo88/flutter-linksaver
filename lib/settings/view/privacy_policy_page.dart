import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_saver/backup_restore/backup_restore.dart';

import '../../theme/theme.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static Route<void> route({Link? initialLink}) {
    return MaterialPageRoute(
      builder: (context) => const PrivacyPolicyPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).brightness == Brightness.light
                ? LinkSaverLighTheme().color
                : LinkSaverDarkTheme().color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  'Collect and Use of information',
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? LinkSaverLighTheme().color
                          : LinkSaverDarkTheme().color,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Text("""
This app doesn't collect any kind of personal information including links information.

We are committed to respecting the privacy of our users and giving them full control over their data.

Users have complete control over their data """),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
