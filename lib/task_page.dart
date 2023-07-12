import 'package:flutter/material.dart';
import 'package:to_do_app/task.dart';
import 'package:to_do_app/category.dart';

class TaskPage extends StatefulWidget {
  final List<Category> categories;
  final List<Task> tasks;
  final void Function(Task) addTask;
  final void Function(int, Task) editTask;
  final void Function(int) removeTask;

  TaskPage({
    required this.categories,
    required this.tasks,
    required this.addTask,
    required this.editTask,
    required this.removeTask,
  });

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    List<Task> filteredTasks = selectedCategory == 'All'
        ? widget.tasks
        : widget.tasks
            .where((task) => task.category == selectedCategory)
            .toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTaskModal(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: selectedCategory,
                  items: _buildDropdownMenuItems(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (BuildContext context, int index) {
                Task task = filteredTasks[index];
                return Dismissible(
                  key: Key(task.name),
                  direction: DismissDirection.endToStart,
                  onDismissed: (DismissDirection direction) {
                    widget.removeTask(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Zadanie usunięto'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: ListTile(
                    title: Text(task.name),
                    subtitle: Text(task.category),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailsPage(
                            task: task,
                            categories: widget.categories,
                            editTask: (Task editedTask) {
                              widget.editTask(index, editedTask);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addTaskModal(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    String category = widget.categories.first.name;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dodaj nowe zadanie'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nazwa zadania',
                ),
              ),
              TextField(
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Opis zadania',
                ),
              ),
              DropdownButtonFormField<String>(
                value: category,
                items: _buildDropdownMenuItems(),
                onChanged: (String? value) {
                  category = value!;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Anuluj'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Dodaj'),
              onPressed: () {
                String name = nameController.text;
                String description = descriptionController.text;
                Task task = Task(
                  name: name,
                  description: description,
                  category: category,
                );
                widget.addTask(task);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownMenuItems() {
    List<DropdownMenuItem<String>> items = [
      const DropdownMenuItem(
        value: 'All',
        child: Text('Wszystkie'),
      ),
    ];
    for (var category in widget.categories) {
      items.add(
        DropdownMenuItem(
          value: category.name,
          child: Text(category.name),
        ),
      );
    }
    return items;
  }
}

class TaskDetailsPage extends StatefulWidget {
  final Task task;
  final List<Category> categories;
  final void Function(Task) editTask;

  const TaskDetailsPage({
    required this.task,
    required this.categories,
    required this.editTask,
  });

  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String category = '';

  @override
  void initState() {
    super.initState();
    nameController.text = widget.task.name;
    descriptionController.text = widget.task.description;
    category = widget.task.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Task Name',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Task Description',
              ),
            ),
            DropdownButtonFormField<String>(
              value: category,
              items: widget.categories.map((Category category) {
                return DropdownMenuItem<String>(
                  value: category.name,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  category = value!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String name = nameController.text;
                String description = descriptionController.text;
                Task editedTask = Task(
                  name: name,
                  description: description,
                  category: category,
                );
                widget.editTask(editedTask);
                Navigator.of(context).pop();
              },
              child: const Text('Zapisz zmiany'),
            ),
          ],
        ),
      ),
    );
  }
}
