import 'package:chore/src/ui/features/task_list/cubit/tasklist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/task.dart';
import 'dart:math';

// NOTE: stateful widget without Cubit because form does not need state?

class AddTaskPage extends StatefulWidget {
  final Task? existingTask;

  const AddTaskPage({super.key, this.existingTask});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _titleFocus = FocusNode();

  bool get _isEditing => widget.existingTask != null;

  @override
  void initState() {
    super.initState();
    final task = widget.existingTask;
    if (task != null) {
      _titleController.text = task.title;
      if (task.frequency != null) {
        _frequencyController.text = task.frequency!.inDays.toString();
      }
    }
    if (!_isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _titleFocus.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _frequencyController.dispose();
    _titleFocus.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();
      return;
    }

    final parsed = int.tryParse(_frequencyController.text);
    final frequency =
    (parsed != null && parsed > 0) ? Duration(days: parsed) : null;

    if (!_isEditing) {
      context.read<TaskListCubit>().addTask(Task(
        id: UniqueKey().toString(),
        title: _titleController.text.trim(),
        frequency: frequency,
      ));
    } else {
      context.read<TaskListCubit>().editTask(Task(
        id: widget.existingTask!.id,
        title: _titleController.text.trim(),
        frequency: frequency,
      ));
    }
    Navigator.of(context).pop();
  }

  void _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Taak verwijderen?'),
        content: Text(
            '"${widget.existingTask!.title}" wordt permanent verwijderd.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuleren'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Verwijderen'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<TaskListCubit>().deleteTask(widget.existingTask!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditing ? 'Taak bewerken' : 'Nieuwe taak',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.delete_outline_rounded,
                  color: colorScheme.error),
              tooltip: 'Verwijderen',
              onPressed: _handleDelete,
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 8),

            _SectionLabel(label: 'Naam'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              focusNode: _titleFocus,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
              decoration: _inputDecoration(
                context,
                hint: _getRandomSuggestion(),
                prefixIcon: Icons.edit_outlined,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Geef de taak een naam';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            _SectionLabel(label: 'Herhaalinterval'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _frequencyController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
              decoration: _inputDecoration(
                context,
                hint: 'Aantal dagen (optioneel)',
                prefixIcon: Icons.repeat_rounded,
                suffix: _frequencyController.text.isNotEmpty
                    ? _frequencyLabel(_frequencyController.text)
                    : null,
              ),
              onChanged: (_) => setState(() {}),
            ),

            // Frequency quick picks
            const SizedBox(height: 12),
            _FrequencyChips(
              onSelect: (days) {
                setState(() {
                  _frequencyController.text = days.toString();
                });
              },
              selected: int.tryParse(_frequencyController.text),
            ),

            const SizedBox(height: 40),

            SizedBox(
              height: 54,
              child: FilledButton(
                onPressed: _handleSubmit,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  _isEditing ? 'Wijzigingen opslaan' : 'Taak toevoegen',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
      BuildContext context, {
        required String hint,
        required IconData prefixIcon,
        Widget? suffix,
      }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: colorScheme.outline.withOpacity(0.6)),
      prefixIcon: Icon(prefixIcon, size: 20, color: colorScheme.outline),
      suffix: suffix,
      filled: true,
      fillColor: colorScheme.surfaceContainerLow,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _frequencyLabel(String value) {
    final days = int.tryParse(value);
    if (days == null || days == 0) return const SizedBox.shrink();
    final label = days == 1 ? 'dag' : 'dagen';
    return Text(
      label,
      style: TextStyle(
        color: Theme.of(context).colorScheme.outline,
        fontSize: 14,
      ),
    );
  }

  String _getRandomSuggestion() {
    List<String> examples = [
      'Planten water geven',
      'Keukenkastjes schoonmaken',
      'Dweilen',
      'Ramen lappen',
      'Was 60 graden',
    ];
    final random = Random();
    String randomExample = examples[random.nextInt(examples.length)];
    return 'bijv. $randomExample';
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}

class _FrequencyChips extends StatelessWidget {
  const _FrequencyChips({required this.onSelect, required this.selected});

  final void Function(int days) onSelect;
  final int? selected;

  static const _options = [
    (label: 'Dagelijks', days: 1),
    (label: '3 dagen', days: 3),
    (label: 'Wekelijks', days: 7),
    (label: '2 weken', days: 14),
    (label: 'Maandelijks', days: 30),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _options.map((opt) {
        final isSelected = selected == opt.days;
        return GestureDetector(
          onTap: () => onSelect(opt.days),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Text(
              opt.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}