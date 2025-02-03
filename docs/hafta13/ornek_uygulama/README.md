# Hafta 13 - Örnek Uygulama: Performans İzleme Paneli

Bu örnek uygulamamızda, Flutter uygulamalarının performansını izlemek ve optimize etmek için bir panel geliştireceğiz.

## 🎯 Uygulama Özellikleri

1. Performans İzleme
   - FPS takibi
   - Bellek kullanımı
   - CPU kullanımı
   - Network aktivitesi

2. Hata Yönetimi
   - Çökme raporları
   - Hata logları
   - Kullanıcı geri bildirimleri
   - Uzaktan güncellemeler

3. Güvenlik Analizi
   - Güvenlik açıkları
   - API güvenliği
   - Depolama güvenliği
   - Kod kalitesi

## 💻 Uygulama Yapısı

```
lib/
  ├── models/
  │   ├── performance_metrics.dart
  │   ├── error_report.dart
  │   └── security_scan.dart
  │
  ├── services/
  │   ├── performance_service.dart
  │   ├── error_service.dart
  │   └── security_service.dart
  │
  ├── screens/
  │   ├── home_screen.dart
  │   ├── performance_screen.dart
  │   ├── error_screen.dart
  │   └── security_screen.dart
  │
  └── widgets/
      ├── fps_chart.dart
      ├── memory_graph.dart
      └── error_list.dart
```

## 📱 Ekran Tasarımları

1. Ana Sayfa
   - Performans özeti
   - Son hatalar
   - Güvenlik durumu
   - Hızlı aksiyonlar

2. Performans Ekranı
   - FPS grafiği
   - Bellek kullanımı
   - CPU yükü
   - Network trafiği

3. Hata Ekranı
   - Hata listesi
   - Çökme raporları
   - Kullanıcı bildirimleri
   - Hata detayları

4. Güvenlik Ekranı
   - Güvenlik taraması
   - API güvenliği
   - Depolama analizi
   - Kod analizi

## 🔧 Teknik Detaylar

### 1. Performans Metrikleri

```dart
class PerformanceMetrics {
  final double fps;
  final int memoryUsage;
  final double cpuUsage;
  final int networkRequests;
  final DateTime timestamp;

  PerformanceMetrics({
    required this.fps,
    required this.memoryUsage,
    required this.cpuUsage,
    required this.networkRequests,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'fps': fps,
    'memory_usage': memoryUsage,
    'cpu_usage': cpuUsage,
    'network_requests': networkRequests,
    'timestamp': timestamp.toIso8601String(),
  };

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) {
    return PerformanceMetrics(
      fps: json['fps'],
      memoryUsage: json['memory_usage'],
      cpuUsage: json['cpu_usage'],
      networkRequests: json['network_requests'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
```

### 2. Performans İzleme

```dart
class PerformanceMonitor {
  static final _performance = FirebasePerformance.instance;

  // FPS ölçümü
  static Stream<double> measureFPS() {
    return Stream.periodic(Duration(seconds: 1), (_) {
      return Window.instance.getFPS();
    });
  }

  // Bellek kullanımı
  static Future<int> getMemoryUsage() async {
    return await Window.instance.getMemoryUsage();
  }

  // CPU kullanımı
  static Future<double> getCPUUsage() async {
    return await Window.instance.getCPUUsage();
  }

  // Network izleme
  static Future<void> trackNetworkRequest({
    required String url,
    required String method,
    required int responseCode,
    required int contentLength,
  }) async {
    final metric = _performance.newHttpMetric(url, HttpMethod.Get);
    await metric.start();

    try {
      metric.httpResponseCode = responseCode;
      metric.responsePayloadSize = contentLength;
      await metric.stop();
    } catch (e) {
      await metric.putAttribute('error', e.toString());
      await metric.stop();
      rethrow;
    }
  }
}
```

### 3. Hata İzleme

