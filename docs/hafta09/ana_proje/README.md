# Hafta 9 - Ana Proje: Alışkanlık Takip Uygulaması Yayını

Bu hafta, alışkanlık takip uygulamamızı mağazalarda yayınlamak için hazırlayacağız.

## 🎯 Hedefler

1. Uygulama Kimliği
   - Uygulama adı: "Alışkanlık Takipçisi"
   - Bundle ID: `com.example.habittracker`
   - Sürüm: `1.0.0+1`

2. Görsel Öğeler
   - Minimal ve modern uygulama simgesi
   - Animasyonlu başlangıç ekranı
   - Etkileyici store görselleri
   - Özellik tanıtım videosu

3. Store Bilgileri
   - Detaylı uygulama açıklaması
   - Kapsamlı gizlilik politikası
   - KVKK uyumlu kullanım koşulları
   - Sık sorulan sorular

4. Teknik Hazırlık
   - Release optimizasyonları
   - Güvenlik kontrolleri
   - Test otomasyonu
   - CI/CD kurulumu

## 💻 Adım Adım Geliştirme

### 1. Uygulama Hazırlığı

#### `pubspec.yaml` Düzenlemeleri

```yaml
name: habit_tracker
description: Alışkanlıklarınızı takip etmenin en kolay yolu

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  google_sign_in: ^6.2.1
  flutter_secure_storage: ^9.0.0
  provider: ^6.1.1
  flutter_riverpod: ^2.4.9
  flutter_bloc: ^8.1.3
  shared_preferences: ^2.2.2
  path_provider: ^2.1.1
  sqflite: ^2.3.0
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  flutter_launcher_icons: ^0.13.1
  flutter_native_splash: ^2.3.9
  build_runner: ^2.4.7
  mockito: ^5.4.4
  integration_test:
    sdk: flutter
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
  remove_alpha_ios: true
```

#### Başlangıç Ekranı

`flutter_native_splash.yaml`:
```yaml
flutter_native_splash:
  color: "#FFFFFF"
  image: assets/splash/splash.png
  branding: assets/splash/branding.png
  color_dark: "#121212"
  image_dark: assets/splash/splash_dark.png
  branding_dark: assets/splash/branding_dark.png

  android_12:
    image: assets/splash/splash_android12.png
    icon_background_color: "#FFFFFF"
    image_dark: assets/splash/splash_android12_dark.png
    icon_background_color_dark: "#121212"
```

### 2. Test Otomasyonu

#### Birim Testler

`test/unit/habit_service_test.dart`:
```dart
void main() {
  group('HabitService Tests', () {
    late HabitService habitService;
    late MockFirestore mockFirestore;

    setUp(() {
      mockFirestore = MockFirestore();
      habitService = HabitService(firestore: mockFirestore);
    });

    test('createHabit başarılı olmalı', () async {
      final habit = Habit(
        id: 'test_id',
        title: 'Test Habit',
        description: 'Test Description',
        createdAt: DateTime.now(),
      );

      when(mockFirestore.collection('habits').add(any))
          .thenAnswer((_) async => MockDocumentReference());

      final result = await habitService.createHabit(habit);
      expect(result, true);
    });
  });
}
```

#### Widget Testler

`test/widget/habit_list_test.dart`:
```dart
void main() {
  testWidgets('HabitList widget testi', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HabitList(),
      ),
    );

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(HabitCard), findsNWidgets(3));
    
    await tester.tap(find.byType(HabitCard).first);
    await tester.pumpAndSettle();
    
    expect(find.byType(HabitDetailScreen), findsOneWidget);
  });
}
```

### 3. CI/CD Pipeline

#### GitHub Actions

`.github/workflows/main.yml`:
```yaml
name: CI/CD
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          channel: 'stable'
      
      - name: Get dependencies
        run: flutter pub get
      
      - name: Analyze
        run: flutter analyze
      
      - name: Run tests
        run: flutter test

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '17'
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
      
      - name: Build APK
        run: flutter build apk --release
      
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: release-apk
          path: build/app/outputs/flutter-apk/app-release.apk

  deploy-firebase:
    needs: build-android
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v3
        with:
          name: release-apk
      
      - name: Firebase App Distribution
        uses: wzieba/Firebase-Distribution-Github-Action@v1
        with:
          appId: ${{ secrets.FIREBASE_APP_ID }}
          token: ${{ secrets.FIREBASE_TOKEN }}
          groups: testers
          file: app-release.apk
```

### 4. Store Hazırlığı

#### Play Store Açıklaması

```
Alışkanlık Takipçisi: Hedeflerinize ulaşmanın en kolay yolu!

ÖZELLİKLER:
• Kolay alışkanlık oluşturma ve takip
• Günlük, haftalık ve aylık istatistikler
• Hatırlatıcılar ve bildirimler
• Detaylı ilerleme grafikleri
• Motivasyon notları
• Karanlık mod desteği

NEDEN ALIŞKANLIK TAKİPÇİSİ?
• Kullanıcı dostu arayüz
• Özelleştirilebilir temalar
• Offline çalışma
• Güvenli veri saklama
• Düzenli yedekleme
• Ücretsiz kullanım
```

#### App Store Açıklaması

```
Alışkanlıklarınızı takip etmek ve yeni alışkanlıklar edinmek hiç bu kadar kolay olmamıştı! 

Alışkanlık Takipçisi ile:
• Yeni alışkanlıklar oluşturun
• İlerlemenizi takip edin
• Motivasyonunuzu koruyun
• Hedeflerinize ulaşın

Öne Çıkan Özellikler:
• Sezgisel kullanıcı arayüzü
• Detaylı istatistikler
• Özelleştirilebilir hatırlatıcılar
• İlerleme grafikleri
• Başarı rozetleri
• Tema desteği
```

## 🎯 Kontrol Listesi

1. Yayın Öncesi:
   - [ ] Tüm testler geçiyor
   - [ ] Performans optimizasyonları tamam
   - [ ] Bellek sızıntısı yok
   - [ ] Çökme raporları temiz

2. Store Hazırlığı:
   - [ ] Tüm görseller hazır
   - [ ] Açıklamalar eksiksiz
   - [ ] Gizlilik politikası güncel
   - [ ] KVKK metinleri hazır

3. Teknik Kontroller:
   - [ ] ProGuard kuralları test edildi
   - [ ] CI/CD pipeline çalışıyor
   - [ ] Firebase yapılandırması tamam
   - [ ] API anahtarları güvende

## 💡 İpuçları

1. Yayın Stratejisi:
   - Aşamalı dağıtım kullanın
   - Beta testlerini ihmal etmeyin
   - Kullanıcı geri bildirimlerini dinleyin
   - Düzenli güncellemeler planlayın

2. Optimizasyon:
   - APK boyutunu küçültün
   - Başlangıç süresini optimize edin
   - Pil tüketimini azaltın
   - Önbellek kullanımını optimize edin

3. Pazarlama:
   - ASO çalışması yapın
   - Sosyal medya kullanın
   - Blog yazıları hazırlayın
   - Kullanıcı yorumlarını yanıtlayın

## 📚 Faydalı Kaynaklar

- [Flutter Release Guide](https://flutter.dev/docs/deployment/android)
- [Firebase Distribution](https://firebase.google.com/docs/app-distribution)
- [Play Console Help](https://support.google.com/googleplay/android-developer)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/) 