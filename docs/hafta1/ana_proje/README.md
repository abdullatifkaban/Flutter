# Hafta 1 - Ana Proje: Alışkanlık Takip Uygulaması

Bu hafta, alışkanlık takip uygulamamızın temellerini atacağız. Flutter'ın temel widget'larını kullanarak ana sayfa tasarımını yapacağız.

## 🎯 Hedefler

1. Proje yapısının oluşturulması
2. Ana sayfa tasarımının yapılması
3. Temel navigation sisteminin kurulması
4. Theme ayarlarının yapılandırılması

## 📱 Ekran Tasarımları

[Ana sayfa tasarımının ekran görüntüsü]

## 💻 Adım Adım Geliştirme

### 1. Proje Yapısı

```
lib/
├── main.dart           # Ana uygulama dosyası
├── screens/           # Ekranlar
│   └── home_page.dart  # Ana sayfa
├── widgets/           # Özel widget'lar
├── models/            # Veri modelleri
├── utils/            # Yardımcı fonksiyonlar
└── theme/            # Tema ayarları
```

### 2. Ana Uygulama Yapısı

`lib/main.dart` dosyasını oluşturun:

```dart
import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const AliskanlikTakipApp());
}

class AliskanlikTakipApp extends StatelessWidget {
  const AliskanlikTakipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alışkanlık Takip',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const AnaSayfa(),
    );
  }
}
```

### 3. Ana Sayfa Tasarımı

`lib/screens/home_page.dart` dosyasını oluşturun:

```dart
import 'package:flutter/material.dart';

class AnaSayfa extends StatelessWidget {
  const AnaSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alışkanlıklarım'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Yeni alışkanlık ekleme
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Henüz alışkanlık eklenmedi'),
      ),
    );
  }
}
```

### 4. Tema Ayarları

`lib/theme/app_theme.dart` dosyasını oluşturun:

```dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
  }
}
```

## 🎯 Ödevler

1. Temel Özellikler:
   - [ ] AppBar'a profil ikonu ekleyin
   - [ ] Drawer menüsü ekleyin
   - [ ] Bottom navigation bar ekleyin
   - [ ] Floating action button ekleyin

2. UI Geliştirmeleri:
   - [ ] Özel renk paleti oluşturun
   - [ ] Custom font ekleyin
   - [ ] Tema geçişi için buton ekleyin
   - [ ] Splash screen tasarlayın

## 🔍 Kontrol Listesi

Her değişiklik sonrası şunları kontrol edin:
- [ ] Hot reload çalışıyor mu?
- [ ] UI tasarımı bozuk görünen yer var mı?
- [ ] Tema değişikliği düzgün çalışıyor mu?
- [ ] Navigation sorunsuz çalışıyor mu?

## 💡 İpuçları

1. Widget Ağacı:
   - Karmaşık UI'ları küçük widget'lara bölün
   - `const` constructor kullanmayı unutmayın
   - Widget parametrelerini named yapın

2. Tema:
   - Material 3 tasarım ilkelerini takip edin
   - Renk paleti oluştururken contrast oranlarına dikkat edin
   - Dark tema desteğini baştan planlayın

3. Performans:
   - Gereksiz build işlemlerinden kaçının
   - Büyük listelerde `ListView.builder` kullanın
   - Resimleri optimize edin

## 📚 Faydalı Kaynaklar

- [Material 3 Tasarım Rehberi](https://m3.material.io/)
- [Flutter Navigation Örnekleri](https://flutter.dev/docs/cookbook/navigation)
- [Flutter Theme Dokümantasyonu](https://api.flutter.dev/flutter/material/ThemeData-class.html)

## 🔄 Geri Bildirim

Aşağıdaki konularda geri bildirim verin:
1. Kod organizasyonu
2. UI/UX tasarımı
3. Performans optimizasyonu
4. Best practices uyumu 