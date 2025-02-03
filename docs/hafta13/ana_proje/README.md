# Hafta 13 - Alışkanlık Takip Uygulaması: Performans ve Hata Ayıklama

Bu hafta, uygulamamızın performansını optimize edecek ve hata ayıklama sistemini kuracağız.

## 📱 Bu Haftanın Yenilikleri

- Performans optimizasyonu
- Bellek yönetimi
- Hata ayıklama sistemi
- Çökme analizi
- Uygulama boyutu optimizasyonu

## 🚀 Kurulum Adımları

1. Gerekli paketleri `pubspec.yaml` dosyasına ekleyin:
```yaml
dependencies:
  sentry_flutter: ^7.13.2
  firebase_crashlytics: ^3.4.8
  flutter_performance: ^1.0.0
  memory_profiler: ^1.0.0
  flutter_cache_manager: ^3.3.1
```

2. `lib` klasörü altında aşağıdaki dosyaları oluşturun:
   - `utils/performans_izleyici.dart`
   - `utils/hata_raporlayici.dart`
   - `services/onbellek_yoneticisi.dart`
   - `utils/bellek_yoneticisi.dart`
   - `config/performans_ayarlari.dart`

## 🔍 Kod İncelemesi

### 1. Performans İzleyici
```dart
class PerformansIzleyici {
  static final _sentry = SentryFlutter.instance;
  static final _crashlytics = FirebaseCrashlytics.instance;

  static Future<void> performansOlcumu(String islem, Function callback) async {
    final baslangic = DateTime.now();
    
    try {
      await callback();
    } catch (e, stack) {
      await hataKaydet(e, stack);
    } finally {
      final bitis = DateTime.now();
      final sure = bitis.difference(baslangic);
      
      await _performansMetrigiKaydet(islem, sure);
    }
  }

  static Future<void> _performansMetrigiKaydet(String islem, Duration sure) async {
    await _sentry.addBreadcrumb(
      Breadcrumb(
        category: 'performans',
        message: 'İşlem: $islem, Süre: ${sure.inMilliseconds}ms',
        level: SentryLevel.info,
      ),
    );
  }
}
```

### 2. Bellek Yöneticisi
```dart
class BellekYoneticisi {
  static const int _maksimumOnbellek = 100 * 1024 * 1024; // 100 MB
  static final _onbellek = DefaultCacheManager();

  static Future<void> onbellekTemizle() async {
    final onbellekBoyutu = await _onbellekBoyutuAl();
    
    if (onbellekBoyutu > _maksimumOnbellek) {
      await _onbellek.emptyCache();
      debugPrint('Önbellek temizlendi: ${onbellekBoyutu ~/ 1024 / 1024} MB');
    }
  }

  static Future<void> bellekOptimizasyonu() async {
    await ImageCache().clear();
    await _onbellek.emptyCache();
    
    // Gereksiz widget ağacı yeniden oluşturmalarını önle
    WidgetsBinding.instance.deferFirstFrame();
    await Future.delayed(Duration(milliseconds: 100));
    WidgetsBinding.instance.allowFirstFrame();
  }
}
```

### 3. Hata Raporlayıcı
```dart
class HataRaporlayici {
  static Future<void> initialize() async {
    await Sentry.init(
      (options) {
        options.dsn = 'your_sentry_dsn';
        options.tracesSampleRate = 1.0;
      },
    );

    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    
    FlutterError.onError = (FlutterErrorDetails details) {
      FirebaseCrashlytics.instance.recordFlutterError(details);
      Sentry.captureException(
        details.exception,
        stackTrace: details.stack,
      );
    };
  }

  static Future<void> hataKaydet(dynamic hata, StackTrace? stackTrace) async {
    await Sentry.captureException(
      hata,
      stackTrace: stackTrace,
    );
    
    await FirebaseCrashlytics.instance.recordError(
      hata,
      stackTrace,
      reason: 'Uygulama hatası',
    );
  }
}
```

## 🎯 Öğrenme Hedefleri

Bu hafta:
- Performans optimizasyon tekniklerini
- Bellek yönetimi stratejilerini
- Hata izleme ve raporlamayı
- Çökme analizini
öğrenmiş olacaksınız.

## 📝 Özelleştirme Önerileri

1. Performans:
   - Widget ağacı optimizasyonu
   - Görsel önbelleğe alma
   - Lazy loading
   - İş parçacığı yönetimi

2. Hata Ayıklama:
   - Özel hata sayfaları
   - Otomatik hata bildirimi
   - Hata önleme stratejileri
   - Debug modu araçları

3. Bellek:
   - Akıllı önbellek stratejisi
   - Büyük veri optimizasyonu
   - Kaynak temizleme
   - Bellek sızıntısı tespiti

## 💡 Sonraki Hafta

Gelecek hafta ekleyeceğimiz özellikler:
- Uluslararasılaştırma (i18n)
- Yerelleştirme (l10n)
- RTL desteği
- Çoklu dil desteği

## 🔍 Önemli Notlar

- Düzenli performans testleri yapın
- Bellek kullanımını izleyin
- Hata raporlarını analiz edin
- Kullanıcı deneyimini koruyun 