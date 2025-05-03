import 'package:shared_preferences/shared_preferences.dart';

class TodoStorage {
  static const String _key = 'todo_list';

  Future<void> saveTodoList(List<String> todos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, todos);
  }

  Future<List<String>> loadTodoList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }
}
