# Hafta 12 - Alışkanlık Takip Uygulaması: Premium Özellikler ve Ödeme Sistemi

Bu hafta, uygulamamıza premium özellikler ekleyecek ve ödeme sistemini entegre edeceğiz.

## 📱 Bu Haftanın Yenilikleri

- Premium özellikler
- Ödeme sistemi entegrasyonu
- Abonelik yönetimi
- Gelir analizi
- Promosyon kodları

## 🚀 Kurulum Adımları

1. Gerekli paketleri `pubspec.yaml` dosyasına ekleyin:
```yaml
dependencies:
  in_app_purchase: ^3.1.11
  revenue_cat: ^6.3.0
  firebase_analytics: ^10.7.4
  shared_preferences: ^2.2.0
  flutter_stripe: ^10.0.0
```

2. `lib` klasörü altında aşağıdaki dosyaları oluşturun:
   - `screens/premium_ekrani.dart`
   - `services/odeme_servisi.dart`
   - `models/abonelik.dart`
   - `utils/gelir_analizi.dart`
   - `widgets/premium_ozellikler.dart`

## 🔍 Kod İncelemesi

### 1. Premium Özellikler
```dart
class PremiumOzellikler {
  static const List<Map<String, dynamic>> ozellikler = [
    {
      'baslik': 'Sınırsız Alışkanlık',
      'aciklama': 'İstediğiniz kadar alışkanlık ekleyin',
      'ikon': Icons.infinite,
    },
    {
      'baslik': 'Detaylı İstatistikler',
      'aciklama': 'Gelişmiş analiz ve raporlar',
      'ikon': Icons.analytics,
    },
    {
      'baslik': 'Veri Yedekleme',
      'aciklama': 'Otomatik bulut yedekleme',
      'ikon': Icons.backup,
    },
    {
      'baslik': 'Reklamsız Deneyim',
      'aciklama': 'Rahatsız edici reklamlar yok',
      'ikon': Icons.block,
    },
  ];
}
```

### 2. Ödeme Servisi
```dart
class OdemeServisi {
  static final _revenueCat = RevenueCat.instance;
  
  static Future<void> initialize() async {
    await _revenueCat.setup(
      apiKey: 'your_api_key',
      appUserId: await _getUserId(),
    );
  }

  static Future<void> abonelikSatinAl(String paketId) async {
    try {
      final offering = await _revenueCat.getOfferings();
      final package = offering.current?.getPackage(paketId);
      
      if (package != null) {
        await _revenueCat.purchasePackage(package);
        await _premiumOzellikleriniAktifEt();
        await _analitikKaydet('premium_satin_alindi', {
          'paket_id': paketId,
        });
      }
    } catch (e) {
      throw OdemeHatasi('Ödeme işlemi başarısız: $e');
    }
  }

  static Future<bool> premiumMu() async {
    final info = await _revenueCat.getPurchaserInfo();
    return info.entitlements.active.containsKey('premium');
  }

  static Future<void> _premiumOzellikleriniAktifEt() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('premium_aktif', true);
  }
}
```

### 3. Abonelik Modeli
```dart
class Abonelik {
  final String id;
  final String baslik;
  final String aciklama;
  final double fiyat;
  final String sure;
  final List<String> ozellikler;

  const Abonelik({
    required this.id,
    required this.baslik,
    required this.aciklama,
    required this.fiyat,
    required this.sure,
    required this.ozellikler,
  });

  static List<Abonelik> paketler = [
    Abonelik(
      id: 'aylik',
      baslik: 'Aylık Premium',
      aciklama: 'Aylık premium üyelik',
      fiyat: 29.99,
      sure: 'ay',
      ozellikler: [
        'Sınırsız Alışkanlık',
        'Detaylı İstatistikler',
        'Veri Yedekleme',
        'Reklamsız Deneyim',
      ],
    ),
    Abonelik(
      id: 'yillik',
      baslik: 'Yıllık Premium',
      aciklama: 'Yıllık premium üyelik (2 ay bedava)',
      fiyat: 299.99,
      sure: 'yıl',
      ozellikler: [
        'Sınırsız Alışkanlık',
        'Detaylı İstatistikler',
        'Veri Yedekleme',
        'Reklamsız Deneyim',
        'Öncelikli Destek',
      ],
    ),
  ];
}
```

## 🎯 Öğrenme Hedefleri

Bu hafta:
- In-app satın alma entegrasyonunu
- RevenueCat kullanımını
- Abonelik yönetimini
- Gelir analizini
öğrenmiş olacaksınız.

## 📝 Özelleştirme Önerileri

1. Premium Özellikler:
   - Özel temalar
   - Gelişmiş istatistikler
   - Grup alışkanlıkları
   - Sosyal özellikler

2. Ödeme Sistemi:
   - Farklı ödeme yöntemleri
   - Promosyon kodları
   - Hediye abonelikler
   - Aile planları

3. Gelir Analizi:
   - Dönüşüm oranları
   - Kullanıcı yaşam boyu değeri
   - Churn analizi
   - Gelir tahminleri

## 💡 Sonraki Hafta

Gelecek hafta ekleyeceğimiz özellikler:
- Performans optimizasyonu
- Bellek yönetimi
- Hata ayıklama sistemi
- Çökme analizi

## 🔍 Önemli Notlar

- Ödeme güvenliğini sağlayın
- Abonelik iptallerini düzgün yönetin
- Gelir metriklerini takip edin
- Kullanıcı geri bildirimlerini dikkate alın 