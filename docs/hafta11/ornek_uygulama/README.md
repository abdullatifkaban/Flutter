# Hafta 11 - Örnek Uygulama: Test Otomasyonu Paneli

Bu örnek uygulamamızda, test otomasyonu kavramlarını uygulamalı olarak öğreneceğiz.

## 🎯 Uygulama Özellikleri

1. Test Yönetimi
   - Test senaryoları oluşturma
   - Test grupları yönetimi
   - Test sonuçları takibi
   - Test raporlama

2. CI/CD Entegrasyonu
   - GitHub Actions entegrasyonu
   - Test otomasyonu
   - Coverage raporları
   - Pull request kontrolleri

3. Test Metrikleri
   - Test başarı oranları
   - Test süreleri
   - Coverage oranları
   - Hata dağılımları

## 💻 Uygulama Yapısı

```
lib/
  ├── models/
  │   ├── test_case.dart
  │   ├── test_group.dart
  │   └── test_result.dart
  │
  ├── services/
  │   ├── test_service.dart
  │   ├── report_service.dart
  │   └── github_service.dart
  │
  ├── screens/
  │   ├── home_screen.dart
  │   ├── test_list_screen.dart
  │   ├── test_detail_screen.dart
  │   └── report_screen.dart
  │
  └── widgets/
      ├── test_card.dart
      ├── result_chart.dart
      └── coverage_indicator.dart
```

## 📱 Ekran Tasarımları

1. Ana Sayfa
   - Test grupları listesi
   - Hızlı aksiyon butonları
   - Özet metrikler
   - Son çalıştırılan testler

2. Test Listesi
   - Test senaryoları
   - Durum göstergeleri
   - Filtreleme seçenekleri
   - Toplu aksiyon butonları

3. Test Detay
   - Test bilgileri
   - Çalıştırma geçmişi
   - Hata detayları
   - İlgili PR'lar

4. Raporlar
   - Metrik grafikleri
   - Coverage haritası
   - Trend analizleri
   - Export seçenekleri

## 🔧 Teknik Detaylar

### 1. Test Modeli

```dart
class TestCase {
  final String id;
  final String name;
  final String description;
  final TestType type;
  final TestStatus status;
  final Duration duration;
  final DateTime lastRun;
  final List<String> tags;

  TestCase({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.status,
    required this.duration,
    required this.lastRun,
    required this.tags,
  });
}
```

### 2. Test Servisi

```dart
class TestService {
  Future<List<TestCase>> getTestCases() async {
    // Test senaryolarını getir
  }

  Future<TestResult> runTest(String testId) async {
    // Testi çalıştır
  }

  Future<TestReport> generateReport() async {
    // Rapor oluştur
  }

  Future<void> updateTestStatus(String testId, TestStatus status) async {
    // Test durumunu güncelle
  }
}
```

### 3. GitHub Entegrasyonu

```dart
class GitHubService {
  Future<void> createPullRequest({
    required String title,
    required String description,
    required List<String> testIds,
  }) async {
    // PR oluştur
  }

  Future<void> updateTestStatus({
    required String prId,
    required String testId,
    required TestStatus status,
  }) async {
    // PR'da test durumunu güncelle
  }
}
```

## 🎯 Test Senaryoları

1. Birim Testleri
   ```dart
   void main() {
     group('TestService Tests', () {
       late TestService testService;
       late MockGitHubService mockGitHub;

       setUp(() {
         mockGitHub = MockGitHubService();
         testService = TestService(mockGitHub);
       });

       test('test listesi başarıyla getirilmeli', () async {
         final tests = await testService.getTestCases();
         expect(tests, isNotEmpty);
       });

       test('test çalıştırma başarılı olmalı', () async {
         final result = await testService.runTest('test_id');
         expect(result.status, equals(TestStatus.passed));
       });
     });
   }
   ```

2. Widget Testleri
   ```dart
   void main() {
     testWidgets('test listesi görüntülenmeli', (tester) async {
       await tester.pumpWidget(MaterialApp(
         home: TestListScreen(),
       ));

       expect(find.byType(TestCard), findsWidgets);
       expect(find.text('Tüm Testler'), findsOneWidget);
     });

     testWidgets('test detayı görüntülenmeli', (tester) async {
       await tester.pumpWidget(MaterialApp(
         home: TestDetailScreen(testId: 'test_id'),
       ));

       expect(find.byType(ResultChart), findsOneWidget);
       expect(find.text('Test Detayı'), findsOneWidget);
     });
   }
   ```

## 🚀 Başlangıç

1. Projeyi oluşturun:
   ```bash
   flutter create test_automation_panel
   cd test_automation_panel
   ```

2. Bağımlılıkları ekleyin:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     github: ^9.0.0
     fl_chart: ^0.60.0
     provider: ^6.0.0

   dev_dependencies:
     flutter_test:
       sdk: flutter
     integration_test:
       sdk: flutter
     mockito: ^5.0.0
   ```

3. Testleri çalıştırın:
   ```bash
   flutter test
   flutter test --coverage
   ```

## 🔍 Kontrol Listesi

1. Test Yazımı:
   - [ ] Birim testleri yazıldı mı?
   - [ ] Widget testleri yazıldı mı?
   - [ ] Entegrasyon testleri yazıldı mı?
   - [ ] Coverage yeterli mi?

2. CI/CD:
   - [ ] GitHub Actions kuruldu mu?
   - [ ] Test otomasyonu çalışıyor mu?
   - [ ] PR kontrolleri aktif mi?
   - [ ] Raporlama yapılıyor mu?

3. Kod Kalitesi:
   - [ ] Lint kuralları uygulandı mı?
   - [ ] Dokümantasyon yeterli mi?
   - [ ] Performans testleri yapıldı mı?
   - [ ] Güvenlik kontrolleri yapıldı mı?

## 💡 İpuçları

1. Test Geliştirme:
   - Testleri küçük ve odaklı tutun
   - Mock kullanımına dikkat edin
   - Test verilerini ayrı tutun
   - Düzenli refactor yapın

2. CI/CD:
   - Hızlı feedback döngüsü kurun
   - Otomatik kontroller ekleyin
   - Detaylı raporlama yapın
   - Versiyon kontrolü yapın

## 📚 Faydalı Kaynaklar

- [Flutter Testing Guide](https://flutter.dev/docs/testing)
- [GitHub Actions Guide](https://docs.github.com/en/actions)
- [Test Coverage Tools](https://pub.dev/packages/test_coverage)
- [Mockito Guide](https://pub.dev/packages/mockito) 