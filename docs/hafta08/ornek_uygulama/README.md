# Hafta 8 - Örnek Uygulama: Güvenli Şifre Yöneticisi

Bu örnek uygulama, Flutter'da güvenlik ve kimlik doğrulama konularını pratik olarak göstermek için tasarlanmış güvenli bir şifre yöneticisi uygulamasıdır.

## 🎯 Uygulama Özellikleri

1. Kimlik Doğrulama:
   - Email/şifre ile giriş
   - Google ile giriş
   - Biometrik kimlik doğrulama
   - PIN koruması

2. Şifre Güvenliği:
   - AES-256 şifreleme
   - Güvenli depolama
   - Otomatik şifre oluşturma
   - Güçlü şifre kontrolü

3. Güvenlik Özellikleri:
   - Otomatik kilit
   - Güvenli mod
   - Acil silme
   - Aktivite günlüğü

## 📱 Ekran Tasarımları

[Ekran tasarımlarının görselleri]

## 💻 Uygulama Yapısı

```
lib/
├── auth/
│   ├── auth_service.dart
│   ├── biometric_service.dart
│   └── pin_service.dart
├── encryption/
│   ├── encryption_service.dart
│   └── password_generator.dart
├── models/
│   ├── password_entry.dart
│   └── user.dart
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── passwords/
│   │   ├── password_list_screen.dart
│   │   ├── password_detail_screen.dart
│   │   └── add_password_screen.dart
│   └── settings/
│       ├── security_settings.dart
│       └── backup_settings.dart
├── services/
│   ├── secure_storage.dart
│   └── backup_service.dart
└── main.dart
```

## 🚀 Başlangıç

1. Yeni bir Flutter projesi oluşturun:

```bash
flutter create secure_password_manager
cd secure_password_manager
```

2. Gerekli bağımlılıkları ekleyin:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  google_sign_in: ^6.2.1
  flutter_secure_storage: ^9.0.0
  local_auth: ^2.1.7
  encrypt: ^5.0.3
  crypto: ^3.0.3
  path_provider: ^2.1.1
```

## 💻 Adım Adım Geliştirme

### 1. Şifre Modeli

`lib/models/password_entry.dart`:

```dart
class PasswordEntry {
  final String id;
  final String title;
  final String username;
  final String password;
  final String? website;
  final String? notes;
  final DateTime createdAt;
  final DateTime lastModified;
  final bool isFavorite;

  PasswordEntry({
    required this.id,
    required this.title,
    required this.username,
    required this.password,
    this.website,
    this.notes,
    required this.createdAt,
    required this.lastModified,
    this.isFavorite = false,
  });

  PasswordEntry copyWith({
    String? id,
    String? title,
    String? username,
    String? password,
    String? website,
    String? notes,
    DateTime? createdAt,
    DateTime? lastModified,
    bool? isFavorite,
  }) {
    return PasswordEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      username: username ?? this.username,
      password: password ?? this.password,
      website: website ?? this.website,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'username': username,
      'password': password,
      'website': website,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }

  factory PasswordEntry.fromMap(Map<String, dynamic> map) {
    return PasswordEntry(
      id: map['id'],
      title: map['title'],
      username: map['username'],
      password: map['password'],
      website: map['website'],
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
      lastModified: DateTime.parse(map['lastModified']),
      isFavorite: map['isFavorite'] ?? false,
    );
  }
}
```

### 2. Şifre Oluşturucu

`lib/encryption/password_generator.dart`:

```dart
class PasswordGenerator {
  static const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _numbers = '0123456789';
  static const String _special = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  static String generatePassword({
    int length = 16,
    bool useLowercase = true,
    bool useUppercase = true,
    bool useNumbers = true,
    bool useSpecial = true,
  }) {
    String chars = '';
    if (useLowercase) chars += _lowercase;
    if (useUppercase) chars += _uppercase;
    if (useNumbers) chars += _numbers;
    if (useSpecial) chars += _special;

    if (chars.isEmpty) return '';

    final random = Random.secure();
    final codeUnits = List.generate(
      length,
      (index) => chars.codeUnitAt(random.nextInt(chars.length)),
    );

    return String.fromCharCodes(codeUnits);
  }

  static double checkPasswordStrength(String password) {
    if (password.isEmpty) return 0.0;

    double strength = 0.0;
    
    // Uzunluk kontrolü
    if (password.length >= 8) strength += 0.2;
    if (password.length >= 12) strength += 0.2;

    // Karakter çeşitliliği kontrolü
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.2;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.2;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.2;
    if (password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) strength += 0.2;

    return strength > 1.0 ? 1.0 : strength;
  }
}
```

### 3. Şifre Yönetim Servisi

`lib/services/password_service.dart`:

```dart
class PasswordService {
  final EncryptionService _encryption;
  final SecureStorage _storage;

