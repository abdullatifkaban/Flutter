# Hafta 8 - Ana Proje: Güvenlik ve Kimlik Doğrulama

Bu hafta, alışkanlık takip uygulamamıza güvenlik ve kimlik doğrulama özelliklerini ekleyeceğiz.

## 🎯 Hedefler

1. Kullanıcı Kimlik Doğrulama
   - Firebase Authentication entegrasyonu
   - Sosyal medya girişleri
   - Biometrik kimlik doğrulama
   - Oturum yönetimi

2. Güvenli Veri Depolama
   - Şifreli yerel depolama
   - Güvenli yedekleme
   - Veri senkronizasyonu
   - Otomatik kilit sistemi

3. Hassas Bilgi Şifreleme
   - Kişisel verilerin şifrelenmesi
   - Güvenli not sistemi
   - Şifreli paylaşım
   - Güvenli silme

4. Güvenlik Önlemleri
   - SSL pinning
   - Jailbreak/Root tespiti
   - Ekran görüntüsü engelleme
   - Güvenli logging

## 📱 Ekran Tasarımları

[Ekran tasarımlarının görselleri]

## 💻 Uygulama Yapısı

```
lib/
├── auth/
│   ├── auth_service.dart
│   ├── biometric_service.dart
│   └── social_auth.dart
├── security/
│   ├── encryption_service.dart
│   ├── secure_storage.dart
│   └── security_utils.dart
├── models/
│   ├── user.dart
│   └── habit.dart
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── reset_password_screen.dart
│   └── settings/
│       ├── security_settings.dart
│       └── privacy_settings.dart
└── main.dart
```

## 🚀 Başlangıç

1. Yeni bağımlılıkları ekleyin:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  google_sign_in: ^6.2.1
  sign_in_with_apple: ^5.0.0
  flutter_secure_storage: ^9.0.0
  local_auth: ^2.1.7
  encrypt: ^5.0.3
  crypto: ^3.0.3
```

## 💻 Adım Adım Geliştirme

### 1. Kimlik Doğrulama Servisi

`lib/auth/auth_service.dart`:

```dart
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Kullanıcı durumu stream'i
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Email/şifre ile kayıt
  Future<UserCredential?> registerWithEmail(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Kayıt hatası: $e');
      return null;
    }
  }

  // Email/şifre ile giriş
  Future<UserCredential?> loginWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Giriş hatası: $e');
      return null;
    }
  }

  // Google ile giriş
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Google giriş hatası: $e');
      return null;
    }
  }

  // Apple ile giriş
  Future<UserCredential?> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();
      return await _auth.signInWithProvider(appleProvider);
    } catch (e) {
      print('Apple giriş hatası: $e');
      return null;
    }
  }

  // Biometrik kimlik doğrulama
  Future<bool> authenticateWithBiometrics() async {
    try {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) return false;

      return await _localAuth.authenticate(
        localizedReason: 'Lütfen kimliğinizi doğrulayın',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      print('Biometrik doğrulama hatası: $e');
      return false;
    }
  }

  // Şifre sıfırlama
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Şifre sıfırlama hatası: $e');
      rethrow;
    }
  }

  // Çıkış yap
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      print('Çıkış hatası: $e');
      rethrow;
    }
  }
}
```

### 2. Güvenli Depolama Servisi

`lib/security/secure_storage.dart`:

```dart
class SecureStorage {
  final FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // Kullanıcı verilerini kaydetme
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      await _storage.write(
        key: 'user_data',
        value: jsonEncode(userData),
      );
    } catch (e) {
      print('Kullanıcı verisi kaydetme hatası: $e');
      rethrow;
    }
  }

  // Kullanıcı verilerini okuma
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      String? data = await _storage.read(key: 'user_data');
      if (data == null) return null;
      return jsonDecode(data);
    } catch (e) {
      print('Kullanıcı verisi okuma hatası: $e');
      return null;
    }
  }

  // Alışkanlık verilerini kaydetme
  Future<void> saveHabitData(String habitId, Map<String, dynamic> habitData) async {
    try {
      await _storage.write(
        key: 'habit_$habitId',
        value: jsonEncode(habitData),
      );
    } catch (e) {
      print('Alışkanlık verisi kaydetme hatası: $e');
      rethrow;
    }
  }

  // Alışkanlık verilerini okuma
  Future<Map<String, dynamic>?> getHabitData(String habitId) async {
    try {
      String? data = await _storage.read(key: 'habit_$habitId');
      if (data == null) return null;
      return jsonDecode(data);
    } catch (e) {
      print('Alışkanlık verisi okuma hatası: $e');
      return null;
    }
  }

  // Veri silme
  Future<void> deleteData(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      print('Veri silme hatası: $e');
      rethrow;
    }
  }

  // Tüm verileri silme
  Future<void> deleteAllData() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      print('Tüm verileri silme hatası: $e');
      rethrow;
    }
  }
}
```

### 3. Şifreleme Servisi

`lib/security/encryption_service.dart`:

```dart
class EncryptionService {
  late final Encrypter _encrypter;
  late final IV _iv;
  final SecureStorage _secureStorage = SecureStorage();

