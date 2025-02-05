import 'package:aliskanlik_takip/providers/aliskanlik_provider.dart';
import 'package:aliskanlik_takip/screens/ana_sayfa.dart';
import 'package:aliskanlik_takip/services/ayarlar_servisi.dart';
import 'package:aliskanlik_takip/services/bildirim_servisi.dart';
import 'package:aliskanlik_takip/services/veritabani_servisi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([VeritabaniServisi, BildirimServisi, AyarlarServisi])
void main() {
  late MockVeritabaniServisi mockVeritabaniServisi;
  late MockBildirimServisi mockBildirimServisi;
  late MockAyarlarServisi mockAyarlarServisi;
  late AliskanlikProvider provider;

  setUp(() {
    mockVeritabaniServisi = MockVeritabaniServisi();
    mockBildirimServisi = MockBildirimServisi();
    mockAyarlarServisi = MockAyarlarServisi();

    when(mockAyarlarServisi.varsayilanHatirlatmaSaati)
        .thenReturn(const TimeOfDay(hour: 9, minute: 0));
    when(mockAyarlarServisi.karanlikTema).thenReturn(false);
    when(mockAyarlarServisi.bildirimAktif).thenReturn(true);

    provider = AliskanlikProvider(
      veritabaniServisi: mockVeritabaniServisi,
      bildirimServisi: mockBildirimServisi,
      ayarlarServisi: mockAyarlarServisi,
    );
  });

  Widget createTestWidget({required Widget child}) {
    return MaterialApp(
      home: ChangeNotifierProvider<AliskanlikProvider>.value(
        value: provider,
        child: child,
      ),
    );
  }

  testWidgets('MyApp başlangıç durumu testi', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(child: const AnaSayfa()));

    expect(find.text('Alışkanlık Takip'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets('Yeni alışkanlık ekleme formu açılıyor',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(child: const AnaSayfa()));

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Yeni Alışkanlık'), findsOneWidget);
    expect(find.text('Başlık'), findsOneWidget);
    expect(find.text('Açıklama'), findsOneWidget);
    expect(find.text('Kategori'), findsOneWidget);
  });

  testWidgets('Ayarlar sayfası açılıyor', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(child: const AnaSayfa()));

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text('Ayarlar'), findsOneWidget);
    expect(find.text('Karanlık Tema'), findsOneWidget);
    expect(find.text('Bildirimleri Etkinleştir'), findsOneWidget);
    expect(find.text('Varsayılan Hatırlatma Saati'), findsOneWidget);
  });
}
