import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_tasks_app/services/database_service.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(350, 400),
    minimumSize: Size(100, 100),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: false,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setAlwaysOnTop(true);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minhas Tarefas',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6272A4),
        scaffoldBackgroundColor: const Color(0xFF282A36),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF44475A),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Color(0xFF282A36),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6272A4),
          secondary: Color(0xFFFF79C6),
          surface: Color(0xFF44475A),
          error: Color(0xFFFF5555),
        ),
      ),
      home: const MyHomePage(title: 'MyTasks'),
    );
  }
}

class Task {
  int? id;
  String title;
  bool isCompleted;

  Task({this.id, required this.title, this.isCompleted = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  final DatabaseService _databaseService = DatabaseService();
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
    final tasks = await _databaseService.getTasks();
    setState(() {
      _tasks = tasks.map((map) => Task.fromMap(map)).toList();
      _sortTasks();
    });
  }

  void _addTask(String taskTitle) async {
    await _databaseService.addTask(taskTitle);
    await _loadTasks();
  }

  void _deleteTask(int index) async {
    final task = _tasks[index];
    await _databaseService.deleteTask(task.id!);
    await _loadTasks();
  }

  void _toggleTaskCompletion(int index) async {
    final task = _tasks[index];
    await _databaseService.updateTask(task.id!, !task.isCompleted);
    await _loadTasks();
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      if (a.isCompleted == b.isCompleted) {
        return 0;
      }
      if (a.isCompleted) {
        return 1;
      }
      return -1;
    });
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
        preferredSize: const Size.fromHeight(40),
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
                const SizedBox(
                  width: 5,
                ),
                Text(widget.title)
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
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _tasks[index].title,
                    style: TextStyle(
                      decoration: _tasks[index].isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: _tasks[index].isCompleted
                          ? Colors.grey
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  leading: Checkbox(
                    value: _tasks[index].isCompleted,
                    onChanged: (bool? value) {
                      _toggleTaskCompletion(index);
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteTask(index),
                  ),
                );
              },
            ),
      floatingActionButton: _isCompactMode
          ? null
          : FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    String newTask = '';
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: const Text('Adicionar Tarefa'),
                      content: TextField(
                        onChanged: (value) {
                          newTask = value;
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (newTask.isNotEmpty) {
                              _addTask(newTask);
                            }
                            Navigator.pop(context);
                          },
                          child: const Text('Adicionar'),
                        ),
                      ],
                    );
                  },
                );
              },
              tooltip: 'Adicionar Tarefa',
              child: const Icon(Icons.add),
            ),
    );
  }
}
