import 'package:flutter/material.dart';
import 'database.dart';
import 'ToDoItem.dart';
import 'ToDoDao.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({Key? key}) : super(key: key);

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<ToDoPage> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<ToDoItem> _items = [];
  late AppDatabase database;
  late ToDoDao toDoDao;
  int _idCounter = 1;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    database = await $FloorAppDatabase.databaseBuilder('todo_database.db').build();
    toDoDao = database.toDoDao;
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await toDoDao.findAllToDos();
    setState(() {
      _items.clear();
      _items.addAll(items);
      _idCounter = (_items.isNotEmpty) ? _items.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1 : 1;
    });
  }

  Future<void> _addItem() async {
    if (_textFieldController.text.isNotEmpty) {
      final newItem = ToDoItem(_idCounter++, _textFieldController.text);
      await toDoDao.insertToDoItem(newItem);
      setState(() {
        _items.add(newItem);
        _textFieldController.clear();
      });
    }
  }

  Future<void> _removeItem(int index) async {
    final itemToRemove = _items[index];
    await toDoDao.deleteToDoItem(itemToRemove);
    setState(() {
      _items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textFieldController,
                    decoration: const InputDecoration(
                      hintText: 'Enter item',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addItem,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _items.isEmpty
                ? const Center(child: Text('There are no items in the list'))
                : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Item'),
                          content: const Text('Do you want to delete this item?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('No'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Yes'),
                              onPressed: () {
                                _removeItem(index);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: ListTile(
                    leading: Text('${index + 1}'),
                    title: Text(_items[index].name),
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
