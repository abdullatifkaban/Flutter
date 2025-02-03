# Hafta 4 - Alışkanlık Takip Uygulaması: İstatistikler ve Bildirimler

Bu hafta, uygulamamıza istatistik sayfası, grafik gösterimleri ve bildirim sistemini ekleyeceğiz.

## 📱 Bu Haftanın Yenilikleri

- İstatistik sayfası
- Grafik gösterimleri (fl_chart)
- Bildirim sistemi (flutter_local_notifications)
- Tema desteği
- Dil desteği

## 🚀 Kurulum Adımları

1. Gerekli paketleri `pubspec.yaml` dosyasına ekleyin:
```yaml
dependencies:
  fl_chart: ^0.65.0
  flutter_local_notifications: ^16.3.0
  intl: ^0.18.0
  shared_preferences: ^2.2.0
```

2. `lib` klasörü altında aşağıdaki dosyaları oluşturun:
   - `screens/istatistik_sayfasi.dart`: İstatistik sayfası
   - `services/bildirim_servisi.dart`: Bildirim yönetimi
   - `utils/tema.dart`: Tema ayarları
   - `utils/dil.dart`: Dil dosyaları

## 🔍 Kod İncelemesi

### 1. İstatistik Sayfası
```dart
class IstatistikSayfasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('İstatistikler')),
      body: Consumer<AliskanlikProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              _tamamlanmaGrafigi(provider.aliskanliklar),
              _gunlukIstatistikler(provider.aliskanliklar),
              _haftalikOzet(provider.aliskanliklar),
            ],
          );
        },
      ),
    );
  }
}
```

### 2. Grafik Gösterimi
```dart
Widget _tamamlanmaGrafigi(List<Aliskanlik> aliskanliklar) {
  return Container(
    height: 200,
    padding: EdgeInsets.all(16),
    child: LineChart(
      LineChartData(
        // Grafik ayarları ve veri noktaları
      ),
    ),
  );
}
```

### 3. Bildirim Servisi
```dart
class BildirimServisi {
  final FlutterLocalNotificationsPlugin _notifications;
  
  Future<void> initialize() async {
    // Bildirim ayarları
  }
  
  Future<void> gunlukHatirlatmaEkle(TimeOfDay zaman) async {
    // Günlük hatırlatma bildirimi
  }
  
  Future<void> basariHatirlatmasi(String baslik) async {
    // Başarı bildirimi
  }
}
```

### 4. Tema Desteği
```dart
class TemaAyarlari extends ChangeNotifier {
  bool _karanlikTema = false;
  
  bool get karanlikTema => _karanlikTema;
  
  void temaDegistir() {
    _karanlikTema = !_karanlikTema;
    notifyListeners();
  }
  
  ThemeData get tema => _karanlikTema 
    ? _karanlikTemaVerileri 
    : _aydinlikTemaVerileri;
}
```

## 🎯 Öğrenme Hedefleri

Bu hafta:
- Grafik kütüphanesi kullanımını
- Bildirim sistemini
- Tema yönetimini
- Dil desteği eklemeyi
öğrenmiş olacaksınız.

## 📝 Özelleştirme Önerileri

1. İstatistikler:
   - Yeni grafik türleri ekleyin
   - Özel istatistikler oluşturun
   - Veri analizi ekleyin

2. Bildirimler:
   - Özel bildirim sesleri ekleyin
   - Bildirim grupları oluşturun
   - Bildirim ayarları ekleyin

3. Tema:
   - Özel renk paletleri ekleyin
   - Animasyonlu tema geçişleri
   - Tema seçim sayfası

## 💡 Sonraki Hafta

Gelecek hafta ekleyeceğimiz özellikler:
- Hedef belirleme sistemi
- Başarı rozetleri
- Sosyal paylaşım
- Yedekleme sistemi

## 🔍 Önemli Notlar

- Grafikleri optimize edin
- Bildirimleri kullanıcı dostu yapın
- Tema geçişlerini sorunsuz yapın
- Dil çevirilerini eksiksiz yapın 