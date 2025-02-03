# Hafta 9 - Örnek Uygulama: Yayın Hazırlığı

Bu haftaki örnek uygulamamızda, önceki haftalarda geliştirdiğimiz şifre yöneticisi uygulamasını yayına hazırlayacağız.

## 🎯 Hedefler

1. Uygulama Kimliği
   - Uygulama adı: "Güvenli Şifre Yöneticisi"
   - Bundle ID: `com.example.securepasswordmanager`
   - Sürüm: `1.0.0+1`

2. Görsel Öğeler
   - Uygulama simgesi
   - Başlangıç ekranı
   - Store görselleri
   - Tanıtım videosu

3. Store Bilgileri
   - Uygulama açıklaması
   - Gizlilik politikası
   - Kullanım koşulları
   - SSS

4. Teknik Hazırlık
   - Release yapılandırması
   - ProGuard kuralları
   - CI/CD pipeline
   - Test otomasyonu

## 💻 Adım Adım Geliştirme

### 1. Uygulama Hazırlığı

#### `pubspec.yaml` Düzenlemeleri

```yaml
name: secure_password_manager
description: Güvenli şifre yönetimi uygulaması

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  google_sign_in: ^6.2.1
  flutter_secure_storage: ^9.0.0
  local_auth: ^2.1.7
  encrypt: ^5.0.3
  crypto: ^3.0.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  flutter_launcher_icons: ^0.13.1
  flutter_native_splash: ^2.3.9
```

#### Uygulama Simgesi

`flutter_launcher_icons.yaml`:
```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon/app_icon.png"
  min_sdk_android: 21
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"
```

#### Başlangıç Ekranı

`flutter_native_splash.yaml`:
```yaml
flutter_native_splash:
  color: "#FFFFFF"
  image: assets/splash/splash.png
  branding: assets/splash/branding.png
  color_dark: "#000000"
  image_dark: assets/splash/splash_dark.png
  branding_dark: assets/splash/branding_dark.png

  android_12:
    image: assets/splash/splash_android12.png
    icon_background_color: "#FFFFFF"
    image_dark: assets/splash/splash_android12_dark.png
    icon_background_color_dark: "#000000"
```

### 2. Android Hazırlığı

#### ProGuard Kuralları

`android/app/proguard-rules.pro`:
```pro
# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Encryption
-keep class javax.crypto.** { *; }
-keep class javax.crypto.spec.** { *; }
```

#### Release Yapılandırması

`android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }

    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
            signingConfig signingConfigs.release
            
            ndk {
                abiFilters 'armeabi-v7a', 'arm64-v8a', 'x86_64'
            }
        }
    }
}
```

### 3. iOS Hazırlığı

#### Info.plist Ayarları

`ios/Runner/Info.plist`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDisplayName</key>
    <string>Güvenli Şifre Yöneticisi</string>
    <key>CFBundleIdentifier</key>
    <string>com.example.securepasswordmanager</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>ITSAppUsesNonExemptEncryption</key>
    <false/>
    <key>NSFaceIDUsageDescription</key>
    <string>Güvenli giriş için Face ID kullanımına izin verin</string>
</dict>
</plist>
```

### 4. CI/CD Pipeline

#### GitHub Actions

`.github/workflows/release.yml`:
```yaml
name: Release
on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run tests
        run: flutter test
      
      - name: Build Android Bundle
        run: flutter build appbundle --release
      
      - name: Upload to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.PLAYSTORE_ACCOUNT_KEY }}
          packageName: com.example.securepasswordmanager
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
          track: internal
          
      - name: Build iOS
        run: flutter build ios --release --no-codesign
```

#### Fastlane

`fastlane/Fastfile`:
```ruby
default_platform(:android)

platform :android do
  desc "Deploy to Play Store Internal"
  lane :internal do
    gradle(
      task: "clean bundleRelease",
      project_dir: "android/"
    )
    upload_to_play_store(
      track: 'internal',
      aab: '../build/app/outputs/bundle/release/app-release.aab',
      skip_upload_metadata: true,
      skip_upload_images: true,
      skip_upload_screenshots: true
    )
  end
end

platform :ios do
  desc "Deploy to TestFlight"
  lane :beta do
    build_ios_app(
      scheme: "Runner",
      export_method: "app-store"
    )
    upload_to_testflight(
      skip_waiting_for_build_processing: true
    )
  end
end
```

## 📱 Store Hazırlığı

### Play Store

1. Uygulama Açıklaması:
```
Güvenli Şifre Yöneticisi, tüm şifrelerinizi güvenle saklayabileceğiniz, modern ve kullanıcı dostu bir uygulamadır.

ÖZELLİKLER:
• AES-256 şifreleme
• Biometrik kimlik doğrulama
• Otomatik şifre oluşturma
• Güvenli not alma
• Otomatik yedekleme
• Karanlık mod desteği

GÜVENLİK:
• End-to-end şifreleme
• Offline çalışma
• Ekran görüntüsü engelleme
• Otomatik kilit
• Acil silme özelliği
```

2. Gizlilik Politikası:
```markdown
# Gizlilik Politikası

## Veri Toplama
Uygulamamız, yalnızca kullanıcının açıkça izin verdiği verileri toplar ve saklar.

## Veri Güvenliği
Tüm veriler cihazınızda AES-256 şifreleme ile saklanır.

## Veri Paylaşımı
Verileriniz üçüncü taraflarla paylaşılmaz.
```

### App Store

1. Ekran Görüntüleri:
   - Giriş ekranı
   - Şifre listesi
   - Şifre detayı
   - Şifre oluşturucu
   - Ayarlar

2. Anahtar Kelimeler:
   - şifre yöneticisi
   - güvenli depolama
   - şifre oluşturucu
   - kriptolama
   - güvenlik

## 🎯 Kontrol Listesi

1. Uygulama:
   - [ ] Tüm ekranlar test edildi
   - [ ] Performans optimizasyonu yapıldı
   - [ ] Bellek sızıntıları kontrol edildi
   - [ ] Çökme raporları incelendi

2. Store:
   - [ ] Tüm görseller hazır
   - [ ] Açıklamalar yazıldı
   - [ ] Gizlilik politikası eklendi
   - [ ] KVKK metni hazırlandı

3. Teknik:
   - [ ] ProGuard kuralları test edildi
   - [ ] CI/CD pipeline çalışıyor
   - [ ] Sertifikalar hazır
   - [ ] API anahtarları güvende

## 💡 İpuçları

1. Release:
   - Her sürümü test edin
   - Aşamalı dağıtım kullanın
   - Beta testlerini ihmal etmeyin
   - Kullanıcı geri bildirimlerini takip edin

2. Store:
   - ASO (App Store Optimization) yapın
   - Düzenli güncelleme planlayın
   - Kullanıcı yorumlarını yanıtlayın
   - Analytics takibi yapın

## 📚 Faydalı Kaynaklar

- [Flutter Release Guide](https://flutter.dev/docs/deployment/android)
- [App Store Guidelines](https://developer.apple.com/app-store/guidelines/)
- [Play Store Guidelines](https://play.google.com/about/developer-content-policy/)
- [Fastlane Docs](https://docs.fastlane.tools) 