import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ioc_get_it/flutter_ioc_get_it.dart';
import 'core.dart' as core;
import 'ui.dart' as ui;
import 'data.dart' as data;

void main() async {
  GetItIocContainer.register();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await data.bootstrap();
  await core.bootstrap();
  await ui.bootstrap();
}