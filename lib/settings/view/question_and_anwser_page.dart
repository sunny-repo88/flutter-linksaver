import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_saver/backup_restore/backup_restore.dart';
import 'package:link_saver/theme/theme.dart';

class FAQ {
  String question = '';
  String anwser = '';

  FAQ(String question, String anwser) {
    this.question = question;
    this.anwser = anwser;
  }
}

List<FAQ> faqs = [
  new FAQ(
    'Is this app free?',
    'Yes, This app is completely free to use, meaning that you do not have to pay any fees or make any purchases to access its features and functionality. It does contain ads that help us sustain its development and provide long-term support.',
  ),
  new FAQ(
    'Having issue?',
    'If this app does not work properly, please email us or contact us via facebook. We will fix it as soon as possible.',
  ),
  new FAQ(
    'Is my data secure?',
    'You have full control over your data. You can backup your data to google drive using our backup features. We do not collect any of your information',
  ),
  new FAQ(
    'Can sync my data across multiple devices?',
    'Yes you can sync all the links across multiple devices. Remember to use the same email to backup and restore them on other devices.',
  ),
  new FAQ(
    'Can i request more feature(s)?',
    'Yes sure, please contact us via facebook or email',
  )
];

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  static Route<void> route({Link? initialLink}) {
    return MaterialPageRoute(
      builder: (context) => const FAQPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FAQ',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: faqs.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                ListTile(
                  title: Text(
                    faqs[index].question,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(faqs[index].anwser),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 8, right: 8),
                  child: Divider(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
