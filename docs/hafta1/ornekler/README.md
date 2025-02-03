# Hafta 1 - İlk Flutter Uygulaması

Bu örnek, basit bir Flutter uygulamasının temel yapısını göstermektedir.

## 📁 Dosya Yapısı

```
lib/
└── main.dart     # Ana uygulama dosyası
```

## 🔍 Kod İncelemesi

### 1. Uygulama Girişi
```dart
void main() {
  runApp(const MyApp());
}
```
- `main()` fonksiyonu uygulamanın giriş noktasıdır
- `runApp()` fonksiyonu ile uygulama başlatılır

### 2. Ana Uygulama Widget'ı
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
```
- `StatelessWidget` sınıfından türetilmiştir
- `MaterialApp` widget'ı ile Material Design teması uygulanır
- `theme` parametresi ile uygulama teması belirlenir
- `home` parametresi ile ana sayfa belirlenir

### 3. Ana Sayfa Widget'ı
```dart
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alışkanlık Takip'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hoş Geldiniz!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Butona tıklandı!'),
                  ),
                );
              },
              child: const Text('Tıkla'),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### Kullanılan Widget'lar:
1. **Scaffold**: Sayfa yapısını oluşturur
   - `appBar`: Üst menü çubuğu
   - `body`: Ana içerik alanı

2. **AppBar**: Üst menü çubuğu
   - `title`: Başlık metni
   - `backgroundColor`: Arka plan rengi

3. **Center**: İçeriği ortalar

4. **Column**: Dikey düzen sağlar
   - `mainAxisAlignment`: Dikey hizalama
   - `children`: Alt widget'lar

5. **Text**: Metin gösterir
   - `style`: Metin stili (boyut, kalınlık vb.)

6. **SizedBox**: Boşluk oluşturur
   - `height`: Dikey boşluk miktarı

7. **ElevatedButton**: Materyal tasarım butonu
   - `onPressed`: Tıklama olayı
   - `child`: Buton içeriği

## 🎯 Öğrenme Hedefleri

Bu örnek ile:
- Flutter uygulamasının temel yapısını
- Temel widget'ların kullanımını
- Widget ağacı oluşturmayı
- Basit kullanıcı etkileşimlerini
öğrenmiş olacaksınız.

## 🔄 Nasıl Çalıştırılır?

1. Projeyi oluşturun:
```bash
flutter create ilk_uygulama
cd ilk_uygulama
```

2. `lib/main.dart` dosyasının içeriğini bu örnekteki kodla değiştirin.

3. Uygulamayı çalıştırın:
```bash
flutter run
```

## 📝 Alıştırmalar

1. AppBar'ın rengini değiştirin
2. Hoş geldiniz metninin stilini özelleştirin
3. Butona tıklandığında farklı bir mesaj gösterin
4. Column içine yeni widget'lar ekleyin 