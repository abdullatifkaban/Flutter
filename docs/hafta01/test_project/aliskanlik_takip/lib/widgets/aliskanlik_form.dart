import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/aliskanlik.dart';
import '../providers/aliskanlik_provider.dart';

class AliskanlikForm extends StatefulWidget {
  final Aliskanlik? aliskanlik;

  const AliskanlikForm({
    super.key,
    this.aliskanlik,
  });

  @override
  State<AliskanlikForm> createState() => _AliskanlikFormState();
}

class _AliskanlikFormState extends State<AliskanlikForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _baslikController;
  late final TextEditingController _aciklamaController;
  late String _secilenKategori;
  final List<String> _kategoriler = ['Genel', 'Sağlık', 'Spor', 'Eğitim', 'Diğer'];
  late TimeOfDay _hatirlatmaSaati;
  late final List<String> _secilenGunler;
  final List<String> _haftaninGunleri = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar'
  ];

  @override
  void initState() {
    super.initState();
    _baslikController = TextEditingController(text: widget.aliskanlik?.baslik);
    _aciklamaController = TextEditingController(text: widget.aliskanlik?.aciklama);
    _secilenKategori = widget.aliskanlik?.kategori ?? 'Genel';
    _hatirlatmaSaati = widget.aliskanlik?.hatirlatmaSaati ?? const TimeOfDay(hour: 9, minute: 0);
    _secilenGunler = List.from(widget.aliskanlik?.gunler ?? []);
  }

  @override
  void dispose() {
    _baslikController.dispose();
    _aciklamaController.dispose();
    super.dispose();
  }

  Future<void> _saatSec() async {
    final secilenSaat = await showTimePicker(
      context: context,
      initialTime: _hatirlatmaSaati,
    );

    if (secilenSaat != null) {
      setState(() {
        _hatirlatmaSaati = secilenSaat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              widget.aliskanlik == null ? 'Yeni Alışkanlık' : 'Alışkanlığı Düzenle',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _baslikController,
              decoration: const InputDecoration(
                labelText: 'Başlık',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen bir başlık girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _aciklamaController,
              decoration: const InputDecoration(
                labelText: 'Açıklama',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _secilenKategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: _kategoriler.map((kategori) {
                return DropdownMenuItem(
                  value: kategori,
                  child: Text(kategori),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _secilenKategori = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Hatırlatma Saati'),
              subtitle: Text(
                '${_hatirlatmaSaati.hour.toString().padLeft(2, '0')}:${_hatirlatmaSaati.minute.toString().padLeft(2, '0')}',
              ),
              trailing: const Icon(Icons.access_time),
              onTap: _saatSec,
            ),
            const SizedBox(height: 8),
            const Text('Tekrar Günleri'),
            Wrap(
              spacing: 8,
              children: _haftaninGunleri.map((gun) {
                final secili = _secilenGunler.contains(gun);
                return FilterChip(
                  label: Text(gun),
                  selected: secili,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _secilenGunler.add(gun);
                      } else {
                        _secilenGunler.remove(gun);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (_secilenGunler.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lütfen en az bir gün seçin'),
                      ),
                    );
                    return;
                  }

                  final provider = context.read<AliskanlikProvider>();
                  final aliskanlik = Aliskanlik(
                    id: widget.aliskanlik?.id ?? DateTime.now().toString(),
                    baslik: _baslikController.text,
                    aciklama: _aciklamaController.text,
                    kategori: _secilenKategori,
                    gunler: _secilenGunler,
                    hatirlatmaSaati: _hatirlatmaSaati,
                    aktif: widget.aliskanlik?.aktif ?? true,
                    baslangicTarihi: widget.aliskanlik?.baslangicTarihi ?? DateTime.now(),
                    sonTamamlanmaTarihi: widget.aliskanlik?.sonTamamlanmaTarihi,
                  );

                  if (widget.aliskanlik == null) {
                    await provider.aliskanlikEkle(aliskanlik);
                  } else {
                    await provider.durumGuncelle(aliskanlik.id, aliskanlik.aktif);
                  }

                  if (mounted && context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: Text(widget.aliskanlik == null ? 'Kaydet' : 'Güncelle'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
