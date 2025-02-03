# Hafta 1: Flutter'a Giriş ve Kurulum

## 🎯 Hedefler
- Flutter geliştirme ortamının kurulumu
- İlk Flutter projesinin oluşturulması
- Temel widget kavramının anlaşılması
- Basit bir UI oluşturma

## 📝 Konu Başlıkları
1. [Flutter Nedir?](#flutter-nedir)
2. [Kurulum Adımları](#kurulum-adımları)
3. [İlk Uygulama](#ilk-uygulama)
4. [Temel Widgetlar](#temel-widgetlar)
5. [Alıştırmalar](#alıştırmalar)

## Flutter Nedir?

Flutter, Google tarafından geliştirilen açık kaynaklı bir UI toolkit'tir. Tek bir kod tabanından iOS, Android, web ve masaüstü uygulamaları geliştirmenize olanak sağlar.

### Flutter'ın Avantajları:
- Hızlı geliştirme (Hot Reload özelliği)
- Zengin widget kütüphanesi
- Yüksek performans
- Özelleştirilebilir tasarım
- Çoklu platform desteği

## Kurulum Adımları

### 1. Flutter SDK Kurulumu

#### Windows için:
1. [Flutter SDK](https://flutter.dev/docs/get-started/install/windows)'yı indirin
2. ZIP dosyasını `C:\src\flutter` konumuna çıkartın
3. `flutter/bin` klasörünü PATH'e ekleyin

#### macOS için:
```bash
# Homebrew ile kurulum
brew install flutter
```

#### Linux için:
```bash
# SDK'yı indirin ve çıkartın
cd ~/development
tar xf ~/Downloads/flutter_linux_3.x.x-stable.tar.xz

# PATH'e ekleyin
export PATH="$PATH:`pwd`/flutter/bin"
```

### 2. VS Code Kurulumu
1. [VS Code](https://code.visualstudio.com/)'u indirin ve kurun
2. Flutter ve Dart eklentilerini yükleyin:
   - Flutter
   - Dart
   - Awesome Flutter Snippets
   - Flutter Widget Snippets

### 3. Gerekli SDK'ların Kurulumu
```bash
# Bağımlılıkları kontrol edin
flutter doctor

# Eksik bağımlılıkları yükleyin
flutter doctor --android-licenses
```

## İlk Uygulama

### 1. Proje Oluşturma
```bash
flutter create habit_tracker
cd habit_tracker
```

### 2. Proje Yapısı
```
habit_tracker/
├── android/         # Android özgü dosyalar
├── ios/            # iOS özgü dosyalar
├── lib/            # Dart kodları
│   └── main.dart   # Ana uygulama dosyası
├── test/           # Test dosyaları
└── pubspec.yaml    # Proje konfigürasyonu
```

### 3. Uygulamayı Çalıştırma
```bash
flutter run
```

## Temel Widgetlar

### MaterialApp
```dart
MaterialApp(
  title: 'Habit Tracker',
  theme: ThemeData(
    primarySwatch: Colors.blue,
  ),
  home: MyHomePage(),
)
```

### Scaffold
```dart
Scaffold(
  appBar: AppBar(
    title: Text('Habit Tracker'),
  ),
  body: Center(
    child: Text('Merhaba Flutter!'),
  ),
)
```

## Alıştırmalar

### 1. Temel Uygulama
- Yeni bir Flutter projesi oluşturun
- Ana sayfaya bir başlık ekleyin
- Ortada bir metin gösterin
- Bir buton ekleyin

### 2. Widget Ağacı
- Column widget'ı kullanarak dikey bir düzen oluşturun
- En az 3 farklı widget ekleyin
- Widgetlar arasına boşluk ekleyin

### 3. Stil ve Tema
- Uygulamanın ana rengini değiştirin
- Yazı stillerini özelleştirin
- AppBar'a bir ikon ekleyin

## 📚 Kaynaklar
- [Flutter Resmi Dokümantasyon](https://flutter.dev/docs)
- [Flutter Widget Kataloğu](https://flutter.dev/docs/development/ui/widgets)
- [Dart Programlama Dili](https://dart.dev/guides)
- [Material Design](https://material.io/design)

## 📝 Ödev
1. Kendi Flutter projenizi oluşturun
2. En az 3 farklı widget kullanın
3. Özel bir tema oluşturun
4. Projenizi GitHub'a yükleyin

## 🔍 Sık Sorulan Sorular
1. Flutter SDK bulunamıyor hatası alıyorum?
   - PATH ayarlarınızı kontrol edin
   
2. Emulator açılmıyor?
   - Android Studio'dan AVD Manager'ı kontrol edin
   
3. Hot Reload çalışmıyor?
   - Uygulamanın çalışır durumda olduğundan emin olun 