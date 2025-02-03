# Hafta 14: Store Yayınlama ve Release Management

Bu haftada HabitMaster uygulamamızı App Store ve Play Store'da yayınlamak için hazırlayacağız.

## 🎯 Hedefler

- Store yayınlama hazırlıkları
- Store listing optimizasyonu
- Release management
- App signing

## 📝 Konu Başlıkları

1. Store Hazırlıkları
   - App Store hesabı
   - Play Store hesabı
   - Store listing
   - Screenshot hazırlama

2. Release Management
   - Versiyonlama
   - Release notes
   - Beta testing
   - Staged rollout

3. App Signing
   - iOS certificates
   - Android keystore
   - Signing configuration
   - Release build

## 💻 Adım Adım Uygulama Geliştirme

### 1. Android Release Hazırlığı

```bash
# key.properties dosyası oluşturma
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=../upload-keystore.jks

# Keystore oluşturma
keytool -genkey -v -keystore upload-keystore.jks \
        -keyalg RSA \
        -keysize 2048 \
        -validity 10000 \
        -alias upload

# build.gradle yapılandırması
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
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'),
                    'proguard-rules.pro'
        }
    }
}
```

### 2. Store Listing Hazırlığı

```yaml
# store_listing.yaml
app_name: HabitMaster
short_description: |
  Alışkanlıklarınızı takip edin, hedeflerinize ulaşın!

full_description: |
  HabitMaster, günlük, haftalık ve aylık alışkanlıklarınızı takip etmenize 
  yardımcı olan güçlü bir alışkanlık takip uygulamasıdır.

  ÖZELLİKLER:
  ✓ Alışkanlık oluşturma ve takibi
  ✓ Hatırlatıcılar ve bildirimler
  ✓ İlerleme istatistikleri
  ✓ Özelleştirilebilir temalar
  ✓ Offline kullanım
  ✓ Veri senkronizasyonu

  Düzenli alışkanlıklar edinmek ve hedeflerinize ulaşmak için 
  HabitMaster'ı hemen indirin!

keywords:
  - alışkanlık takibi
  - hedef yönetimi
  - kişisel gelişim
  - verimlilik
  - hatırlatıcı
  - motivasyon

screenshots:
  - path: screenshots/1_home.png
    title: Ana Sayfa
    description: Tüm alışkanlıklarınızı tek bir yerden yönetin
  
  - path: screenshots/2_add_habit.png
    title: Alışkanlık Ekleme
    description: Yeni alışkanlıklar oluşturun ve özelleştirin
  
  - path: screenshots/3_statistics.png
    title: İstatistikler
    description: İlerlemenizi detaylı grafiklerle takip edin
```

### 3. Release Script

```dart
// scripts/release.dart
import 'dart:io';

Future<void> main() async {
  final version = await _getVersion();
  
  // Android build
  print('Building Android release...');
  await _buildAndroid();
  
  // iOS build
  print('Building iOS release...');
  await _buildIOS();
  
  // Create release notes
  await _createReleaseNotes(version);
  
  print('Release $version prepared successfully!');
}

Future<String> _getVersion() async {
  final pubspec = File('pubspec.yaml');
  final content = await pubspec.readAsString();
  final versionLine = content.split('\n')
      .firstWhere((line) => line.startsWith('version:'));
  return versionLine.split(':')[1].trim();
}

Future<void> _buildAndroid() async {
  final result = await Process.run('flutter', [
    'build',
    'appbundle',
    '--release',
  ]);
  
  if (result.exitCode != 0) {
    throw Exception('Android build failed: ${result.stderr}');
  }
}

Future<void> _buildIOS() async {
  final result = await Process.run('flutter', [
    'build',
    'ipa',
    '--release',
  ]);
  
  if (result.exitCode != 0) {
    throw Exception('iOS build failed: ${result.stderr}');
  }
}

Future<void> _createReleaseNotes(String version) async {
  final notes = '''
Version $version

Yeni Özellikler:
- Özellik 1
- Özellik 2

İyileştirmeler:
- İyileştirme 1
- İyileştirme 2

Hata Düzeltmeleri:
- Düzeltme 1
- Düzeltme 2
''';

  await File('release_notes.txt').writeAsString(notes);
}
```

## 📝 Ödevler

1. App Store ve Play Store hesaplarını oluşturun
2. Store listing için görsel materyaller hazırlayın
3. Release pipeline'ı otomatikleştirin

## 🎉 Kurs Tamamlandı!

Tebrikler! 14 haftalık Flutter eğitimini başarıyla tamamladınız. 
Artık profesyonel Flutter uygulamaları geliştirebilecek bilgi ve 
deneyime sahipsiniz. Öğrendiklerinizi pekiştirmek için:

1. Kendi projelerinizi geliştirmeye başlayın
2. Açık kaynak projelere katkıda bulunun
3. Flutter topluluğuna katılın
4. Sürekli öğrenmeye devam edin

İyi kodlamalar! 🚀 