import 'package:chore/src/ui/tasklist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../data/models/task.dart';
import 'add_task_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage>
    with SingleTickerProviderStateMixin {
  Task? _pendingTask;
  late AnimationController _barController;
  late Animation<Offset> _barSlide;
  late Animation<double> _barFade;

  @override
  void initState() {
    super.initState();
    _barController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _barSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _barController, curve: Curves.easeOutCubic));
    _barFade = CurvedAnimation(parent: _barController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _barController.dispose();
    super.dispose();
  }

  void _onLongPress(Task task) {
    HapticFeedback.mediumImpact();
    setState(() => _pendingTask = task);
    _barController.forward();
  }

  Future<void> _dismissBar() async {
    await _barController.reverse();
    setState(() => _pendingTask = null);
  }

  void _confirmMarkDone() {
    if (_pendingTask != null) {
      context.read<TaskListCubit>().markDone(_pendingTask!.id);
    }
    _dismissBar();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(context),
              BlocBuilder<TaskListCubit, List<Task>>(
                builder: (context, tasks) {
                  if (tasks.isEmpty) {
                    return SliverFillRemaining(child: _buildEmptyState(context));
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                    sliver: SliverList.separated(
                      itemCount: tasks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return _TaskCard(
                          task: tasks[index],
                          isPending: _pendingTask?.id == tasks[index].id,
                          onLongPress: () => _onLongPress(tasks[index]),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddTaskPage(existingTask: tasks[index]),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),

          // FAB
          Positioned(
            right: 20,
            bottom: 24,
            child: FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddTaskPage()),
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Nieuwe taak'),
              elevation: 2,
            ),
          ),

          // Confirmation bottom bar
          if (_pendingTask != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: FadeTransition(
                opacity: _barFade,
                child: SlideTransition(
                  position: _barSlide,
                  child: _ConfirmBar(
                    task: _pendingTask!,
                    onConfirm: _confirmMarkDone,
                    onCancel: _dismissBar,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SliverAppBar.large(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      title: const Text('Mijn taken'),
      titleTextStyle: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: colorScheme.onSurface,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.tune_rounded),
          tooltip: 'Instellingen',
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.checklist_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.outline.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(
            'Geen taken',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tik op + om een taak toe te voegen',
            style: TextStyle(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.isPending,
    required this.onLongPress,
    required this.onTap,
  });

  final Task task;
  final bool isPending;
  final VoidCallback onLongPress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = _colorForTask(task);
    final formatter = DateFormat('dd MMM yyyy');
    final lastDone = task.lastDoneAt != null
        ? formatter.format(task.lastDoneAt!.toLocal())
        : 'Nog nooit gedaan';
    final timeAgo = _getTimeUnitsAgo(task.lastDoneAt);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isPending
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPending
              ? colorScheme.primary.withOpacity(0.4)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Status dot
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                          if (task.frequency != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _formatFrequency(task.frequency),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.history_rounded,
                              size: 13, color: colorScheme.outline),
                          const SizedBox(width: 4),
                          Text(
                            lastDone,
                            style: TextStyle(
                                fontSize: 12, color: colorScheme.outline),
                          ),
                          if (timeAgo.isNotEmpty) ...[
                            Text('  ·  ',
                                style:
                                TextStyle(color: colorScheme.outline)),
                            Text(
                              timeAgo,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded,
                    color: colorScheme.outlineVariant, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmBar extends StatelessWidget {
  const _ConfirmBar({
    required this.task,
    required this.onConfirm,
    required this.onCancel,
  });

  final Task task;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: colorScheme.outline.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.check_rounded,
                        color: colorScheme.primary, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Markeren als gedaan?',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          task.title,
                          style: TextStyle(
                              fontSize: 13, color: colorScheme.outline),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: onCancel,
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          side: BorderSide(
                              color: colorScheme.outline.withOpacity(0.3)),
                        ),
                        child: const Text('Annuleren',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed: onConfirm,
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Bevestigen',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _colorForTask(Task task) {
  if (task.lastDoneAt == null || task.frequency == null) return Colors.grey;
  final hours = DateTime.now().difference(task.lastDoneAt!).inHours;
  final int freq = task.frequency!.inDays;
  if (hours < freq * 0.8) return Colors.green;
  if (hours < freq) return Colors.orange;
  return Colors.red;
}

String _formatFrequency(Duration? frequency) {
  if (frequency == null) return '';
  final days = frequency.inDays;
  return days == 1 ? 'dagelijks' : 'elke $days dagen';
}

String _getTimeUnitsAgo(DateTime? date) {
  if (date == null) return '';
  final difference = DateTime.now().difference(date);
  if (difference.inSeconds < 60) return 'zojuist';
  if (difference.inMinutes < 60) return '${difference.inMinutes}m geleden';
  if (difference.inHours < 24) return '${difference.inHours}u geleden';
  if (difference.inDays < 7) return '${difference.inDays}d geleden';
  if (difference.inDays < 30) return '${(difference.inDays / 7).floor()}w geleden';
  if (difference.inDays < 365) return '${(difference.inDays / 30).floor()}mnd geleden';
  return '${(difference.inDays / 365).floor()}j geleden';
}