import 'package:flutter/material.dart';
import '../services/ayarlar_servisi.dart';

class AyarlarSayfasi extends StatefulWidget {
  final AyarlarServisi ayarlarServisi;

  const AyarlarSayfasi({
    super.key,
    required this.ayarlarServisi,
  });

  @override
  State<AyarlarSayfasi> createState() => _AyarlarSayfasiState();
}

class _AyarlarSayfasiState extends State<AyarlarSayfasi> {
  late TimeOfDay _varsayilanHatirlatmaSaati;
  late bool _karanlikTema;
  late bool _bildirimAktif;

  @override
  void initState() {
    super.initState();
    _ayarlariYukle();
  }

  void _ayarlariYukle() {
    setState(() {
      _varsayilanHatirlatmaSaati = widget.ayarlarServisi.varsayilanHatirlatmaSaati;
      _karanlikTema = widget.ayarlarServisi.karanlikTema;
      _bildirimAktif = widget.ayarlarServisi.bildirimAktif;
    });
  }

  Future<void> _hatirlatmaSaatiSec() async {
    final secilenSaat = await showTimePicker(
      context: context,
      initialTime: _varsayilanHatirlatmaSaati,
    );

    if (secilenSaat != null) {
      setState(() {
        _varsayilanHatirlatmaSaati = secilenSaat;
      });
      await widget.ayarlarServisi.varsayilanHatirlatmaSaatiKaydet(secilenSaat);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Varsayılan Hatırlatma Saati'),
            subtitle: Text(
              '${_varsayilanHatirlatmaSaati.hour.toString().padLeft(2, '0')}:${_varsayilanHatirlatmaSaati.minute.toString().padLeft(2, '0')}',
            ),
            onTap: _hatirlatmaSaatiSec,
          ),
          SwitchListTile(
            title: const Text('Karanlık Tema'),
            value: _karanlikTema,
            onChanged: (bool value) async {
              setState(() {
                _karanlikTema = value;
              });
              await widget.ayarlarServisi.karanlikTemaKaydet(value);
            },
          ),
          SwitchListTile(
            title: const Text('Bildirimleri Etkinleştir'),
            value: _bildirimAktif,
            onChanged: (bool value) async {
              setState(() {
                _bildirimAktif = value;
              });
              await widget.ayarlarServisi.bildirimAktifKaydet(value);
            },
          ),
        ],
      ),
    );
  }
}
