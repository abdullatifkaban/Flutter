# Hafta 5 - Örnek Uygulama: Not Defteri

Bu örnek uygulama, Flutter'da veri depolama yöntemlerini kullanarak basit bir not defteri uygulaması geliştirmeyi gösterecek.

## 🎯 Uygulama Özellikleri

- Not ekleme, düzenleme ve silme
- Kategori yönetimi
- Etiket sistemi
- Resim ekleme
- Arama ve filtreleme
- Yedekleme ve geri yükleme
- Tema ve görünüm ayarları

## 📱 Ekran Görüntüleri

[Ekran görüntüleri buraya eklenecek]

## 💻 Uygulama Yapısı

```
lib/
├── models/
│   ├── note.dart
│   ├── category.dart
│   └── tag.dart
├── services/
│   ├── database_helper.dart
│   ├── storage_service.dart
│   └── backup_service.dart
├── screens/
│   ├── home_screen.dart
│   ├── note_form_screen.dart
│   ├── category_screen.dart
│   └── settings_screen.dart
├── widgets/
│   ├── note_card.dart
│   ├── category_chip.dart
│   └── tag_selector.dart
└── main.dart
```

## 🚀 Başlangıç

1. Yeni bir Flutter projesi oluşturun:

```bash
flutter create note_app
cd note_app
```

2. Gerekli bağımlılıkları ekleyin:

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0
  path: ^1.8.3
  shared_preferences: ^2.2.2
  path_provider: ^2.1.1
  image_picker: ^1.0.4
  uuid: ^4.2.1
