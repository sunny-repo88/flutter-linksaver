import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:link_saver/backup_restore/backup_restore.dart';
import 'package:link_saver/helpers/restart_app_management.dart';
import 'package:link_saver/helpers/LocalStorageLinkSaver.dart';
import 'package:link_saver/l10n/l10n.dart';
import 'package:link_saver/settings/bloc/settings_bloc.dart';
import 'package:link_saver/settings/view/ads_page.dart';
import 'package:link_saver/settings/view/app_info.dart';
import 'package:link_saver/settings/view/privacy_policy_page.dart';
import 'package:link_saver/settings/view/question_and_anwser_page.dart';
import 'package:link_saver/theme/theme.dart';
import 'package:link_saver/ui_components/reboot_dialog.dart';
import 'package:link_saver/widgets/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static Route<void> route({Link? initialLink}) {
    return MaterialPageRoute(
      builder: (context) => const SettingsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(
          localStorageLinkSaver: context.read<LocalStorageLinkSaver>())
        ..add(const SettingsPageSubscriptionRequested()),
      child: const SettingsPageView(),
    );
  }
}

class SettingsPageView extends StatefulWidget {
  const SettingsPageView({super.key});

  @override
  State<SettingsPageView> createState() => _SettingsPageViewState();
}

class _SettingsPageViewState extends State<SettingsPageView> {
  BannerAd? _bannerAd;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settingsBloc = context.read<SettingsBloc>();
    final state = context.select((SettingsBloc bloc) => bloc.state);
    bool _light = state.theme;

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Settings',
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
          body: BlocListener<SettingsBloc, SettingsState>(
            listener: (context, state) {
              if (state.status == SettingsStatus.loadFailure) {
                SnackBar snackbar = createSnackbar(
                  context,
                  l10n.loadSettingsPageErrorSnackbarText,
                  true,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
              ;
              if (state.status == SettingsStatus.switchThemeFailure) {
                SnackBar snackbar = createSnackbar(
                  context,
                  l10n.switchThemeErrorSnackbarText,
                  true,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
              if (state.status == SettingsStatus.switchThemeSuccess) {
                showThemeChangedDialog(context, _light);
              }
            },
            child: CupertinoScrollbar(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text('Theme'),
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Icon(Icons.brightness_medium_rounded),
                        ),
                        trailing: Switch(
                            value: _light,
                            onChanged: (toggle) {
                              context
                                  .read<SettingsBloc>()
                                  .add(SettingsPageThemeSubmitted(toggle));
                            }),
                        subtitle: Text(_light ? 'light' : 'dark'),
                      ),
                      // Divider(height: 5),
                      // ListTile(
                      //   title: Text('App Language'),
                      //   leading: Padding(
                      //     padding: const EdgeInsets.only(top: 8.0),
                      //     child: Icon(Icons.language),
                      //   ),
                      //   subtitle: Text('English(phone\'s language)'),
                      // ),
                      Divider(height: 5),
                      ListTile(
                        title: Text('Backup & Restore'),
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Icon(Icons.settings_backup_restore_rounded),
                        ),
                        subtitle: Text('Backup and restore links'),
                        onTap: () {
                          Navigator.of(context).push(
                            BackUpRestore.route(),
                          );
                        },
                      ),
                      if (_bannerAd != null)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SafeArea(
                            child: SizedBox(
                              width: _bannerAd!.size.width.toDouble(),
                              height: _bannerAd!.size.height.toDouble(),
                              child: AdWidget(ad: _bannerAd!),
                            ),
                          ),
                        ),
                      Divider(height: 5),
                      ListTile(
                        title: Text('FAQ'),
                        subtitle: Text('Frequently asked questions'),
                        leading: Icon(Icons.question_answer_sharp),
                        onTap: () {
                          Navigator.of(context).push(
                            FAQPage.route(),
                          );
                        },
                      ),
                      Divider(height: 5),
                      ListTile(
                        title: Text('Terms and Privacy Policy'),
                        leading: Icon(Icons.privacy_tip_rounded),
                        onTap: () {
                          Navigator.of(context).push(
                            PrivacyPolicyPage.route(),
                          );
                        },
                      ),
                      Divider(height: 5),
                      ListTile(
                        title: Text('Help'),
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Icon(Icons.help_outline_rounded),
                        ),
                        subtitle: Text('Support center & contact us'),
                        onTap: () async {
                          final Uri _url = Uri.parse(
                              'https://www.facebook.com/profile.php?id=100090150495095');
                          await launchUrl(_url,
                              mode: LaunchMode.externalApplication);
                        },
                      ),
                      Divider(height: 5),
                      ListTile(
                        title: Text('App Info'),
                        leading: Icon(Icons.info_rounded),
                        onTap: () {
                          Navigator.of(context).push(
                            AppInfoPage.route(),
                          );
                        },
                      ),
                      // Divider(height: 5),
                      // ListTile(
                      //   title: Text('Ads'),
                      //   leading: Icon(Icons.ads_click),
                      //   onTap: () {
                      //     Navigator.of(context).push(
                      //       AdsPage.route(),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _loadAd() async {
    BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}

showThemeChangedDialog(BuildContext context, bool light) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: Text(
        "Theme changed to theme ${light ? 'light' : 'dark'}.  You need to restart the app to apply the changes."),
    actions: [
      TextButton(
        child: Text(
          "Cancel",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? LinkSaverLighTheme().color
                : LinkSaverDarkTheme().color,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      ElevatedButton(
        child: Text(
          "Restart now",
          style: TextStyle(color: LinkSaverDarkTheme().color),
        ),
        onPressed: () async {
          try {
            showRestartDialog(context);
            await Restart(context);
            Navigator.pop(context);
          } catch (e) {
            const snackBar = SnackBar(
              content: Text(
                  'Something went wrong when restarting app. Please reopen the app to have theme change effect.'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
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
