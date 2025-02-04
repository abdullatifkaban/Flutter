# Hafta 5 - Veri Depolama ve Kalıcılık

Bu hafta, Flutter uygulamalarında veri depolama ve kalıcılık konularını öğreneceğiz.

## 🎯 Bu Hafta Neler Öğreneceğiz?

1. Veri Depolama Temelleri
   - Veri tipleri ve formatları
   - Depolama yöntemleri
   - Veri güvenliği
   - CRUD operasyonları

2. SharedPreferences
   - Basit veri depolama
   - Anahtar-değer çiftleri
   - Veri tipleri
   - Ayarlar yönetimi

3. SQLite Veritabanı
   - Tablo yapısı
   - SQL sorguları
   - CRUD işlemleri
   - İlişkisel veriler

4. Dosya İşlemleri
   - Dosya okuma/yazma
   - Dizin yönetimi
   - Resim depolama
   - Dosya paylaşımı

## 📚 Konu Anlatımı

### SharedPreferences

1. **Kurulum**:
   ```yaml
   dependencies:
     shared_preferences: ^2.2.2
   ```

2. **Temel Kullanım**:
   ```dart
   // Örnek veri kaydetme
   final prefs = await SharedPreferences.getInstance();
   await prefs.setString('username', 'ahmet');
   await prefs.setInt('age', 25);
   await prefs.setBool('isLoggedIn', true);

   // Veri okuma
   final username = prefs.getString('username') ?? 'misafir';
   final age = prefs.getInt('age') ?? 0;
   final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

   // Veri silme
   await prefs.remove('username');
   
   // Tüm verileri silme
   await prefs.clear();
   ```

### SQLite Veritabanı

1. **Kurulum**:
   ```yaml
   dependencies:
     sqflite: ^2.3.0
     path: ^1.8.3
   ```

2. **Veritabanı Oluşturma**:
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
       final dbPath = join(path, 'app.db');
       
       return await openDatabase(
         dbPath,
         version: 1,
         onCreate: _onCreate,
       );
     }
     
     Future<void> _onCreate(Database db, int version) async {
       await db.execute('''
         CREATE TABLE users (
           id INTEGER PRIMARY KEY AUTOINCREMENT,
           name TEXT NOT NULL,
           email TEXT UNIQUE NOT NULL,
           created_at TEXT NOT NULL
         )
       ''');
     }
   }
   ```

3. **CRUD İşlemleri**:
   ```dart
   // Veri ekleme
   Future<int> insertUser(Map<String, dynamic> user) async {
     final db = await database;
     return await db.insert('users', user);
   }
   
   // Veri okuma
   Future<List<Map<String, dynamic>>> getUsers() async {
     final db = await database;
     return await db.query('users');
   }
   
   // Veri güncelleme
   Future<int> updateUser(Map<String, dynamic> user) async {
     final db = await database;
     return await db.update(
       'users',
       user,
       where: 'id = ?',
       whereArgs: [user['id']],
     );
   }
   
   // Veri silme
   Future<int> deleteUser(int id) async {
     final db = await database;
     return await db.delete(
       'users',
       where: 'id = ?',
       whereArgs: [id],
     );
   }
   ```

### Dosya İşlemleri

1. **Dosya Okuma/Yazma**:
   ```dart
   Future<void> writeFile() async {
     final directory = await getApplicationDocumentsDirectory();
     final file = File('${directory.path}/data.txt');
     
     await file.writeAsString('Merhaba Dünya!');
   }
   
   Future<String> readFile() async {
     final directory = await getApplicationDocumentsDirectory();
     final file = File('${directory.path}/data.txt');
     
     if (await file.exists()) {
       return await file.readAsString();
     }
     return '';
   }
   ```

2. **Resim Depolama**:
   ```dart
   Future<void> saveImage(File image) async {
     final directory = await getApplicationDocumentsDirectory();
     final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
     final savedImage = await image.copy('${directory.path}/$fileName');
   }
   
   Future<List<File>> getImages() async {
     final directory = await getApplicationDocumentsDirectory();
     final files = directory.listSync();
     
     return files
         .whereType<File>()
         .where((file) => file.path.endsWith('.jpg'))
         .toList();
   }
   ```

## 💻 Örnek Uygulama: Not Defteri

Bu haftaki örnek uygulamamızda, öğrendiğimiz veri depolama yöntemlerini kullanarak bir not defteri uygulaması geliştireceğiz. Detaylar için [tıklayınız](./ornek_uygulama/README.md).

## 🚀 Ana Proje: Alışkanlık Takip Uygulaması

Bu hafta ana projemizde şunları yapacağız:

1. Alışkanlık verilerini SQLite'da depolama
2. Kullanıcı ayarlarını SharedPreferences ile yönetme
3. İstatistik verilerini yerel dosyalarda saklama
4. Veri yedekleme ve geri yükleme sistemi

Ana proje detayları için [tıklayınız](./ana_proje/README.md).

## 🎯 Alıştırmalar

1. SharedPreferences:
   - [ ] Tema ayarlarını kaydedin
   - [ ] Dil tercihlerini saklayın
   - [ ] Son kullanım bilgilerini tutun
   - [ ] Kullanıcı tercihlerini yönetin

2. SQLite:
   - [ ] Yeni tablolar ekleyin
   - [ ] İlişkisel sorgular yazın
   - [ ] Veritabanı migrasyonu yapın
   - [ ] Toplu veri işlemleri yapın

3. Dosya İşlemleri:
   - [ ] JSON dosyaları oluşturun
   - [ ] Resimleri optimize edin
   - [ ] Dizin yapısı kurun
   - [ ] Dosya paylaşımı ekleyin

## 🔍 Hata Ayıklama İpuçları

- Veritabanı bağlantılarını kontrol edin
- Dosya izinlerini doğrulayın
- Bellek kullanımını optimize edin
- Veri tutarlılığını sağlayın

## 📚 Faydalı Kaynaklar

- [SharedPreferences Guide](https://pub.dev/packages/shared_preferences)
- [SQLite Documentation](https://pub.dev/packages/sqflite)
- [File Operations](https://api.flutter.dev/flutter/dart-io/File-class.html)
- [Path Provider](https://pub.dev/packages/path_provider) 