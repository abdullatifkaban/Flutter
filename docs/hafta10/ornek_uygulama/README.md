# Hafta 10 - Örnek Uygulama: Analitik Paneli

Bu örnek uygulama, Flutter'da analitik ve kullanıcı geri bildirimleri konularını pratik olarak göstermek için tasarlanmış bir analitik paneli uygulamasıdır.

## 🎯 Uygulama Özellikleri

1. Analitik Özellikleri:
   - Kullanıcı davranışı takibi
   - Özel olaylar ve dönüşümler
   - Performans metrikleri
   - Çökme raporları

2. Geri Bildirim Sistemi:
   - In-app anketler
   - Kullanıcı değerlendirmeleri
   - Hata raporlama
   - Özellik istekleri

3. A/B Testleri:
   - Arayüz varyasyonları
   - Özellik denemeleri
   - Kullanıcı segmentasyonu
   - Test sonuçları analizi

## 📱 Ekran Tasarımları

[Ekran tasarımlarının görselleri]

## 💻 Uygulama Yapısı

```
lib/
├── analytics/
│   ├── analytics_service.dart
│   ├── custom_events.dart
│   └── performance_monitoring.dart
├── feedback/
│   ├── feedback_service.dart
│   ├── survey_manager.dart
│   └── rating_dialog.dart
├── models/
│   ├── analytics_data.dart
│   └── feedback_data.dart
├── screens/
│   ├── dashboard/
│   │   ├── analytics_dashboard.dart
│   │   └── performance_metrics.dart
│   ├── feedback/
│   │   ├── feedback_list.dart
│   │   └── survey_screen.dart
│   └── settings/
│       ├── analytics_settings.dart
│       └── feedback_settings.dart
├── services/
│   ├── firebase_service.dart
│   └── ab_testing_service.dart
└── main.dart
```

## 🚀 Başlangıç

1. Yeni bir Flutter projesi oluşturun:

```bash
flutter create analytics_dashboard
cd analytics_dashboard
```

2. Gerekli bağımlılıkları ekleyin:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.2
  firebase_analytics: ^10.7.4
  firebase_crashlytics: ^3.4.8
  firebase_performance: ^0.9.3+8
  in_app_review: ^2.0.8
  surveys: ^1.0.0
  ab_testing: ^1.0.0
  charts_flutter: ^0.12.0
```

## 💻 Adım Adım Geliştirme

### 1. Analitik Servisi

`lib/analytics/analytics_service.dart`:

```dart
class AnalyticsService {
  final FirebaseAnalytics _analytics;
  
  AnalyticsService(this._analytics);

  // Sayfa görüntüleme
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  // Özel olay
  Future<void> logCustomEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  // Kullanıcı özelliği
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await _analytics.setUserProperty(
      name: name,
      value: value,
    );
  }

  // Dönüşüm takibi
  Future<void> logPurchase({
    required double value,
    required String currency,
    String? itemId,
  }) async {
    await _analytics.logPurchase(
      currency: currency,
      value: value,
      items: [
        AnalyticsEventItem(
          itemId: itemId,
          itemName: 'Premium Üyelik',
        ),
      ],
    );
  }
}
```

### 2. Geri Bildirim Yöneticisi

`lib/feedback/feedback_service.dart`:

```dart
class FeedbackService {
  final FirebaseFirestore _firestore;
  
  FeedbackService(this._firestore);

  // Anket gönderme
  Future<void> submitSurvey({
    required String userId,
    required Map<String, dynamic> answers,
  }) async {
    await _firestore.collection('surveys').add({
      'userId': userId,
      'answers': answers,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Değerlendirme isteme
  Future<void> requestReview() async {
    if (await InAppReview.instance.isAvailable()) {
      await InAppReview.instance.requestReview();
    }
  }

  // Hata raporu gönderme
  Future<void> submitBugReport({
    required String title,
    required String description,
    String? deviceInfo,
    List<String>? screenshots,
  }) async {
    await _firestore.collection('bug_reports').add({
      'title': title,
      'description': description,
      'deviceInfo': deviceInfo,
      'screenshots': screenshots,
      'status': 'new',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Özellik isteği gönderme
  Future<void> submitFeatureRequest({
    required String title,
    required String description,
    int? priority,
  }) async {
    await _firestore.collection('feature_requests').add({
      'title': title,
      'description': description,
      'priority': priority,
      'votes': 0,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
```

### 3. A/B Test Yöneticisi

`lib/services/ab_testing_service.dart`:

```dart
class ABTestingService {
  final FirebaseRemoteConfig _remoteConfig;
  
  ABTestingService(this._remoteConfig);

  // Test varyasyonu alma
  Future<String> getVariant(String testName) async {
    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getString('test_$testName');
  }

  // Test sonucu gönderme
  Future<void> logTestResult({
    required String testName,
    required String variant,
    required bool success,
  }) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'ab_test_result',
      parameters: {
        'test_name': testName,
        'variant': variant,
        'success': success,
      },
    );
  }

  // Kullanıcı segmentasyonu
  Future<String> getUserSegment() async {
    // Kullanıcı davranışına göre segment belirleme
    final userProperties = await _getUserProperties();
    return _calculateSegment(userProperties);
  }

  String _calculateSegment(Map<String, dynamic> properties) {
    // Segment hesaplama mantığı
    if (properties['usage_frequency'] == 'high' &&
        properties['subscription'] == 'premium') {
      return 'power_user';
    } else if (properties['last_active'] < 7) {
      return 'active_user';
    }
    return 'regular_user';
  }
}
```

## 🎯 Ödevler

1. Analitik:
   - [ ] Özel olay tanımları ekleyin
   - [ ] Dönüşüm hunisi oluşturun
   - [ ] Kullanıcı segmentasyonu yapın
   - [ ] Performans metriklerini izleyin

2. Geri Bildirim:
   - [ ] Özelleştirilmiş anketler ekleyin
   - [ ] Otomatik değerlendirme isteği ekleyin
   - [ ] Hata raporu sistemi geliştirin
   - [ ] Kullanıcı görüşmeleri planlayın

3. A/B Testleri:
   - [ ] Test senaryoları oluşturun
   - [ ] Varyasyon yönetimi ekleyin
   - [ ] Test sonuçlarını analiz edin
   - [ ] Otomatik optimizasyon ekleyin

## 🔍 Kontrol Listesi

Her değişiklik sonrası şunları kontrol edin:
- [ ] Analitik olayları doğru kaydediliyor mu?
- [ ] Geri bildirim sistemi çalışıyor mu?
- [ ] A/B testleri düzgün çalışıyor mu?
- [ ] Performans metrikleri toplanıyor mu?

## 💡 İpuçları

1. Analitik:
   - Önemli olayları belirleyin
   - Veri kalitesini kontrol edin
   - Düzenli raporlama yapın
   - KVKK uyumlu olun

2. Geri Bildirim:
   - Kullanıcıyı rahatsız etmeyin
   - Net sorular sorun
   - Hızlı yanıt verin
   - Geri bildirimleri değerlendirin

3. A/B Testleri:
   - Tek seferde tek test yapın
   - Yeterli örnek boyutu kullanın
   - İstatistiksel anlamlılık arayın
   - Test süresini doğru belirleyin

## 📚 Faydalı Kaynaklar

- [Firebase Analytics Guide](https://firebase.google.com/docs/analytics)
- [A/B Testing Best Practices](https://firebase.google.com/docs/ab-testing)
- [User Feedback Guidelines](https://material.io/design/communication/confirmation-acknowledgement.html)
- [Performance Monitoring](https://firebase.google.com/docs/perf-mon) 