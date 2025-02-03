# Hafta 10 - Analitik ve Kullanıcı Geri Bildirimleri

Bu hafta, Flutter uygulamalarında analitik ve kullanıcı geri bildirimleri konularını öğreneceğiz.

## 🎯 Bu Hafta Neler Öğreneceğiz?

1. Firebase Analytics
   - Temel kurulum
   - Özel olaylar
   - Kullanıcı özellikleri
   - Dönüşüm takibi

2. Crashlytics
   - Çökme raporları
   - Hata takibi
   - Performans izleme
   - Kullanıcı etkisi

3. Kullanıcı Geri Bildirimi
   - In-app geri bildirim
   - Store değerlendirmeleri
   - Kullanıcı anketleri
   - A/B testleri

4. Performans İzleme
   - Firebase Performance
   - Network istekleri
   - Başlangıç süresi
   - Render performansı

## 📚 Konu Anlatımı

### Firebase Analytics

1. **Temel Kurulum**:
   ```yaml
   dependencies:
     firebase_core: ^2.24.2
     firebase_analytics: ^10.7.4
   ```

2. **Analitik Servisi**:
   ```dart
   class AnalyticsService {
     final FirebaseAnalytics _analytics;
     
     AnalyticsService(this._analytics);

     // Sayfa görüntüleme
     Future<void> logScreenView(String screenName) async {
       await _analytics.logScreenView(
         screenName: screenName,
       );
     }

     // Özel olay
     Future<void> logCustomEvent(String name, Map<String, dynamic> parameters) async {
       await _analytics.logEvent(
         name: name,
         parameters: parameters,
       );
     }

     // Kullanıcı özelliği
     Future<void> setUserProperty(String name, String value) async {
       await _analytics.setUserProperty(
         name: name,
         value: value,
       );
     }
   }
   ```

### Crashlytics

1. **Temel Kurulum**:
   ```yaml
   dependencies:
     firebase_crashlytics: ^3.4.8
   ```

2. **Hata Raporlama**:
   ```dart
   class CrashlyticsService {
     final FirebaseCrashlytics _crashlytics;
     
     CrashlyticsService(this._crashlytics);

     // Hata yakalama
     Future<void> recordError(
       dynamic error,
       StackTrace? stack,
       {dynamic reason}
     ) async {
       await _crashlytics.recordError(
         error,
         stack,
         reason: reason,
       );
     }

     // Özel anahtar
     Future<void> setCustomKey(String key, dynamic value) async {
       await _crashlytics.setCustomKey(key, value);
     }

     // Kullanıcı tanımlayıcı
     Future<void> setUserIdentifier(String identifier) async {
       await _crashlytics.setUserIdentifier(identifier);
     }
   }
   ```

### Kullanıcı Geri Bildirimi

1. **In-App Değerlendirme**:
   ```dart
   class FeedbackService {
     final InAppReview _inAppReview;
     
     FeedbackService(this._inAppReview);

     Future<void> requestReview() async {
       if (await _inAppReview.isAvailable()) {
         await _inAppReview.requestReview();
       }
     }

     Future<void> openStoreListing() async {
       await _inAppReview.openStoreListing();
     }
   }
   ```

2. **Anket Sistemi**:
   ```dart
   class SurveyService {
     final FirebaseFirestore _firestore;
     
     SurveyService(this._firestore);

     Future<void> submitSurvey(Map<String, dynamic> answers) async {
       await _firestore.collection('surveys').add({
         'answers': answers,
         'timestamp': FieldValue.serverTimestamp(),
       });
     }

     Future<List<Survey>> getActiveSurveys() async {
       final snapshot = await _firestore
           .collection('surveys')
           .where('active', isEqualTo: true)
           .get();
           
       return snapshot.docs
           .map((doc) => Survey.fromFirestore(doc))
           .toList();
     }
   }
   ```

### Performans İzleme

1. **Temel Kurulum**:
   ```yaml
   dependencies:
     firebase_performance: ^0.9.3+8
   ```

2. **Performans İzleme**:
   ```dart
   class PerformanceService {
     final FirebasePerformance _performance;
     
     PerformanceService(this._performance);

     // HTTP isteği izleme
     Future<void> monitorHttpRequest(
       String url,
       String method,
       Future<void> Function() request,
     ) async {
       final metric = _performance.newHttpMetric(url, HttpMethod.Get);
       
       await metric.start();
       try {
         await request();
       } finally {
         await metric.stop();
       }
     }

     // Özel trace
     Future<void> startTrace(String name) async {
       final trace = _performance.newTrace(name);
       await trace.start();
     }

     Future<void> stopTrace(String name) async {
       final trace = _performance.newTrace(name);
       await trace.stop();
     }
   }
   ```

## 💻 Örnek Uygulama: Analitik Paneli

Bu haftaki örnek uygulamamızda, öğrendiğimiz analitik ve geri bildirim tekniklerini kullanarak bir analitik paneli uygulaması geliştireceğiz. Detaylar için [tıklayınız](./ornek_uygulama/README.md).

## 🚀 Ana Proje: Alışkanlık Takip Uygulaması

Bu hafta ana projemizde şunları yapacağız:

1. Analitik entegrasyonu
2. Geri bildirim sistemi
3. A/B testleri
4. Performans izleme

Ana proje detayları için [tıklayınız](./ana_proje/README.md).

## 🎯 Alıştırmalar

1. Firebase Analytics:
   - [ ] Özel olaylar tanımlayın
   - [ ] Kullanıcı özellikleri ekleyin
   - [ ] Dönüşüm hunisi oluşturun
   - [ ] Özel metrikler ekleyin

2. Crashlytics:
   - [ ] Hata yakalama ekleyin
   - [ ] Özel anahtarlar tanımlayın
   - [ ] Kullanıcı bilgisi ekleyin
   - [ ] Hata gruplandırma yapın

3. Geri Bildirim:
   - [ ] In-app anket ekleyin
   - [ ] Store değerlendirmesi isteyin
   - [ ] A/B testi yapın
   - [ ] Kullanıcı segmentasyonu yapın

## 🔍 Hata Ayıklama İpuçları

- Analitik olaylarını test edin
- Çökme raporlarını inceleyin
- Performans metriklerini izleyin
- Kullanıcı geri bildirimlerini değerlendirin

## 📚 Faydalı Kaynaklar

- [Firebase Analytics Guide](https://firebase.google.com/docs/analytics)
- [Crashlytics Documentation](https://firebase.google.com/docs/crashlytics)
- [Performance Monitoring](https://firebase.google.com/docs/perf-mon)
- [In-App Review Plugin](https://pub.dev/packages/in_app_review) 