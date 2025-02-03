# Hafta 14 - Ana Proje: Çoklu Dil Desteği

Bu hafta, alışkanlık takip uygulamamıza çoklu dil desteği ve yerelleştirme özellikleri ekleyeceğiz.

## 🎯 Hedefler

1. Çoklu Dil Desteği
   - ARB dosyaları
   - Dil seçimi
   - Otomatik dil algılama
   - Dil değiştirme

2. Yerelleştirme
   - Tarih formatları
   - Sayı formatları
   - Para birimi
   - Ölçü birimleri

3. RTL Desteği
   - Layout uyarlaması
   - İkon ve görseller
   - Metin yönü
   - Scroll yönü

4. Kültürel Uyarlama
   - Temalar
   - İçerik
   - Görseller
   - Bildirimler

## 💻 Adım Adım Geliştirme

### 1. Çoklu Dil Desteği

`lib/l10n/app_tr.arb`:
```json
{
  "appTitle": "Alışkanlık Takip",
  "@appTitle": {
    "description": "Uygulama başlığı"
  },

  "habitCount": "{count} alışkanlık",
  "@habitCount": {
    "description": "Alışkanlık sayısı",
    "placeholders": {
      "count": {
        "type": "int",
        "example": "5"
      }
    }
  },

  "streakMessage": "{count} günlük seri!",
  "@streakMessage": {
    "description": "Seri mesajı",
    "placeholders": {
      "count": {
        "type": "int",
        "example": "7"
      }
    }
  },

  "completionRate": "%{rate} tamamlama",
  "@completionRate": {
    "description": "Tamamlama oranı",
    "placeholders": {
      "rate": {
        "type": "double",
        "format": "decimalPattern",
        "example": "85.5"
      }
    }
  }
}
```

`lib/l10n/app_en.arb`:
```json
{
  "appTitle": "Habit Tracker",
  "habitCount": "{count} habits",
  "streakMessage": "{count} day streak!",
  "completionRate": "{rate}% completion"
}
```

### 2. Yerelleştirme Servisi

`lib/services/localization_service.dart`:
```dart
class LocalizationService {
  static final _supportedLocales = [
    Locale('tr', ''),  // Türkçe
    Locale('en', ''),  // İngilizce
    Locale('ar', ''),  // Arapça
    Locale('de', ''),  // Almanca
  ];

  // Tarih formatı
  static String formatDate(DateTime date) {
    return DateFormat.yMMMd(
      Localizations.localeOf(context).languageCode,
    ).format(date);
  }

  // Saat formatı
  static String formatTime(DateTime time) {
    return DateFormat.Hm(
      Localizations.localeOf(context).languageCode,
    ).format(time);
  }

  // Para birimi formatı
  static String formatCurrency(double amount) {
    final locale = Localizations.localeOf(context);
    final symbol = locale.languageCode == 'tr' ? '₺' : '\$';

    return NumberFormat.currency(
      locale: locale.toString(),
      symbol: symbol,
    ).format(amount);
  }

  // Yüzde formatı
  static String formatPercent(double percent) {
    return NumberFormat.percentPattern(
      Localizations.localeOf(context).languageCode,
    ).format(percent / 100);
  }
}
```

### 3. RTL Desteği

`lib/widgets/habit_card.dart`:
```dart
class HabitCard extends StatelessWidget {
  final Habit habit;

  const HabitCard({
    Key? key,
    required this.habit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Card(
      child: Padding(
        padding: EdgeInsets.only(
          left: isRTL ? 0 : 16.0,
          right: isRTL ? 16.0 : 0,
        ),
        child: Row(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Icon(habit.icon),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: isRTL
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(habit.title),
                  Text(habit.description),
                ],
              ),
            ),
            HabitProgress(progress: habit.progress),
          ],
        ),
      ),
    );
  }
}
```

### 4. Dil Seçimi

`lib/screens/settings_screen.dart`:
```dart
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settingsTitle),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context).language),
            trailing: LanguageDropdown(),
          ),
          SwitchListTile(
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (value) {
              // Tema değiştir
            },
            title: Text(AppLocalizations.of(context).darkMode),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).notifications),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Bildirim ayarları
            },
          ),
        ],
      ),
    );
  }
}

class LanguageDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: Localizations.localeOf(context).languageCode,
      items: [
        DropdownMenuItem(
          value: 'tr',
          child: Text('Türkçe'),
        ),
        DropdownMenuItem(
          value: 'en',
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: 'ar',
          child: Text('العربية'),
        ),
        DropdownMenuItem(
          value: 'de',
          child: Text('Deutsch'),
        ),
      ],
      onChanged: (String? languageCode) {
        if (languageCode != null) {
          context.read<LocaleProvider>().setLocale(
                Locale(languageCode),
              );
        }
      },
    );
  }
}
```

## 🎯 Ödevler

1. Çeviri:
   - [ ] Tüm metinleri ARB'ye taşıyın
   - [ ] Eksik çevirileri tamamlayın
   - [ ] Placeholder'ları kontrol edin
   - [ ] Çeviri kalitesini test edin

2. Yerelleştirme:
   - [ ] Tarih formatlarını ayarlayın
   - [ ] Sayı formatlarını düzenleyin
   - [ ] Para birimlerini ekleyin
   - [ ] Ölçü birimlerini uyarlayın

3. RTL:
   - [ ] Layout'ları test edin
   - [ ] İkonları uyarlayın
   - [ ] Margin/padding'leri düzeltin
   - [ ] Scroll yönlerini ayarlayın

## 🔍 Kontrol Listesi

1. Çeviri:
   - [ ] Tüm metinler çevrildi mi?
   - [ ] Placeholder'lar doğru mu?
   - [ ] Format hataları var mı?
   - [ ] Çeviriler anlamlı mı?

2. Yerelleştirme:
   - [ ] Tarihler doğru mu?
   - [ ] Sayılar düzgün mü?
   - [ ] Para birimleri uygun mu?
   - [ ] Ölçü birimleri mantıklı mı?

3. RTL:
   - [ ] Layout bozulmuyor mu?
   - [ ] İkonlar doğru yönde mi?
   - [ ] Metinler okunabiliyor mu?
   - [ ] Scroll doğru çalışıyor mu?

## 💡 İpuçları

1. Çeviri:
   - Context'e dikkat edin
   - Uzun metinleri test edin
   - Özel karakterleri kontrol edin
   - Tutarlılığı koruyun

2. RTL:
   - Flexible widget kullanın
   - Simetrik padding verin
   - İkon yönlerini kontrol edin
   - TextDirection kullanın

## 📚 Faydalı Kaynaklar

- [Flutter Localization Guide](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)
- [ARB Format](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)
- [RTL Best Practices](https://material.io/design/usability/bidirectionality.html)
- [Intl Package](https://pub.dev/packages/intl) 