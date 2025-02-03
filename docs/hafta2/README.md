# Hafta 2 - Liste Görünümleri ve Kullanıcı Etkileşimleri

Merhaba! Bu hafta Flutter'da liste görünümleri, kullanıcı etkileşimleri ve form elemanları üzerine çalışacağız. Basit bir TODO List uygulaması geliştirerek bu kavramları pratikte uygulayacağız.

## 🎯 Bu Hafta Neler Öğreneceğiz?

- Liste widget'ları (ListView, GridView)
- Kullanıcı etkileşimleri (GestureDetector, InkWell)
- Dialog ve bottom sheet'ler
- Form elemanları ve validasyon
- Snackbar ve Toast mesajları

## 📚 Konu Anlatımı

### Liste Widget'ları

Flutter'da iki temel liste widget'ı vardır:

1. **ListView**: Dikey veya yatay olarak kaydırılabilen liste görünümü
   - `ListView`: Tüm elemanları aynı anda oluşturur
   - `ListView.builder`: Elemanları görünür olduğunda oluşturur
   - `ListView.separated`: Elemanlar arasına ayraç ekler

2. **GridView**: Izgara şeklinde düzenlenmiş liste görünümü
   - `GridView.count`: Sabit sütun sayısı
   - `GridView.extent`: Sabit eleman genişliği
   - `GridView.builder`: Lazy loading desteği

### Kullanıcı Etkileşimleri

Flutter'da kullanıcı etkileşimlerini yönetmek için:

1. **GestureDetector**: Temel dokunma olayları
   - `onTap`: Dokunma
   - `onDoubleTap`: Çift dokunma
   - `onLongPress`: Uzun basma
   - `onPanUpdate`: Sürükleme

2. **InkWell**: Material Design dalga efekti
   - GestureDetector'ın tüm özellikleri
   - Splash ve highlight efektleri
   - Ripple animasyonu

### Dialog ve Bottom Sheet'ler

1. **Dialog Türleri**:
   - `AlertDialog`: Basit uyarı dialogları
   - `SimpleDialog`: Seçenek listesi
   - `CustomDialog`: Özelleştirilmiş dialoglar

2. **Bottom Sheet'ler**:
   - `showModalBottomSheet`: Modal alt sayfa
   - `showBottomSheet`: Kalıcı alt sayfa
   - Sürüklenebilir tasarım

### Form Elemanları

1. **Form Widget'ları**:
   - `TextField`: Metin girişi
   - `TextFormField`: Validasyonlu metin girişi
   - `Checkbox`: İşaret kutusu
   - `Radio`: Seçenek düğmesi
   - `Switch`: Açma/kapama düğmesi
   - `Slider`: Değer kaydırıcı

2. **Form Validasyonu**:
   - `Form` widget'ı
   - `GlobalKey<FormState>`
   - Validasyon fonksiyonları
   - Hata mesajları

## 💻 Örnek Uygulama: TODO List

Bu haftaki örnek uygulamamızda, öğrendiğimiz widget'ları kullanarak bir TODO List uygulaması geliştireceğiz. Uygulamamız şu özelliklere sahip olacak:

- Görev ekleme/silme/düzenleme
- Görev listesi görünümü
- Görev detay sayfası
- Form validasyonu
- Sürükle-bırak sıralama
- Kategori filtreleme

Örnek uygulamanın detaylı anlatımı için [tıklayınız](./ornek_uygulama/README.md).

## 🚀 Ana Proje: Alışkanlık Takip Uygulaması

Bu hafta ana projemizde şunları yapacağız:

1. Alışkanlık listesi görünümü
2. Yeni alışkanlık ekleme formu
3. Alışkanlık detay sayfası
4. Kategori filtreleme sistemi

Ana proje detayları için [tıklayınız](./ana_proje/README.md).

## 🎯 Alıştırmalar

1. Liste İşlemleri:
   - [ ] GridView ile kart tasarımı yapın
   - [ ] Sürükle-bırak sıralama ekleyin
   - [ ] Pull-to-refresh ekleyin
   - [ ] Sonsuz scroll yapın

2. Form Geliştirmeleri:
   - [ ] Karmaşık form validasyonu
   - [ ] Custom form field
   - [ ] Otomatik form doldurma
   - [ ] Form durumu yönetimi

## 🔍 Hata Ayıklama İpuçları

- ListView performans optimizasyonu
- Form validasyon hataları
- Dialog ve bottom sheet yaşam döngüsü
- Gesture çakışmaları

## 📚 Faydalı Kaynaklar

- [Flutter ListView Cookbook](https://flutter.dev/docs/cookbook/lists)
- [Form Validation Cookbook](https://flutter.dev/docs/cookbook/forms)
- [Gestures in Flutter](https://flutter.dev/docs/development/ui/advanced/gestures)

## ✅ Haftalık Görevler

1. Örnek TODO List uygulamasını tamamlayın
2. Ana projedeki liste görünümlerini oluşturun
3. Alıştırmaları çözün
4. Öğrendiklerinizi blog yazısına dönüştürün

## 💪 Sonraki Hafta

Gelecek hafta şunları öğreneceğiz:
- Navigasyon ve routing
- Sayfa geçiş animasyonları
- Veri aktarımı
- Durum yönetimi 