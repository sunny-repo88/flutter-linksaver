import 'package:flutter/cupertino.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:link_saver/main.dart';

Restart(BuildContext context) async {
  await Future.delayed(Duration(seconds: 2));
  await main();
  await Phoenix.rebirth(context);
}
