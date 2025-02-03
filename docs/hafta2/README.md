# Hafta 2: Flutter Temelleri ve Widget'lar

## 🎯 Hedefler
- Stateless ve Stateful Widget'ların farkını anlama
- Temel layout widget'larını öğrenme
- Gesture ve Input widget'larını kullanma
- State yönetiminin temellerini kavrama

## 📝 Konu Başlıkları
1. [Widget Türleri](#widget-türleri)
2. [Layout Widget'ları](#layout-widgetları)
3. [Gesture ve Input](#gesture-ve-input)
4. [State Yönetimi](#state-yönetimi)
5. [Alıştırmalar](#alıştırmalar)

## Widget Türleri

### Stateless Widgets
Durumu değişmeyen, statik widget'lardır. Örneğin:
- Text
- Icon
- RaisedButton
- Container

```dart
class StatikWidget extends StatelessWidget {
  final String metin;
  
  const StatikWidget({required this.metin});
  
  @override
  Widget build(BuildContext context) {
    return Text(metin);
  }
}
```

### Stateful Widgets
Durumu değişebilen, dinamik widget'lardır. Örneğin:
- Checkbox
- TextField
- Radio
- Form

```dart
class DinamikWidget extends StatefulWidget {
  const DinamikWidget({super.key});

  @override
  State<DinamikWidget> createState() => _DinamikWidgetState();
}

class _DinamikWidgetState extends State<DinamikWidget> {
  bool _durum = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _durum,
      onChanged: (yeniDeger) {
        setState(() {
          _durum = yeniDeger;
        });
      },
    );
  }
}
```

## Layout Widget'ları

### Container
En temel layout widget'ı. Padding, margin, dekorasyon gibi özellikleri vardır.

```dart
Container(
  padding: EdgeInsets.all(8.0),
  margin: EdgeInsets.symmetric(vertical: 10.0),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(8.0),
  ),
  child: Text('Merhaba'),
)
```

### Row ve Column
Yatay ve dikey düzen sağlar:

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Icon(Icons.star),
    Text('Yıldızlı'),
    Icon(Icons.star),
  ],
)

Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Başlık'),
    Text('Alt başlık'),
    Text('İçerik'),
  ],
)
```

### Stack
Widget'ları üst üste yerleştirir:

```dart
Stack(
  children: [
    Image.asset('arkaplan.jpg'),
    Positioned(
      bottom: 10,
      right: 10,
      child: Text('Alt yazı'),
    ),
  ],
)
```

## Gesture ve Input

### GestureDetector
Dokunma olaylarını yakalar:

```dart
GestureDetector(
  onTap: () {
    print('Tıklandı!');
  },
  onDoubleTap: () {
    print('Çift tıklandı!');
  },
  child: Container(
    color: Colors.blue,
    child: Text('Bana tıkla'),
  ),
)
```

### TextField
Metin girişi alır:

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Adınız',
    hintText: 'Adınızı girin',
    border: OutlineInputBorder(),
  ),
  onChanged: (deger) {
    print('Yeni değer: $deger');
  },
)
```

## State Yönetimi

### setState
Widget'ın durumunu günceller:

```dart
class SayacWidget extends StatefulWidget {
  @override
  _SayacWidgetState createState() => _SayacWidgetState();
}

class _SayacWidgetState extends State<SayacWidget> {
  int _sayac = 0;

  void _artir() {
    setState(() {
      _sayac++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Sayaç: $_sayac'),
        ElevatedButton(
          onPressed: _artir,
          child: Text('Artır'),
        ),
      ],
    );
  }
}
```

## 📝 Alıştırmalar

### 1. Layout Alıştırması
- Row ve Column kullanarak bir kart tasarlayın
- İçinde resim, başlık ve açıklama olsun
- Padding ve margin kullanın

### 2. Gesture Alıştırması
- Bir GestureDetector ile farklı dokunma olaylarını yakalayın
- Her olay için farklı bir geri bildirim verin
- SnackBar kullanarak bildirim gösterin

### 3. State Alıştırması
- Bir alışkanlık sayacı oluşturun
- Artır/Azalt butonları ekleyin
- Sıfırlama özelliği ekleyin

## 📚 Kaynaklar
- [Flutter Widget Kataloğu](https://flutter.dev/docs/development/ui/widgets)
- [Layout Tutorial](https://flutter.dev/docs/development/ui/layout/tutorial)
- [Gestures in Flutter](https://flutter.dev/docs/development/ui/advanced/gestures)
- [State Management](https://flutter.dev/docs/development/data-and-backend/state-mgmt/intro)

## 🎯 Ödev
1. Bir TODO listesi uygulaması geliştirin
2. Görevleri ekleyip silebilme özelliği olsun
3. Görevleri tamamlandı olarak işaretleyebilme özelliği olsun
4. Tamamlanan ve tamamlanmayan görevleri farklı renklerde gösterin 