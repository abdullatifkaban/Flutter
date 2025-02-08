# Flutter Navigation Projesi - Adım Adım

Bu bölümde, öğrendiğimiz navigasyon konularını kullanarak basit bir e-ticaret uygulaması yapacağız.

## 1. Proje Oluşturma

Öncelikle yeni bir Flutter projesi oluşturalım:

```bash
flutter create navigation_shop
cd navigation_shop
```

## 2. Proje Yapısı

Projemizde aşağıdaki sayfalar olacak:
- Ana Sayfa (Ürün Listesi)
- Ürün Detay Sayfası
- Sepet Sayfası
- Profil Sayfası

## 3. Uygulama Kodları

### 3.1. Model Sınıfları (lib/models/urun.dart)

```dart
class Urun {
  final String id;
  final String ad;
  final double fiyat;
  final String resimUrl;
  final String aciklama;

  Urun({
    required this.id,
    required this.ad,
    required this.fiyat,
    required this.resimUrl,
    required this.aciklama,
  });
}
```

### 3.2. Ana Uygulama (lib/main.dart)

```dart
import 'package:flutter/material.dart';
import 'screens/ana_sayfa.dart';
import 'screens/sepet_sayfasi.dart';
import 'screens/profil_sayfasi.dart';

void main() {
  runApp(const AlisverisApp());
}

class AlisverisApp extends StatelessWidget {
  const AlisverisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alışveriş Uygulaması',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AnaEkran(),
    );
  }
}

class AnaEkran extends StatefulWidget {
  const AnaEkran({super.key});

  @override
  State<AnaEkran> createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  int _secilenIndeks = 0;
  
  final List<Widget> _sayfalar = [
    const AnaSayfa(),
    const SepetSayfasi(),
    const ProfilSayfasi(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _sayfalar[_secilenIndeks],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _secilenIndeks,
        onTap: (indeks) {
          setState(() {
            _secilenIndeks = indeks;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Sepet',
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

### 3.3. Ana Sayfa (lib/screens/ana_sayfa.dart)

```dart
import 'package:flutter/material.dart';
import '../models/urun.dart';
import 'urun_detay.dart';

class AnaSayfa extends StatelessWidget {
  const AnaSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    // Örnek ürün listesi
    final List<Urun> urunler = [
      Urun(
        id: '1',
        ad: 'Akıllı Telefon',
        fiyat: 12999.99,
        resimUrl: 'https://picsum.photos/200',
        aciklama: 'Son model akıllı telefon',
      ),
      Urun(
        id: '2',
        ad: 'Laptop',
        fiyat: 22999.99,
        resimUrl: 'https://picsum.photos/201',
        aciklama: 'Yüksek performanslı laptop',
      ),
      // Daha fazla ürün eklenebilir
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürünler'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: urunler.length,
        itemBuilder: (context, index) {
          return UrunKarti(urun: urunler[index]);
        },
      ),
    );
  }
}

class UrunKarti extends StatelessWidget {
  final Urun urun;

  const UrunKarti({super.key, required this.urun});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UrunDetay(urun: urun),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                urun.resimUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    urun.ad,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${urun.fiyat} TL',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 3.4. Ürün Detay Sayfası (lib/screens/urun_detay.dart)

```dart
import 'package:flutter/material.dart';
import '../models/urun.dart';

class UrunDetay extends StatelessWidget {
  final Urun urun;

  const UrunDetay({super.key, required this.urun});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(urun.ad),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              urun.resimUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    urun.ad,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${urun.fiyat} TL',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    urun.aciklama,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Sepete ekleme işlemi
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ürün sepete eklendi'),
                          ),
                        );
                      },
                      child: const Text('Sepete Ekle'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 3.5. Sepet Sayfası (lib/screens/sepet_sayfasi.dart)

```dart
import 'package:flutter/material.dart';

class SepetSayfasi extends StatelessWidget {
  const SepetSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepetim'),
      ),
      body: const Center(
        child: Text('Sepet Sayfası'),
      ),
    );
  }
}
```

### 3.6. Profil Sayfası (lib/screens/profil_sayfasi.dart)

```dart
import 'package:flutter/material.dart';

class ProfilSayfasi extends StatelessWidget {
  const ProfilSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim'),
      ),
      body: const Center(
        child: Text('Profil Sayfası'),
      ),
    );
  }
}
```

## 4. Projeyi Çalıştırma

Projeyi çalıştırmak için terminal'de aşağıdaki komutları sırasıyla çalıştırın:

```bash
flutter pub get
flutter run
```

## 5. Ödev

1. Sepet sayfasına ürün ekleme ve çıkarma özelliği ekleyin
2. Profil sayfasına kullanıcı bilgileri ekleyin
3. Ürün arama özelliği ekleyin
4. Ürünleri kategorilere ayırın

Bu proje ile Flutter'da:
- Sayfa geçişlerini
- Veri aktarımını
- Bottom Navigation Bar kullanımını
- Temel widget'ları
öğrenmiş olduk.

İyi çalışmalar!
