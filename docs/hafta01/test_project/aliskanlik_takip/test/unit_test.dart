import 'package:aliskanlik_takip/models/aliskanlik.dart';
import 'package:aliskanlik_takip/providers/aliskanlik_provider.dart';
import 'package:aliskanlik_takip/services/ayarlar_servisi.dart';
import 'package:aliskanlik_takip/services/bildirim_servisi.dart';
import 'package:aliskanlik_takip/services/veritabani_servisi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'unit_test.mocks.dart';

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
    provider = AliskanlikProvider(
      veritabaniServisi: mockVeritabaniServisi,
      bildirimServisi: mockBildirimServisi,
      ayarlarServisi: mockAyarlarServisi,
    );
  });

  group('AliskanlikProvider Tests', () {
    test('Alışkanlıkları yükleme', () async {
      final testAliskanliklar = [
        Aliskanlik(
          id: '1',
          baslik: 'Test Alışkanlık',
          aciklama: 'Test Açıklama',
          kategori: 'Test Kategori',
          gunler: ['Pazartesi', 'Çarşamba'],
          hatirlatmaSaati: const TimeOfDay(hour: 10, minute: 0),
          aktif: true,
          baslangicTarihi: DateTime.now(),
        ),
      ];

      when(mockVeritabaniServisi.tumAliskanliklarGetir())
          .thenAnswer((_) async => testAliskanliklar);

      await provider.aliskanliklarYukle();

      expect(provider.aliskanliklar, equals(testAliskanliklar));
      verify(mockVeritabaniServisi.tumAliskanliklarGetir()).called(1);
    });

    test('Alışkanlık ekleme', () async {
      final testAliskanlik = Aliskanlik(
        id: '1',
        baslik: 'Test Alışkanlık',
        aciklama: 'Test Açıklama',
        kategori: 'Test Kategori',
        gunler: ['Pazartesi', 'Çarşamba'],
        hatirlatmaSaati: const TimeOfDay(hour: 10, minute: 0),
        aktif: true,
        baslangicTarihi: DateTime.now(),
      );

      when(mockVeritabaniServisi.aliskanlikEkle(any))
          .thenAnswer((_) async => {});
      when(mockBildirimServisi.bildirimPlanla(any))
          .thenAnswer((_) async => {});

      await provider.aliskanlikEkle(testAliskanlik);

      expect(provider.aliskanliklar.length, equals(1));
      expect(provider.aliskanliklar.first, equals(testAliskanlik));
      verify(mockVeritabaniServisi.aliskanlikEkle(any)).called(1);
      verify(mockBildirimServisi.bildirimPlanla(any)).called(1);
    });

    test('Alışkanlık silme', () async {
      final testAliskanlik = Aliskanlik(
        id: '1',
        baslik: 'Test Alışkanlık',
        aciklama: 'Test Açıklama',
        kategori: 'Test Kategori',
        gunler: ['Pazartesi', 'Çarşamba'],
        hatirlatmaSaati: const TimeOfDay(hour: 10, minute: 0),
        aktif: true,
        baslangicTarihi: DateTime.now(),
      );

      when(mockVeritabaniServisi.aliskanlikSil(any))
          .thenAnswer((_) async => {});
      when(mockBildirimServisi.bildirimIptalEt(any))
          .thenAnswer((_) async => {});

      provider.aliskanliklar.add(testAliskanlik);
      await provider.aliskanlikSil(testAliskanlik.id);

      expect(provider.aliskanliklar.length, equals(0));
      verify(mockVeritabaniServisi.aliskanlikSil(any)).called(1);
      verify(mockBildirimServisi.bildirimIptalEt(any)).called(1);
    });
  });
}
