# Hafta 2 - Örnek Uygulama: TODO List

Bu örnek uygulama, Flutter'da liste görünümleri ve kullanıcı etkileşimlerini öğrenmek için geliştirilmiş bir TODO List uygulamasıdır.

## 🎯 Uygulama Özellikleri

- Görev ekleme/silme/düzenleme
- Görev listesi görünümü
- Görev detay sayfası
- Form validasyonu
- Sürükle-bırak sıralama
- Kategori filtreleme

## 📱 Ekran Görüntüleri

[Ekran görüntüleri buraya eklenecek]

## 🚀 Başlangıç

1. Yeni bir Flutter projesi oluşturun:
```bash
flutter create todo_list
cd todo_list
```

2. `pubspec.yaml` dosyasını güncelleyin:
```yaml
name: todo_list
description: Gelişmiş TODO List uygulaması.

dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1        # State yönetimi için
  uuid: ^4.2.1           # Benzersiz ID üretmek için
  intl: ^0.18.1          # Tarih formatlaması için
```

## 💻 Adım Adım Geliştirme

### 1. Veri Modeli

`lib/models/todo.dart` dosyasını oluşturun:

```dart
class Todo {
  final String id;
  String baslik;
  String? aciklama;
  bool tamamlandi;
  DateTime olusturulmaTarihi;
  String? kategori;

  Todo({
    required this.baslik,
    this.aciklama,
    this.tamamlandi = false,
    String? id,
    DateTime? olusturulmaTarihi,
    this.kategori,
  })  : id = id ?? const Uuid().v4(),
        olusturulmaTarihi = olusturulmaTarihi ?? DateTime.now();

  Todo copyWith({
    String? baslik,
    String? aciklama,
    bool? tamamlandi,
    String? kategori,
  }) {
    return Todo(
      id: id,
      baslik: baslik ?? this.baslik,
      aciklama: aciklama ?? this.aciklama,
      tamamlandi: tamamlandi ?? this.tamamlandi,
      olusturulmaTarihi: olusturulmaTarihi,
      kategori: kategori ?? this.kategori,
    );
  }
}
```

### 2. State Yönetimi

`lib/providers/todo_provider.dart` dosyasını oluşturun:

```dart
class TodoProvider with ChangeNotifier {
  final List<Todo> _todos = [];
  String? _selectedCategory;

  List<Todo> get todos => _selectedCategory == null
      ? _todos
      : _todos.where((todo) => todo.kategori == _selectedCategory).toList();

  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void toggleTodo(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index >= 0) {
      _todos[index].tamamlandi = !_todos[index].tamamlandi;
      notifyListeners();
    }
  }

  void updateTodo(Todo todo) {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index >= 0) {
      _todos[index] = todo;
      notifyListeners();
    }
  }

  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void reorderTodos(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final todo = _todos.removeAt(oldIndex);
    _todos.insert(newIndex, todo);
    notifyListeners();
  }
}
```

### 3. Liste Görünümü

`lib/screens/todo_list_screen.dart` dosyasını oluşturun:

```dart
class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Görevlerim'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showCategoryFilter(context),
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, provider, child) {
          if (provider.todos.isEmpty) {
            return const Center(
              child: Text('Henüz görev eklenmedi'),
            );
          }

          return ReorderableListView.builder(
            itemCount: provider.todos.length,
            onReorder: provider.reorderTodos,
            itemBuilder: (context, index) {
              final todo = provider.todos[index];
              return TodoListItem(
                key: ValueKey(todo.id),
                todo: todo,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCategoryFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const CategoryFilterSheet(),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const TodoFormDialog(),
    );
  }
}
```

### 4. Liste Öğesi Widget'ı

`lib/widgets/todo_list_item.dart` dosyasını oluşturun:

```dart
class TodoListItem extends StatelessWidget {
  final Todo todo;

  const TodoListItem({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(todo.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        context.read<TodoProvider>().deleteTodo(todo.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Görev silindi'),
          ),
        );
      },
      child: ListTile(
        leading: Checkbox(
          value: todo.tamamlandi,
          onChanged: (_) {
            context.read<TodoProvider>().toggleTodo(todo.id);
          },
        ),
        title: Text(
          todo.baslik,
          style: TextStyle(
            decoration: todo.tamamlandi ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: todo.aciklama != null ? Text(todo.aciklama!) : null,
        trailing: todo.kategori != null
            ? Chip(
                label: Text(todo.kategori!),
              )
            : null,
        onTap: () => _showTodoDetails(context),
      ),
    );
  }

  void _showTodoDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoDetailScreen(todo: todo),
      ),
    );
  }
}
```

