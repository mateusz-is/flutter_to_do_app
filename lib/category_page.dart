import 'package:flutter/material.dart';
import 'package:to_do_app/category.dart';

class CategoryPage extends StatelessWidget {
  final List<Category> categories;
  final void Function(int, Category) editCategory;
  final void Function(Category) addCategory;
  final void Function(int) removeCategory;

  CategoryPage({
    required this.categories,
    required this.editCategory,
    required this.addCategory,
    required this.removeCategory,
  });

  void _addCategoryModal(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dodaj kategorię'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nazwa kategorii',
                ),
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
                Category category = Category(name: name);
                addCategory(category);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addCategoryModal(context);
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          Category category = categories[index];
          return Dismissible(
            key: Key(category.name),
            direction: DismissDirection.endToStart,
            onDismissed: (DismissDirection direction) {
              removeCategory(index);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Usunięto kategorię'),
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
              title: Text(category.name),
              onTap: () {
                TextEditingController nameController =
                    TextEditingController(text: category.name);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Edytuj kategorię'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nazwa kategorii',
                            ),
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
                          child: const Text('Zapisz'),
                          onPressed: () {
                            String name = nameController.text;
                            Category editedCategory = Category(name: name);
                            editCategory(index, editedCategory);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
