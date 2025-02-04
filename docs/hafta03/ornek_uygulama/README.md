# Hafta 3 - Örnek Uygulama: Çok Sayfalı TODO List

Bu örnek uygulama, geçen hafta geliştirdiğimiz TODO List uygulamasını çok sayfalı bir yapıya dönüştürerek navigasyon ve durum yönetimi konularını pratikte uygulamamızı sağlayacak.

## 🎯 Yeni Özellikler

- Görev kategorileri sayfası
- Görev detay sayfası
- Ayarlar sayfası
- Alt navigasyon menüsü
- Sayfa geçiş animasyonları
- Global durum yönetimi

## 📱 Ekran Görüntüleri

[Ekran görüntüleri buraya eklenecek]

## 💻 Uygulama Yapısı

```
lib/
├── models/
│   ├── todo.dart
│   └── category.dart
├── providers/
│   ├── todo_provider.dart
│   └── settings_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── categories_screen.dart
│   ├── todo_detail_screen.dart
│   └── settings_screen.dart
├── widgets/
│   ├── todo_list_item.dart
│   ├── category_card.dart
│   └── custom_bottom_nav.dart
└── main.dart
```

## 🚀 Başlangıç

1. Geçen haftaki projeye yeni bağımlılıkları ekleyin:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  uuid: ^4.2.1
  intl: ^0.18.1
  shared_preferences: ^2.2.2  # Ayarları kaydetmek için
  animations: ^2.0.11        # Sayfa geçiş animasyonları için
```

## 💻 Adım Adım Geliştirme

### 1. Ana Sayfa ve Navigasyon

`lib/screens/home_screen.dart` dosyasını oluşturun:

```dart
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  final _screens = [
    const TodoListScreen(),
    const CategoriesScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Görevler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Kategoriler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
      ),
    );
  }
}
```

### 2. Kategori Modeli ve Provider

`lib/models/category.dart` dosyasını oluşturun:

```dart
class Category {
  final String id;
  String ad;
  Color renk;

  Category({
    required this.ad,
    required this.renk,
    String? id,
  }) : id = id ?? const Uuid().v4();

  Category copyWith({
    String? ad,
    Color? renk,
  }) {
    return Category(
      id: id,
      ad: ad ?? this.ad,
      renk: renk ?? this.renk,
    );
  }
}
```

`lib/providers/todo_provider.dart` dosyasını güncelleyin:

```dart
class TodoProvider with ChangeNotifier {
  final List<Todo> _todos = [];
  final List<Category> _categories = [];
  String? _selectedCategoryId;

  List<Todo> get todos => _selectedCategoryId == null
      ? _todos
      : _todos.where((todo) => todo.kategori?.id == _selectedCategoryId).toList();

  List<Category> get categories => _categories;

  void addCategory(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  void updateCategory(Category category) {
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index >= 0) {
      _categories[index] = category;
      notifyListeners();
    }
  }

  void deleteCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
    // Kategoriye ait görevlerin kategorisini null yap
    for (var todo in _todos.where((t) => t.kategori?.id == id)) {
      todo.kategori = null;
    }
    notifyListeners();
  }

  void setSelectedCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }
}
```

### 3. Görev Detay Sayfası

`lib/screens/todo_detail_screen.dart` dosyasını oluşturun:

```dart
class TodoDetailScreen extends StatelessWidget {
  final Todo todo;

