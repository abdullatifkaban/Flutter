# Flutter'da Navigasyon Örnekleri

Bu bölümde, Flutter'da sık kullanılan navigasyon senaryolarını örneklerle inceleyeceğiz.

## 1. Basit İki Sayfa Arası Geçiş

### 1.1. Ana Sayfa (main.dart)

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigasyon Örneği',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatelessWidget {
  const AnaSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DetaySayfasi()),
            );
          },
          child: const Text('Detay Sayfasına Git'),
        ),
      ),
    );
  }
}

class DetaySayfasi extends StatelessWidget {
  const DetaySayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detay Sayfası'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Geri Dön'),
        ),
      ),
    );
  }
}
```

## 2. Veri Aktarımlı Sayfa Geçişi

### 2.1. Ürün Listesi Örneği

```dart
// Ürün modeli
class Urun {
  final String id;
  final String ad;
  final double fiyat;

  Urun({required this.id, required this.ad, required this.fiyat});
}

// Ürün listesi sayfası
class UrunListesi extends StatelessWidget {
  final List<Urun> urunler = [
    Urun(id: '1', ad: 'Laptop', fiyat: 15000),
    Urun(id: '2', ad: 'Telefon', fiyat: 10000),
    Urun(id: '3', ad: 'Tablet', fiyat: 5000),
  ];

  UrunListesi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ürünler')),
      body: ListView.builder(
        itemCount: urunler.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(urunler[index].ad),
            subtitle: Text('${urunler[index].fiyat} TL'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UrunDetay(urun: urunler[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Ürün detay sayfası
class UrunDetay extends StatelessWidget {
  final Urun urun;

  const UrunDetay({super.key, required this.urun});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(urun.ad)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ürün ID: ${urun.id}'),
            const SizedBox(height: 8),
            Text('Ürün Adı: ${urun.ad}'),
            const SizedBox(height: 8),
            Text('Fiyat: ${urun.fiyat} TL'),
          ],
        ),
      ),
    );
  }
}
```

## 3. Named Routes ile Çoklu Sayfa Yönetimi

### 3.1. Route Tanımlamaları (main.dart)

```dart
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Named Routes Örneği',
      initialRoute: '/',
      routes: {
        '/': (context) => const AnaSayfa(),
        '/profil': (context) => const ProfilSayfasi(),
        '/ayarlar': (context) => const AyarlarSayfasi(),
        '/hakkinda': (context) => const HakkindaSayfasi(),
      },
    );
  }
}

// Ana sayfa widget'ı
class AnaSayfa extends StatelessWidget {
  const AnaSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ana Sayfa')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menü'),
            ),
            ListTile(
              title: const Text('Profil'),
              onTap: () => Navigator.pushNamed(context, '/profil'),
            ),
            ListTile(
              title: const Text('Ayarlar'),
              onTap: () => Navigator.pushNamed(context, '/ayarlar'),
            ),
            ListTile(
              title: const Text('Hakkında'),
              onTap: () => Navigator.pushNamed(context, '/hakkinda'),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Menüyü açmak için sol kenardan kaydırın'),
      ),
    );
  }
}
```

## 4. Pratik Alıştırma

1. Ana sayfaya bir alt menü ekleyin
2. Her sayfada farklı bir tema rengi kullanın
3. Sayfa geçişlerinde özel animasyonlar ekleyin
4. Sayfalar arası veri aktarımını deneyin

Bu örnekleri çalıştırmak için yeni bir Flutter projesi oluşturun ve kodları ilgili dosyalara ekleyin:

```bash
flutter create navigation_demo
cd navigation_demo
# Kodları ekleyin ve çalıştırın
flutter run
```
