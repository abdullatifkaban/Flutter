# Hafta 4: Yerel Veritabanı ve CRUD İşlemleri

Bu haftada HabitMaster uygulamamıza SQLite veritabanı entegrasyonu yapacağız ve CRUD işlemlerini gerçekleştireceğiz.

## 🎯 Hedefler

- SQLite veritabanı kurulumu
- Temel CRUD işlemleri
- Repository pattern
- Veri persistance

## 📝 Konu Başlıkları

1. SQLite Veritabanı
   - sqflite paketi kurulumu
   - Veritabanı yapılandırması
   - Tablo oluşturma
   - Migration yönetimi

2. Repository Pattern
   - Repository nedir?
   - Data Access Layer
   - CRUD operasyonları
   - Error handling

3. Veri İşlemleri
   - Alışkanlık kaydetme
   - Alışkanlık güncelleme
   - Alışkanlık silme
   - Alışkanlık sorgulama

## 💻 Adım Adım Uygulama Geliştirme

### 1. Veritabanı Yapılandırması

```dart
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'habit_master.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habits(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        type TEXT NOT NULL,
        reminderTime TEXT NOT NULL,
        frequency INTEGER NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }
}
```

### 2. Repository Implementasyonu

```dart
class HabitRepository {
  final DatabaseHelper _databaseHelper;

  HabitRepository(this._databaseHelper);

  Future<void> insertHabit(Habit habit) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'habits',
      habit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Habit>> getAllHabits() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('habits');
    return List.generate(maps.length, (i) => Habit.fromMap(maps[i]));
  }

  Future<void> updateHabit(Habit habit) async {
    final db = await _databaseHelper.database;
    await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<void> deleteHabit(String id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
```

### 3. Provider Güncelleme

```dart
class HabitProvider extends ChangeNotifier {
  final HabitRepository _repository;
  List<Habit> _habits = [];

  HabitProvider(this._repository) {
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    _habits = await _repository.getAllHabits();
    notifyListeners();
  }

  Future<void> addHabit(Habit habit) async {
    await _repository.insertHabit(habit);
    await _loadHabits();
  }

  Future<void> updateHabit(Habit habit) async {
    await _repository.updateHabit(habit);
    await _loadHabits();
  }

  Future<void> deleteHabit(String id) async {
    await _repository.deleteHabit(id);
    await _loadHabits();
  }
}
```

## 📝 Ödevler

1. Alışkanlık tamamlama geçmişini kaydedin
2. Veritabanı işlemlerini async/await ile optimize edin
3. Hata yakalama ve kullanıcı bildirimleri ekleyin

## 🔍 Sonraki Adımlar

Gelecek hafta:
- PostgreSQL veritabanı entegrasyonu
- REST API tasarımı
- Backend servisleri 