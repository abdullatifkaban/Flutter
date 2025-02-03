# Hafta 9 - Uygulama Yayınlama ve Dağıtım

Bu hafta, Flutter uygulamalarının yayınlanması ve dağıtımı konularını öğreneceğiz.

## 🎯 Bu Hafta Neler Öğreneceğiz?

1. Uygulama Hazırlığı
   - Sürüm yönetimi
   - Uygulama simgesi
   - Başlangıç ekranı
   - Uygulama açıklamaları

2. Android Yayınlama
   - Keystore oluşturma
   - Release build
   - Play Store hazırlığı
   - Uygulama bundle

3. iOS Yayınlama
   - Sertifika yönetimi
   - Provisioning profili
   - App Store hazırlığı
   - TestFlight

4. CI/CD Pipeline
   - GitHub Actions
   - Codemagic
   - Fastlane
   - Firebase App Distribution

## 📚 Konu Anlatımı

### 1. Uygulama Hazırlığı

#### Sürüm Yönetimi

`pubspec.yaml`:
```yaml
version: 1.0.0+1  # <sürüm_adı>+<build_numarası>
```

#### Uygulama Simgesi

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon/icon.png"
  min_sdk_android: 21
```

#### Başlangıç Ekranı

```yaml
dev_dependencies:
  flutter_native_splash: ^2.3.9

flutter_native_splash:
  color: "#FFFFFF"
  image: assets/splash/splash.png
  android_12:
    image: assets/splash/splash_android12.png
    color: "#FFFFFF"
  ios: true
```

### 2. Android Yayınlama

#### Keystore Oluşturma

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA \
        -keysize 2048 -validity 10000 -alias upload
```

#### Release Build

```bash
flutter build appbundle --release
# veya
flutter build apk --release
```

#### `android/key.properties`:

```properties
storePassword=<şifre>
keyPassword=<şifre>
keyAlias=upload
storeFile=../upload-keystore.jks
```

#### `android/app/build.gradle`:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 3. iOS Yayınlama

#### Sertifika Oluşturma

1. Xcode > Preferences > Accounts
2. Apple ID ekle
3. Manage Certificates
4. + > Apple Development/Distribution

#### Provisioning Profile

1. Apple Developer Portal
2. Certificates, IDs & Profiles
3. Profiles > +
4. App Store/Development seç
5. Bundle ID seç
6. Sertifika seç
7. Profil indir ve Xcode'a ekle

#### Build ve Archive

1. Product > Scheme > Runner
2. Product > Destination > Any iOS Device
3. Product > Archive
4. Distribute App > App Store Connect

### 4. CI/CD Pipeline

#### GitHub Actions

`.github/workflows/ci.yml`:
```yaml
name: CI
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          channel: 'stable'
      
      - name: Get dependencies
        run: flutter pub get
      
      - name: Run tests
        run: flutter test
      
      - name: Build APK
        run: flutter build apk --release
      
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: release-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

#### Fastlane

`android/fastlane/Fastfile`:
```ruby
default_platform(:android)

platform :android do
  desc "Deploy to Play Store"
  lane :deploy do
    gradle(
      task: "clean bundleRelease",
      project_dir: "android/"
    )
    upload_to_play_store(
      track: 'internal',
      aab: '../build/app/outputs/bundle/release/app-release.aab'
    )
  end
end
```

`ios/fastlane/Fastfile`:
```ruby
default_platform(:ios)

platform :ios do
  desc "Deploy to App Store"
  lane :deploy do
    build_ios_app(
      scheme: "Runner",
      export_method: "app-store"
    )
    upload_to_app_store(
      skip_screenshots: true,
      skip_metadata: true
    )
  end
end
```

## 💻 Örnek Uygulama: Yayın Hazırlığı

Bu haftaki örnek uygulamamızda, önceki haftalarda geliştirdiğimiz uygulamaları yayına hazırlayacağız. Detaylar için [tıklayınız](./ornek_uygulama/README.md).

## 🚀 Ana Proje: Alışkanlık Takip Uygulaması

Bu hafta ana projemizde şunları yapacağız:

1. Uygulama hazırlığı
2. Release build'leri
3. CI/CD pipeline kurulumu
4. Dağıtım hazırlığı

Ana proje detayları için [tıklayınız](./ana_proje/README.md).

## 🎯 Alıştırmalar

1. Uygulama Hazırlığı:
   - [ ] Simge tasarlayın
   - [ ] Başlangıç ekranı hazırlayın
   - [ ] Store açıklamaları yazın
   - [ ] Ekran görüntüleri hazırlayın

2. Android:
   - [ ] Keystore oluşturun
   - [ ] Release build alın
   - [ ] Bundle oluşturun
   - [ ] Play Store hesabı açın

3. iOS:
   - [ ] Sertifika oluşturun
   - [ ] Provisioning profile alın
   - [ ] TestFlight'a yükleyin
   - [ ] App Store hesabı açın

4. CI/CD:
   - [ ] GitHub Actions kurun
   - [ ] Fastlane ekleyin
   - [ ] Firebase dağıtımı ekleyin
   - [ ] Otomatik sürüm artırma ekleyin

## 🔍 Hata Ayıklama İpuçları

- Release build'leri test edin
- ProGuard kurallarını kontrol edin
- Sertifika sorunlarını çözün
- Store kısıtlamalarını inceleyin

## 📚 Faydalı Kaynaklar

- [Flutter Deployment Guide](https://flutter.dev/docs/deployment/android)
- [Play Console Guide](https://developer.android.com/distribute/console)
- [App Store Connect Guide](https://developer.apple.com/app-store-connect/)
- [Fastlane Documentation](https://docs.fastlane.tools) 