  // Servis başlatma
  Future<void> initialize() async {
    String? key = await _secureStorage.read('encryption_key');
    if (key == null) {
      key = _generateKey();
      await _secureStorage.write('encryption_key', key);
    }

    _encrypter = Encrypter(AES(Key.fromUtf8(key)));
    _iv = IV.fromLength(16);
  }

  // Rastgele anahtar oluşturma
  String _generateKey() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  // Veri şifreleme
  String encrypt(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  // Şifre çözme
  String decrypt(String encryptedText) {
    final encrypted = Encrypted.fromBase64(encryptedText);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }

  // Alışkanlık şifreleme
  Habit encryptHabit(Habit habit) {
    return Habit(
      id: habit.id,
      title: encrypt(habit.title),
      description: encrypt(habit.description),
      category: encrypt(habit.category),
      createdAt: habit.createdAt,
      isPrivate: habit.isPrivate,
    );
  }

  // Alışkanlık şifre çözme
  Habit decryptHabit(Habit habit) {
    return Habit(
      id: habit.id,
      title: decrypt(habit.title),
      description: decrypt(habit.description),
      category: decrypt(habit.category),
      createdAt: habit.createdAt,
      isPrivate: habit.isPrivate,
    );
  }
}
```

### 4. Güvenlik Yardımcıları

`lib/security/security_utils.dart`:

```dart
class SecurityUtils {
  // Jailbreak/Root kontrolü
  static Future<bool> isDeviceSecure() async {
    if (Platform.isAndroid) {
      return !await RootChecker.isDeviceRooted;
    } else if (Platform.isIOS) {
      return !await JailbreakChecker.isJailbroken;
    }
    return true;
  }

  // SSL Pinning
  static Future<void> setupSSLPinning() async {
    ByteData data = await rootBundle.load('assets/certificates/cert.pem');
    SecurityContext context = SecurityContext.defaultContext;
    context.setTrustedCertificatesBytes(data.buffer.asUint8List());
  }

  // Ekran görüntüsü engelleme
  static void preventScreenshots() {
    if (Platform.isAndroid) {
      const MethodChannel('app_settings').invokeMethod('preventScreenshots');
    } else if (Platform.isIOS) {
      FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }

  // Güvenli logging
  static void secureLog(String message, {bool isSensitive = false}) {
    if (isSensitive) {
      debugPrint('***MASKED***');
    } else {
      debugPrint(message);
    }
  }

  // Uygulama kilidi kontrolü
  static Future<bool> checkAppLock() async {
    final SecureStorage storage = SecureStorage();
    final bool isLockEnabled = await storage.read('app_lock_enabled') == 'true';
    
    if (!isLockEnabled) return true;

    final LocalAuthentication localAuth = LocalAuthentication();
    return await localAuth.authenticate(
      localizedReason: 'Uygulamaya erişmek için kimliğinizi doğrulayın',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: false,
      ),
    );
  }
}
```

## 🎯 Ödevler

1. Kimlik Doğrulama:
   - [ ] Telefon doğrulama ekleyin
   - [ ] İki faktörlü doğrulama ekleyin
   - [ ] Oturum yönetimi geliştirin
   - [ ] Güvenlik soruları ekleyin

2. Veri Güvenliği:
   - [ ] End-to-end şifreleme ekleyin
   - [ ] Güvenli yedekleme sistemi ekleyin
   - [ ] Veri senkronizasyonu ekleyin
   - [ ] Otomatik silme ekleyin

3. Güvenlik Özellikleri:
   - [ ] Güvenlik raporu ekleyin
   - [ ] Aktivite günlüğü ekleyin
   - [ ] Güvenli mod ekleyin
   - [ ] Uzaktan silme ekleyin

## 🔍 Kontrol Listesi

Her değişiklik sonrası şunları kontrol edin:
- [ ] Kimlik doğrulama düzgün çalışıyor mu?
- [ ] Veriler güvenli şekilde saklanıyor mu?
- [ ] Şifreleme işlemleri doğru mu?
- [ ] Güvenlik önlemleri aktif mi?

## 💡 İpuçları

1. Güvenlik:
   - Güçlü şifreleme kullanın
   - Hassas verileri koruyun
   - Güvenlik güncellemelerini takip edin
   - Düzenli güvenlik denetimi yapın

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