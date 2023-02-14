import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_saver/backup_restore/backup_restore.dart';
import 'package:link_saver/settings/view/privacy_policy_page.dart';
import 'package:link_saver/settings/view/question_and_anwser_page.dart';
import 'package:link_saver/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_review/in_app_review.dart';

class AppInfoPage extends StatelessWidget {
  AppInfoPage({super.key});

  static Route<void> route({Link? initialLink}) {
    return MaterialPageRoute(
      builder: (context) => AppInfoPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'App Information',
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
      body: CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                  child: Center(
                    child: Image(
                      image: AssetImage('assets/hyperlink.png'),
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Version'),
                  subtitle: Text('1.0.0'),
                  leading: Icon(Icons.numbers_outlined),
                  onTap: () {},
                ),
                ListTile(
                  title: Text('Rate us'),
                  leading: Icon(Icons.star_border),
                  onTap: () async {
                    final InAppReview inAppReview = InAppReview.instance;
                    if (await inAppReview.isAvailable()) {
                      inAppReview.requestReview();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
