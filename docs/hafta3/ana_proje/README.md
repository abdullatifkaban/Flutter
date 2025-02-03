# Hafta 3 - Alışkanlık Takip Uygulaması: State Yönetimi ve Navigasyon

Bu hafta, uygulamamıza Provider ile state yönetimi, sayfa yönlendirmeleri ve detay sayfası ekleyeceğiz.

## 📱 Bu Haftanın Yenilikleri

- Provider ile state yönetimi
- Sayfa yönlendirmeleri (Navigation)
- Detay sayfası
- Düzenleme özelliği
- Veri kalıcılığı (SharedPreferences)

## 🚀 Kurulum Adımları

1. Yeni bir Flutter projesi oluşturun:
```bash
flutter create habit_tracker
cd habit_tracker
```

2. `pubspec.yaml` dosyasına gerekli paketleri ekleyin:
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  shared_preferences: ^2.2.0
```

3. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

4. `lib` klasörü altında aşağıdaki dosyaları oluşturun:
   - `models/aliskanlik.dart`: Alışkanlık veri modeli
   - `providers/aliskanlik_provider.dart`: Provider sınıfı
   - `screens/ana_sayfa.dart`: Ana sayfa widget'ı
   - `screens/detay_sayfasi.dart`: Detay sayfası widget'ı
   - `screens/duzenleme_sayfasi.dart`: Düzenleme sayfası widget'ı
   - `utils/depolama.dart`: Veri kalıcılığı işlemleri

5. `main.dart` dosyasını güncelleyin ve provider'ı ekleyin.

## 🔍 Kod İncelemesi

### 1. Provider Entegrasyonu
```dart
class AliskanlikProvider extends ChangeNotifier {
  List<Aliskanlik> _aliskanliklar = [];
  
  List<Aliskanlik> get aliskanliklar => _aliskanliklar;
  
  void aliskanlikEkle(Aliskanlik aliskanlik) {
    _aliskanliklar.add(aliskanlik);
    notifyListeners();
  }
  
  void aliskanlikSil(int index) {
    _aliskanliklar.removeAt(index);
    notifyListeners();
  }
  
  void aliskanlikGuncelle(int index, Aliskanlik aliskanlik) {
    _aliskanliklar[index] = aliskanlik;
    notifyListeners();
  }
}
```
- Provider ile merkezi state yönetimi
- State değişikliklerinde otomatik UI güncellemesi
- CRUD operasyonları için metodlar

### 2. Navigasyon Yapısı
```dart
MaterialApp(
  // ...
  routes: {
    '/': (context) => const AnaSayfa(),
    '/detay': (context) => const DetaySayfasi(),
    '/duzenle': (context) => const DuzenlemeSayfasi(),
  },
)
```
- Named routes ile sayfa yönlendirmeleri
- Sayfa geçişleri için standart yapı
- Geri tuşu desteği

### 3. Detay Sayfası
```dart
class DetaySayfasi extends StatelessWidget {
  final Aliskanlik aliskanlik;
  
  // İstatistikler, notlar ve ilerleme grafikleri
}
```
- Alışkanlık detayları
- İstatistikler ve grafikler
- Düzenleme seçeneği

### 4. Veri Kalıcılığı
```dart
class AliskanlikDepolama {
  static Future<void> kaydet(List<Aliskanlik> aliskanliklar) async {
    final prefs = await SharedPreferences.getInstance();
    // JSON dönüşümü ve kaydetme işlemleri
  }
  
  static Future<List<Aliskanlik>> yukle() async {
    final prefs = await SharedPreferences.getInstance();
    // JSON'dan veri okuma ve dönüştürme işlemleri
  }
}
```
- SharedPreferences ile yerel depolama
- JSON formatında veri saklama
- Uygulama başlangıcında veri yükleme

## 🎯 Öğrenme Hedefleri

Bu hafta:
- Provider kullanımını
- Sayfa yönlendirmelerini
- Veri kalıcılığını
- Detay sayfası tasarımını
öğrenmiş olacaksınız.

## 📝 Özelleştirme Önerileri

1. State Yönetimi:
   - Filtreleme mantığını provider'a taşıyın
   - İstatistik hesaplamalarını ekleyin
   - Çoklu provider kullanın

2. Navigasyon:
   - Animasyonlu geçişler ekleyin
   - Tab bar navigation ekleyin
   - Bottom navigation bar ekleyin

3. Veri Kalıcılığı:
   - SQLite entegrasyonu yapın
   - Bulut depolama ekleyin
   - Veri senkronizasyonu ekleyin

## 💡 Sonraki Hafta

Gelecek hafta ekleyeceğimiz özellikler:
- İstatistik sayfası
- Grafik gösterimleri
- Bildirim sistemi
- Tema desteği

## 🔍 Önemli Notlar

- Provider kullanımında widget ağacını doğru yapılandırın
- Navigation için route'ları düzgün tanımlayın
- Veri kaybını önlemek için düzenli kaydetme yapın
- UI/UX prensiplerini göz önünde bulundurun 