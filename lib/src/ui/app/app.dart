import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../task_list_page.dart';

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
      child: const MaterialApp(
        home: const TaskListPage(),
      ),
    );
  }
}
