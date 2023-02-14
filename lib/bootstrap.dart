import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:link_saver/app/app.dart';
import 'package:link_saver/app/app_bloc_observer.dart';
import 'package:link_saver/helpers/LocalStorageLinkSaver.dart';
import 'package:link_saver/theme/theme.dart';
import 'package:links_api/links_api.dart';
import 'package:links_repository/links_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_links/sqflite_links.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

Future<void> bootstrap({
  required LinksApi linksApi,
}) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = AppBlocObserver();

  final linksRepository = LinksRepository(linksApi: linksApi);
  LocalStorageLinkSaver localStorageLinkSaver = LocalStorageLinkSaver(
    plugin: await SharedPreferences.getInstance(),
  );
  bool themeMode = await localStorageLinkSaver.getTheme();

  runZonedGuarded(
    () => runApp(App(
      linksRepository: linksRepository,
      localStorageLinkSaver: localStorageLinkSaver,
      themeMode: themeMode,
    )),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
