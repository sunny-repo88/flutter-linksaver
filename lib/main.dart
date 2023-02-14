import 'package:flutter/widgets.dart';
import 'package:link_saver/bootstrap.dart';
import 'package:sqflite_links/sqflite_links.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  // initialize the database
  final linksApi = SqfliteLinks();
  await linksApi.init();

  // final linksApi = LocalStorageLinksApi(
  //   plugin: await SharedPreferences.getInstance(),
  // );

  await bootstrap(linksApi: linksApi);
}
