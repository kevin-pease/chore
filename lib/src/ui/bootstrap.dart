import 'package:chore/src/ui/tasklist_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ioc/flutter_ioc.dart';


import '../../core.dart';
import 'app/app.dart';

Future<void> bootstrap() async {
  runApp(
    App(
      globalBlocProviders: [
        BlocProvider<TaskListCubit>(
          // TODO: Verder gaan met ChatGpt prompt, stap 5 ongeveer
          create: (_) => TaskListCubit()..loadInitialTasks(),
        ),
      ],
    ),
  );

}