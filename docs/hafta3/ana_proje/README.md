# Hafta 3 - Ana Proje: Navigasyon ve Durum Yönetimi

Bu hafta, alışkanlık takip uygulamamıza çoklu sayfa yapısı ve global durum yönetimi ekleyeceğiz.

## 🎯 Hedefler

1. Sayfa yapısının oluşturulması
   - Ana sayfa (Dashboard)
   - Alışkanlık listesi
   - Alışkanlık detay sayfası
   - Profil ve ayarlar sayfası

2. Navigasyon sisteminin kurulması
   - Alt navigasyon menüsü
   - Sayfa geçişleri
   - Derin bağlantılar

3. Sayfa geçiş animasyonları
   - Hero animasyonları
   - Özel geçiş efektleri
   - Paylaşılan element geçişleri

4. Global durum yönetimi
   - Provider yapılandırması
   - Tema yönetimi
   - Kullanıcı tercihleri
   - Veri kalıcılığı

## 📱 Ekran Tasarımları

[Ekran tasarımlarının görselleri]

## 💻 Uygulama Yapısı

```
lib/
├── models/
│   ├── aliskanlik.dart
│   └── kullanici.dart
├── providers/
│   ├── aliskanlik_provider.dart
│   └── ayarlar_provider.dart
├── screens/
│   ├── ana_sayfa.dart
│   ├── aliskanlik_listesi.dart
│   ├── aliskanlik_detay.dart
│   └── profil.dart
├── widgets/
│   ├── alt_menu.dart
│   ├── aliskanlik_karti.dart
│   └── istatistik_karti.dart
└── main.dart
```

## 🚀 Başlangıç

1. Yeni bağımlılıkları ekleyin:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  shared_preferences: ^2.2.2
  animations: ^2.0.11
  fl_chart: ^0.66.2        # İstatistikler için
  cached_network_image: ^3.3.1  # Profil fotoğrafları için
