import 'package:flutter/material.dart';
import 'core.dart' as core;
import 'ui.dart' as ui;
import 'package:flutter_ioc_get_it/flutter_ioc_get_it.dart';

import 'core.dart' as core;
// import 'data.dart' as data;
// import 'ui.dart' as ui;

void main() async {
  GetItIocContainer.register();
  WidgetsFlutterBinding.ensureInitialized();

  // await data.bootstrap();
  await core.bootstrap();
  await ui.bootstrap();
}