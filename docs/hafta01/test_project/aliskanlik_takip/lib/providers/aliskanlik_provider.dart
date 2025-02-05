import 'package:flutter/material.dart';
import '../models/aliskanlik.dart';
import '../services/ayarlar_servisi.dart';
import '../services/bildirim_servisi.dart';
import '../services/veritabani_servisi.dart';

class AliskanlikProvider extends ChangeNotifier {
  final VeritabaniServisi veritabaniServisi;
  final BildirimServisi bildirimServisi;
  final AyarlarServisi ayarlarServisi;
  List<Aliskanlik> _aliskanliklar = [];

  AliskanlikProvider({
    required this.veritabaniServisi,
    required this.bildirimServisi,
    required this.ayarlarServisi,
  }) {
    aliskanliklarYukle();
  }

  List<Aliskanlik> get aliskanliklar => _aliskanliklar;

  Future<void> aliskanliklarYukle() async {
    final aliskanliklar = await veritabaniServisi.tumAliskanliklarGetir();
    _aliskanliklar = aliskanliklar;
    notifyListeners();
  }

  Future<void> aliskanlikEkle(Aliskanlik aliskanlik) async {
    await veritabaniServisi.aliskanlikEkle(aliskanlik);
    _aliskanliklar.add(aliskanlik);
    await bildirimServisi.bildirimPlanla(aliskanlik);
    notifyListeners();
  }

  Future<void> aliskanlikSil(String id) async {
    await veritabaniServisi.aliskanlikSil(id);
    _aliskanliklar.removeWhere((aliskanlik) => aliskanlik.id == id);
    await bildirimServisi.bildirimIptalEt(id);
    notifyListeners();
  }

  Future<void> durumGuncelle(String id, bool aktif) async {
    final index = _aliskanliklar.indexWhere((aliskanlik) => aliskanlik.id == id);
    if (index != -1) {
      final aliskanlik = _aliskanliklar[index];
      final yeniAliskanlik = aliskanlik.copyWith(
        aktif: aktif,
        sonTamamlanmaTarihi: aktif ? DateTime.now() : null,
      );
      await veritabaniServisi.aliskanlikGuncelle(yeniAliskanlik);
      _aliskanliklar[index] = yeniAliskanlik;
      if (aktif) {
        await bildirimServisi.bildirimPlanla(yeniAliskanlik);
      } else {
        await bildirimServisi.bildirimIptalEt(id);
      }
      notifyListeners();
    }
  }

  Future<void> aliskanlikGuncelle(Aliskanlik aliskanlik) async {
    final index = _aliskanliklar.indexWhere((a) => a.id == aliskanlik.id);
    if (index != -1) {
      await veritabaniServisi.aliskanlikGuncelle(aliskanlik);
      _aliskanliklar[index] = aliskanlik;
      if (aliskanlik.aktif) {
        await bildirimServisi.bildirimPlanla(aliskanlik);
      } else {
        await bildirimServisi.bildirimIptalEt(aliskanlik.id);
      }
      notifyListeners();
    }
  }
}
