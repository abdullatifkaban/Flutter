# Hafta 14 - Uluslararasılaştırma ve Yerelleştirme

Bu hafta, Flutter uygulamalarında çoklu dil desteği ve yerelleştirme konularını öğreneceğiz.

## 🎯 Bu Hafta Neler Öğreneceğiz?

1. Uluslararasılaştırma (i18n)
   - Çoklu dil desteği
   - Metin çevirileri
   - RTL desteği
   - Yerel formatlar

2. Yerelleştirme (l10n)
   - Tarih formatları
   - Sayı formatları
   - Para birimi formatları
   - Ölçü birimleri

3. Kültürel Uyarlama
   - Renk ve temalar
   - İkonlar ve görseller
   - İçerik uyarlaması
   - Bölgesel özellikler

4. Çeviri Yönetimi
   - ARB dosyaları
   - Çeviri araçları
   - Otomatik çeviri
   - Çeviri kalite kontrolü

## 📚 Konu Anlatımı

### 1. Uluslararasılaştırma

`pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0

flutter:
  generate: true
```

`l10n.yaml`:
```yaml
arb-dir: lib/l10n
template-arb-file: app_tr.arb
output-localization-file: app_localizations.dart
```

`lib/l10n/app_tr.arb`:
```json
{
  "appTitle": "Alışkanlık Takip",
  "@appTitle": {
    "description": "Uygulama başlığı"
  },
  "welcomeMessage": "Hoş geldiniz, {username}",
  "@welcomeMessage": {
    "description": "Karşılama mesajı",
    "placeholders": {
      "username": {
        "type": "String",
        "example": "Ahmet"
      }
    }
  }
}
```

### 2. Yerelleştirme

```dart
class LocalizationHelper {
  static String formatDate(DateTime date) {
    return DateFormat.yMMMd(
      Localizations.localeOf(context).languageCode,
    ).format(date);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: Localizations.localeOf(context).toString(),
      symbol: '₺',
    ).format(amount);
  }

  static String formatNumber(double number) {
    return NumberFormat.decimalPattern(
      Localizations.localeOf(context).languageCode,
    ).format(number);
  }
}
```

### 3. RTL Desteği

```dart
class RTLAwareWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: [
          Icon(Icons.arrow_back),
          Text('Geri'),
        ],
      ),
    );
  }
}
```

### 4. Çeviri Yönetimi

```dart
class TranslationService {
  static final _supportedLocales = [
    Locale('tr', ''),  // Türkçe
    Locale('en', ''),  // İngilizce
    Locale('ar', ''),  // Arapça
    Locale('de', ''),  // Almanca
  ];

  static Locale? localeResolutionCallback(
    Locale? locale,
    Iterable<Locale> supportedLocales,
  ) {
    if (locale == null) {
      return supportedLocales.first;
    }

    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }

    return supportedLocales.first;
  }

  static Future<void> changeLocale(BuildContext context, String languageCode) async {
    final state = Localizations.of<AppLocalizations>(context, AppLocalizations);
    state.setLocale(Locale(languageCode));
  }
}
```

## 💻 Örnek Uygulama: Dil Yönetim Paneli

Bu haftaki örnek uygulamamızda, çoklu dil desteği için bir yönetim paneli geliştireceğiz. Detaylar için [tıklayınız](./ornek_uygulama/README.md).

## 🚀 Ana Proje: Alışkanlık Takip Uygulaması

Bu hafta ana projemizde şunları yapacağız:

1. Çoklu dil desteği
2. Yerelleştirme
3. RTL desteği
4. Kültürel uyarlama

Ana proje detayları için [tıklayınız](./ana_proje/README.md).

## 🎯 Alıştırmalar

1. Uluslararasılaştırma:
   - [ ] ARB dosyaları oluşturun
   - [ ] Çevirileri ekleyin
   - [ ] RTL desteği ekleyin
   - [ ] Yerel formatları kullanın

2. Yerelleştirme:
   - [ ] Tarih formatlarını ayarlayın
   - [ ] Sayı formatlarını ayarlayın
   - [ ] Para birimi formatlarını ayarlayın
   - [ ] Ölçü birimlerini ayarlayın

3. Kültürel Uyarlama:
   - [ ] Tema desteği ekleyin
   - [ ] İkonları uyarlayın
   - [ ] İçeriği uyarlayın
   - [ ] Bölgesel özellikleri ekleyin

4. Çeviri Yönetimi:
   - [ ] Çeviri sistemi kurun
   - [ ] Kalite kontrolü yapın
   - [ ] Eksik çevirileri bulun
   - [ ] Otomatik çeviri ekleyin

## 🔍 Hata Ayıklama İpuçları

1. Çeviri:
   - ARB dosyalarını kontrol edin
   - Eksik çevirileri bulun
   - Placeholder'ları doğrulayın
   - Format hatalarını düzeltin

2. RTL:
   - Layout sorunlarını kontrol edin
   - İkonları uyarlayın
   - Margin ve padding'leri düzenleyin
   - Scroll yönünü ayarlayın

## 📚 Faydalı Kaynaklar

- [Flutter Internationalization](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)
- [Intl Package](https://pub.dev/packages/intl)
- [RTL Guide](https://flutter.dev/docs/development/ui/layout/rtl)
- [Localization Tutorial](https://flutter.dev/docs/development/accessibility-and-localization/internationalization) 