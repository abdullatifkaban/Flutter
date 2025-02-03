# Hafta 7 - Alışkanlık Takip Uygulaması: Analitik ve Test

Bu hafta, uygulamamıza analitik, A/B testleri ve hata raporlama sistemini ekleyeceğiz.

## 📱 Bu Haftanın Yenilikleri

- Firebase Analytics entegrasyonu
- A/B test sistemi
- Kullanıcı geri bildirimleri
- Hata raporlama (Crashlytics)
- Performans izleme

## 🚀 Kurulum Adımları

1. Gerekli paketleri `pubspec.yaml` dosyasına ekleyin:
```yaml
dependencies:
  firebase_analytics: ^10.7.4
  firebase_crashlytics: ^3.4.8
  firebase_performance: ^0.9.3+8
  firebase_remote_config: ^4.3.8
  feedback: ^3.0.0
```

2. `lib` klasörü altında aşağıdaki dosyaları oluşturun:
   - `services/analytics_service.dart`: Analitik işlemleri
   - `services/ab_test_service.dart`: A/B test yönetimi
   - `services/crashlytics_service.dart`: Hata raporlama
   - `widgets/feedback_form.dart`: Geri bildirim formu
   - `utils/performance_monitoring.dart`: Performans izleme

## 🔍 Kod İncelemesi

### 1. Analitik Servisi
```dart
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> aliskanlikEklendi(String aliskanlikId) async {
    await _analytics.logEvent(
      name: 'aliskanlik_eklendi',
      parameters: {
        'aliskanlik_id': aliskanlikId,
        'tarih': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> hedefTamamlandi(String hedefId, int sure) async {
    await _analytics.logEvent(
      name: 'hedef_tamamlandi',
      parameters: {
        'hedef_id': hedefId,
        'tamamlanma_suresi': sure,
      },
    );
  }

  Future<void> kullaniciEtkilesimi(String ekranAdi, String eylem) async {
    await _analytics.logEvent(
      name: 'kullanici_etkilesimi',
      parameters: {
        'ekran': ekranAdi,
        'eylem': eylem,
      },
    );
  }
}
```

### 2. A/B Test Sistemi
```dart
class ABTestService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  
  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await _remoteConfig.setDefaults({
      'yeni_ui_aktif': false,
      'premium_fiyat': 9.99,
      'rozet_sistemi_v2': false,
    });

    await _remoteConfig.fetchAndActivate();
  }

  bool get yeniUiAktif => _remoteConfig.getBool('yeni_ui_aktif');
  double get premiumFiyat => _remoteConfig.getDouble('premium_fiyat');
  bool get yeniRozetSistemi => _remoteConfig.getBool('rozet_sistemi_v2');
}
```

### 3. Hata Raporlama
```dart
class CrashlyticsService {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  Future<void> initialize() async {
    await _crashlytics.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = _crashlytics.recordFlutterError;
  }

  Future<void> hataBildir(dynamic hata, StackTrace? stackTrace) async {
    await _crashlytics.recordError(hata, stackTrace, fatal: true);
  }

  Future<void> kullaniciBilgisiEkle(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }

  Future<void> ozelBilgiEkle(String key, String value) async {
    await _crashlytics.setCustomKey(key, value);
  }
}
```

### 4. Performans İzleme
```dart
class PerformanceMonitoring {
  final FirebasePerformance _performance = FirebasePerformance.instance;

  Future<void> sayfaYuklemeSuresiniOlc(String sayfaAdi) async {
    final trace = _performance.newTrace('sayfa_yukleme_$sayfaAdi');
    await trace.start();
    
    // Sayfa yükleme işlemleri...
    
    await trace.stop();
  }

  Future<void> veritabaniSuresiniOlc(String islemAdi) async {
    final metric = _performance.newHttpMetric(
      'veritabani_$islemAdi',
      HttpMethod.Get,
    );
    await metric.start();
    
    // Veritabanı işlemleri...
    
    await metric.stop();
  }
}
```

## 🎯 Öğrenme Hedefleri

Bu hafta:
- Firebase Analytics kullanımını
- A/B test sistemini
- Hata raporlama sistemini
- Performans izlemeyi
öğrenmiş olacaksınız.

## 📝 Özelleştirme Önerileri

1. Analitik:
   - Özel event'ler ekleyin
   - Kullanıcı segmentasyonu yapın
   - Detaylı raporlar oluşturun

2. A/B Testleri:
   - Farklı UI varyasyonları ekleyin
   - Özellik bayrakları kullanın
   - Test sonuçlarını analiz edin

3. Hata Raporlama:
   - Özel hata tipleri ekleyin
   - Otomatik hata yakalama
   - Hata önceliklendirme

## 💡 Sonraki Hafta

Gelecek hafta ekleyeceğimiz özellikler:
- Uygulama güvenliği
- Kod kalitesi
- CI/CD entegrasyonu
- App Store hazırlığı

## 🔍 Önemli Notlar

- Kullanıcı gizliliğine dikkat edin
- Test verilerini düzenli analiz edin
- Hata raporlarını takip edin
- Performans metriklerini izleyin 