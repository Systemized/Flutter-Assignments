import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TaskApp());
}

/// Priority levels (High shows first, then Medium, then Low)
enum Priority { high, medium, low }

extension PriorityX on Priority {
  String get label {
    switch (this) {
      case Priority.high:
        return 'High';
      case Priority.medium:
        return 'Medium';
      case Priority.low:
        return 'Low';
    }
  }

  /// For sorting (High first)
  int get sortScore {
    switch (this) {
      case Priority.high:
        return 3;
      case Priority.medium:
        return 2;
      case Priority.low:
        return 1;
    }
  }

  static Priority fromString(String s) {
    switch (s) {
      case 'high':
        return Priority.high;
      case 'medium':
        return Priority.medium;
      default:
        return Priority.low;
    }
  }

  String get asString => toString().split('.').last;
}

/// Simple Task model with (id for stable keys), name, done, priority, createdAt
class Task {
  final String id;
  String name;
  bool done;
  Priority priority;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.name,
    this.done = false,
    this.priority = Priority.low,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'done': done,
        'priority': priority.asString,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'] as String,
        name: map['name'] as String,
        done: map['done'] as bool? ?? false,
        priority: PriorityX.fromString(map['priority'] as String? ?? 'low'),
        createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      );
}

class TaskApp extends StatefulWidget {
  const TaskApp({super.key});

  @override
  State<TaskApp> createState() => _TaskAppState();
}

class _TaskAppState extends State<TaskApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _restoreTheme();
  }

  Future<void> _restoreTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString('themeMode') ?? 'system';
    setState(() {
      _themeMode = _decodeTheme(themeStr);
    });
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', _encodeTheme(mode));
  }

  String _encodeTheme(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
    }
  }

  ThemeMode _decodeTheme(String s) {
    switch (s) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  void _toggleThemeMode() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else if (_themeMode == ThemeMode.dark) {
        _themeMode = ThemeMode.light;
      } else {
        // system -> light
        _themeMode = ThemeMode.light;
      }
    });
    _saveTheme(_themeMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
        brightness: Brightness.dark,
      ),
      home: TaskListScreen(
        onToggleTheme: _toggleThemeMode,
        themeMode: _themeMode,
      ),
    );
  }
}

/// Main screen: add tasks, list, complete, delete, edit priority/name
class TaskListScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const TaskListScreen({
    Key? key,
    required this.onToggleTheme,
    required this.themeMode,
  }) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _controller = TextEditingController();
  Priority _newTaskPriority = Priority.low;
  List<Task> _tasks = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _restoreTasks();
  }

  // ---- Persistence ----
  Future<void> _restoreTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('tasks_v1');
    if (raw != null && raw.isNotEmpty) {
      final decoded = jsonDecode(raw) as List<dynamic>;
      _tasks = decoded.map((e) => Task.fromMap(Map<String, dynamic>.from(e))).toList();
      _sortTasks();
    }
    setState(() => _loaded = true);
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _tasks.map((t) => t.toMap()).toList();
    await prefs.setString('tasks_v1', jsonEncode(list));
  }

  // ---- CRUD ----
  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final task = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: text,
      priority: _newTaskPriority,
    );
    setState(() {
      _tasks.add(task);
      _controller.clear();
      _newTaskPriority = Priority.low; // reset input selector (optional)
      _sortTasks();
    });
    _saveTasks();
  }

  void _toggleDone(Task t, bool? val) {
    setState(() {
      t.done = val ?? false;
      _sortTasks(); // keep completed ones after uncompleted with same priority (optional)
    });
    _saveTasks();
  }

  void _deleteTask(Task t) {
    setState(() {
      _tasks.removeWhere((x) => x.id == t.id);
    });
    _saveTasks();
  }

  void _changePriority(Task t, Priority p) {
    setState(() {
      t.priority = p;
      _sortTasks();
    });
    _saveTasks();
  }

  void _renameTask(Task t) async {
    final nameController = TextEditingController(text: t.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Task'),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'New name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, nameController.text.trim()), child: const Text('Save')),
        ],
      ),
    );
    if (newName != null && newName.isNotEmpty) {
      setState(() {
        t.name = newName;
      });
      _saveTasks();
    }
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      // Higher priority first
      final byPriority = b.priority.sortScore.compareTo(a.priority.sortScore);
      if (byPriority != 0) return byPriority;

      // Incomplete before complete
      if (a.done != b.done) return (a.done ? 1 : -1);

      // Earlier created first (stable feel)
      return a.createdAt.compareTo(b.createdAt);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Todo List'),
        actions: [
          IconButton(
            tooltip: 'Toggle Theme',
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : widget.themeMode == ThemeMode.light
                      ? Icons.light_mode
                      : Icons.brightness_auto,
            ),
          ),
        ],
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      // Priority selector for the new task
                      DropdownButton<Priority>(
                        value: _newTaskPriority,
                        onChanged: (p) => setState(() => _newTaskPriority = p ?? Priority.low),
                        items: Priority.values
                            .map((p) => DropdownMenuItem(value: p, child: Text(p.label)))
                            .toList(),
                      ),
                      const SizedBox(width: 8),
                      // Task input
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onSubmitted: (_) => _addTask(),
                          decoration: const InputDecoration(
                            labelText: 'Input New Assignment',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: _addTask,
                        icon: const Icon(Icons.add),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0),
                Expanded(
                  child: _tasks.isEmpty
                      ? const Center(
                          child: Text('No tasks yet. Add your first task!'),
                        )
                      : ListView.builder(
                          itemCount: _tasks.length,
                          itemBuilder: (context, index) {
                            final t = _tasks[index];
                            return Dismissible(
                              key: ValueKey(t.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                color: Colors.red.withOpacity(0.85),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              confirmDismiss: (_) async {
                                return await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Delete task?'),
                                        content: Text('Are you sure you want to delete "${t.name}"?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () => Navigator.pop(ctx, false),
                                              child: const Text('Cancel')),
                                          FilledButton(
                                              onPressed: () => Navigator.pop(ctx, true),
                                              child: const Text('Delete')),
                                        ],
                                      ),
                                    ) ??
                                    false;
                              },
                              onDismissed: (_) => _deleteTask(t),
                              child: ListTile(
                                leading: Checkbox(
                                  value: t.done,
                                  onChanged: (val) => _toggleDone(t, val),
                                ),
                                title: GestureDetector(
                                  onLongPress: () => _renameTask(t),
                                  child: Text(
                                    t.name,
                                    style: TextStyle(
                                      decoration: t.done ? TextDecoration.lineThrough : null,
                                      fontStyle: t.done ? FontStyle.italic : FontStyle.normal,
                                    ),
                                  ),
                                ),
                                subtitle: Text('Priority: ${t.priority.label}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Edit priority after creation
                                    DropdownButton<Priority>(
                                      value: t.priority,
                                      underline: const SizedBox.shrink(),
                                      onChanged: (p) {
                                        if (p != null) _changePriority(t, p);
                                      },
                                      items: Priority.values
                                          .map((p) =>
                                              DropdownMenuItem(value: p, child: Text(p.label)))
                                          .toList(),
                                    ),
                                    IconButton(
                                      tooltip: 'Delete',
                                      onPressed: () => _deleteTask(t),
                                      icon: const Icon(Icons.delete_outline),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
