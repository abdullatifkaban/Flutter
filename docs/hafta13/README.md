# Hafta 13 - Performans Optimizasyonu ve Güvenlik

Bu hafta, Flutter uygulamalarında performans optimizasyonu ve güvenlik konularını öğreneceğiz.

## 🎯 Bu Hafta Neler Öğreneceğiz?

1. Performans Optimizasyonu
   - Widget ağacı optimizasyonu
   - Bellek yönetimi
   - Render optimizasyonu
   - State yönetimi

2. Güvenlik Önlemleri
   - Veri şifreleme
   - Güvenli depolama
   - API güvenliği
   - Kod karıştırma

3. Hata Yönetimi
   - Hata yakalama
   - Çökme raporlama
   - Uzaktan güncellemeler
   - Kullanıcı geri bildirimi

4. Profilleme ve Analiz
   - DevTools kullanımı
   - Performans profili
   - Bellek analizi
   - Network izleme

## 📚 Konu Anlatımı

### 1. Performans Optimizasyonu

```dart
// Kötü Örnek
class HeavyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1000,
      itemBuilder: (context, index) {
        return ExpensiveWidget();
      },
    );
  }
}

// İyi Örnek
class OptimizedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1000,
      itemBuilder: (context, index) {
        return const CachedExpensiveWidget();
      },
    );
  }
}
```

### 2. Güvenlik Önlemleri

```dart
class SecurityService {
  static const _key = 'your_encryption_key';
  static const _algorithm = 'AES-256';

  // Veri şifreleme
  static Future<String> encryptData(String data) async {
    final encrypter = Encrypter(AES(_key));
    return encrypter.encrypt(data).base64;
  }

  // Güvenli depolama
  static Future<void> secureStore(
    String key,
    String value,
  ) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: key, value: value);
  }

  // API güvenliği
  static Future<Response> secureApiCall(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final token = await getToken();
    return dio.post(
      endpoint,
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'X-Security-Hash': generateHash(data),
        },
      ),
    );
  }
}
```

### 3. Hata Yönetimi

```dart
class ErrorHandler {
  static Future<void> initialize() async {
    FlutterError.onError = (details) {
      FirebaseCrashlytics.instance.recordFlutterError(details);
    };

    Isolate.current.addErrorListener(RawReceivePort((pair) {
      final List<dynamic> errorAndStacktrace = pair;
      FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);
  }

  static Future<T> handleError<T>(
    Future<T> Function() operation,
  ) async {
    try {
      return await operation();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      rethrow;
    }
  }
}
```

### 4. Profilleme

```dart
class PerformanceMonitor {
  static final _performance = FirebasePerformance.instance;

  static Future<T> measureOperation<T>({
    required String name,
    required Future<T> Function() operation,
  }) async {
    final metric = _performance.newTrace(name);
    await metric.start();
    
    try {
      final result = await operation();
      await metric.stop();
      return result;
    } catch (e) {
      await metric.putAttribute('error', e.toString());
      await metric.stop();
      rethrow;
    }
  }
}
```

## 💻 Örnek Uygulama: Performans İzleme Paneli

Bu haftaki örnek uygulamamızda, uygulama performansını izlemek ve optimize etmek için bir panel geliştireceğiz. Detaylar için [tıklayınız](./ornek_uygulama/README.md).

## 🚀 Ana Proje: Alışkanlık Takip Uygulaması

Bu hafta ana projemizde şunları yapacağız:

1. Performans optimizasyonu
2. Güvenlik önlemleri
3. Hata yönetimi
4. Profilleme ve analiz

Ana proje detayları için [tıklayınız](./ana_proje/README.md).

## 🎯 Alıştırmalar

1. Performans:
   - [ ] Widget ağacını optimize edin
   - [ ] Bellek sızıntılarını bulun
   - [ ] Render performansını ölçün
   - [ ] State yönetimini iyileştirin

2. Güvenlik:
   - [ ] Veri şifreleme ekleyin
   - [ ] API güvenliği sağlayın
   - [ ] Güvenli depolama kullanın
   - [ ] Kod karıştırma yapın

3. Hata Yönetimi:
   - [ ] Hata yakalama ekleyin
   - [ ] Çökme raporlama kurun
   - [ ] Uzaktan güncelleme ekleyin
   - [ ] Kullanıcı bildirimi alın

4. Profilleme:
   - [ ] DevTools kullanın
   - [ ] Performans profili çıkarın
   - [ ] Bellek analizi yapın
   - [ ] Network izleme ekleyin

## 🔍 Hata Ayıklama İpuçları

1. Performans:
   - Widget Inspector kullanın
   - Timeline'ı inceleyin
   - Memory grafiklerini takip edin
   - CPU profilini analiz edin

2. Güvenlik:
   - Güvenlik açıklarını tarayın
   - Penetrasyon testi yapın
   - Güvenlik güncellemelerini takip edin
   - Kullanıcı verilerini koruyun

## 📚 Faydalı Kaynaklar

- [Flutter Performance](https://flutter.dev/docs/perf)
- [Security Best Practices](https://flutter.dev/docs/security)
- [DevTools Guide](https://flutter.dev/docs/development/tools/devtools)
- [Error Handling](https://flutter.dev/docs/testing/errors) 