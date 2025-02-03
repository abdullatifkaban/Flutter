# Hafta 1 - Alışkanlık Takip Uygulaması: Başlangıç

Bu hafta, Flutter ile temel bir uygulama yapısı oluşturacağız ve Material Design prensiplerini öğreneceğiz.

## 📱 Bu Haftanın Yenilikleri

- Flutter kurulumu
- Temel widget'lar
- Material Design kullanımı
- Basit sayfa yapısı

## 🚀 Kurulum Adımları

1. Flutter SDK'yı kurun:
```bash
# Windows için
git clone https://github.com/flutter/flutter.git
# Ortam değişkenlerine Flutter'ı ekleyin

# macOS için
brew install flutter

# Linux için
sudo snap install flutter --classic
```

2. Yeni bir Flutter projesi oluşturun:
```bash
flutter create habit_tracker
cd habit_tracker
```

3. `pubspec.yaml` dosyasını güncelleyin:
```yaml
name: habit_tracker
description: Alışkanlık takip uygulaması.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
```

4. `lib/main.dart` dosyasını oluşturun.

## 🔍 Kod İncelemesi

### 1. Ana Uygulama Yapısı
```dart
void main() {
  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alışkanlık Takip',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const AnaSayfa(),
    );
  }
}
```

### 2. Ana Sayfa Yapısı
```dart
class AnaSayfa extends StatelessWidget {
  const AnaSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alışkanlık Takip'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Text('Hoş Geldiniz!'),
      ),
    );
  }
}
```

## 🎯 Öğrenme Hedefleri

Bu hafta:
- Flutter geliştirme ortamını kurmayı
- Temel widget'ları kullanmayı
- Material Design prensiplerini uygulamayı
- Basit bir sayfa yapısı oluşturmayı
öğrenmiş olacaksınız.

## 📝 Özelleştirme Önerileri

1. Tema:
   - Kendi renk şemanızı oluşturun
   - Özel yazı tipleri ekleyin
   - Dark/Light tema desteği ekleyin

2. Sayfa Yapısı:
   - AppBar'a menü ekleyin
   - Floating action button ekleyin
   - Drawer menü ekleyin

3. Widget'lar:
   - Card widget'ı kullanın
   - ListView ekleyin
   - Custom widget'lar oluşturun

## 💡 Sonraki Hafta

Gelecek hafta ekleyeceğimiz özellikler:
- Alışkanlık listesi
- Form işlemleri
- StatefulWidget kullanımı
- Temel state yönetimi

## 🔍 Önemli Notlar

- Hot Reload özelliğini etkin kullanın
- Widget ağacını düzgün yapılandırın
- Material Design kurallarına uyun
- Kodunuzu düzenli tutun 