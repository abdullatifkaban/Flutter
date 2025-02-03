# Hafta 5 - Ana Proje: Veri Depolama ve Kalıcılık

Bu hafta, alışkanlık takip uygulamamıza veri depolama ve kalıcılık özelliklerini ekleyeceğiz.

## 🎯 Hedefler

1. Alışkanlık Verileri
   - SQLite veritabanı entegrasyonu
   - Alışkanlık tablosu tasarımı
   - İlerleme kayıtları
   - İstatistik verileri

2. Kullanıcı Ayarları
   - SharedPreferences kullanımı
   - Tema ayarları
   - Bildirim tercihleri
   - Görünüm seçenekleri

3. Dosya İşlemleri
   - Profil fotoğrafı
   - Alışkanlık ikonları
   - İstatistik grafikleri
   - Başarı rozetleri

4. Veri Yedekleme
   - JSON formatında yedekleme
   - Geri yükleme sistemi
   - Otomatik yedekleme
   - Bulut senkronizasyonu

## 📱 Ekran Tasarımları

[Ekran tasarımlarının görselleri]

## 💻 Uygulama Yapısı

```
lib/
├── models/
│   ├── habit.dart
│   ├── progress.dart
│   └── settings.dart
├── services/
│   ├── database_helper.dart
│   ├── settings_service.dart
│   └── backup_service.dart
├── screens/
│   ├── settings_screen.dart
│   ├── statistics_screen.dart
│   └── backup_screen.dart
└── widgets/
    ├── settings_card.dart
    ├── progress_chart.dart
    └── backup_card.dart
```

## 🚀 Başlangıç

1. Yeni bağımlılıkları ekleyin:

```yaml
dependencies:
  sqflite: ^2.3.0
  path: ^1.8.3
  shared_preferences: ^2.2.2
  path_provider: ^2.1.1
  image_picker: ^1.0.4
  fl_chart: ^0.65.0
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
    final dbPath = join(path, 'habits.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Alışkanlıklar tablosu
    await db.execute('''
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        icon TEXT,
        color INTEGER NOT NULL,
        frequency TEXT NOT NULL,
        reminder_time TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // İlerleme kayıtları tablosu
    await db.execute('''
      CREATE TABLE progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habit_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        status INTEGER NOT NULL,
        note TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (habit_id) REFERENCES habits (id)
          ON DELETE CASCADE
      )
    ''');

    // İstatistikler tablosu
    await db.execute('''
      CREATE TABLE statistics (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habit_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        success_rate REAL NOT NULL,
        streak_count INTEGER NOT NULL,
        total_completed INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (habit_id) REFERENCES habits (id)
          ON DELETE CASCADE
      )
    ''');

    // Rozetler tablosu
    await db.execute('''
      CREATE TABLE badges (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habit_id INTEGER NOT NULL,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        icon TEXT NOT NULL,
        earned_at TEXT NOT NULL,
        FOREIGN KEY (habit_id) REFERENCES habits (id)
          ON DELETE CASCADE
      )
    ''');
  }
}
```

### 2. Alışkanlık Modeli

`lib/models/habit.dart` dosyasını oluşturun:

```dart
enum HabitFrequency {
  daily,
  weekly,
  monthly,
  custom,
}

class Habit {
  final int? id;
  String title;
  String? description;
  String? icon;
  int color;
  HabitFrequency frequency;
  String? reminderTime;
  final DateTime createdAt;
  DateTime updatedAt;

  Habit({
    this.id,
    required this.title,
    this.description,
    this.icon,
    required this.color,
    required this.frequency,
    this.reminderTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'color': color,
      'frequency': frequency.name,
      'reminder_time': reminderTime,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
      frequency: HabitFrequency.values.byName(json['frequency']),
      reminderTime: json['reminder_time'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
```

### 3. İlerleme Modeli

`lib/models/progress.dart` dosyasını oluşturun:

