# Hafta 8 - Alışkanlık Takip Uygulaması: Güvenlik ve Kod Kalitesi

Bu hafta, uygulamamızın güvenliğini artıracak ve kod kalitesini iyileştirecek özellikler ekleyeceğiz.

## 📱 Bu Haftanın Yenilikleri

- Güvenli veri depolama
- Kod kalitesi kontrolleri
- Birim testleri
- Güvenlik denetimleri
- Kod dokümantasyonu

## 🚀 Kurulum Adımları

1. Gerekli paketleri `pubspec.yaml` dosyasına ekleyin:
```yaml
dependencies:
  flutter_secure_storage: ^9.0.0
  encrypt: ^5.0.3
  
dev_dependencies:
  flutter_lints: ^2.0.0
  test: ^1.24.9
  mockito: ^5.4.3
  flutter_test:
    sdk: flutter
```

2. `lib` klasörü altında aşağıdaki dosyaları oluşturun:
   - `security/encryption_service.dart`: Şifreleme işlemleri
   - `security/secure_storage.dart`: Güvenli depolama
   - `utils/input_validator.dart`: Girdi doğrulama
   - `utils/sanitizer.dart`: Veri temizleme
   - `test/unit_tests/`: Birim testler

## 🔍 Kod İncelemesi

### 1. Güvenli Depolama
```dart
class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final EncryptionService _encryption = EncryptionService();

  Future<void> guvenliKaydet(String key, String value) async {
    final sifreliVeri = await _encryption.sifrele(value);
    await _storage.write(key: key, value: sifreliVeri);
  }

  Future<String?> guvenliOku(String key) async {
    final sifreliVeri = await _storage.read(key: key);
    if (sifreliVeri == null) return null;
    return await _encryption.sifreCoz(sifreliVeri);
  }

  Future<void> guvenliSil(String key) async {
    await _storage.delete(key: key);
  }
}
```

### 2. Veri Doğrulama
```dart
class InputValidator {
  static String? emailDogrula(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-posta adresi gerekli';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Geçerli bir e-posta adresi girin';
    }
    
    return null;
  }

  static String? parolaDogrula(String? value) {
    if (value == null || value.isEmpty) {
      return 'Parola gerekli';
    }
    
    if (value.length < 8) {
      return 'Parola en az 8 karakter olmalı';
    }
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Parola en az bir büyük harf içermeli';
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Parola en az bir rakam içermeli';
    }
    
    return null;
  }
}
```

### 3. Birim Testler
```dart
void main() {
  group('InputValidator testleri', () {
    test('Geçerli email testi', () {
      expect(
        InputValidator.emailDogrula('test@example.com'),
        null,
      );
    });

    test('Geçersiz email testi', () {
      expect(
        InputValidator.emailDogrula('invalid-email'),
        'Geçerli bir e-posta adresi girin',
      );
    });

    test('Boş email testi', () {
      expect(
        InputValidator.emailDogrula(''),
        'E-posta adresi gerekli',
      );
    });
  });

  group('SecureStorage testleri', () {
    late SecureStorage storage;
    late MockEncryptionService mockEncryption;

    setUp(() {
      mockEncryption = MockEncryptionService();
      storage = SecureStorage(encryption: mockEncryption);
    });

    test('Veri kaydetme testi', () async {
      await storage.guvenliKaydet('test_key', 'test_value');
      verify(mockEncryption.sifrele('test_value')).called(1);
    });
  });
}
```

### 4. Kod Kalitesi
```dart
// Örnek bir sınıf için lint kuralları ve dokümantasyon
/// Kullanıcı verilerini güvenli bir şekilde yöneten sınıf.
/// 
/// Bu sınıf, kullanıcı verilerinin şifrelenmesi, güvenli depolanması ve
/// doğrulanması işlemlerini gerçekleştirir.
class UserSecurityManager {
  final SecureStorage _storage;
  final InputValidator _validator;

  /// Yeni bir UserSecurityManager örneği oluşturur.
  /// 
  /// [storage] ve [validator] parametreleri zorunludur.
  UserSecurityManager({
    required SecureStorage storage,
    required InputValidator validator,
  })  : _storage = storage,
        _validator = validator;

  /// Kullanıcı bilgilerini güvenli bir şekilde kaydeder.
  /// 
  /// [userData] parametresi JSON formatında olmalıdır.
  /// Hata durumunda [SecurityException] fırlatır.
  Future<void> kullaniciBilgileriniKaydet(Map<String, dynamic> userData) async {
    try {
      final jsonString = jsonEncode(userData);
      await _storage.guvenliKaydet('user_data', jsonString);
    } catch (e) {
      throw SecurityException('Kullanıcı bilgileri kaydedilemedi: $e');
    }
  }
}
```

## 🎯 Öğrenme Hedefleri

Bu hafta:
- Güvenli veri depolama yöntemlerini
- Birim test yazımını
- Kod kalitesi kontrollerini
- Güvenlik önlemlerini
öğrenmiş olacaksınız.

## 📝 Özelleştirme Önerileri

1. Güvenlik:
   - İki faktörlü doğrulama ekleyin
   - SSL pinning uygulayın
   - Güvenlik denetimi ekleyin

2. Testler:
   - Widget testleri ekleyin
   - Integration testleri ekleyin
   - Test coverage artırın

3. Kod Kalitesi:
   - Custom lint kuralları ekleyin
   - Statik kod analizi ekleyin
   - Kod dokümantasyonu geliştirin

## 💡 Sonraki Hafta

Gelecek hafta ekleyeceğimiz özellikler:
- CI/CD pipeline kurulumu
- Test otomasyonu
- Kod analiz araçları
- Dağıtım scriptleri

## 🔍 Önemli Notlar

- Güvenlik en önemli öncelik olmalı
- Test coverage %80'in üzerinde olmalı
- Kod kalitesi kurallarına uyun
- Düzenli güvenlik denetimleri yapın 