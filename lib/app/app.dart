import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link_saver/helpers/LocalStorageLinkSaver.dart';
import 'package:link_saver/home/home.dart';
import 'package:link_saver/l10n/l10n.dart';
import 'package:link_saver/theme/theme.dart';
import 'package:links_repository/links_repository.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.linksRepository,
    required this.localStorageLinkSaver,
    required this.themeMode,
  });

  final LinksRepository linksRepository;
  final LocalStorageLinkSaver localStorageLinkSaver;
  final bool themeMode;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LinksRepository>(
          create: (context) => linksRepository,
        ),
        RepositoryProvider<LocalStorageLinkSaver>(
          create: (context) => localStorageLinkSaver,
        ),
      ],
      child: Phoenix(
        child: AppView(themeMode: themeMode),
      ),
    );
    // return RepositoryProvider.value(
    //   value: linksRepository,
    //   child: const AppView(),
    // );
  }
}

class AppView extends StatefulWidget {
  AppView({super.key, required this.themeMode});
  final bool themeMode;

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: widget.themeMode ? LinkSaverTheme.light : LinkSaverTheme.dark,
      // darkTheme: LinkSaverTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}
