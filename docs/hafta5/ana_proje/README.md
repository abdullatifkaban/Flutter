# Hafta 5 - Alışkanlık Takip Uygulaması: Hedefler ve Başarılar

Bu hafta, uygulamamıza hedef belirleme sistemi, başarı rozetleri ve sosyal paylaşım özelliklerini ekleyeceğiz.

## 📱 Bu Haftanın Yenilikleri

- Hedef belirleme sistemi
- Başarı rozetleri
- Sosyal paylaşım
- Yedekleme sistemi
- Firebase entegrasyonu

## 🚀 Kurulum Adımları

1. Gerekli paketleri `pubspec.yaml` dosyasına ekleyin:
```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  share_plus: ^7.2.1
  path_provider: ^2.1.1
```

2. Firebase projesini oluşturun ve yapılandırın:
   - Firebase Console'dan yeni proje oluşturun
   - Flutter uygulamanızı Firebase'e ekleyin
   - google-services.json dosyasını indirin
   - Gerekli yapılandırmaları yapın

3. `lib` klasörü altında aşağıdaki dosyaları oluşturun:
   - `models/hedef.dart`: Hedef veri modeli
   - `models/rozet.dart`: Rozet veri modeli
   - `services/firebase_servisi.dart`: Firebase işlemleri
   - `screens/hedef_sayfasi.dart`: Hedef yönetimi
   - `screens/basari_sayfasi.dart`: Rozetler ve başarılar

## 🔍 Kod İncelemesi

### 1. Hedef Modeli
```dart
class Hedef {
  String id;
  String baslik;
  int hedefSayisi;
  int tamamlanan;
  DateTime baslangicTarihi;
  DateTime? bitisTarihi;
  List<String> altHedefler;
  bool tamamlandi;

  Hedef({
    required this.id,
    required this.baslik,
    required this.hedefSayisi,
    this.tamamlanan = 0,
    required this.baslangicTarihi,
    this.bitisTarihi,
    this.altHedefler = const [],
    this.tamamlandi = false,
  });

  double get ilerleme => tamamlanan / hedefSayisi;
  bool get suresiDoldu => bitisTarihi?.isBefore(DateTime.now()) ?? false;
}
```

### 2. Rozet Sistemi
```dart
class RozetYoneticisi {
  static const List<Rozet> tumRozetler = [
    Rozet(
      id: 'ilk_aliskanlik',
      ad: 'İlk Adım',
      aciklama: 'İlk alışkanlığını oluştur',
      ikon: 'assets/rozetler/ilk_adim.png',
    ),
    // Diğer rozetler...
  ];

  static List<Rozet> kazanilanRozetleriHesapla(KullaniciVerileri veriler) {
    return tumRozetler.where((rozet) => rozet.kosulKontrol(veriler)).toList();
  }
}
```

### 3. Firebase Servisi
```dart
class FirebaseServisi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String kullaniciId;

  Future<void> hedefEkle(Hedef hedef) async {
    await _firestore
        .collection('kullanicilar')
        .doc(kullaniciId)
        .collection('hedefler')
        .add(hedef.toMap());
  }

  Future<void> rozetKaydet(String rozetId) async {
    await _firestore
        .collection('kullanicilar')
        .doc(kullaniciId)
        .collection('rozetler')
        .doc(rozetId)
        .set({
      'kazanilmaTarihi': DateTime.now(),
    });
  }
}
```

### 4. Sosyal Paylaşım
```dart
class BasariPaylasim {
  static Future<void> rozetPaylas(Rozet rozet) async {
    final resimYolu = await _rozetResmiKaydet(rozet);
    await Share.shareFiles(
      [resimYolu],
      text: 'Yeni bir rozet kazandım: ${rozet.ad}! 🎉',
    );
  }

  static Future<void> hedefPaylas(Hedef hedef) async {
    await Share.share(
      'Yeni hedefime ulaştım: ${hedef.baslik} ✅\n'
      'İlerleme: %${(hedef.ilerleme * 100).toInt()}',
    );
  }
}
```

## 🎯 Öğrenme Hedefleri

Bu hafta:
- Firebase kullanımını
- Veri yedekleme ve senkronizasyonu
- Sosyal paylaşım entegrasyonunu
- Başarı sistemi tasarımını
öğrenmiş olacaksınız.

## 📝 Özelleştirme Önerileri

1. Hedefler:
   - Alt hedefler ekleyin
   - Hedef kategorileri oluşturun
   - İlerleme grafikleri ekleyin

2. Rozetler:
   - Animasyonlu rozetler ekleyin
   - Özel rozet tasarımları yapın
   - Rozet seviyeleri ekleyin

3. Sosyal Özellikler:
   - Arkadaş sistemi ekleyin
   - Başarı sıralaması yapın
   - Grup hedefleri oluşturun

## 💡 Sonraki Hafta

Gelecek hafta ekleyeceğimiz özellikler:
- Çevrimdışı çalışma modu
- Veri senkronizasyonu
- Performans iyileştirmeleri
- Hata ayıklama sistemi

## 🔍 Önemli Notlar

- Firebase kurallarını düzgün yapılandırın
- Veri güvenliğine dikkat edin
- Kullanıcı gizliliğini koruyun
- Performansı optimize edin 