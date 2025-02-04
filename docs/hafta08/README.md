# Hafta 8 - Uygulama Güvenliği ve Kimlik Doğrulama

Bu hafta, Flutter uygulamalarında güvenlik ve kimlik doğrulama konularını öğreneceğiz.

## 🎯 Bu Hafta Neler Öğreneceğiz?

1. Firebase Authentication
   - Email/Şifre kimlik doğrulama
   - Google ile giriş
   - Apple ile giriş
   - Telefon numarası doğrulama
   - Anonim giriş

2. Güvenli Veri Depolama
   - Secure Storage
   - Şifreli SharedPreferences
   - Keychain/Keystore
   - Biometrik kimlik doğrulama

3. Şifreleme ve Hash'leme
   - AES şifreleme
   - RSA şifreleme
   - Hash fonksiyonları
   - Salt kullanımı

4. Güvenlik En İyi Pratikleri
   - SSL pinning
   - Jailbreak/Root tespiti
   - Ekran görüntüsü engelleme
   - Güvenli logging

## 📚 Konu Anlatımı

### 1. Firebase Authentication

```dart
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Email/Şifre ile kayıt
  Future<UserCredential?> kayitOl(String email, String sifre) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: sifre,
      );
    } catch (e) {
      print('Hata: $e');
      return null;
    }
  }

  // Email/Şifre ile giriş
  Future<UserCredential?> girisYap(String email, String sifre) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: sifre,
      );
    } catch (e) {
      print('Hata: $e');
      return null;
    }
  }

  // Google ile giriş
  Future<UserCredential?> googleIleGiris() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Hata: $e');
      return null;
    }
  }

  // Çıkış yap
  Future<void> cikisYap() async {
    await _auth.signOut();
  }
}
```

### 2. Güvenli Veri Depolama

```dart
class SecureStorage {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Güvenli veri kaydetme
  Future<void> kaydet(String key, String value) async {
    await _storage.write(
      key: key,
      value: value,
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ),
    );
  }

  // Güvenli veri okuma
  Future<String?> oku(String key) async {
    return await _storage.read(
      key: key,
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ),
    );
  }

  // Güvenli veri silme
  Future<void> sil(String key) async {
    await _storage.delete(key: key);
  }

  // Tüm verileri silme
  Future<void> tumunuSil() async {
    await _storage.deleteAll();
  }
}
```

### 3. Şifreleme ve Hash'leme

```dart
class Encryption {
  // AES şifreleme
  String aesEncrypt(String plainText, String key) {
    final encrypter = Encrypter(AES(Key.fromUtf8(key)));
    final iv = IV.fromLength(16);
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  // AES şifre çözme
  String aesDecrypt(String encryptedText, String key) {
    final encrypter = Encrypter(AES(Key.fromUtf8(key)));
    final iv = IV.fromLength(16);
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }

  // SHA-256 hash
  String hashPassword(String password, String salt) {
    var bytes = utf8.encode(password + salt);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Güvenli rastgele string oluşturma
  String generateSecureRandom(int length) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }
}
```

### 4. Güvenlik En İyi Pratikleri

```dart
class SecurityUtils {
  // Jailbreak/Root kontrolü
  Future<bool> isDeviceSecure() async {
    if (Platform.isAndroid) {
      return !await RootChecker.isDeviceRooted;
    } else if (Platform.isIOS) {
      return !await JailbreakChecker.isJailbroken;
    }
    return true;
  }

  // SSL Pinning
  Future<void> setupSSLPinning() async {
    ByteData data = await rootBundle.load('assets/certificates/cert.pem');
    SecurityContext context = SecurityContext.defaultContext;
    context.setTrustedCertificatesBytes(data.buffer.asUint8List());
  }

  // Ekran görüntüsü engelleme
  void preventScreenshots() {
    if (Platform.isAndroid) {
      const MethodChannel('app_settings').invokeMethod('preventScreenshots');
    } else if (Platform.isIOS) {
      FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }

  // Güvenli logging
  void secureLog(String message, {bool isSensitive = false}) {
    if (isSensitive) {
      // Hassas bilgileri maskeleme
      debugPrint('***MASKED***');
    } else {
      debugPrint(message);
    }
  }
}
```

## 💻 Örnek Uygulama: Güvenli Not Defteri

Bu haftaki örnek uygulamamızda, öğrendiğimiz güvenlik tekniklerini kullanarak şifreli bir not defteri uygulaması geliştireceğiz. Detaylar için [tıklayınız](./ornek_uygulama/README.md).

## 🚀 Ana Proje: Alışkanlık Takip Uygulaması

Bu hafta ana projemizde şunları yapacağız:

1. Kullanıcı kimlik doğrulama sistemi
2. Güvenli veri depolama
3. Hassas bilgi şifreleme
4. Güvenlik önlemleri

Ana proje detayları için [tıklayınız](./ana_proje/README.md).

## 🎯 Alıştırmalar

1. Firebase Auth:
   - [ ] Email/şifre girişi ekleyin
   - [ ] Google girişi ekleyin
   - [ ] Şifre sıfırlama ekleyin
   - [ ] Email doğrulama ekleyin

2. Güvenli Depolama:
   - [ ] Secure Storage kullanın
   - [ ] Biometrik kimlik doğrulama ekleyin
   - [ ] Otomatik kilit ekleyin
   - [ ] Güvenli yedekleme ekleyin

3. Şifreleme:
   - [ ] AES şifreleme kullanın
   - [ ] End-to-end şifreleme ekleyin
   - [ ] Güvenli anahtar yönetimi ekleyin
   - [ ] Hash fonksiyonları kullanın

## 🔍 Hata Ayıklama İpuçları

- Güvenlik açıklarını test edin
- Şifreleme/çözme işlemlerini kontrol edin
- Hassas bilgileri loglamayın
- Güvenlik önlemlerini düzenli güncelleyin

## 📚 Faydalı Kaynaklar

- [Firebase Authentication](https://firebase.flutter.dev/docs/auth/overview)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [Encryption in Flutter](https://pub.dev/packages/encrypt)
- [Flutter Security Best Practices](https://flutter.dev/security) 