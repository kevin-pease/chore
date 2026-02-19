import 'package:chore/src/ui/tasklist_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/app.dart';

Future<void> bootstrap() async {
  runApp(
    App(
      globalBlocProviders: [
        BlocProvider<TaskListCubit>(
          create: (_) => TaskListCubit()..loadInitialTasks(),
        ),
      ],
    ),
  );

}