# Hafta 11 - Ana Proje: Test Otomasyonu

Bu hafta, alışkanlık takip uygulamamız için test otomasyonu sistemi kuracağız.

## 🎯 Hedefler

1. Test Altyapısı
   - Test mimarisi
   - Mock servisleri
   - Test helpers
   - Test fixtures

2. Test Kapsamı
   - Servis testleri
   - Widget testleri
   - Entegrasyon testleri
   - Performans testleri

3. CI/CD Pipeline
   - GitHub Actions
   - Test otomasyonu
   - Coverage raporları
   - Kalite kontrolleri

## 💻 Adım Adım Geliştirme

### 1. Servis Testleri

`test/unit/services/habit_service_test.dart`:

```dart
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_app/services/habit_service.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

void main() {
  group('HabitService Tests', () {
    late HabitService habitService;
    late MockFirestore mockFirestore;

    setUp(() {
      mockFirestore = MockFirestore();
      habitService = HabitService(mockFirestore);
    });

    test('alışkanlık oluşturma başarılı olmalı', () async {
      final habit = Habit(
        id: 'test_id',
        title: 'Test Habit',
        description: 'Test Description',
        frequency: 'daily',
        reminder: DateTime.now(),
      );

      when(mockFirestore.collection('habits').add(any))
          .thenAnswer((_) async => MockDocumentReference());

      final result = await habitService.createHabit(habit);
      expect(result, isTrue);
    });

    test('alışkanlık güncelleme başarılı olmalı', () async {
      final habit = Habit(
        id: 'test_id',
        title: 'Updated Habit',
        description: 'Updated Description',
        frequency: 'weekly',
        reminder: DateTime.now(),
      );

      when(mockFirestore.collection('habits').doc(any).update(any))
          .thenAnswer((_) async => null);

      final result = await habitService.updateHabit(habit);
      expect(result, isTrue);
    });

    test('alışkanlık silme başarılı olmalı', () async {
      when(mockFirestore.collection('habits').doc(any).delete())
          .thenAnswer((_) async => null);

      final result = await habitService.deleteHabit('test_id');
      expect(result, isTrue);
    });
  });
}
```

### 2. Widget Testleri

`test/widget/screens/habit_form_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/screens/habit_form.dart';

void main() {
  group('HabitForm Tests', () {
    testWidgets('form validasyonu çalışmalı', (tester) async {
      await tester.pumpWidget(MaterialApp(home: HabitForm()));

      // Boş form kontrolü
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Başlık gerekli'), findsOneWidget);
      expect(find.text('Sıklık seçiniz'), findsOneWidget);

      // Form doldurma
      await tester.enterText(
        find.byKey(Key('title_field')),
        'Test Alışkanlık',
      );
      await tester.tap(find.byKey(Key('frequency_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Günlük').last);
      await tester.pumpAndSettle();

      // Hatırlatıcı seçimi
      await tester.tap(find.byKey(Key('reminder_picker')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('TAMAM'));
      await tester.pumpAndSettle();

      // Form gönderimi
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Alışkanlık oluşturuldu'), findsOneWidget);
    });

    testWidgets('form iptal edilebilmeli', (tester) async {
      await tester.pumpWidget(MaterialApp(home: HabitForm()));

      // Form doldurma
      await tester.enterText(
        find.byKey(Key('title_field')),
        'Test Alışkanlık',
      );

      // İptal butonu
      await tester.tap(find.byKey(Key('cancel_button')));
      await tester.pumpAndSettle();

      expect(find.byType(HabitForm), findsNothing);
    });
  });
}
```

### 3. Entegrasyon Testleri

`integration_test/app_test.dart`:

```dart
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Alışkanlık Takip Uygulaması', () {
    testWidgets('tam kullanıcı akışı', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Giriş yap
      await tester.enterText(
        find.byKey(Key('email_field')),
        'test@test.com',
      );
      await tester.enterText(
        find.byKey(Key('password_field')),
        '123456',
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Ana sayfada olduğunu doğrula
      expect(find.text('Alışkanlıklarım'), findsOneWidget);

      // Yeni alışkanlık ekle
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(Key('title_field')),
        'Test Alışkanlık',
      );
      await tester.tap(find.byKey(Key('frequency_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Günlük').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();

      // Alışkanlığın eklendiğini doğrula
      expect(find.text('Test Alışkanlık'), findsOneWidget);

      // Alışkanlığı tamamla
      await tester.tap(find.byIcon(Icons.check_circle_outline));
      await tester.pumpAndSettle();

      // Tamamlandı işaretinin görünmesi
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      // İstatistikleri kontrol et
      await tester.tap(find.byIcon(Icons.bar_chart));
      await tester.pumpAndSettle();

      expect(find.text('İstatistikler'), findsOneWidget);
      expect(find.text('Tamamlanan: 1'), findsOneWidget);
    });
  });
}
```

## 🎯 Ödevler

1. Test Kapsamı:
   - [ ] Tüm servisleri test edin
   - [ ] Tüm ekranları test edin
   - [ ] Tüm widget'ları test edin
   - [ ] Edge case'leri test edin

2. Test Kalitesi:
   - [ ] Test coverage artırın
   - [ ] Test performansını iyileştirin
   - [ ] Test okunabilirliğini artırın
   - [ ] Test bakımını kolaylaştırın

3. CI/CD:
   - [ ] GitHub Actions kurun
   - [ ] Test otomasyonu ekleyin
   - [ ] Coverage raporu ekleyin
   - [ ] Pull request kontrolü ekleyin

## 🔍 Kontrol Listesi

Her özellik için şunları kontrol edin:
- [ ] Testler başarılı çalışıyor mu?
- [ ] Coverage yeterli mi?
- [ ] CI/CD pipeline çalışıyor mu?
- [ ] Kod kalitesi kontrolleri geçiyor mu?

## 💡 İpuçları

1. Test Yazımı:
   - Testleri anlaşılır yazın
   - Tekrarı önleyin
   - Mock'ları doğru kullanın
   - Edge case'leri unutmayın

2. Test Organizasyonu:
   - Testleri gruplandırın
   - Helper'lar oluşturun
   - Fixture'lar kullanın
   - Dokümantasyon ekleyin

3. CI/CD:
   - Hızlı feedback alın
   - Otomatik kontroller ekleyin
   - Raporlama yapın
   - Versiyon kontrolü yapın

## 📚 Faydalı Kaynaklar

- [Flutter Testing Guide](https://flutter.dev/docs/testing)
- [GitHub Actions for Flutter](https://github.com/marketplace/actions/flutter-action)
- [Test Coverage Tools](https://pub.dev/packages/test_coverage)
- [Mockito Guide](https://pub.dev/packages/mockito) 