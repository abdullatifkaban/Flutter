# Hafta 14 - Örnek Uygulama: Dil Yönetim Paneli

Bu örnek uygulamamızda, Flutter uygulamaları için bir dil yönetim paneli geliştireceğiz.

## 🎯 Uygulama Özellikleri

1. Dil Yönetimi
   - Dil ekleme/düzenleme
   - Çeviri yönetimi
   - Eksik çeviri kontrolü
   - Otomatik çeviri

2. ARB Yönetimi
   - ARB dosya oluşturma
   - Çeviri importu/exportu
   - Placeholder yönetimi
   - Format kontrolü

3. Kalite Kontrolü
   - Çeviri doğrulama
   - Tutarlılık kontrolü
   - Karakter limiti kontrolü
   - HTML kontrolü

## 💻 Uygulama Yapısı

```
lib/
  ├── models/
  │   ├── language.dart
  │   ├── translation.dart
  │   └── validation_result.dart
  │
  ├── services/
  │   ├── translation_service.dart
  │   ├── arb_service.dart
  │   └── validation_service.dart
  │
  ├── screens/
  │   ├── home_screen.dart
  │   ├── language_screen.dart
  │   ├── translation_screen.dart
  │   └── validation_screen.dart
  │
  └── widgets/
      ├── language_card.dart
      ├── translation_editor.dart
      └── validation_report.dart
```

## 📱 Ekran Tasarımları

1. Ana Sayfa
   - Dil listesi
   - Çeviri durumu
   - Hızlı aksiyonlar
   - İstatistikler

2. Dil Yönetimi
   - Dil ekleme formu
   - Dil düzenleme
   - Dil silme
   - Dil detayları

3. Çeviri Editörü
   - Metin düzenleme
   - Placeholder yönetimi
   - Önizleme
   - Versiyon geçmişi

4. Kalite Kontrolü
   - Validasyon raporu
   - Hata listesi
   - Düzeltme önerileri
   - Otomatik düzeltme

## 🔧 Teknik Detaylar

### 1. Dil Modeli

```dart
class Language {
  final String code;
  final String name;
  final String nativeName;
  final TextDirection textDirection;
  final bool isDefault;
  final Map<String, String> translations;

  Language({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.textDirection,
    this.isDefault = false,
    required this.translations,
  });

  // ARB formatına dönüştürme
  Map<String, dynamic> toARB() {
    final arb = <String, dynamic>{
      '@@locale': code,
    };

    translations.forEach((key, value) {
      arb[key] = value;
      arb['@$key'] = {
        'description': 'Translation for $key',
      };
    });

    return arb;
  }

  // ARB'den oluşturma
  factory Language.fromARB(Map<String, dynamic> arb) {
    final code = arb['@@locale'] as String;
    final translations = <String, String>{};

    arb.forEach((key, value) {
      if (!key.startsWith('@') && key != '@@locale') {
        translations[key] = value as String;
      }
    });

    return Language(
      code: code,
      name: LocaleNames.of(code),
      nativeName: LocaleNamesLocalized.of(code, code),
      textDirection: isRTL(code) ? TextDirection.rtl : TextDirection.ltr,
      translations: translations,
    );
  }
}
```

### 2. Çeviri Servisi

```dart
class TranslationService {
  // Çeviri ekleme
  Future<void> addTranslation(
    String languageCode,
    String key,
    String value,
  ) async {
    final language = await getLanguage(languageCode);
    language.translations[key] = value;
    await saveLanguage(language);
  }

  // Toplu çeviri
  Future<void> bulkTranslate(
    String sourceLanguageCode,
    List<String> targetLanguageCodes,
  ) async {
    final sourceLanguage = await getLanguage(sourceLanguageCode);
    final translator = GoogleTranslator();

    for (final targetCode in targetLanguageCodes) {
      final targetLanguage = await getLanguage(targetCode);

      for (final entry in sourceLanguage.translations.entries) {
        final translation = await translator.translate(
          entry.value,
          from: sourceLanguageCode,
          to: targetCode,
        );

        targetLanguage.translations[entry.key] = translation.text;
      }

      await saveLanguage(targetLanguage);
    }
  }

  // Eksik çevirileri bulma
  Future<List<String>> findMissingTranslations(
    String languageCode,
  ) async {
    final defaultLanguage = await getDefaultLanguage();
    final language = await getLanguage(languageCode);

    return defaultLanguage.translations.keys
        .where((key) => !language.translations.containsKey(key))
        .toList();
  }
}
```