  PasswordService({
    required EncryptionService encryption,
    required SecureStorage storage,
  })  : _encryption = encryption,
        _storage = storage;

  // Şifre kaydetme
  Future<void> savePassword(PasswordEntry entry) async {
    final encryptedEntry = _encryption.encryptPasswordEntry(entry);
    final json = jsonEncode(encryptedEntry.toMap());
    await _storage.write('password_${entry.id}', json);
  }

  // Şifre getirme
  Future<PasswordEntry?> getPassword(String id) async {
    final json = await _storage.read('password_$id');
    if (json == null) return null;

    final map = jsonDecode(json);
    final encryptedEntry = PasswordEntry.fromMap(map);
    return _encryption.decryptPasswordEntry(encryptedEntry);
  }

  // Tüm şifreleri getirme
  Future<List<PasswordEntry>> getAllPasswords() async {
    final allKeys = await _storage.getAllKeys();
    final passwordKeys = allKeys.where((key) => key.startsWith('password_'));

    final passwords = <PasswordEntry>[];
    for (final key in passwordKeys) {
      final entry = await getPassword(key.substring(9));
      if (entry != null) passwords.add(entry);
    }

    return passwords;
  }

  // Şifre silme
  Future<void> deletePassword(String id) async {
    await _storage.delete('password_$id');
  }

  // Tüm şifreleri silme
  Future<void> deleteAllPasswords() async {
    final allKeys = await _storage.getAllKeys();
    final passwordKeys = allKeys.where((key) => key.startsWith('password_'));

    for (final key in passwordKeys) {
      await _storage.delete(key);
    }
  }

  // Şifre yedekleme
  Future<String> exportPasswords() async {
    final passwords = await getAllPasswords();
    final exportData = {
      'version': '1.0',
      'timestamp': DateTime.now().toIso8601String(),
      'passwords': passwords.map((e) => e.toMap()).toList(),
    };
    return jsonEncode(exportData);
  }

  // Yedekten geri yükleme
  Future<void> importPasswords(String jsonData) async {
    final data = jsonDecode(jsonData);
    final passwords = (data['passwords'] as List)
        .map((e) => PasswordEntry.fromMap(e))
        .toList();

    for (final password in passwords) {
      await savePassword(password);
    }
  }
}
```

## 🎯 Ödevler

1. Kimlik Doğrulama:
   - [ ] Apple ile giriş ekleyin
   - [ ] İki faktörlü doğrulama ekleyin
   - [ ] Güvenlik soruları ekleyin
   - [ ] Oturum yönetimi geliştirin

2. Şifre Güvenliği:
   - [ ] Şifre analizi ekleyin
   - [ ] Güvenlik açığı kontrolü ekleyin
   - [ ] Otomatik şifre değiştirme ekleyin
   - [ ] Güvenli paylaşım ekleyin

3. Güvenlik Özellikleri:
   - [ ] Güvenlik raporu ekleyin
   - [ ] Aktivite günlüğü ekleyin
   - [ ] Uzaktan silme ekleyin
   - [ ] Sahte veri sistemi ekleyin

## 🔍 Kontrol Listesi

Her değişiklik sonrası şunları kontrol edin:
- [ ] Kimlik doğrulama düzgün çalışıyor mu?
- [ ] Şifreleme/çözme işlemleri doğru mu?
- [ ] Güvenli depolama çalışıyor mu?
- [ ] Otomatik kilit sistemi aktif mi?

## 💡 İpuçları

1. Güvenlik:
   - Güçlü şifreleme kullanın
   - Anahtarları güvenli saklayın
   - Düzenli güvenlik denetimi yapın
   - Hata mesajlarını gizleyin

2. Performans:
   - Şifreleme işlemlerini optimize edin
   - Önbellek kullanın
   - Batch işlemleri yapın
   - Lazy loading kullanın

3. Kullanıcı Deneyimi:
   - Kolay kullanım sağlayın
   - Güvenlik ayarlarını basitleştirin
   - Yardım/ipucu ekleyin
   - Hata mesajlarını anlaşılır yapın

## 📚 Faydalı Kaynaklar

- [Flutter Security Best Practices](https://flutter.dev/security)
- [Firebase Auth Documentation](https://firebase.flutter.dev/docs/auth/overview)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [Local Auth Plugin](https://pub.dev/packages/local_auth) 