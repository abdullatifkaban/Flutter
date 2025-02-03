# Hafta 5 - Alışkanlık Takip Uygulaması: PostgreSQL Entegrasyonu

Bu hafta, uygulamamıza PostgreSQL veritabanı entegrasyonunu ekleyeceğiz.

## 📱 Bu Haftanın Yenilikleri

- PostgreSQL veritabanı tasarımı
- Veritabanı bağlantısı
- CRUD işlemleri
- Veri modelleri
- Veritabanı güvenliği

## 🚀 Kurulum Adımları

1. Gerekli paketleri `pubspec.yaml` dosyasına ekleyin:
```yaml
dependencies:
  postgres: ^2.6.3
  dotenv: ^4.2.0
  crypto: ^3.0.3
```

2. `lib` klasörü altında aşağıdaki dosyaları oluşturun:
   - `database/postgres_connection.dart`
   - `models/habit.dart`
   - `repositories/habit_repository.dart`
   - `services/database_service.dart`
   - `utils/database_helper.dart`

## 🔍 Kod İncelemesi

### 1. Veritabanı Bağlantısı
```dart
class PostgresConnection {
  static final PostgresConnection _instance = PostgresConnection._internal();
  Connection? _connection;

  factory PostgresConnection() {
    return _instance;
  }

  PostgresConnection._internal();

  Future<Connection> get connection async {
    if (_connection != null) return _connection!;
    
    _connection = await connect(
      host: ENV['DB_HOST'],
      port: int.parse(ENV['DB_PORT']),
      database: ENV['DB_NAME'],
      username: ENV['DB_USER'],
      password: ENV['DB_PASSWORD'],
    );
    
    return _connection!;
  }
}
```

### 2. Veri Modeli
```dart
class Habit {
  final int? id;
  final String title;
  final String description;
  final int frequency;
  final DateTime createdAt;
  final DateTime? completedAt;

  Habit({
    this.id,
    required this.title,
    required this.description,
    required this.frequency,
    required this.createdAt,
    this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'frequency': frequency,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      frequency: map['frequency'],
      createdAt: DateTime.parse(map['created_at']),
      completedAt: map['completed_at'] != null 
        ? DateTime.parse(map['completed_at']) 
        : null,
    );
  }
}
```

### 3. Repository Sınıfı
```dart
class HabitRepository {
  final PostgresConnection _db = PostgresConnection();

  Future<List<Habit>> getAllHabits() async {
    final conn = await _db.connection;
    final results = await conn.query('SELECT * FROM habits');
    
    return results.map((row) => Habit.fromMap(row.toColumnMap())).toList();
  }

  Future<Habit> createHabit(Habit habit) async {
    final conn = await _db.connection;
    final result = await conn.query(
      'INSERT INTO habits (title, description, frequency, created_at) '
      'VALUES (@title, @description, @frequency, @created_at) '
      'RETURNING *',
      substitutionValues: habit.toMap(),
    );
    
    return Habit.fromMap(result.first.toColumnMap());
  }

  Future<bool> deleteHabit(int id) async {
    final conn = await _db.connection;
    final result = await conn.execute(
      'DELETE FROM habits WHERE id = @id',
      substitutionValues: {'id': id},
    );
    
    return result == 1;
  }
}
```

## 🎯 Öğrenme Hedefleri

Bu hafta:
- PostgreSQL veritabanı tasarımını
- Veritabanı bağlantı yönetimini
- CRUD operasyonlarını
- Veri modellemesini
öğrenmiş olacaksınız.

## 📝 Özelleştirme Önerileri

1. Veritabanı:
   - İndeksler ekleyin
   - Yedekleme stratejisi oluşturun
   - Performans optimizasyonu yapın
   - Bağlantı havuzu ekleyin

2. Güvenlik:
   - SSL bağlantısı ekleyin
   - Şifreleme uygulayın
   - Kullanıcı yetkilendirmesi ekleyin
   - SQL injection önlemleri alın

3. Veri Modelleri:
   - İlişkisel tablolar ekleyin
   - Veri doğrulama ekleyin
   - Veri dönüşümleri ekleyin
   - Özel sorgular yazın

## 💡 Sonraki Hafta

Gelecek hafta ekleyeceğimiz özellikler:
- İlişkisel tablolar
- Kompleks sorgular
- Veritabanı optimizasyonu
- Yedekleme sistemi

## 🔍 Önemli Notlar

- Veritabanı bağlantı bilgilerini güvenli tutun
- Hata yönetimini düzgün yapın
- Veritabanı şemasını versiyonlayın
- Performans metriklerini takip edin 