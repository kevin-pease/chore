import 'package:chore/src/ui/features/task_list/cubit/tasklist_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/task_repository_impl.dart';
import 'app/app.dart';

Future<void> bootstrap() async {
  final repository = TaskRepositoryImpl();
  runApp(
    App(repository: repository),
  );
}