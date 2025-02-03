# Hafta 10 - Ana Proje: Analitik ve Kullanıcı Geri Bildirimleri

Bu hafta, alışkanlık takip uygulamamıza analitik ve kullanıcı geri bildirimleri özelliklerini ekleyeceğiz.

## 🎯 Hedefler

1. Analitik Entegrasyonu
   - Kullanıcı davranışı izleme
   - Alışkanlık istatistikleri
   - Performans metrikleri
   - Çökme raporları

2. Geri Bildirim Sistemi
   - Kullanıcı değerlendirmeleri
   - Özellik istekleri
   - Hata raporları
   - Kullanıcı anketleri

3. A/B Testleri
   - Arayüz testleri
   - Özellik denemeleri
   - Kullanıcı deneyimi optimizasyonu
   - Test sonuçları analizi

## 💻 Adım Adım Geliştirme

### 1. Firebase Analitik Entegrasyonu

`lib/services/analytics_service.dart`:

```dart
class AnalyticsService {
  final FirebaseAnalytics _analytics;
  
  AnalyticsService(this._analytics);

  // Alışkanlık olayları
  Future<void> logHabitCreated(String habitId, String category) async {
    await _analytics.logEvent(
      name: 'habit_created',
      parameters: {
        'habit_id': habitId,
        'category': category,
      },
    );
  }

  Future<void> logHabitCompleted(String habitId) async {
    await _analytics.logEvent(
      name: 'habit_completed',
      parameters: {
        'habit_id': habitId,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logStreakAchieved(String habitId, int streakCount) async {
    await _analytics.logEvent(
      name: 'streak_achieved',
      parameters: {
        'habit_id': habitId,
        'streak_count': streakCount,
      },
    );
  }

  // Kullanıcı özellikleri
  Future<void> setUserProperties({
    required String userType,
    required int habitCount,
    required int longestStreak,
  }) async {
    await _analytics.setUserProperty(name: 'user_type', value: userType);
    await _analytics.setUserProperty(name: 'habit_count', value: '$habitCount');
    await _analytics.setUserProperty(name: 'longest_streak', value: '$longestStreak');
  }
}
```

### 2. Geri Bildirim Sistemi

`lib/services/feedback_service.dart`:

```dart
class FeedbackService {
  final FirebaseFirestore _firestore;
  
  FeedbackService(this._firestore);

  // Alışkanlık değerlendirmesi
  Future<void> rateHabit({
    required String habitId,
    required int rating,
    String? comment,
  }) async {
    await _firestore.collection('habit_ratings').add({
      'habit_id': habitId,
      'rating': rating,
      'comment': comment,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Özellik isteği
  Future<void> submitFeatureRequest({
    required String title,
    required String description,
    required String category,
  }) async {
    await _firestore.collection('feature_requests').add({
      'title': title,
      'description': description,
      'category': category,
      'votes': 0,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Kullanıcı anketi
  Future<void> submitSurvey({
    required String surveyId,
    required Map<String, dynamic> answers,
  }) async {
    await _firestore.collection('survey_responses').add({
      'survey_id': surveyId,
      'answers': answers,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Hata raporu
  Future<void> submitBugReport({
    required String title,
    required String description,
    Map<String, dynamic>? deviceInfo,
  }) async {
    await _firestore.collection('bug_reports').add({
      'title': title,
      'description': description,
      'device_info': deviceInfo,
      'status': 'new',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
```

### 3. A/B Test Yönetimi

`lib/services/ab_testing_service.dart`:

```dart
class ABTestingService {
  final FirebaseRemoteConfig _remoteConfig;
  
  ABTestingService(this._remoteConfig);

  // UI testleri
  Future<String> getUIVariant(String testName) async {
    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getString('ui_test_$testName');
  }

  // Özellik testleri
  Future<bool> isFeatureEnabled(String featureName) async {
    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getBool('feature_$featureName');
  }

  // Test sonuçları
  Future<void> logTestResult({
    required String testName,
    required String variant,
    required Map<String, dynamic> metrics,
  }) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'ab_test_result',
      parameters: {
        'test_name': testName,
        'variant': variant,
        ...metrics,
      },
    );
  }
}
```

## 🎯 Ödevler

1. Analitik:
   - [ ] Detaylı alışkanlık metrikleri ekleyin
   - [ ] Kullanıcı segmentasyonu yapın
   - [ ] Dönüşüm hunileri oluşturun
   - [ ] Özel raporlar hazırlayın

2. Geri Bildirim:
   - [ ] In-app anket sistemi geliştirin
   - [ ] Otomatik değerlendirme isteği ekleyin
   - [ ] Geri bildirim yönetim paneli oluşturun
   - [ ] Kullanıcı görüşmeleri planlayın

3. A/B Testleri:
   - [ ] Farklı motivasyon mesajları test edin
   - [ ] Bildirim stratejilerini test edin
   - [ ] Ödül sistemlerini test edin
   - [ ] UI varyasyonlarını test edin

## 🔍 Kontrol Listesi

Her özellik için şunları kontrol edin:
- [ ] Veri gizliliği sağlandı mı?
- [ ] Performans etkileri ölçüldü mü?
- [ ] Kullanıcı deneyimi test edildi mi?
- [ ] Hata durumları yönetiliyor mu?

## 💡 İpuçları

1. Analitik:
   - Kritik metrikleri belirleyin
   - Veri kalitesini kontrol edin
   - Düzenli raporlama yapın
   - KVKK uyumlu olun

2. Geri Bildirim:
   - Doğru zamanda isteyin
   - Kısa ve öz tutun
   - Hızlı yanıt verin
   - Yapıcı eleştirileri değerlendirin

3. A/B Testleri:
   - Net hedefler belirleyin
   - Yeterli süre test edin
   - Anlamlı metrikler kullanın
   - Sonuçları dikkatle analiz edin

## 📚 Faydalı Kaynaklar

- [Firebase Analytics](https://firebase.google.com/docs/analytics)
- [Remote Config](https://firebase.google.com/docs/remote-config)
- [A/B Testing](https://firebase.google.com/docs/ab-testing)
- [User Feedback](https://material.io/design/communication/confirmation-acknowledgement.html) 