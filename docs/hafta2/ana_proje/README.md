# Hafta 2 - Alışkanlık Takip Uygulaması: Liste ve Form

Bu hafta, uygulamamıza alışkanlık listesi ve ekleme formunu ekleyeceğiz. Ayrıca temel state yönetimini öğreneceğiz.

## 📱 Bu Haftanın Yenilikleri

- Alışkanlık veri modeli
- Alışkanlık listesi görünümü
- Alışkanlık ekleme formu
- Temel state yönetimi
- Form validasyonu

## 🚀 Kurulum Adımları

1. İlk haftanın projesini açın:
```bash
cd habit_tracker
```

2. `lib` klasörü altında aşağıdaki dosyaları oluşturun:
   - `models/aliskanlik.dart`: Alışkanlık veri modeli
   - `screens/ana_sayfa.dart`: Ana sayfa widget'ı

## 🔍 Kod İncelemesi

### 1. Veri Modeli
```dart
class Aliskanlik {
  String baslik;
  String aciklama;
  bool tamamlandi;
  DateTime olusturulmaTarihi;

  Aliskanlik({
    required this.baslik,
    required this.aciklama,
    this.tamamlandi = false,
    DateTime? olusturulmaTarihi,
  }) : olusturulmaTarihi = olusturulmaTarihi ?? DateTime.now();
}
```
- Alışkanlık için temel veri yapısı
- Başlık ve açıklama zorunlu alanlar
- Varsayılan olarak tamamlanmamış durumda
- Oluşturulma tarihi otomatik atanıyor

### 2. State Yönetimi
```dart
class _AnaSayfaState extends State<AnaSayfa> {
  final List<Aliskanlik> _aliskanliklar = [];
  final _formKey = GlobalKey<FormState>();
  final _baslikController = TextEditingController();
  final _aciklamaController = TextEditingController();
  
  // ...
}
```
- StatefulWidget ile durum yönetimi
- Liste için state tanımı
- Form kontrolü için key ve controller'lar

### 3. Form İşlemleri
```dart
void _aliskanlikEkle() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Yeni Alışkanlık'),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(...),
            TextFormField(...),
          ],
        ),
      ),
    ),
  );
}
```
- Dialog içinde form gösterimi
- Form validasyonu
- TextFormField kullanımı

### 4. Liste Görünümü
```dart
ListView.builder(
  itemCount: _aliskanliklar.length,
  itemBuilder: (context, index) {
    final aliskanlik = _aliskanliklar[index];
    return Card(
      child: ListTile(
        leading: Checkbox(...),
        title: Text(...),
        subtitle: Text(...),
        trailing: IconButton(...),
      ),
    );
  },
)
```
- Dinamik liste görünümü
- Her alışkanlık için kart tasarımı
- Checkbox ile durum kontrolü
- Silme butonu

## 🎯 Öğrenme Hedefleri

Bu hafta:
- StatefulWidget kullanımını
- Form işlemlerini
- Dialog gösterimini
- Liste yönetimini
- Temel state yönetimini
öğrenmiş olacaksınız.

## 📝 Özelleştirme Önerileri

1. Form Alanları:
   - Yeni form alanları ekleyin (örn. hedef, süre)
   - Alan validasyonlarını özelleştirin
   - Form tasarımını geliştirin

2. Liste Görünümü:
   - Kart tasarımını özelleştirin
   - Sıralama seçenekleri ekleyin
   - Filtreleme özelliği ekleyin

3. State Yönetimi:
   - Provider paketini entegre edin
   - Veriyi yerel depolayın
   - Durum değişikliklerinde animasyon ekleyin

## 💡 Sonraki Hafta

Gelecek hafta ekleyeceğimiz özellikler:
- Provider ile state yönetimi
- Sayfa yönlendirmeleri (Navigation)
- Detay sayfası
- Düzenleme özelliği

## 🔍 Önemli Notlar

- State yönetimi şu an basit seviyede
- Veriler henüz kalıcı olarak saklanmıyor
- Form validasyonu temel seviyede
- UI/UX geliştirmeleri yapılabilir 