```

## 💻 Adım Adım Geliştirme

### 1. Veritabanı Yapısı

`lib/services/database_helper.dart` dosyasını oluşturun:

```dart
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static DatabaseHelper get instance => _instance;

  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'notes.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Kategoriler tablosu
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Etiketler tablosu
    await db.execute('''
      CREATE TABLE tags (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        created_at TEXT NOT NULL
      )
    ''');

    // Notlar tablosu
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category_id INTEGER,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id)
          ON DELETE SET NULL
      )
    ''');

    // Not-Etiket ilişki tablosu
    await db.execute('''
      CREATE TABLE note_tags (
        note_id INTEGER NOT NULL,
        tag_id INTEGER NOT NULL,
        PRIMARY KEY (note_id, tag_id),
        FOREIGN KEY (note_id) REFERENCES notes (id)
          ON DELETE CASCADE,
        FOREIGN KEY (tag_id) REFERENCES tags (id)
          ON DELETE CASCADE
      )
    ''');

    // Not resimleri tablosu
    await db.execute('''
      CREATE TABLE note_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        note_id INTEGER NOT NULL,
        path TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (note_id) REFERENCES notes (id)
          ON DELETE CASCADE
      )
    ''');
  }
}
```

### 2. Not Modeli

`lib/models/note.dart` dosyasını oluşturun:

```dart
class Note {
  final int? id;
  String title;
  String content;
  int? categoryId;
  bool isFavorite;
  List<String> imagePaths;
  List<int> tagIds;
  final DateTime createdAt;
  DateTime updatedAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.categoryId,
    this.isFavorite = false,
    this.imagePaths = const [],
    this.tagIds = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category_id': categoryId,
      'is_favorite': isFavorite ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      categoryId: json['category_id'],
      isFavorite: json['is_favorite'] == 1,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    int? categoryId,
    bool? isFavorite,
    List<String>? imagePaths,
    List<int>? tagIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      categoryId: categoryId ?? this.categoryId,
      isFavorite: isFavorite ?? this.isFavorite,
      imagePaths: imagePaths ?? this.imagePaths,
      tagIds: tagIds ?? this.tagIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

### 3. Not Servisi

`lib/services/note_service.dart` dosyasını oluşturun:

```dart
class NoteService {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<int> insertNote(Note note) async {
    final db = await _db.database;
    final noteId = await db.insert('notes', note.toJson());

    // Etiketleri kaydet
    for (final tagId in note.tagIds) {
      await db.insert('note_tags', {
        'note_id': noteId,
        'tag_id': tagId,
      });
    }

    // Resimleri kaydet
    for (final path in note.imagePaths) {
      await db.insert('note_images', {
        'note_id': noteId,
        'path': path,
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    return noteId;
  }

  Future<Note?> getNote(int id) async {
    final db = await _db.database;
    final notes = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (notes.isEmpty) return null;

    final note = Note.fromJson(notes.first);

    // Etiketleri yükle
    final tags = await db.query(
      'note_tags',
      where: 'note_id = ?',
      whereArgs: [id],
    );
    note.tagIds = tags.map((t) => t['tag_id'] as int).toList();

    // Resimleri yükle
    final images = await db.query(
      'note_images',
      where: 'note_id = ?',
      whereArgs: [id],
    );
    note.imagePaths = images.map((i) => i['path'] as String).toList();

    return note;
  }

  Future<List<Note>> getNotes({
    String? search,
    int? categoryId,
    List<int>? tagIds,
    bool? isFavorite,
  }) async {
    final db = await _db.database;
    var query = 'SELECT * FROM notes WHERE 1=1';
    final args = <dynamic>[];

    if (search != null && search.isNotEmpty) {
      query += ' AND (title LIKE ? OR content LIKE ?)';
      args.add('%$search%');
      args.add('%$search%');
    }

    if (categoryId != null) {
      query += ' AND category_id = ?';
      args.add(categoryId);
    }

    if (isFavorite != null) {
      query += ' AND is_favorite = ?';
      args.add(isFavorite ? 1 : 0);
    }

    if (tagIds != null && tagIds.isNotEmpty) {
      query += ''' AND id IN (
        SELECT note_id FROM note_tags
        WHERE tag_id IN (${List.filled(tagIds.length, '?').join(',')})
        GROUP BY note_id
        HAVING COUNT(DISTINCT tag_id) = ?
      )''';
      args.addAll(tagIds);
      args.add(tagIds.length);
    }

    query += ' ORDER BY updated_at DESC';

    final notes = await db.rawQuery(query, args);
    return Future.wait(
      notes.map((n) => getNote(n['id'] as int)).whereType<Future<Note>>(),
    );
  }

  Future<int> updateNote(Note note) async {
    final db = await _db.database;
    note.updatedAt = DateTime.now();

    // Not bilgilerini güncelle
    final result = await db.update(
      'notes',
      note.toJson(),
      where: 'id = ?',
      whereArgs: [note.id],
    );

    // Etiketleri güncelle
    await db.delete(
      'note_tags',
      where: 'note_id = ?',
      whereArgs: [note.id],
    );
    for (final tagId in note.tagIds) {
      await db.insert('note_tags', {
        'note_id': note.id,
        'tag_id': tagId,
      });
    }

    // Resimleri güncelle
    await db.delete(
      'note_images',
      where: 'note_id = ?',
      whereArgs: [note.id],
    );
    for (final path in note.imagePaths) {
      await db.insert('note_images', {
        'note_id': note.id,
        'path': path,
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    return result;
  }

  Future<int> deleteNote(int id) async {
    final db = await _db.database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
```

### 4. Ayarlar Servisi

`lib/services/settings_service.dart` dosyasını oluşturun:

```dart
class SettingsService {
  static const String _themeKey = 'theme_mode';
  static const String _sortByKey = 'sort_by';
  static const String _showPreviewKey = 'show_preview';
  static const String _gridViewKey = 'grid_view';

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_themeKey) ?? ThemeMode.system.index;
    return ThemeMode.values[index];
  }

  Future<void> setSortBy(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sortByKey, value);
  }

  Future<String> getSortBy() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sortByKey) ?? 'updated_at';
  }

  Future<void> setShowPreview(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showPreviewKey, value);
  }

  Future<bool> getShowPreview() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showPreviewKey) ?? true;
  }

  Future<void> setGridView(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_gridViewKey, value);
  }

  Future<bool> getGridView() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_gridViewKey) ?? false;
  }
}
```

### 5. Yedekleme Servisi

`lib/services/backup_service.dart` dosyasını oluşturun:

```dart
class BackupService {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<String> createBackup() async {
    final db = await _db.database;
    final directory = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${directory.path}/backups');
    await backupDir.create(recursive: true);

    final timestamp = DateTime.now().toIso8601String();
    final backupPath = '${backupDir.path}/backup_$timestamp.json';

    // Verileri topla
    final data = {
      'notes': await db.query('notes'),
      'categories': await db.query('categories'),
      'tags': await db.query('tags'),
      'note_tags': await db.query('note_tags'),
      'note_images': await db.query('note_images'),
    };

    // JSON dosyası oluştur
    final file = File(backupPath);
    await file.writeAsString(jsonEncode(data));

    return backupPath;
  }

  Future<void> restoreBackup(String backupPath) async {
    final db = await _db.database;
    final file = File(backupPath);
    final data = jsonDecode(await file.readAsString());

    await db.transaction((txn) async {
      // Mevcut verileri temizle
      await txn.delete('note_images');
      await txn.delete('note_tags');
      await txn.delete('notes');
      await txn.delete('categories');
      await txn.delete('tags');

      // Verileri geri yükle
      for (final category in data['categories']) {
        await txn.insert('categories', category);
      }

      for (final tag in data['tags']) {
        await txn.insert('tags', tag);
      }

      for (final note in data['notes']) {
        await txn.insert('notes', note);
      }

      for (final noteTag in data['note_tags']) {
        await txn.insert('note_tags', noteTag);
      }

      for (final noteImage in data['note_images']) {
        await txn.insert('note_images', noteImage);
      }
    });
  }
}
```

## 🎯 Öğrenilen Kavramlar

1. Veritabanı:
   - SQLite kullanımı
   - İlişkisel tablolar
   - CRUD işlemleri
   - Sorgular ve filtreleme

2. Dosya İşlemleri:
   - Resim depolama
   - JSON dosyaları
   - Yedekleme sistemi
   - Dosya yönetimi

3. Ayarlar:
   - SharedPreferences
   - Tema yönetimi
   - Kullanıcı tercihleri
   - Veri kalıcılığı

## ✅ Alıştırma Önerileri

1. Veritabanı:
   - [ ] Tam metin araması ekleyin
   - [ ] Veritabanı şifreleme ekleyin
   - [ ] Otomatik yedekleme ekleyin
   - [ ] Veritabanı migrasyonu ekleyin

2. Özellikler:
   - [ ] Markdown desteği ekleyin
   - [ ] Ses notu ekleyin
   - [ ] Çizim desteği ekleyin
   - [ ] Hatırlatıcılar ekleyin

3. Kullanıcı Deneyimi:
   - [ ] Sürükle-bırak sıralama
   - [ ] Çoklu seçim işlemleri
   - [ ] Arama önerileri
   - [ ] Gelişmiş filtreleme

## 🔍 Önemli Noktalar

1. Veritabanı:
   - İndeksler kullanın
   - Sorguları optimize edin
   - Toplu işlemleri transaction içinde yapın
   - Veri tutarlılığını kontrol edin

2. Dosyalar:
   - Dosya izinlerini kontrol edin
   - Dosya boyutlarını optimize edin
   - Önbellek kullanın
   - Hata kontrolü yapın

3. Performans:
   - Lazy loading kullanın
   - Bellek kullanımını optimize edin
   - Sorgu sonuçlarını önbelleğe alın
   - Büyük listeleri sayfalayın

## 📚 Faydalı Kaynaklar

- [SQLite Guide](https://pub.dev/packages/sqflite)
- [File Operations](https://api.flutter.dev/flutter/dart-io/File-class.html)
- [SharedPreferences](https://pub.dev/packages/shared_preferences)
- [Path Provider](https://pub.dev/packages/path_provider) 