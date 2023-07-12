import 'package:flutter/material.dart';
import 'package:to_do_app/task.dart';
import 'package:to_do_app/category.dart';

import 'task_page.dart';
import 'category_page.dart';
import 'contact_page.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  int _selectedIndex = 0;
  final List<Category> _categories = [
    Category(name: 'Personal'),
    Category(name: 'Work'),
    Category(name: 'Shopping'),
  ];
  final List<Task> _tasks = [
    Task(
      name: 'Task 1',
      description: 'Description 1',
      category: 'Personal',
    ),
    Task(
      name: 'Task 2',
      description: 'Description 2',
      category: 'Work',
    ),
    Task(
      name: 'Task 3',
      description: 'Description 3',
      category: 'Shopping',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addTask(Task task) {
    if (_categories.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Categories'),
            content: Text('Please add a category first.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return; // Exit the function
    }

    setState(() {
      _tasks.add(task);
    });
  }

  void _editTask(int index, Task task) {
    setState(() {
      _tasks[index] = task;
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _addCategory(Category category) {
    setState(() {
      _categories.add(category);
    });
  }

  void _editCategory(int index, Category category) {
    setState(() {
      String oldCategoryName = _categories[index].name;
      _categories[index] = category;
      for (var task in _tasks) {
        if (task.category == oldCategoryName) {
          task.category = category.name;
        }
      }
    });
  }

  void _removeCategory(int index) {
    setState(() {
      String categoryName = _categories[index].name;
      _categories.removeAt(index);
      for (var task in _tasks) {
        if (task.category == categoryName) {
          task.category = 'Bez kategorii';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Color.fromARGB(255, 100, 183, 250)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const SizedBox(
            width: double.infinity,
            height: 60,
            child: Center(
              child: Text(
                "Let's To Do!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Zadania',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Kategorie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: 'Kontakt',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return TaskPage(
          categories: _categories,
          tasks: _tasks,
          addTask: _addTask,
          editTask: _editTask,
          removeTask: _removeTask,
        );
      case 1:
        return CategoryPage(
          categories: _categories,
          addCategory: _addCategory,
          editCategory: _editCategory,
          removeCategory: _removeCategory,
        );
      case 2:
        return ContactPage();
      default:
        return Container();
    }
  }
}
