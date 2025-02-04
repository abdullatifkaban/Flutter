# Hafta 3 - Navigasyon ve Durum Yönetimi

Bu hafta, Flutter uygulamalarında sayfa yönetimi, navigasyon ve durum yönetimi konularını öğreneceğiz.

## 🎯 Bu Hafta Neler Öğreneceğiz?

1. Navigasyon ve Routing
   - Navigator API'si
   - Named routes
   - Dinamik route'lar
   - Derin bağlantılar (Deep linking)

2. Sayfa Geçiş Animasyonları
   - Varsayılan geçişler
   - Özel geçiş animasyonları
   - Hero animasyonları
   - Paylaşılan element geçişleri

3. Sayfalar Arası Veri Aktarımı
   - Route parametreleri
   - Geri dönüş değerleri
   - Argüman geçişi
   - Sonuç işleme

4. Durum Yönetimi
   - Provider pattern
   - InheritedWidget
   - State yaşam döngüsü
   - Global durum yönetimi

## 📚 Konu Anlatımı

### Navigasyon ve Routing

Flutter'da iki temel navigasyon yaklaşımı vardır:

1. **Temel Navigasyon**:
   ```dart
   // Yeni sayfaya git
   Navigator.push(
     context,
     MaterialPageRoute(builder: (context) => YeniSayfa()),
   );

   // Geri dön
   Navigator.pop(context);
   ```

2. **Named Routes**:
   ```dart
   // Route tanımlaması
   MaterialApp(
     routes: {
       '/': (context) => AnaSayfa(),
       '/detay': (context) => DetaySayfasi(),
     },
   );

   // Navigasyon
   Navigator.pushNamed(context, '/detay');
   ```

### Sayfa Geçiş Animasyonları

1. **Özel Geçiş Animasyonu**:
   ```dart
   Navigator.push(
     context,
     PageRouteBuilder(
       pageBuilder: (context, animation, secondaryAnimation) => YeniSayfa(),
       transitionsBuilder: (context, animation, secondaryAnimation, child) {
         return FadeTransition(
           opacity: animation,
           child: child,
         );
       },
     ),
   );
   ```

2. **Hero Animasyonu**:
   ```dart
   // Sayfa 1
   Hero(
     tag: 'profil',
     child: Image.asset('assets/profil.jpg'),
   );

   // Sayfa 2
   Hero(
     tag: 'profil',
     child: Image.asset('assets/profil.jpg'),
   );
   ```

### Veri Aktarımı

1. **Parametre Geçişi**:
   ```dart
   // Veri gönderme
   Navigator.push(
     context,
     MaterialPageRoute(
       builder: (context) => DetaySayfasi(veri: 'Merhaba'),
     ),
   );

   // Veri alma
   class DetaySayfasi extends StatelessWidget {
     final String veri;
     
     const DetaySayfasi({required this.veri});
     
     @override
     Widget build(BuildContext context) {
       return Text(veri);
     }
   }
   ```

2. **Sonuç Döndürme**:
   ```dart
   // Sonuç bekleme
   final sonuc = await Navigator.push(
     context,
     MaterialPageRoute(builder: (context) => SecimSayfasi()),
   );

   // Sonuç döndürme
   Navigator.pop(context, 'seçilen_değer');
   ```

### Durum Yönetimi

1. **Provider Kullanımı**:
   ```dart
   // Provider tanımlama
   class SepetProvider with ChangeNotifier {
     List<Urun> _urunler = [];
     
     void ekle(Urun urun) {
       _urunler.add(urun);
       notifyListeners();
     }
   }

   // Provider kullanımı
   Consumer<SepetProvider>(
     builder: (context, provider, child) {
       return Text('${provider._urunler.length} ürün');
     },
   );
   ```

2. **InheritedWidget**:
   ```dart
   class VeriProvider extends InheritedWidget {
     final String veri;
     
     const VeriProvider({
       required this.veri,
       required Widget child,
     }) : super(child: child);
     
     static VeriProvider of(BuildContext context) {
       return context.dependOnInheritedWidgetOfExactType<VeriProvider>()!;
     }
     
     @override
     bool updateShouldNotify(VeriProvider old) => veri != old.veri;
   }
   ```

## 💻 Örnek Uygulama: Çok Sayfalı TODO List

Bu haftaki örnek uygulamamızda, geçen hafta geliştirdiğimiz TODO List uygulamasını çok sayfalı bir yapıya dönüştüreceğiz. Detaylar için [tıklayınız](./ornek_uygulama/README.md).

## 🚀 Ana Proje: Alışkanlık Takip Uygulaması

Bu hafta ana projemizde şunları yapacağız:

1. Sayfa yapısının oluşturulması
2. Navigasyon sisteminin kurulması
3. Sayfa geçiş animasyonlarının eklenmesi
4. Global durum yönetiminin implementasyonu

Ana proje detayları için [tıklayınız](./ana_proje/README.md).

## 🎯 Alıştırmalar

1. Navigasyon:
   - [ ] Özel route tanımlayın
   - [ ] Derin bağlantı ekleyin
   - [ ] Geçiş animasyonu oluşturun
   - [ ] Geri tuşu yönetimi yapın

2. Durum Yönetimi:
   - [ ] Provider implementasyonu
   - [ ] InheritedWidget kullanımı
   - [ ] State yaşam döngüsü
   - [ ] Bellek optimizasyonu

## 🔍 Hata Ayıklama İpuçları

- Navigator stack kontrolü
- Provider dispose işlemleri
- Memory leak kontrolleri
- Gereksiz build'lerin önlenmesi

## 📚 Faydalı Kaynaklar

- [Flutter Navigation Cookbook](https://flutter.dev/docs/cookbook/navigation)
- [Provider Package](https://pub.dev/packages/provider)
- [Hero Animations](https://flutter.dev/docs/development/ui/animations/hero-animations)
- [State Management Guide](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options) 