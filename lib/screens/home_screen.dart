import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../widgets/todo_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Todo> _todos = [];
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _addTodo() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tugas tidak boleh kosong!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final newTodo = Todo(id: DateTime.now().toString(), title: text);
    setState(() {
      _todos.insert(0, newTodo);
      _controller.clear();
      _listKey.currentState?.insertItem(0);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tugas berhasil ditambahkan!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteTodoWithAnimation(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) return;

    final removedItem = _todos[index];
    setState(() {
      _todos.removeAt(index);
      _listKey.currentState?.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: TodoItem(
            todo: removedItem,
            onToggle: _toggleTodo,
            onDelete: _deleteTodoWithAnimation,
          ),
        ),
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  void _toggleTodo(String id) {
    setState(() {
      final todo = _todos.firstWhere((todo) => todo.id == id);
      todo.isDone = !todo.isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Tugas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Tambahkan Tugas',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: _todos.length,
              itemBuilder: (context, index, animation) {
                final todo = _todos[index];
                return SizeTransition(
                  sizeFactor: animation,
                  child: TodoItem(
                    todo: todo,
                    onToggle: _toggleTodo,
                    onDelete: _deleteTodoWithAnimation,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        backgroundColor: const Color.fromRGBO(63, 63, 63, 1),
        tooltip: 'Tambah Tugas',
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