  const TodoDetailScreen({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Görev Detayı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.baslik,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (todo.aciklama != null) ...[
              const SizedBox(height: 8),
              Text(todo.aciklama!),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 8),
                Text(
                  DateFormat('d MMMM y').format(todo.olusturulmaTarihi),
                ),
              ],
            ),
            if (todo.kategori != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.category),
                  const SizedBox(width: 8),
                  Text(todo.kategori!.ad),
                ],
              ),
            ],
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Tamamlandı'),
              value: todo.tamamlandi,
              onChanged: (value) {
                context.read<TodoProvider>().toggleTodo(todo.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TodoFormDialog(todo: todo),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Görevi Sil'),
        content: const Text('Bu görevi silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TodoProvider>().deleteTodo(todo.id);
              Navigator.pop(context); // Dialog'u kapat
              Navigator.pop(context); // Detay sayfasını kapat
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}
```

### 4. Ayarlar Sayfası

`lib/screens/settings_screen.dart` dosyasını oluşturun:

```dart
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Karanlık Tema'),
                subtitle: const Text('Uygulamayı karanlık temada görüntüle'),
                value: settings.isDarkMode,
                onChanged: (value) => settings.setDarkMode(value),
              ),
              ListTile(
                title: const Text('Varsayılan Kategori'),
                subtitle: Text(
                  settings.defaultCategoryId == null
                      ? 'Seçilmedi'
                      : context
                          .read<TodoProvider>()
                          .categories
                          .firstWhere(
                            (c) => c.id == settings.defaultCategoryId,
                          )
                          .ad,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showCategoryPicker(context),
              ),
              SwitchListTile(
                title: const Text('Tamamlananları Göster'),
                subtitle: const Text('Tamamlanan görevleri listede göster'),
                value: settings.showCompleted,
                onChanged: (value) => settings.setShowCompleted(value),
              ),
              ListTile(
                title: const Text('Önbelleği Temizle'),
                subtitle: const Text('Tüm görev ve kategori verilerini sıfırla'),
                trailing: const Icon(Icons.delete_forever),
                onTap: () => _showClearCacheDialog(context),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCategoryPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final categories = context.read<TodoProvider>().categories;
        return AlertDialog(
          title: const Text('Varsayılan Kategori'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...categories.map(
                (category) => RadioListTile(
                  title: Text(category.ad),
                  value: category.id,
                  groupValue: context.read<SettingsProvider>().defaultCategoryId,
                  onChanged: (value) {
                    context.read<SettingsProvider>().setDefaultCategory(value);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<SettingsProvider>().setDefaultCategory(null);
                Navigator.pop(context);
              },
              child: const Text('Varsayılanı Kaldır'),
            ),
          ],
        );
      },
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Önbelleği Temizle'),
        content: const Text(
          'Tüm görev ve kategori verileri silinecek. Bu işlem geri alınamaz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Tüm verileri temizle
              context.read<TodoProvider>().clearAll();
              context.read<SettingsProvider>().clearSettings();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Temizle'),
          ),
        ],
      ),
    );
  }
}
```

## 🎯 Öğrenilen Kavramlar

1. Navigasyon:
   - BottomNavigationBar kullanımı
   - Sayfa geçişleri
   - Dialog ve modal yönetimi
   - Geri tuşu kontrolü

2. Durum Yönetimi:
   - Provider ile global state
   - Settings provider
   - Kategori filtreleme
   - Veri kalıcılığı

3. UI/UX:
   - Hero animasyonları
   - Shared element transitions
   - Tema değişimi
   - Form validasyonu

## ✅ Alıştırma Önerileri

1. Yeni Özellikler:
   - [ ] Görev arama sayfası ekleyin
   - [ ] Görev paylaşma özelliği ekleyin
   - [ ] İstatistik sayfası ekleyin
   - [ ] Çoklu dil desteği ekleyin

2. UI İyileştirmeleri:
   - [ ] Özel geçiş animasyonları
   - [ ] Tema renk seçici
   - [ ] Gesture tabanlı işlemler
   - [ ] Pull-to-refresh desteği

## 🔍 Önemli Noktalar

1. Performans:
   - Route önbellekleme
   - Provider optimizasyonu
   - Gereksiz build'leri önleme
   - Bellek yönetimi

2. Kullanıcı Deneyimi:
   - Tutarlı navigasyon
   - Anlamlı animasyonlar
   - Hata yönetimi
   - Yükleme durumları

3. Kod Organizasyonu:
   - Route yönetimi
   - Provider yapılandırması
   - Widget hiyerarşisi
   - Dosya yapısı

## 📚 Faydalı Kaynaklar

- [Flutter Navigation 2.0](https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade)
- [Provider Architecture](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple)
- [Hero Animations](https://flutter.dev/docs/development/ui/animations/hero-animations)
- [SharedPreferences Guide](https://flutter.dev/docs/cookbook/persistence/key-value) 