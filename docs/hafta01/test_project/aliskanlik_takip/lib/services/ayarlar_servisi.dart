import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AyarlarServisi {
  static final AyarlarServisi _instance = AyarlarServisi._internal();
  factory AyarlarServisi() => _instance;
  AyarlarServisi._internal();

  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> varsayilanHatirlatmaSaatiKaydet(TimeOfDay saat) async {
    await _prefs?.setInt('varsayilan_hatirlatma_saati_saat', saat.hour);
    await _prefs?.setInt('varsayilan_hatirlatma_saati_dakika', saat.minute);
  }

  TimeOfDay get varsayilanHatirlatmaSaati {
    final saat = _prefs?.getInt('varsayilan_hatirlatma_saati_saat') ?? 9;
    final dakika = _prefs?.getInt('varsayilan_hatirlatma_saati_dakika') ?? 0;
    return TimeOfDay(hour: saat, minute: dakika);
  }

  Future<void> karanlikTemaKaydet(bool karanlik) async {
    await _prefs?.setBool('karanlik_tema', karanlik);
  }

  bool get karanlikTema => _prefs?.getBool('karanlik_tema') ?? false;

  Future<void> bildirimAktifKaydet(bool aktif) async {
    await _prefs?.setBool('bildirim_aktif', aktif);
  }

  bool get bildirimAktif => _prefs?.getBool('bildirim_aktif') ?? true;
}
