# Hafta 1 - Flutter'a Giriş ve İlk Uygulama

Merhaba! Bu hafta Flutter dünyasına ilk adımımızı atacağız. Basit bir sayaç uygulaması yaparak Flutter'ın temel kavramlarını öğreneceğiz.

## 🎯 Bu Hafta Neler Öğreneceğiz?

- Flutter geliştirme ortamının kurulumu
- Widget kavramı ve temel widget'lar
- StatelessWidget ve StatefulWidget farkı
- Hot Reload özelliğinin kullanımı
- Basit state yönetimi
- Temel UI bileşenleri

## 📚 Konu Anlatımı

### Flutter Nedir?

Flutter, Google tarafından geliştirilen ve tek bir kod tabanından mobil, web ve masaüstü uygulamaları geliştirmenize olanak sağlayan bir UI framework'üdür. Dart programlama dilini kullanır ve "her şey bir widget" felsefesine dayanır.

### Widget Nedir?

Widget'lar, Flutter'da kullanıcı arayüzünü oluşturan yapı taşlarıdır. İki temel widget türü vardır:

1. **StatelessWidget**: Durumu olmayan, statik widget'lar
   - Değişmeyen UI elemanları için kullanılır
   - Performanslıdır
   - Örnek: Text, Icon, Image

2. **StatefulWidget**: Durumu olan, dinamik widget'lar
   - Değişen veriye sahip UI elemanları için kullanılır
   - setState() ile yeniden çizilir
   - Örnek: Form, Checkbox, TextField

## 💻 Örnek Uygulama: Gelişmiş Sayaç

Bu haftaki örnek uygulamamızda, Flutter'ın temel kavramlarını öğrenmek için gelişmiş bir sayaç uygulaması yapacağız. Uygulamamız şu özelliklere sahip olacak:

- Artırma/azaltma butonları
- Sıfırlama butonu
- Renkli sayaç gösterimi
- 10'un katlarında özel animasyon
- Karanlık/Aydınlık tema desteği
- Sayaç geçmişi

Örnek uygulamanın detaylı anlatımı için [tıklayınız](./ornek_uygulama/README.md).

## 🚀 Ana Proje: Alışkanlık Takip Uygulaması

Bu hafta ana projemizde şunları yapacağız:

1. Proje yapısının oluşturulması
2. Ana sayfa tasarımı
3. Temel navigation yapısı
4. Theme ayarları

Ana proje detayları için [tıklayınız](./ana_proje/README.md).

## 🎯 Alıştırmalar

1. Temel Özellikler:
   - [ ] Sıfırlama butonu ekleyin
   - [ ] Çift/tek sayı kontrolü yapın
   - [ ] Maksimum/minimum limit koyun

2. UI Geliştirmeleri:
   - [ ] Karanlık tema desteği ekleyin
   - [ ] Sayaç değişiminde animasyon yapın
   - [ ] Özel font kullanın

## 🔍 Hata Ayıklama İpuçları

- Widget Inspector'ı kullanın (Flutter DevTools)
- `print` ile değişkenleri kontrol edin
- Hot Reload çalışmazsa Hot Restart deneyin

## 📚 Faydalı Kaynaklar

- [Flutter Widget Kataloğu](https://flutter.dev/docs/development/ui/widgets)
- [Flutter'da State Yönetimi](https://flutter.dev/docs/development/data-and-backend/state-mgmt/intro)
- [Material Design Rehberi](https://material.io/design)

## ✅ Haftalık Görevler

1. Örnek uygulamayı tamamlayın
2. Ana projedeki bu haftaki görevleri yapın
3. Alıştırmaları çözün
4. Öğrendiklerinizi blog yazısına dönüştürün

## 💪 Sonraki Hafta

Gelecek hafta şunları öğreneceğiz:
- Liste görünümleri
- Gesture detector'lar
- Dialog ve bottom sheet'ler
- Form elemanları 