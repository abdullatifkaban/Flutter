# Hafta 13 - Ana Proje: Performans ve Güvenlik

Bu hafta, alışkanlık takip uygulamamızın performansını optimize edecek ve güvenliğini artıracağız.

## 🎯 Hedefler

1. Performans İyileştirmeleri
   - Widget optimizasyonu
   - Bellek yönetimi
   - Render performansı
   - State yönetimi

2. Güvenlik Önlemleri
   - Veri şifreleme
   - Güvenli depolama
   - API güvenliği
   - Kod karıştırma

3. Hata Yönetimi
   - Hata yakalama
   - Çökme raporlama
   - Uzaktan güncelleme
   - Kullanıcı bildirimi

## 💻 Adım Adım Geliştirme

### 1. Performans İyileştirmeleri

`lib/widgets/habit_list.dart`:
```dart
class HabitList extends StatelessWidget {
  final List<Habit> habits;

  const HabitList({
    Key? key,
    required this.habits,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Görünür öğeleri önbellekleme
      cacheExtent: 100.0,
      // Sabit yükseklik için
      itemExtent: 80.0,
      itemCount: habits.length,
      itemBuilder: (context, index) {
        return HabitTile(
          // const constructor kullanımı
          key: ValueKey(habits[index].id),
          habit: habits[index],
        );
      },
    );
  }
}

class HabitTile extends StatelessWidget {
  final Habit habit;

  const HabitTile({
    Key? key,
    required this.habit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // Gereksiz rebuild'leri önleme
      child: ListTile(
        leading: CircleAvatar(
          // Asset önbellekleme
          child: CachedNetworkImage(
            imageUrl: habit.iconUrl,
            placeholder: (context, url) => CircularProgressIndicator(),
          ),
        ),
        title: Text(habit.title),
        subtitle: Text(habit.description),
        trailing: HabitProgress(
          // Ağır hesaplamaları önbellekleme
          progress: habit.calculateProgress(),
        ),
      ),
    );
  }
}
```

### 2. Güvenlik Önlemleri

`lib/services/security_service.dart`:
```dart
class SecurityService {
  static final _secureStorage = FlutterSecureStorage();
  static final _encrypter = Encrypter(AES(Key.fromSecureRandom(32)));

  // Hassas veri şifreleme
  static Future<String> encryptSensitiveData(String data) async {
    final iv = IV.fromSecureRandom(16);
    final encrypted = _encrypter.encrypt(data, iv: iv);
    return '${encrypted.base64}:${iv.base64}';
  }

  // Güvenli depolama
  static Future<void> secureStore(String key, String value) async {
    final encrypted = await encryptSensitiveData(value);
    await _secureStorage.write(key: key, value: encrypted);
  }

  // API güvenliği
  static Future<Map<String, String>> getSecureHeaders() async {
    final token = await _secureStorage.read(key: 'auth_token');
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final signature = generateSignature(token!, timestamp);

    return {
      'Authorization': 'Bearer $token',
      'X-Timestamp': timestamp,
      'X-Signature': signature,
    };
  }

  // Güvenli hash oluşturma
  static String generateSignature(String token, String timestamp) {
    final key = utf8.encode(token);
    final bytes = utf8.encode(timestamp);
    final hmac = Hmac(sha256, key);
    return hmac.convert(bytes).toString();
  }
}
```

### 3. Hata Yönetimi

`lib/services/error_service.dart`:
```dart
class ErrorService {
  static final _crashlytics = FirebaseCrashlytics.instance;

  // Hata izleme başlatma
  static Future<void> initialize() async {
    await _crashlytics.setCrashlyticsCollectionEnabled(true);
    
    FlutterError.onError = (details) {
      _crashlytics.recordFlutterError(details);
    };

    Isolate.current.addErrorListener(RawReceivePort((pair) {
      final List<dynamic> errorAndStacktrace = pair;
      _crashlytics.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);
  }

  // Hata yakalama ve raporlama
  static Future<T> handleError<T>(
    Future<T> Function() operation,
    String operationName,
  ) async {
    try {
      return await operation();
    } catch (e, stack) {
      await _crashlytics.recordError(
        e,
        stack,
        reason: 'Error in $operationName',
      );
      
      await _showErrorDialog(e.toString());
      rethrow;
    }
  }

  // Kullanıcı bildirimi
  static Future<void> _showErrorDialog(String message) async {
    // Hata dialogu göster
  }
}
```

### 4. Profilleme ve İzleme

`lib/services/performance_service.dart`:
```dart
class PerformanceService {
  static final _performance = FirebasePerformance.instance;

  // Operasyon ölçümü
  static Future<T> measureOperation<T>({
    required String name,
    required Future<T> Function() operation,
  }) async {
    final trace = _performance.newTrace(name);
    await trace.start();

    try {
      final result = await operation();
      await trace.stop();
      return result;
    } catch (e) {
      await trace.putAttribute('error', e.toString());
      await trace.stop();
      rethrow;
    }
  }

  // Network izleme
  static Future<Response> measureHttpRequest(
    Future<Response> Function() request,
    String url,
  ) async {
    final metric = _performance.newHttpMetric(url, HttpMethod.Get);
    await metric.start();

    try {
      final response = await request();
      metric.httpResponseCode = response.statusCode;
      metric.responsePayloadSize = response.contentLength ?? 0;
      await metric.stop();
      return response;
    } catch (e) {
      await metric.putAttribute('error', e.toString());
      await metric.stop();
      rethrow;
    }
  }
}
```

## 🎯 Ödevler

1. Performans:
   - [ ] ListView optimizasyonu
   - [ ] Image önbellekleme
   - [ ] State yönetimi iyileştirmesi
   - [ ] Build metodu optimizasyonu

2. Güvenlik:
   - [ ] Hassas veri şifreleme
   - [ ] API güvenliği
   - [ ] Güvenli depolama
   - [ ] Kod karıştırma

3. Hata Yönetimi:
   - [ ] Crashlytics entegrasyonu
   - [ ] Hata yakalama sistemi
   - [ ] Kullanıcı bildirimleri
   - [ ] Uzaktan güncelleme

## 🔍 Kontrol Listesi

1. Performans:
   - [ ] FPS 60'ın üzerinde mi?
   - [ ] Bellek kullanımı normal mi?
   - [ ] Jank yok mu?
   - [ ] CPU kullanımı makul mü?

2. Güvenlik:
   - [ ] Hassas veriler şifreli mi?
   - [ ] API çağrıları güvenli mi?
   - [ ] Depolama güvenli mi?
   - [ ] Kod karıştırma aktif mi?

3. Hata Yönetimi:
   - [ ] Hatalar yakalanıyor mu?
   - [ ] Raporlar geliyor mu?
   - [ ] Kullanıcı bildirimleri var mı?
   - [ ] Güncellemeler çalışıyor mu?

## 💡 İpuçları

1. Performans:
   - const constructor kullanın
   - Gereksiz build'lerden kaçının
   - Ağır işlemleri isolate'e alın
   - Önbellekleme yapın

2. Güvenlik:
   - Şifreleme anahtarlarını gizleyin
   - SSL pinning kullanın
   - Güvenlik güncellemelerini takip edin
   - Penetrasyon testi yapın

## 📚 Faydalı Kaynaklar

- [Flutter Performance Best Practices](https://flutter.dev/docs/perf/rendering/best-practices)
- [Security Best Practices](https://flutter.dev/docs/security)
- [Firebase Crashlytics](https://firebase.google.com/docs/crashlytics)
- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools/performance) 