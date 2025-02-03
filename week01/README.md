# Hafta 1: Proje Kurulumu ve Temel UI

Bu haftada HabitMaster uygulamamızın temellerini oluşturacağız. Flutter projesini kurup, temel UI yapısını tasarlayacağız.

## 🎯 Hedefler

- Flutter projesinin oluşturulması
- Proje klasör yapısının düzenlenmesi
- Ana ekran tasarımının yapılması
- Bottom Navigation Bar eklenmesi
- Temel tema ayarlarının yapılması

## 📝 Konu Başlıkları

1. Proje Kurulumu
   - Flutter projesinin oluşturulması
   - Gerekli paketlerin eklenmesi
   - Klasör yapısının düzenlenmesi

2. Temel UI Tasarımı
   - Material Design kullanımı
   - Custom tema oluşturma
   - Renk paleti belirleme

3. Ana Ekran Yapısı
   - Bottom Navigation Bar
   - Ana sayfa tasarımı
   - Görev listesi görünümü

## 💻 Adım Adım Uygulama Geliştirme

### 1. Proje Oluşturma ve Paket Kurulumu

```bash
flutter create habit_master
cd habit_master
```

pubspec.yaml dosyasını düzenleyin:

```yaml
name: habit_master
description: Alışkanlık takip uygulaması
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  google_fonts: ^6.1.0
  flutter_riverpod: ^2.4.9
  go_router: ^13.0.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
```

### 2. Temel Klasör Yapısının Oluşturulması

```
lib/
  ├── core/
  │   ├── constants/
  │   │   ├── app_colors.dart
  │   │   └── app_text_styles.dart
  │   └── theme/
  │       └── app_theme.dart
  ├── features/
  │   ├── habits/
  │   │   ├── presentation/
  │   │   │   ├── screens/
  │   │   │   └── widgets/
  │   │   └── data/
  │   │       └── models/
  │   └── settings/
  │       └── presentation/
  │           └── screens/
  └── main.dart
```

## 📝 Ödevler

1. Uygulamaya kendi renk paletinizi ekleyin
2. Bottom Navigation Bar'a custom ikonlar ekleyin
3. Ana sayfaya bir FAB (Floating Action Button) ekleyin ve tıklandığında bir SnackBar gösterin

## 🔍 Sonraki Adımlar

Gelecek hafta:
- Alışkanlık ekleme formunu oluşturacağız
- Form validasyonlarını öğreneceğiz
- Dialog ve modal bottom sheet kullanımını göreceğiz