### 5. Görev Ekleme/Düzenleme Formu

`lib/widgets/todo_form_dialog.dart` dosyasını oluşturun:

```dart
class TodoFormDialog extends StatefulWidget {
  final Todo? todo;

  const TodoFormDialog({
    super.key,
    this.todo,
  });

  @override
  State<TodoFormDialog> createState() => _TodoFormDialogState();
}

class _TodoFormDialogState extends State<TodoFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _baslikController;
  late final TextEditingController _aciklamaController;
  String? _kategori;

  @override
  void initState() {
    super.initState();
    _baslikController = TextEditingController(text: widget.todo?.baslik);
    _aciklamaController = TextEditingController(text: widget.todo?.aciklama);
    _kategori = widget.todo?.kategori;
  }

  @override
  void dispose() {
    _baslikController.dispose();
    _aciklamaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.todo == null ? 'Yeni Görev' : 'Görevi Düzenle'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _baslikController,
              decoration: const InputDecoration(
                labelText: 'Başlık',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Başlık boş olamaz';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _aciklamaController,
              decoration: const InputDecoration(
                labelText: 'Açıklama',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Kişisel',
                  child: Text('Kişisel'),
                ),
                DropdownMenuItem(
                  value: 'İş',
                  child: Text('İş'),
                ),
                DropdownMenuItem(
                  value: 'Alışveriş',
                  child: Text('Alışveriş'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _kategori = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: _saveForm,
          child: const Text('Kaydet'),
        ),
      ],
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final todo = Todo(
        id: widget.todo?.id,
        baslik: _baslikController.text,
        aciklama: _aciklamaController.text.isEmpty
            ? null
            : _aciklamaController.text,
        kategori: _kategori,
        tamamlandi: widget.todo?.tamamlandi ?? false,
        olusturulmaTarihi: widget.todo?.olusturulmaTarihi,
      );

      if (widget.todo == null) {
        context.read<TodoProvider>().addTodo(todo);
      } else {
        context.read<TodoProvider>().updateTodo(todo);
      }

      Navigator.pop(context);
    }
  }
}
```

## 🎯 Öğrenilen Kavramlar

1. Liste Widget'ları:
   - ReorderableListView kullanımı
   - Dismissible widget'ı
   - ListView.builder optimizasyonu

2. Form İşlemleri:
   - Form validasyonu
   - TextFormField kullanımı
   - DropdownButtonFormField

3. Dialog ve Bottom Sheet:
   - AlertDialog
   - ModalBottomSheet
   - Custom dialog tasarımı

4. State Yönetimi:
   - Provider pattern
   - ChangeNotifier kullanımı
   - Consumer widget'ı

## ✅ Alıştırma Önerileri

1. Yeni Özellikler:
   - [ ] Görev bitiş tarihi ekleyin
   - [ ] Alt görevler ekleyin
   - [ ] Öncelik seviyeleri ekleyin
   - [ ] Etiketleme sistemi ekleyin

2. UI İyileştirmeleri:
   - [ ] Görev kartları tasarlayın
   - [ ] Animasyonlu geçişler ekleyin
   - [ ] Tema desteği ekleyin
   - [ ] İlerleme göstergesi ekleyin

## 🔍 Önemli Noktalar

1. Performans:
   - ListView.builder kullanımı
   - const constructor'lar
   - Provider optimizasyonu

2. Kullanıcı Deneyimi:
   - Form validasyonu
   - Hata mesajları
   - Loading durumları
   - Geri bildirimler

3. Kod Organizasyonu:
   - Widget parçalama
   - Provider yapısı
   - Model sınıfları

## 📚 Faydalı Kaynaklar

- [Flutter ListView Cookbook](https://flutter.dev/docs/cookbook/lists)
- [Form Validation Cookbook](https://flutter.dev/docs/cookbook/forms)
- [Provider Package](https://pub.dev/packages/provider)
- [Dismissible Widget](https://api.flutter.dev/flutter/widgets/Dismissible-class.html) 