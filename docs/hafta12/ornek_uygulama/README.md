# Hafta 12 - Örnek Uygulama: Mağaza Yönetim Paneli

Bu örnek uygulamamızda, uygulama mağazası yönetimi için bir panel geliştireceğiz.

## 🎯 Uygulama Özellikleri

1. Mağaza Yönetimi
   - Uygulama bilgileri yönetimi
   - Metadata düzenleme
   - Görsel materyal yönetimi
   - Versiyon kontrolü

2. ASO Araçları
   - Anahtar kelime analizi
   - Rakip takibi
   - Performans metrikleri
   - A/B test yönetimi

3. Analitik Paneli
   - İndirme istatistikleri
   - Kullanıcı metrikleri
   - Gelir analizi
   - Değerlendirme takibi

## 💻 Uygulama Yapısı

```
lib/
  ├── models/
  │   ├── app_info.dart
  │   ├── store_listing.dart
  │   └── analytics_data.dart
  │
  ├── services/
  │   ├── play_store_service.dart
  │   ├── app_store_service.dart
  │   └── analytics_service.dart
  │
  ├── screens/
  │   ├── home_screen.dart
  │   ├── store_listing_screen.dart
  │   ├── analytics_screen.dart
  │   └── aso_screen.dart
  │
  └── widgets/
      ├── app_info_card.dart
      ├── metrics_chart.dart
      └── keyword_analyzer.dart
```

## 📱 Ekran Tasarımları

1. Ana Sayfa
   - Uygulama kartları
   - Hızlı metrikler
   - Son değerlendirmeler
   - Yapılacaklar listesi

2. Mağaza Listesi
   - Metadata düzenleyici
   - Görsel yükleyici
   - Önizleme
   - Versiyon yönetimi

3. Analitik Ekranı
   - Metrik grafikleri
   - Kullanıcı segmentleri
   - Trend analizleri
   - Raporlama araçları

4. ASO Ekranı
   - Keyword analizi
   - Rakip takibi
   - A/B test sonuçları
   - Optimizasyon önerileri

## 🔧 Teknik Detaylar

### 1. Uygulama Modeli

```dart
class AppInfo {
  final String id;
  final String name;
  final String bundleId;
  final String version;
  final String buildNumber;
  final AppPlatform platform;
  final StoreStatus status;
  final DateTime lastUpdate;
  final Map<String, StoreListing> listings;

  AppInfo({
    required this.id,
    required this.name,
    required this.bundleId,
    required this.version,
    required this.buildNumber,
    required this.platform,
    required this.status,
    required this.lastUpdate,
    required this.listings,
  });
}

class StoreListing {
  final String title;
  final String shortDescription;
  final String fullDescription;
  final List<String> keywords;
  final List<String> screenshots;
  final String video;
  final String icon;
  final String featureGraphic;

  StoreListing({
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.keywords,
    required this.screenshots,
    required this.video,
    required this.icon,
    required this.featureGraphic,
  });
}
```

### 2. Mağaza Servisleri

```dart
class PlayStoreService {
  Future<void> updateListing(String appId, StoreListing listing) async {
    // Play Store listing güncelle
  }

  Future<void> uploadAssets(String appId, StoreAssets assets) async {
    // Görselleri yükle
  }

  Future<void> publishRelease(String appId, ReleaseInfo release) async {
    // Yeni sürüm yayınla
  }

  Future<AnalyticsData> getAnalytics(String appId, DateRange range) async {
    // Analitik verileri getir
  }
}

class AppStoreService {
  Future<void> updateMetadata(String appId, StoreListing metadata) async {
    // App Store metadata güncelle
  }

  Future<void> submitForReview(String appId, SubmissionInfo info) async {
    // İnceleme için gönder
  }

  Future<void> manageTestflight(String appId, TestflightConfig config) async {
    // TestFlight yönetimi
  }

  Future<AnalyticsData> getMetrics(String appId, DateRange range) async {
    // Metrik verileri getir
  }
}
```

### 3. ASO Araçları

```dart
class ASOService {
  Future<KeywordAnalysis> analyzeKeywords(List<String> keywords) async {
    // Anahtar kelime analizi
  }

  Future<CompetitorAnalysis> analyzeCompetitors(List<String> appIds) async {
    // Rakip analizi
  }

  Future<ABTestResults> getTestResults(String testId) async {
    // A/B test sonuçları
  }

  Future<List<Suggestion>> getOptimizationSuggestions(String appId) async {
    // Optimizasyon önerileri
  }
}
```

## 🚀 Başlangıç

1. Projeyi oluşturun:
   ```bash
   flutter create store_management_panel
   cd store_management_panel
   ```

2. Bağımlılıkları ekleyin:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     google_play_developer_api: ^1.0.0
     app_store_connect_api: ^1.0.0
     fl_chart: ^0.60.0
     provider: ^6.0.0

   dev_dependencies:
     flutter_test:
       sdk: flutter
     mockito: ^5.0.0
   ```

3. Servisleri yapılandırın:
   ```dart
   // lib/config/store_config.dart
   class StoreConfig {
     static const playStoreConfig = {
       'credentials_path': 'assets/play_store_credentials.json',
       'api_endpoint': 'https://www.googleapis.com/androidpublisher/v3',
     };

     static const appStoreConfig = {
       'key_id': 'YOUR_KEY_ID',
       'issuer_id': 'YOUR_ISSUER_ID',
       'key_path': 'assets/app_store_key.p8',
     };
   }
   ```

## 🔍 Kontrol Listesi

1. Mağaza Yönetimi:
   - [ ] Metadata düzenleyici çalışıyor mu?
   - [ ] Görsel yükleme işliyor mu?
   - [ ] Versiyon kontrolü doğru mu?
   - [ ] Önizleme güncel mi?

2. ASO Araçları:
   - [ ] Keyword analizi yapılıyor mu?
   - [ ] Rakip takibi aktif mi?
   - [ ] A/B testler çalışıyor mu?
   - [ ] Öneriler mantıklı mı?

3. Analitik:
   - [ ] Metrikler doğru mu?
   - [ ] Grafikler güncel mi?
   - [ ] Raporlar oluşuyor mu?
   - [ ] Trendler izleniyor mu?

## 💡 İpuçları

1. Mağaza Yönetimi:
   - API limitlerini kontrol edin
   - Görsel optimizasyonu yapın
   - Metadata validasyonu ekleyin
   - Sürüm kontrolü yapın

2. ASO:
   - Düzenli analiz yapın
   - Rakipleri takip edin
   - A/B testleri planlayın
   - Optimizasyon önerilerini değerlendirin

## 📚 Faydalı Kaynaklar

- [Play Console API](https://developers.google.com/android-publisher)
- [App Store Connect API](https://developer.apple.com/app-store-connect/api/)
- [ASO Guide](https://developer.android.com/distribute/best-practices/launch)
- [Store Listing Tips](https://developer.apple.com/app-store/product-page/) 