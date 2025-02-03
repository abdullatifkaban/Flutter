# Hafta 11 - Entegrasyon ve Birim Testleri

Bu hafta, Flutter uygulamalarında test yazma ve test otomasyonu konularını öğreneceğiz.

## 🎯 Bu Hafta Neler Öğreneceğiz?

1. Birim Testleri
   - Test temelleri
   - Mock ve stub kullanımı
   - Test grupları
   - Assertion'lar

2. Widget Testleri
   - Widget test temelleri
   - Pump ve pumpAndSettle
   - Finder'lar
   - Widget etkileşimleri

3. Entegrasyon Testleri
   - Integration test paketi
   - Tam uygulama testleri
   - Performans testleri
   - Senaryo testleri

4. Test Otomasyonu
   - CI/CD entegrasyonu
   - Test raporlama
   - Test coverage
   - Test stratejileri

## 📚 Konu Anlatımı

### Birim Testleri

1. **Test Dosyası Oluşturma**:
   ```dart
   import 'package:test/test.dart';
   import 'package:my_app/services/auth_service.dart';

   void main() {
     group('AuthService Tests', () {
       late AuthService authService;
       late MockFirebaseAuth mockAuth;

       setUp(() {
         mockAuth = MockFirebaseAuth();
         authService = AuthService(mockAuth);
       });

       test('giriş başarılı olmalı', () async {
         when(mockAuth.signInWithEmailAndPassword(
           email: 'test@test.com',
           password: '123456',
         )).thenAnswer((_) async => MockUserCredential());

         final result = await authService.signIn(
           email: 'test@test.com',
           password: '123456',
         );

         expect(result, isTrue);
       });

       test('giriş hatalı olmalı', () async {
         when(mockAuth.signInWithEmailAndPassword(
           email: 'test@test.com',
           password: 'wrong',
         )).thenThrow(FirebaseAuthException(code: 'wrong-password'));

         expect(
           () => authService.signIn(
             email: 'test@test.com',
             password: 'wrong',
           ),
           throwsA(isA<AuthException>()),
         );
       });
     });
   }
   ```

### Widget Testleri

1. **Widget Test Örneği**:
   ```dart
   import 'package:flutter_test/flutter_test.dart';
   import 'package:my_app/widgets/login_form.dart';

   void main() {
     testWidgets('login form testi', (WidgetTester tester) async {
       await tester.pumpWidget(MaterialApp(
         home: LoginForm(),
       ));

       // Form alanlarını bul
       final emailField = find.byKey(Key('email_field'));
       final passwordField = find.byKey(Key('password_field'));
       final loginButton = find.byType(ElevatedButton);

       // Form alanlarına veri gir
       await tester.enterText(emailField, 'test@test.com');
       await tester.enterText(passwordField, '123456');
       
       // Butona tıkla
       await tester.tap(loginButton);
       await tester.pumpAndSettle();

       // Sonuçları kontrol et
       expect(find.text('Giriş Başarılı'), findsOneWidget);
     });
   }
   ```

### Entegrasyon Testleri

1. **Integration Test Örneği**:
   ```dart
   import 'package:integration_test/integration_test.dart';
   import 'package:flutter_test/flutter_test.dart';
   import 'package:my_app/main.dart' as app;

   void main() {
     IntegrationTestWidgetsFlutterBinding.ensureInitialized();

     group('uçtan uca testler', () {
       testWidgets('giriş ve ana sayfa testi', (tester) async {
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

         // Ana sayfayı kontrol et
         expect(find.text('Ana Sayfa'), findsOneWidget);
         
         // Menüyü aç
         await tester.tap(find.byIcon(Icons.menu));
         await tester.pumpAndSettle();
         
         // Profil sayfasına git
         await tester.tap(find.text('Profil'));
         await tester.pumpAndSettle();
         
         // Profil sayfasını kontrol et
         expect(find.text('Profil Sayfası'), findsOneWidget);
       });
     });
   }
   ```

### Test Coverage

1. **Coverage Raporu Oluşturma**:
   ```bash
   # Test coverage çalıştır
   flutter test --coverage

   # HTML raporu oluştur
   genhtml coverage/lcov.info -o coverage/html
   ```

## 💻 Örnek Uygulama: Test Otomasyonu

Bu haftaki örnek uygulamamızda, öğrendiğimiz test tekniklerini kullanarak kapsamlı bir test otomasyonu sistemi kuracağız. Detaylar için [tıklayınız](./ornek_uygulama/README.md).

## 🚀 Ana Proje: Alışkanlık Takip Uygulaması

Bu hafta ana projemizde şunları yapacağız:

1. Servis testleri
2. Widget testleri
3. Entegrasyon testleri
4. CI/CD entegrasyonu

Ana proje detayları için [tıklayınız](./ana_proje/README.md).

## 🎯 Alıştırmalar

1. Birim Testleri:
   - [ ] Servis testleri yazın
   - [ ] Mock kullanımını öğrenin
   - [ ] Test grupları oluşturun
   - [ ] Edge case'leri test edin

2. Widget Testleri:
   - [ ] Form testleri yazın
   - [ ] Navigasyon testleri yazın
   - [ ] State testleri yazın
   - [ ] Callback testleri yazın

3. Entegrasyon Testleri:
   - [ ] E2E test yazın
   - [ ] Performans testi yazın
   - [ ] Senaryo testi yazın
   - [ ] Smoke test yazın

## 🔍 Hata Ayıklama İpuçları

- Test coverage'ı kontrol edin
- Testleri düzenli çalıştırın
- Mock kullanımına dikkat edin
- Edge case'leri unutmayın

## 📚 Faydalı Kaynaklar

- [Flutter Test Documentation](https://flutter.dev/docs/testing)
- [Integration Testing](https://flutter.dev/docs/testing/integration-tests)
- [Widget Testing](https://flutter.dev/docs/cookbook/testing/widget)
- [Mockito Package](https://pub.dev/packages/mockito) 