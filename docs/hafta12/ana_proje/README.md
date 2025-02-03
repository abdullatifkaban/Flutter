# Hafta 12 - Ana Proje: Mağaza Yayınlama

Bu hafta, alışkanlık takip uygulamamızı mağazalarda yayınlamak için hazırlayacağız.

## 🎯 Hedefler

1. Mağaza Hazırlığı
   - App icon ve splash screen
   - Ekran görüntüleri ve videolar
   - Mağaza açıklamaları
   - Gizlilik politikası

2. Release Hazırlığı
   - Versiyon yönetimi
   - ProGuard kuralları
   - Signing ayarları
   - Performance optimizasyonu

3. ASO Stratejisi
   - Anahtar kelime araştırması
   - Rakip analizi
   - Görsel optimizasyon
   - Değerlendirme yönetimi

## 💻 Adım Adım Geliştirme

### 1. Mağaza Hazırlığı

`pubspec.yaml`:
```yaml
name: habit_tracker
description: >
  Alışkanlık Takip uygulaması ile günlük rutinlerinizi
  kolayca planlayın, takip edin ve hedeflerinize ulaşın.
  Motivasyonunuzu yüksek tutun, istatistiklerinizi görün
  ve başarılarınızı kutlayın.
version: 1.0.0+1

dependencies:
  flutter:
    sdk: flutter
  flutter_launcher_icons: ^0.13.1
  flutter_native_splash: ^2.3.13

flutter_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/icon/icon_foreground.png"

flutter_native_splash:
  color: "#FFFFFF"
  image: assets/splash/splash.png
  branding: assets/splash/branding.png
  android_12:
    image: assets/splash/splash_android12.png
    branding: assets/splash/branding_android12.png
```

### 2. Android Release

`android/key.properties`:
```properties
storePassword=*****
keyPassword=*****
keyAlias=upload
storeFile=../upload-keystore.jks
```

`android/app/build.gradle`:
```gradle
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

### 3. iOS Release

`ios/Runner.xcodeproj/project.pbxproj`:
```xcconfig
PRODUCT_BUNDLE_IDENTIFIER = com.example.habitTracker
PRODUCT_NAME = Alışkanlık Takip
MARKETING_VERSION = 1.0.0
CURRENT_PROJECT_VERSION = 1
```

### 4. Mağaza Metadataları

`metadata/android/tr-TR/full_description.txt`:
```text
Alışkanlık Takip uygulaması ile hayatınızı düzene sokun!

✨ Özellikler:
• Kolay alışkanlık oluşturma
• Günlük, haftalık, aylık hedefler
• Detaylı istatistikler
• Hatırlatıcılar
• Başarı rozetleri
• Tema desteği

🎯 Neler Yapabilirsiniz:
• Yeni alışkanlıklar edinebilir
• Mevcut alışkanlıklarınızı takip edebilir
• İlerlemenizi görebilir
• Motivasyonunuzu artırabilir
• Hedeflerinize ulaşabilirsiniz

📊 İstatistikler:
• Günlük, haftalık, aylık grafikler
• Başarı oranları
• Streak takibi
• Detaylı raporlar

⭐️ Neden Bizi Seçmelisiniz:
• Kullanıcı dostu arayüz
• Özelleştirilebilir temalar
• Offline çalışma
• Ücretsiz özellikler
• Düzenli güncellemeler

Hemen indirin ve alışkanlıklarınızı yönetmeye başlayın!
```

`metadata/ios/tr-TR/keywords.txt`:
```text
alışkanlık,rutin,takip,planlayıcı,hedef,motivasyon,hatırlatıcı,takvim,istatistik,günlük
```

## 🎯 Ödevler

1. Mağaza Hazırlığı:
   - [ ] App icon tasarımı
   - [ ] Screenshot'lar
   - [ ] Feature grafikleri
   - [ ] Tanıtım videosu

2. Release Hazırlığı:
   - [ ] ProGuard kuralları
   - [ ] Signing ayarları
   - [ ] Performance testleri
   - [ ] Crash reporting

3. ASO:
   - [ ] Keyword araştırması
   - [ ] Rakip analizi
   - [ ] A/B test planı
   - [ ] Review stratejisi

## 🔍 Kontrol Listesi

1. Android:
   - [ ] App bundle hazır mı?
   - [ ] Keystore güvende mi?
   - [ ] Metadata tam mı?
   - [ ] Store listing uygun mu?

2. iOS:
   - [ ] IPA hazır mı?
   - [ ] Sertifikalar güncel mi?
   - [ ] Screenshots uygun mu?
   - [ ] App privacy tam mı?

3. Genel:
   - [ ] Versiyon doğru mu?
   - [ ] Açıklamalar eksiksiz mi?
   - [ ] Görseller optimize mi?
   - [ ] Gizlilik politikası hazır mı?

## 💡 İpuçları

1. Mağaza Optimizasyonu:
   - Görselleri optimize edin
   - Açıklamaları zenginleştirin
   - Anahtar kelimeleri araştırın
   - Rakipleri analiz edin

2. Release Yönetimi:
   - Sürüm notları yazın
   - Beta testleri yapın
   - Feedback toplayın
   - Hataları düzeltin

## 📚 Faydalı Kaynaklar

- [Flutter Release Guide](https://flutter.dev/docs/deployment/android)
- [App Store Guidelines](https://developer.apple.com/app-store/guidelines/)
- [Play Store Guidelines](https://play.google.com/about/developer-content-policy/)
- [ASO Guide](https://developer.android.com/distribute/best-practices/launch) 