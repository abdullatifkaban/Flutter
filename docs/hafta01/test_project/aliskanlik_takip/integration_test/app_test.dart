import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:aliskanlik_takip/main.dart';
import 'package:aliskanlik_takip/services/ayarlar_servisi.dart';
import 'package:aliskanlik_takip/services/veritabani_servisi.dart';
import 'package:aliskanlik_takip/services/bildirim_servisi.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Uygulama Entegrasyon Testleri', () {
    testWidgets('Tam uygulama akışı testi', (tester) async {
      final ayarlarServisi = AyarlarServisi();
      await ayarlarServisi.initialize();

      final veritabaniServisi = VeritabaniServisi();
      await veritabaniServisi.initialize();

      final bildirimServisi = BildirimServisi();
      await bildirimServisi.initialize();
      
      await tester.pumpWidget(MyApp(
        ayarlarServisi: ayarlarServisi,
        veritabaniServisi: veritabaniServisi,
        bildirimServisi: bildirimServisi,
      ));
      await tester.pumpAndSettle();

      // Ana sayfa kontrolü
      expect(find.text('Alışkanlıklarım'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);

      // Alışkanlık ekleme sayfasına git
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Alışkanlık ekleme formu kontrolü
      expect(find.text('Alışkanlık Ekle'), findsOneWidget);
      
      // Form alanlarını doldur
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Test Alışkanlığı',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'Test Açıklaması',
      );
      
      // Kategori seç
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sağlık').last);
      await tester.pumpAndSettle();

      // Günleri seç
      await tester.tap(find.text('Pzt'));
      await tester.tap(find.text('Çar'));
      await tester.tap(find.text('Cum'));
      await tester.pumpAndSettle();

      // Hatırlatma saati seç
      await tester.tap(find.byIcon(Icons.access_time));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Kaydet butonuna tıkla
      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();

      // Ana sayfaya dönüş ve eklenen alışkanlığı kontrol et
      expect(find.text('Test Alışkanlığı'), findsOneWidget);
      expect(find.text('Test Açıklaması'), findsOneWidget);

      // Ayarlar sayfasına git
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Ayarlar sayfası kontrolü
      expect(find.text('Ayarlar'), findsOneWidget);
      expect(find.text('Tema Modu'), findsOneWidget);
      expect(find.text('Bildirimler'), findsOneWidget);

      // Tema modunu değiştir
      await tester.tap(find.byType(Switch).first);
      await tester.pumpAndSettle();

      // Bildirimleri değiştir
      await tester.tap(find.byType(Switch).last);
      await tester.pumpAndSettle();

      // Ana sayfaya geri dön
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Eklenen alışkanlığı sil
      final dismissible = find.byType(Dismissible);
      await tester.drag(dismissible, const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Silme işlemini onayla
      await tester.tap(find.text('Evet'));
      await tester.pumpAndSettle();

      // Alışkanlığın silindiğini kontrol et
      expect(find.text('Test Alışkanlığı'), findsNothing);
    });
  });
}
