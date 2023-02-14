import 'dart:ffi';

import 'package:flutter/src/material/theme_data.dart';
import 'package:link_saver/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageLinkSaver {
  /// {@macro local_storage_todos_api}
  LocalStorageLinkSaver({
    required SharedPreferences plugin,
  }) : _plugin = plugin {}
  SharedPreferences _plugin;

  saveTheme(bool theme) async {
    SharedPreferences pref = await _plugin;
    pref.setBool('theme', theme);
  }

  Future<bool> getTheme() async {
    SharedPreferences pref = await _plugin;
    bool? rv = pref.getBool('theme');

    if (rv == null) return true;
    if (rv == true) return true;
    if (rv == false) return false;
    return true;
  }
}
