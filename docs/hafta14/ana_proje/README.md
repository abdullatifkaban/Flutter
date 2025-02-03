# Hafta 14 - Alışkanlık Takip Uygulaması: Uluslararasılaştırma ve Yerelleştirme

Bu hafta, uygulamamızı farklı dillere ve kültürlere uygun hale getireceğiz.

## 📱 Bu Haftanın Yenilikleri

- Çoklu dil desteği
- RTL (Sağdan sola) desteği
- Yerel tarih ve saat formatları
- Kültürel uyarlamalar
- Dil seçimi arayüzü

## 🚀 Kurulum Adımları

1. Gerekli paketleri `pubspec.yaml` dosyasına ekleyin:
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.1
  easy_localization: ^3.0.3
  flutter_localized_locales: ^2.0.5

flutter:
  generate: true
```

2. `lib` klasörü altında aşağıdaki dosyaları ve klasörleri oluşturun:
   - `l10n/app_tr.arb`: Türkçe çeviriler
   - `l10n/app_en.arb`: İngilizce çeviriler
   - `l10n/app_ar.arb`: Arapça çeviriler
   - `utils/dil_yoneticisi.dart`
   - `config/yerellestime_ayarlari.dart`

## 🔍 Kod İncelemesi

### 1. ARB Dosyaları
```arb
// app_tr.arb
{
  "@@locale": "tr",
  "appTitle": "Alışkanlık Takipçisi",
  "welcomeMessage": "Hoş Geldiniz!",
  "addHabit": "Alışkanlık Ekle",
  "settings": "Ayarlar",
  "statistics": "İstatistikler",
  "profile": "Profil",
  "language": "Dil",
  "theme": "Tema",
  "darkMode": "Karanlık Mod",
  "notifications": "Bildirimler",
  "about": "Hakkında",
  "@addHabit": {
    "description": "Ana sayfadaki alışkanlık ekleme butonu"
  }
}

// app_en.arb
{
  "@@locale": "en",
  "appTitle": "Habit Tracker",
  "welcomeMessage": "Welcome!",
  "addHabit": "Add Habit",
  "settings": "Settings",
  "statistics": "Statistics",
  "profile": "Profile",
  "language": "Language",
  "theme": "Theme",
  "darkMode": "Dark Mode",
  "notifications": "Notifications",
  "about": "About"
}

// app_ar.arb
{
  "@@locale": "ar",
  "appTitle": "متتبع العادات",
  "welcomeMessage": "مرحباً بك!",
  "addHabit": "إضافة عادة",
  "settings": "الإعدادات",
  "statistics": "الإحصائيات",
  "profile": "الملف الشخصي",
  "language": "اللغة",
  "theme": "المظهر",
  "darkMode": "الوضع الداكن",
  "notifications": "الإشعارات",
  "about": "حول"
}
```

### 2. Dil Yöneticisi
```dart
class DilYoneticisi {
  static const List<Locale> desteklenenDiller = [
    Locale('tr'),
    Locale('en'),
    Locale('ar'),
  ];

  static const varsayilanDil = Locale('tr');

  static Future<void> dilDegistir(BuildContext context, Locale yeniDil) async {
    if (desteklenenDiller.contains(yeniDil)) {
      await EasyLocalization.of(context)?.setLocale(yeniDil);
      await _tercihleriKaydet(yeniDil);
    }
  }

  static Future<void> _tercihleriKaydet(Locale dil) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('secili_dil', dil.languageCode);
  }

  static bool rtlMi(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  static String tarihFormatla(DateTime tarih, BuildContext context) {
    final dil = EasyLocalization.of(context)?.locale ?? varsayilanDil;
    return DateFormat.yMMMd(dil.toString()).format(tarih);
  }
}
```

### 3. Yerelleştirme Ayarları
```dart
class YerellestirmeAyarlari extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        EasyLocalization.of(context)!.delegate,
      ],
      supportedLocales: DilYoneticisi.desteklenenDiller,
      locale: EasyLocalization.of(context)?.locale,
      builder: (context, child) {
        return Directionality(
          textDirection: DilYoneticisi.rtlMi(context)
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: child!,
        );
      },
      // ... diğer uygulama ayarları
    );
  }
}
```

## 🎯 Öğrenme Hedefleri

Bu hafta:
- Uluslararasılaştırma prensiplerini
- ARB dosyası yönetimini
- RTL desteği eklemeyi
- Yerel format kullanımını
öğrenmiş olacaksınız.

## 📝 Özelleştirme Önerileri

1. Dil Desteği:
   - Yeni diller ekleyin
   - Dil algılama
   - Otomatik çeviri
   - Dil tercihi kaydetme

2. Kültürel Uyarlamalar:
   - Bölgesel takvimler
   - Para birimleri
   - Ölçü birimleri
   - Renk tercihleri

3. Yerelleştirme:
   - Bölgesel içerik
   - Yerel tatiller
   - Kültürel ikonlar
   - Bölgesel temalar

## 💡 Sonraki Hafta

Gelecek hafta ekleyeceğimiz özellikler:
- Widget testleri
- Entegrasyon testleri
- Kullanıcı arayüzü testleri
- Test otomasyonu

## 🔍 Önemli Notlar

- Tüm metinleri yerelleştirin
- RTL desteğini test edin
- Tarih/saat formatlarını kontrol edin
- Kültürel hassasiyetlere dikkat edin 