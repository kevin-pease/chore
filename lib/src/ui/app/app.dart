import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../gen/localizations/app_localizations.dart';
import '../features/task_list/task_list_page.dart';

class App extends StatelessWidget {
  const App({
    required this.globalBlocProviders,
    super.key,
  });

  final List<BlocProvider<Cubit<dynamic>>> globalBlocProviders;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: globalBlocProviders,
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.orangeAccent,
            brightness: Brightness.light,
            textTheme: const TextTheme(
              titleLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              bodyLarge: TextStyle(fontSize: 6),
              bodyMedium: TextStyle(fontSize: 4),
              labelMedium: TextStyle(fontSize: 23),
            ),
          ),
          home: const TaskListPage(),
        )
    );
  }
}
