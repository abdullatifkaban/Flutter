# Flutter ile Uygulama Geliştirmeye Giriş

![Flutter Overview](https://lilacinfotech.com/lilac_assets/images/blog/Why-Google-Flutter.jpg)

[Kaynak](https://lilacinfotech.com/lilac_assets/images/blog/Why-Google-Flutter.jpg)

## Flutter Nedir?
Flutter, modern çapraz platform uygulama geliştirme dünyasının öncü teknolojilerinden biridir. Google tarafından geliştirilen bu framework, aşağıdaki özellikleriyle öne çıkar:

- **Tek Kod Tabanı**: iOS, Android, web, Windows, macOS ve Linux platformları için tek bir kod tabanından native uygulamalar geliştirmenize olanak tanır. Bu özellik, geliştirme sürecini hızlandırır ve bakım maliyetlerini düşürür.

- **Hot Reload**: Kod değişikliklerini anında görebilmenizi sağlayan Hot Reload özelliği, geliştirme sürecini hızlandırır ve deneysel yaklaşımı kolaylaştırır. Uygulamanın mevcut durumunu kaybetmeden değişiklikleri test edebilirsiniz.

- **Widget Sistemi**: Her şeyin widget olduğu deklaratif UI yaklaşımı, karmaşık arayüzleri bile kolayca oluşturmanıza olanak sağlar. Material Design ve Cupertino widget'ları ile platform-spesifik görünümler elde edebilirsiniz.

- **Performans**: Dart dilinin sunduğu ahead-of-time (AOT) derleme özelliği ve kendi render motoru sayesinde yüksek performanslı uygulamalar geliştirebilirsiniz.

## Geliştirme Ortamının Hazırlanması

### 1. Flutter SDK Kurulumu

Flutter SDK'yı işletim sisteminize uygun şekilde kurmanız gerekir:

- **Linux için**:
```bash
# SDK'yı indirme ve çıkarma
cd ~/development
tar xf ~/Downloads/flutter_linux_3.x.x-stable.tar.xz

# PATH'e ekleme
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
```

- **Dart SDK**: Flutter SDK ile otomatik olarak gelir, ayrıca kurulum gerektirmez.

### 2. IDE Yapılandırması

Modern Flutter geliştirmesi için iki popüler IDE seçeneği bulunur:

- **Visual Studio Code Kurulumu**:
  - VS Code'u sisteminize yükleyin
  - Flutter ve Dart eklentilerini kurun
  - Komut paletinden Flutter: New Project komutunu kullanarak yeni projeler oluşturun
  - Flutter Widget Snippets ile kod yazımını hızlandırın

- **Android Studio Kurulumu**:
  - Android Studio'yu indirip kurun
  - Flutter ve Dart pluginlerini yükleyin
  - Android SDK Manager'ı kullanarak gerekli SDK'ları indirin
  - Emülatör oluşturun ve yapılandırın

### 3. Platform Geliştirme Araçları

Hedef platformlara göre ek araçların kurulumu gerekir:

- **Android Geliştirme için**:
  - Android SDK
  - Platform-tools
  - Build-tools
  - Android Emulator
  - Google USB Driver (Windows için)

- **iOS Geliştirme için** (macOS gerektirir):
  - Xcode
  - iOS Simulator
  - CocoaPods
  - iOS Deployment Tools

### 4. Doğrulama ve Test

Kurulumun başarılı olduğunu doğrulamak için:

```bash
flutter doctor
```

Bu komut aşağıdaki kontrolleri gerçekleştirir:
- Flutter SDK durumu
- Gerekli araçların varlığı
- IDE kurulumları
- Platform araçları
- Lisans durumları

### 5. İlk Flutter Projesini Oluşturma

```bash
# Yeni proje oluşturma
flutter create ilk_uygulama

# Proje dizinine geçiş
cd ilk_uygulama

# Uygulamayı çalıştırma
flutter run
```

> [!NOTE]
> İlk uygulama oluşturma örneği için [Flutter'ın resmi belgelerine](https://codelabs.developers.google.com/codelabs/flutter-codelab-first?hl=tr) bakabilirsiniz.

## Önerilen Geliştirme Araçları

### IDE Eklentileri
- **Flutter**: Temel Flutter geliştirme desteği
- **Dart**: Dart dili desteği ve kod tamamlama
- **Flutter Widget Snippets**: Hazır widget şablonları
- **Awesome Flutter Snippets**: Gelişmiş kod parçacıkları
- **Flutter Tree**: Widget ağacı görselleştirme
- **pubspec Assist**: Paket yönetimi yardımcısı

### Debugging Araçları
- Flutter DevTools
- Dart Debug Extension
- Performance Profiler
- Layout Explorer

### Tasarım Araçları
- Flutter Inspector
- Widget Inspector
- Material Theme Editor
- Color Picker

Bu kurulum ve yapılandırma adımlarını tamamladıktan sonra Flutter ile modern, performanslı ve çapraz platform uygulamalar geliştirmeye başlayabilirsiniz. 