```

## 💻 Adım Adım Geliştirme

### 1. Ana Sayfa ve Navigasyon

`lib/screens/ana_sayfa.dart` dosyasını oluşturun:

```dart
class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _selectedIndex = 0;
  
  final _screens = [
    const Dashboard(),
    const AliskanlikListesi(),
    const ProfilSayfasi(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Özet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Alışkanlıklar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
```

### 2. Dashboard Sayfası

`lib/screens/dashboard.dart` dosyasını oluşturun:

```dart
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alışkanlık Takibi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showNotifications(context),
          ),
        ],
      ),
      body: Consumer<AliskanlikProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildGunlukOzet(context, provider),
              const SizedBox(height: 16),
              _buildHaftalikGrafik(context, provider),
              const SizedBox(height: 16),
              _buildPopulerAliskanliklar(context, provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGunlukOzet(
    BuildContext context,
    AliskanlikProvider provider,
  ) {
    final bugunTamamlanan = provider.bugunTamamlananlar.length;
    final toplamAliskanlik = provider.bugunkuAliskanliklar.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Günlük Özet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOzetKart(
                  context,
                  'Tamamlanan',
                  '$bugunTamamlanan',
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildOzetKart(
                  context,
                  'Toplam',
                  '$toplamAliskanlik',
                  Icons.list,
                  Colors.blue,
                ),
                _buildOzetKart(
                  context,
                  'Başarı',
                  '%${_hesaplaBasariOrani(bugunTamamlanan, toplamAliskanlik)}',
                  Icons.star,
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHaftalikGrafik(
    BuildContext context,
    AliskanlikProvider provider,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Haftalık İlerleme',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  // Grafik verilerini burada yapılandırın
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopulerAliskanliklar(
    BuildContext context,
    AliskanlikProvider provider,
  ) {
    final populerAliskanliklar = provider.enPopulerAliskanliklar;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'En Popüler Alışkanlıklar',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: populerAliskanliklar.length,
              itemBuilder: (context, index) {
                final aliskanlik = populerAliskanliklar[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(aliskanlik.baslik),
                  subtitle: Text(
                    '${aliskanlik.tamamlanmaSayisi} kez tamamlandı',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () => _showAliskanlikDetay(
                      context,
                      aliskanlik,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOzetKart(
    BuildContext context,
    String baslik,
    String deger,
    IconData icon,
    Color renk,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: renk,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          deger,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          baslik,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  int _hesaplaBasariOrani(int tamamlanan, int toplam) {
    if (toplam == 0) return 0;
    return (tamamlanan / toplam * 100).round();
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const BildirimlerSayfasi(),
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
}
```

### 3. Alışkanlık Detay Sayfası

`lib/screens/aliskanlik_detay.dart` dosyasını oluşturun:

```dart
class AliskanlikDetay extends StatelessWidget {
  final Aliskanlik aliskanlik;

  const AliskanlikDetay({
    super.key,
    required this.aliskanlik,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(aliskanlik.baslik),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: Consumer<AliskanlikProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildDetayKarti(context),
              const SizedBox(height: 16),
              _buildIstatistikler(context, provider),
              const SizedBox(height: 16),
              _buildTakipTablosu(context, provider),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tamamlaAliskanlik(context),
        child: const Icon(Icons.check),
      ),
    );
  }

  Widget _buildDetayKarti(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              aliskanlik.baslik,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (aliskanlik.aciklama != null) ...[
              const SizedBox(height: 8),
              Text(aliskanlik.aciklama!),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 8),
                Text(
                  'Başlangıç: ${DateFormat('d MMMM y').format(aliskanlik.baslangicTarihi)}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 8),
                Text(
                  'Hatırlatma: ${aliskanlik.hatirlatmaSaati.format(context)}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: aliskanlik.gunler.map((gun) {
                return Chip(
                  label: Text(gun),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIstatistikler(
    BuildContext context,
    AliskanlikProvider provider,
  ) {
    final istatistikler = provider.getAliskanlikIstatistikleri(aliskanlik.id);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'İstatistikler',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIstatistikKart(
                  context,
                  'Toplam',
                  '${istatistikler.toplamTamamlanma}',
                  Icons.check_circle,
                ),
                _buildIstatistikKart(
                  context,
                  'Seri',
                  '${istatistikler.gunlukSeri}',
                  Icons.local_fire_department,
                ),
                _buildIstatistikKart(
                  context,
                  'Başarı',
                  '%${istatistikler.basariOrani}',
                  Icons.star,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTakipTablosu(
    BuildContext context,
    AliskanlikProvider provider,
  ) {
    final takipVerileri = provider.getAylikTakipVerileri(aliskanlik.id);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aylık Takip',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: takipVerileri.length,
              itemBuilder: (context, index) {
                final veri = takipVerileri[index];
                return Container(
                  decoration: BoxDecoration(
                    color: veri.tamamlandi ? Colors.green : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Tooltip(
                    message: DateFormat('d MMMM').format(veri.tarih),
                    child: const SizedBox(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIstatistikKart(
    BuildContext context,
    String baslik,
    String deger,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          deger,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          baslik,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AliskanlikFormu(
        aliskanlik: aliskanlik,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alışkanlığı Sil'),
        content: const Text(
          'Bu alışkanlığı silmek istediğinize emin misiniz? '
          'Tüm takip verileri silinecektir.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AliskanlikProvider>().deleteAliskanlik(aliskanlik.id);
              Navigator.pop(context); // Dialog'u kapat
              Navigator.pop(context); // Detay sayfasını kapat
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  void _tamamlaAliskanlik(BuildContext context) {
    context.read<AliskanlikProvider>().tamamlaAliskanlik(
          aliskanlik.id,
          DateTime.now(),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alışkanlık tamamlandı!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
```

## 🎯 Ödevler

1. Navigasyon:
   - [ ] Özel route animasyonları ekleyin
   - [ ] Deep linking desteği ekleyin
   - [ ] Web URL yapısını düzenleyin
   - [ ] Geri tuşu yönetimini geliştirin

2. Dashboard:
   - [ ] Farklı grafik türleri ekleyin
   - [ ] Özelleştirilebilir widget'lar ekleyin
   - [ ] Sürükle-bırak düzenleme ekleyin
   - [ ] Veri filtreleme ekleyin

3. Detay Sayfası:
   - [ ] Paylaşım özelliği ekleyin
   - [ ] Not ekleme özelliği ekleyin
   - [ ] Fotoğraf ekleme desteği ekleyin
   - [ ] Hatırlatma ayarları ekleyin

## 🔍 Kontrol Listesi

Her değişiklik sonrası şunları kontrol edin:
- [ ] Navigasyon akışı doğru çalışıyor mu?
- [ ] Sayfa geçişleri akıcı mı?
- [ ] Veriler doğru güncelleniyor mu?
- [ ] Performans sorunları var mı?

## 💡 İpuçları

1. Navigasyon:
   - Route'ları merkezi yönetin
   - Geçiş animasyonlarını optimize edin
   - Deep link yapısını baştan planlayın
   - Geri tuşu davranışlarını özelleştirin

2. Durum Yönetimi:
   - Provider'ları mantıklı gruplandırın
   - Gereksiz build'lerden kaçının
   - Veri akışını optimize edin
   - Bellek sızıntılarını önleyin

3. UI/UX:
   - Tutarlı tasarım dili kullanın
   - Kullanıcı geri bildirimleri ekleyin
   - Yükleme durumlarını gösterin
   - Hata mesajlarını özelleştirin

## 📚 Faydalı Kaynaklar

- [Flutter Navigation 2.0](https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade)
- [Provider Architecture](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple)
- [Hero Animations](https://flutter.dev/docs/development/ui/animations/hero-animations)
- [Charts Library](https://pub.dev/packages/fl_chart) 