### 3. ARB Servisi

```dart
class ARBService {
  // ARB oluşturma
  Future<String> generateARB(String languageCode) async {
    final language = await getLanguage(languageCode);
    final arb = language.toARB();
    return jsonEncode(arb);
  }

  // ARB içe aktarma
  Future<void> importARB(String content) async {
    final arb = jsonDecode(content) as Map<String, dynamic>;
    final language = Language.fromARB(arb);
    await saveLanguage(language);
  }

  // Placeholder kontrolü
  List<String> validatePlaceholders(String content) {
    final errors = <String>[];
    final arb = jsonDecode(content) as Map<String, dynamic>;

    arb.forEach((key, value) {
      if (!key.startsWith('@') && key != '@@locale') {
        final placeholders = extractPlaceholders(value as String);
        final metadata = arb['@$key'] as Map<String, dynamic>?;

        if (metadata != null) {
          final definedPlaceholders = metadata['placeholders'] as Map<String, dynamic>?;
          
          for (final placeholder in placeholders) {
            if (definedPlaceholders?[placeholder] == null) {
              errors.add('Undefined placeholder $placeholder in $key');
            }
          }
        }
      }
    });

    return errors;
  }
}
```

### 4. Validasyon Servisi

```dart
class ValidationService {
  // Çeviri doğrulama
  Future<ValidationResult> validateTranslation(
    String languageCode,
    String key,
    String value,
  ) async {
    final errors = <String>[];

    // Karakter limiti kontrolü
    if (value.length > 1000) {
      errors.add('Translation too long');
    }

    // HTML kontrolü
    if (containsHTML(value)) {
      errors.add('HTML tags not allowed');
    }

    // Placeholder kontrolü
    final defaultTranslation = await getDefaultTranslation(key);
    final defaultPlaceholders = extractPlaceholders(defaultTranslation);
    final translationPlaceholders = extractPlaceholders(value);

    if (!listsEqual(defaultPlaceholders, translationPlaceholders)) {
      errors.add('Placeholder mismatch');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}
```

## 🚀 Başlangıç

1. Projeyi oluşturun:
   ```bash
   flutter create translation_manager
   cd translation_manager
   ```

2. Bağımlılıkları ekleyin:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     flutter_localizations:
       sdk: flutter
     intl: ^0.18.0
     translator: ^0.1.7
     json_annotation: ^4.8.1

   dev_dependencies:
     flutter_test:
       sdk: flutter
     build_runner: ^2.4.6
     json_serializable: ^6.7.1
   ```

3. ARB yapılandırması:
   ```yaml
   # l10n.yaml
   arb-dir: lib/l10n
   template-arb-file: app_tr.arb
   output-localization-file: app_localizations.dart
   ```

## 🔍 Kontrol Listesi

1. Dil Yönetimi:
   - [ ] Dil ekleme çalışıyor mu?
   - [ ] Çeviriler kaydediliyor mu?
   - [ ] Dil silme işliyor mu?
   - [ ] Varsayılan dil ayarlanıyor mu?

2. ARB Yönetimi:
   - [ ] ARB oluşturma doğru mu?
   - [ ] İçe aktarma çalışıyor mu?
   - [ ] Placeholder'lar korunuyor mu?
   - [ ] Format geçerli mi?

3. Kalite Kontrolü:
   - [ ] Validasyonlar çalışıyor mu?
   - [ ] Hatalar raporlanıyor mu?
   - [ ] Öneriler mantıklı mı?
   - [ ] Otomatik düzeltme işliyor mu?

## 💡 İpuçları

1. Çeviri:
   - Placeholder'ları koruyun
   - Uzun metinleri test edin
   - HTML'den kaçının
   - Tutarlılığı kontrol edin

2. ARB:
   - Format doğrulaması yapın
   - Metadata ekleyin
   - Açıklamalar yazın
   - Örnekler ekleyin

## 📚 Faydalı Kaynaklar

- [ARB Specification](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)
- [Flutter Localization](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)
- [Intl Package](https://pub.dev/packages/intl)
- [JSON Serialization](https://flutter.dev/docs/development/data-and-backend/json) 