```dart
class ErrorTracker {
  static final _crashlytics = FirebaseCrashlytics.instance;

  // Hata yakalama
  static Future<void> captureError(
    dynamic error,
    StackTrace stackTrace,
  ) async {
    await _crashlytics.recordError(
      error,
      stackTrace,
      reason: 'Uygulama hatası',
      fatal: true,
    );
  }

  // Kullanıcı geri bildirimi
  static Future<void> submitFeedback({
    required String title,
    required String description,
    List<String>? screenshots,
  }) async {
    await _crashlytics.log('''
      Feedback:
      Title: $title
      Description: $description
      Screenshots: ${screenshots?.join(', ')}
    ''');
  }

  // Hata istatistikleri
  static Future<ErrorStats> getErrorStats() async {
    // Hata istatistiklerini getir
  }
}
```

### 4. Güvenlik Taraması

```dart
class SecurityScanner {
  // API güvenliği kontrolü
  static Future<SecurityReport> checkAPISecurit() async {
    final report = SecurityReport();

    // SSL sertifikası kontrolü
    report.sslValid = await checkSSLCertificate();

    // API anahtarı kontrolü
    report.apiKeySecure = await checkAPIKey();

    // İstek şifreleme kontrolü
    report.requestsEncrypted = await checkRequestEncryption();

    return report;
  }

  // Depolama güvenliği kontrolü
  static Future<StorageReport> checkStorageSecurity() async {
    final report = StorageReport();

    // Şifreleme kontrolü
    report.encryptionEnabled = await checkEncryption();

    // İzin kontrolü
    report.permissionsValid = await checkPermissions();

    // Veri sızıntısı kontrolü
    report.noDataLeaks = await checkDataLeaks();

    return report;
  }
}
```

## 🚀 Başlangıç

1. Projeyi oluşturun:
   ```bash
   flutter create performance_monitor
   cd performance_monitor
   ```

2. Bağımlılıkları ekleyin:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     firebase_performance: ^0.9.3
     firebase_crashlytics: ^3.4.8
     fl_chart: ^0.60.0
     provider: ^6.0.0

   dev_dependencies:
     flutter_test:
       sdk: flutter
     mockito: ^5.0.0
   ```

3. Firebase'i yapılandırın:
   ```dart
   // lib/config/firebase_config.dart
   class FirebaseConfig {
     static Future<void> initialize() async {
       await Firebase.initializeApp();
       await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
       await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
     }
   }
   ```

## 🔍 Kontrol Listesi

1. Performans İzleme:
   - [ ] FPS ölçümü çalışıyor mu?
   - [ ] Bellek takibi doğru mu?
   - [ ] CPU ölçümü hassas mı?
   - [ ] Network izleme aktif mi?

2. Hata Yönetimi:
   - [ ] Hatalar yakalanıyor mu?
   - [ ] Raporlar oluşuyor mu?
   - [ ] Kullanıcı bildirimleri alınıyor mu?
   - [ ] Güncellemeler kontrol ediliyor mu?

3. Güvenlik:
   - [ ] API güvenliği tam mı?
   - [ ] Depolama güvenli mi?
   - [ ] Kod analizi yapılıyor mu?
   - [ ] Güvenlik açıkları taranıyor mu?

## 💡 İpuçları

1. Performans:
   - Düzenli ölçüm yapın
   - Eşik değerleri belirleyin
   - Anomalileri tespit edin
   - Optimizasyon önerileri sunun

2. Hata Yönetimi:
   - Hataları sınıflandırın
   - Öncelik belirleyin
   - Çözüm önerileri sunun
   - Kullanıcıları bilgilendirin

## 📚 Faydalı Kaynaklar

- [Flutter Performance Profiling](https://flutter.dev/docs/perf/rendering/ui-performance)
- [Firebase Performance Monitoring](https://firebase.google.com/docs/perf-mon)
- [Crashlytics Dashboard](https://firebase.google.com/docs/crashlytics)
- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools/performance) 