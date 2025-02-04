# Hafta 2 - Ana Proje: Alışkanlık Listesi ve Form İşlemleri

Bu hafta, alışkanlık takip uygulamamıza liste görünümü ve form işlemlerini ekleyeceğiz.

## 🎯 Hedefler

1. Alışkanlık listesi görünümünün oluşturulması
2. Yeni alışkanlık ekleme formunun tasarlanması
3. Alışkanlık detay sayfasının hazırlanması
4. Kategori filtreleme sisteminin eklenmesi

## 📱 Ekran Tasarımları

[Ekran tasarımlarının görselleri]

## 💻 Adım Adım Geliştirme

### 1. Alışkanlık Modeli

`lib/models/aliskanlik.dart` dosyasını oluşturun:

```dart
class Aliskanlik {
  final String id;
  String baslik;
  String? aciklama;
  DateTime baslangicTarihi;
  String? kategori;
  List<String> gunler;
  TimeOfDay hatirlatmaSaati;
  bool aktif;

  Aliskanlik({
    required this.baslik,
    this.aciklama,
    required this.baslangicTarihi,
    this.kategori,
    required this.gunler,
    required this.hatirlatmaSaati,
    this.aktif = true,
    String? id,
  }) : id = id ?? const Uuid().v4();

  Aliskanlik copyWith({
    String? baslik,
    String? aciklama,
    DateTime? baslangicTarihi,
    String? kategori,
    List<String>? gunler,
    TimeOfDay? hatirlatmaSaati,
    bool? aktif,
  }) {
    return Aliskanlik(
      id: id,
      baslik: baslik ?? this.baslik,
      aciklama: aciklama ?? this.aciklama,
      baslangicTarihi: baslangicTarihi ?? this.baslangicTarihi,
      kategori: kategori ?? this.kategori,
      gunler: gunler ?? this.gunler,
      hatirlatmaSaati: hatirlatmaSaati ?? this.hatirlatmaSaati,
      aktif: aktif ?? this.aktif,
    );
  }
}
```

### 2. Alışkanlık Listesi

`lib/screens/aliskanlik_listesi.dart` dosyasını oluşturun:

```dart
class AliskanlikListesi extends StatelessWidget {
  const AliskanlikListesi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alışkanlıklarım'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showKategoriFiltresi(context),
          ),
        ],
      ),
      body: Consumer<AliskanlikProvider>(
        builder: (context, provider, child) {
          if (provider.aliskanliklar.isEmpty) {
            return const Center(
              child: Text('Henüz alışkanlık eklenmedi'),
            );
          }

          return ListView.builder(
            itemCount: provider.aliskanliklar.length,
            itemBuilder: (context, index) {
              final aliskanlik = provider.aliskanliklar[index];
              return AliskanlikListeOgesi(
                aliskanlik: aliskanlik,
                onTap: () => _showAliskanlikDetay(context, aliskanlik),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAliskanlikFormu(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showKategoriFiltresi(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const KategoriFiltresi(),
    );
  }

  void _showAliskanlikDetay(BuildContext context, Aliskanlik aliskanlik) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AliskanlikDetay(aliskanlik: aliskanlik),
      ),
    );
  }

  void _showAliskanlikFormu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AliskanlikFormu(),
    );
  }
}
```

### 3. Alışkanlık Form Dialog'u

`lib/widgets/aliskanlik_formu.dart` dosyasını oluşturun:

```dart
class AliskanlikFormu extends StatefulWidget {
  final Aliskanlik? aliskanlik;

  const AliskanlikFormu({
    super.key,
    this.aliskanlik,
  });

  @override
  State<AliskanlikFormu> createState() => _AliskanlikFormuState();
}

class _AliskanlikFormuState extends State<AliskanlikFormu> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _baslikController;
  late final TextEditingController _aciklamaController;
  DateTime? _baslangicTarihi;
  TimeOfDay? _hatirlatmaSaati;
  String? _kategori;
  final List<String> _gunler = [];

  @override
  void initState() {
    super.initState();
    _baslikController = TextEditingController(text: widget.aliskanlik?.baslik);
    _aciklamaController = TextEditingController(text: widget.aliskanlik?.aciklama);
    _baslangicTarihi = widget.aliskanlik?.baslangicTarihi;
    _hatirlatmaSaati = widget.aliskanlik?.hatirlatmaSaati;
    _kategori = widget.aliskanlik?.kategori;
    if (widget.aliskanlik != null) {
      _gunler.addAll(widget.aliskanlik!.gunler);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.aliskanlik == null ? 'Yeni Alışkanlık' : 'Alışkanlığı Düzenle',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _baslikController,
                decoration: const InputDecoration(
                  labelText: 'Başlık',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Başlık boş olamaz';
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
              ListTile(
                title: const Text('Başlangıç Tarihi'),
                subtitle: Text(
                  _baslangicTarihi == null
                      ? 'Seçilmedi'
                      : DateFormat('d MMMM y').format(_baslangicTarihi!),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Hatırlatma Saati'),
                subtitle: Text(
                  _hatirlatmaSaati == null
                      ? 'Seçilmedi'
                      : '${_hatirlatmaSaati!.hour}:${_hatirlatmaSaati!.minute}',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Sağlık',
                    child: Text('Sağlık'),
                  ),
                  DropdownMenuItem(
                    value: 'Spor',
                    child: Text('Spor'),
                  ),
                  DropdownMenuItem(
                    value: 'Eğitim',
                    child: Text('Eğitim'),
                  ),
                  DropdownMenuItem(
                    value: 'Hobi',
                    child: Text('Hobi'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _kategori = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text('Tekrar Günleri'),
              Wrap(
                spacing: 8,
                children: [
                  'Pazartesi',
                  'Salı',
                  'Çarşamba',
                  'Perşembe',
                  'Cuma',
                  'Cumartesi',
                  'Pazar',
                ].map((gun) {
                  return FilterChip(
                    label: Text(gun),
                    selected: _gunler.contains(gun),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _gunler.add(gun);
                        } else {
                          _gunler.remove(gun);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: _saveForm,
          child: const Text('Kaydet'),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _baslangicTarihi ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _baslangicTarihi = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _hatirlatmaSaati ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _hatirlatmaSaati = picked;
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      if (_baslangicTarihi == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lütfen başlangıç tarihi seçin'),
          ),
        );
        return;
      }
      if (_hatirlatmaSaati == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lütfen hatırlatma saati seçin'),
          ),
        );
        return;
      }
      if (_gunler.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lütfen en az bir gün seçin'),
          ),
        );
        return;
      }

      final aliskanlik = Aliskanlik(
        id: widget.aliskanlik?.id,
        baslik: _baslikController.text,
        aciklama: _aciklamaController.text.isEmpty
            ? null
            : _aciklamaController.text,
        baslangicTarihi: _baslangicTarihi!,
        kategori: _kategori,
        gunler: _gunler,
        hatirlatmaSaati: _hatirlatmaSaati!,
        aktif: widget.aliskanlik?.aktif ?? true,
      );

      if (widget.aliskanlik == null) {
        context.read<AliskanlikProvider>().addAliskanlik(aliskanlik);
      } else {
        context.read<AliskanlikProvider>().updateAliskanlik(aliskanlik);
      }

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _baslikController.dispose();
    _aciklamaController.dispose();
    super.dispose();
  }
}
```

### 4. Alışkanlık Liste Öğesi

`lib/widgets/aliskanlik_liste_ogesi.dart` dosyasını oluşturun:

```dart
class AliskanlikListeOgesi extends StatelessWidget {
  final Aliskanlik aliskanlik;
  final VoidCallback onTap;

  const AliskanlikListeOgesi({
    super.key,
    required this.aliskanlik,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            aliskanlik.baslik[0].toUpperCase(),
          ),
        ),
        title: Text(aliskanlik.baslik),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (aliskanlik.aciklama != null)
              Text(
                aliskanlik.aciklama!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Text(
              'Her ${aliskanlik.gunler.join(", ")} günleri',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (aliskanlik.kategori != null)
              Chip(
                label: Text(aliskanlik.kategori!),
              ),
            Switch(
              value: aliskanlik.aktif,
              onChanged: (value) {
                context.read<AliskanlikProvider>().toggleAliskanlik(
                      aliskanlik.id,
                      value,
                    );
              },
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
```

## 🎯 Ödevler

1. Liste Görünümü:
   - [ ] GridView alternatifi ekleyin
   - [ ] Liste/Grid geçiş butonu ekleyin
   - [ ] Sürükle-bırak sıralama ekleyin
   - [ ] Pull-to-refresh ekleyin

2. Form Geliştirmeleri:
   - [ ] Özel kategori ekleme
   - [ ] Tekrar sıklığı seçimi
   - [ ] Hatırlatma sesi seçimi
   - [ ] Renk seçimi

## 🔍 Kontrol Listesi

Her değişiklik sonrası şunları kontrol edin:
- [ ] Form validasyonu çalışıyor mu?
- [ ] Liste görünümü düzgün mu?
- [ ] Filtreler doğru çalışıyor mu?
- [ ] Hatırlatma ayarları kaydediliyor mu?

## 💡 İpuçları

1. Form Tasarımı:
   - Kullanıcı dostu hata mesajları
   - Mantıklı varsayılan değerler
   - Kolay tarih/saat seçimi
   - Açık yönlendirmeler

2. Liste Optimizasyonu:
   - ListView.builder kullanımı
   - Gereksiz build'lerden kaçınma
   - Lazy loading
   - Önbelleğe alma

3. Kullanıcı Deneyimi:
   - Yükleme göstergeleri
   - Hata durumu yönetimi
   - Geri bildirim mesajları
   - Kolay gezinme

## 📚 Faydalı Kaynaklar

- [Flutter Form Widgets](https://flutter.dev/docs/cookbook/forms)
- [DateTime Picker](https://api.flutter.dev/flutter/material/showDatePicker.html)
- [ListView Documentation](https://api.flutter.dev/flutter/widgets/ListView-class.html)
- [Provider State Management](https://pub.dev/packages/provider) 