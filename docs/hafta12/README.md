# Hafta 12 - Uygulama Yayınlama ve Mağaza Optimizasyonu

Bu hafta, Flutter uygulamalarının mağaza yayınlama sürecini ve ASO (App Store Optimization) stratejilerini öğreneceğiz.

## 🎯 Bu Hafta Neler Öğreneceğiz?

1. Mağaza Hazırlığı
   - Uygulama kimliği
   - Görsel materyaller
   - Açıklamalar ve anahtar kelimeler
   - Gizlilik politikası

2. Android Yayınlama
   - Play Store hesap yönetimi
   - Uygulama paketi hazırlama
   - Mağaza listesi optimizasyonu
   - Release yönetimi

3. iOS Yayınlama
   - App Store Connect yönetimi
   - TestFlight dağıtımı
   - App Review süreci
   - Versiyon güncelleme

4. ASO Stratejileri
   - Anahtar kelime optimizasyonu
   - Görsel optimizasyon
   - Kullanıcı değerlendirmeleri
   - A/B testleri

## 📚 Konu Anlatımı

### 1. Mağaza Hazırlığı

```yaml
# pubspec.yaml
name: my_app
description: >
  Alışkanlık takip uygulaması ile günlük rutinlerinizi
  kolayca takip edin ve hedeflerinize ulaşın.
version: 1.0.0+1

flutter_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"

flutter_native_splash:
  color: "#FFFFFF"
  image: assets/splash/splash.png
```

### 2. Android Yayınlama

```bash
# Key oluşturma
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload

# Release build
flutter build appbundle --release
```

### 3. iOS Yayınlama

```bash
# iOS build
flutter build ipa --release

# TestFlight yükleme
xcrun altool --upload-app -f build/ios/ipa/*.ipa \
  -u "apple@email.com" -p "app-specific-password"
```

### 4. ASO Stratejileri

1. **Anahtar Kelime Analizi**:
   ```json
   {
     "title": "Alışkanlık Takip - Rutin Planlayıcı",
     "keywords": "alışkanlık,rutin,takip,planlayıcı,hedef,motivasyon",
     "short_description": "Günlük rutinlerinizi takip edin",
     "long_description": "Alışkanlık Takip uygulaması ile...",
   }
   ```

2. **Görsel Optimizasyon**:
   - Ekran görüntüleri
   - Özellik grafikleri
   - Tanıtım videosu
   - App icon

## 💻 Örnek Uygulama: Mağaza Yönetim Paneli

Bu haftaki örnek uygulamamızda, uygulama mağazası yönetimi için bir panel geliştireceğiz. Detaylar için [tıklayınız](./ornek_uygulama/README.md).

## 🚀 Ana Proje: Alışkanlık Takip Uygulaması

Bu hafta ana projemizde şunları yapacağız:

1. Mağaza hazırlıkları
2. Release sürümü
3. ASO optimizasyonu
4. Yayınlama süreci

Ana proje detayları için [tıklayınız](./ana_proje/README.md).

## 🎯 Alıştırmalar

1. Mağaza Hazırlığı:
   - [ ] App icon tasarlayın
   - [ ] Screenshot'lar hazırlayın
   - [ ] Açıklamalar yazın
   - [ ] Gizlilik politikası oluşturun

2. Android Yayınlama:
   - [ ] Keystore oluşturun
   - [ ] Release build alın
   - [ ] Play Store hesabı açın
   - [ ] Uygulama yükleyin

3. iOS Yayınlama:
   - [ ] Sertifika oluşturun
   - [ ] Provisioning profile alın
   - [ ] TestFlight'a yükleyin
   - [ ] App Store'a gönderin

4. ASO:
   - [ ] Keyword araştırması yapın
   - [ ] A/B testi planlayın
   - [ ] Görsel optimizasyon yapın
   - [ ] Değerlendirme stratejisi oluşturun

## 🔍 Hata Ayıklama İpuçları

1. Release Hataları:
   - ProGuard kurallarını kontrol edin
   - Signing ayarlarını doğrulayın
   - Bağımlılıkları gözden geçirin
   - Performans testleri yapın

2. Mağaza Redleri:
   - Gizlilik politikasını kontrol edin
   - Ekran görüntülerini güncelleyin
   - Açıklamaları düzenleyin
   - Metadata'yı gözden geçirin

## 📚 Faydalı Kaynaklar

- [Flutter Release Guide](https://flutter.dev/docs/deployment/android)
- [App Store Guidelines](https://developer.apple.com/app-store/guidelines/)
- [Play Store Guidelines](https://play.google.com/about/developer-content-policy/)
- [ASO Guide](https://developer.android.com/distribute/best-practices/launch) 