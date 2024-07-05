import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_tasks_app/shared/models/task.dart';
import 'package:my_tasks_app/shared/widgets/task_floating_action.dart';
import 'package:my_tasks_app/shared/widgets/task_list.dart';
import 'package:window_manager/window_manager.dart';
import '../../shared/repositories/task_repository.dart';

class HomeScreenDesktop extends StatefulWidget {
  const HomeScreenDesktop({super.key});

  @override
  State<HomeScreenDesktop> createState() => _HomeScreenDesktopState();
}

class _HomeScreenDesktopState extends State<HomeScreenDesktop>
    with WindowListener {
  final TaskRepository _taskRepository = TaskRepository();
  List<Task> _tasks = [];
  bool _isCompactMode = false;
  DateTime? _minimizedTime;
  Timer? _checkMinimizedTimer;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _loadTasks();
    _startMinimizedCheck();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _checkMinimizedTimer?.cancel();
    super.dispose();
  }

  @override
  void onWindowMinimize() {
    _minimizedTime = DateTime.now();
  }

  @override
  void onWindowRestore() {
    _minimizedTime = null;
  }

  void _startMinimizedCheck() {
    _checkMinimizedTimer =
        Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (_minimizedTime != null) {
        final minimizedDuration = DateTime.now().difference(_minimizedTime!);
        if (minimizedDuration.inMinutes >= 5) {
          await windowManager.restore();
          await windowManager.focus();
        }
      }
    });
  }

  Future<void> _loadTasks() async {
    _taskRepository.getTasks().listen((tasks) {
      setState(() {
        _tasks = tasks;
      });
    });
  }

  void _addTask(String taskTitle) async {
    await _taskRepository.addTask(taskTitle);
  }

  int get _pendingTasksCount =>
      _tasks.where((task) => !task.isCompleted).length;

  void _toggleCompactMode() {
    setState(() {
      _isCompactMode = !_isCompactMode;
    });
    if (_isCompactMode) {
      windowManager.setSize(const Size(100, 120));
    } else {
      windowManager.setSize(const Size(350, 400));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_isCompactMode ? 40 : 56),
        child: GestureDetector(
          onPanStart: (details) {
            windowManager.startDragging();
          },
          child: AppBar(
            title: Row(
              children: [
                Icon(
                  Icons.check_box,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 5),
                const Text('MyTasks')
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                    _isCompactMode ? Icons.fullscreen : Icons.fullscreen_exit),
                onPressed: _toggleCompactMode,
              ),
              IconButton(
                icon: const Icon(Icons.minimize),
                onPressed: () => windowManager.minimize(),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => windowManager.close(),
              ),
            ],
          ),
        ),
      ),
      body: _isCompactMode
          ? Center(
              child: Text(
                '$_pendingTasksCount',
                style:
                    const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            )
          : TaskList(taskRepository: _taskRepository),
      floatingActionButton: _isCompactMode
          ? null
          : TaskFloatingActionButton(
              addTask: _addTask,
            ),
    );
  }
}