```dart
enum ProgressStatus {
  completed,
  skipped,
  failed,
}

class Progress {
  final int? id;
  final int habitId;
  final DateTime date;
  ProgressStatus status;
  String? note;
  final DateTime createdAt;

  Progress({
    this.id,
    required this.habitId,
    required this.date,
    required this.status,
    this.note,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habit_id': habitId,
      'date': date.toIso8601String(),
      'status': status.index,
      'note': note,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      id: json['id'],
      habitId: json['habit_id'],
      date: DateTime.parse(json['date']),
      status: ProgressStatus.values[json['status']],
      note: json['note'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
```

### 4. Ayarlar Servisi

`lib/services/settings_service.dart` dosyasını oluşturun:

```dart
class SettingsService {
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _reminderTimeKey = 'reminder_time';
  static const String _weekStartKey = 'week_start';
  static const String _chartTypeKey = 'chart_type';

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_themeKey) ?? ThemeMode.system.index;
    return ThemeMode.values[index];
  }

  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'tr';
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, enabled);
  }

  Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsKey) ?? true;
  }

  Future<void> setReminderTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _reminderTimeKey,
      '${time.hour}:${time.minute}',
    );
  }

  Future<TimeOfDay> getReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timeStr = prefs.getString(_reminderTimeKey) ?? '20:00';
    final parts = timeStr.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  Future<void> setWeekStart(int weekday) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_weekStartKey, weekday);
  }

  Future<int> getWeekStart() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_weekStartKey) ?? DateTime.monday;
  }

  Future<void> setChartType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chartTypeKey, type);
  }

  Future<String> getChartType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_chartTypeKey) ?? 'line';
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
      'habits': await db.query('habits'),
      'progress': await db.query('progress'),
      'statistics': await db.query('statistics'),
      'badges': await db.query('badges'),
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
      await txn.delete('badges');
      await txn.delete('statistics');
      await txn.delete('progress');
      await txn.delete('habits');

      // Verileri geri yükle
      for (final habit in data['habits']) {
        await txn.insert('habits', habit);
      }

      for (final progress in data['progress']) {
        await txn.insert('progress', progress);
      }

      for (final statistic in data['statistics']) {
        await txn.insert('statistics', statistic);
      }

      for (final badge in data['badges']) {
        await txn.insert('badges', badge);
      }
    });
  }

  Future<void> scheduleBackup() async {
    // TODO: Otomatik yedekleme için WorkManager eklenecek
  }

  Future<void> syncWithCloud() async {
    // TODO: Firebase veya başka bir bulut servisi entegrasyonu
  }
}
```

## 🎯 Ödevler

1. Veritabanı:
   - [ ] Tam metin araması ekleyin
   - [ ] İndeksler oluşturun
   - [ ] Veritabanı şifreleme ekleyin
   - [ ] Veritabanı migrasyonu ekleyin

2. Ayarlar:
   - [ ] Yeni tema seçenekleri ekleyin
   - [ ] Dil desteği ekleyin
   - [ ] Veri silme seçeneği ekleyin
   - [ ] Veri dışa aktarma ekleyin

3. Yedekleme:
   - [ ] Otomatik yedekleme ekleyin
   - [ ] Google Drive entegrasyonu ekleyin
   - [ ] Yedekleme şifreleme ekleyin
   - [ ] Yedekleme geçmişi ekleyin

## 🔍 Kontrol Listesi

Her değişiklik sonrası şunları kontrol edin:
- [ ] Veriler doğru kaydediliyor mu?
- [ ] Ayarlar kalıcı olarak saklanıyor mu?
- [ ] Yedekleme ve geri yükleme çalışıyor mu?
- [ ] Dosya işlemleri hatasız çalışıyor mu?

## 💡 İpuçları

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
- [SharedPreferences](https://pub.dev/packages/shared_preferences)
- [File Operations](https://api.flutter.dev/flutter/dart-io/File-class.html)
- [Path Provider](https://pub.dev/packages/path_provider) 