import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoItem> _todos = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _ekleGorev() {
    if (_controller.text.isEmpty) return;

    setState(() {
      _todos.add(
        TodoItem(
          baslik: _controller.text,
          tamamlandi: false,
        ),
      );
      _controller.clear();
    });
  }

  void _durumDegistir(int index) {
    setState(() {
      _todos[index].tamamlandi = !_todos[index].tamamlandi;
    });
  }

  void _gorevSil(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Görevlerim'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Yeni Görev',
                      hintText: 'Görev başlığını girin',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _ekleGorev,
                  child: const Text('Ekle'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: todo.tamamlandi,
                      onChanged: (_) => _durumDegistir(index),
                    ),
                    title: Text(
                      todo.baslik,
                      style: TextStyle(
                        decoration: todo.tamamlandi
                            ? TextDecoration.lineThrough
                            : null,
                        color: todo.tamamlandi ? Colors.grey : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _gorevSil(index),
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

class TodoItem {
  String baslik;
  bool tamamlandi;

  TodoItem({
    required this.baslik,
    required this.tamamlandi,
  });
} 