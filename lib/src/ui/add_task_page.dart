import 'package:chore/src/ui/tasklist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:format/format.dart';
import 'dart:ui';
import '../data/models/task.dart'; // TODO: is this wise?

class AddTaskPage extends StatefulWidget {
  AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                  labelText: "Naam"
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Naam is vereist';
                return null;
              },
            ),
            TextFormField(
              controller: _frequencyController,
              decoration: InputDecoration(
                  labelText: "Interval (in dagen)"
              ),
            ),
            Spacer(),
            ElevatedButton(onPressed: _handleSubmit, child: Text('Toevoegen')),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final parsed = int.tryParse(_frequencyController.text);
      Duration? frequency;

      if (parsed != null && parsed > 0) {
        frequency = Duration(days: parsed);
      } else {
        frequency = null;
      }

      final task = Task(
        id: UniqueKey().toString(),
        title: _titleController.text,
        frequency: frequency,
      );

      context.read<TaskListCubit>().addTask(task);

      Navigator.of(context).pop();
    } else {
      // TODO
    }
  }

}