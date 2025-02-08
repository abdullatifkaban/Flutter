# Flutter Widget Sistemi

## Widget Nedir?

Flutter'da her şey bir widget'tır. Widget'lar, kullanıcı arayüzünün yapı taşlarıdır. Bir düğme, bir metin, bir görüntü veya tüm ekran - hepsi birer widget'tır. Widget'lar, kullanıcı arayüzünün nasıl görüneceğini ve nasıl davranacağını tanımlar.

## Stateless vs Stateful Widgets

### Stateless Widgets
Durumu olmayan, statik widget'lardır. Bir kez oluşturulduktan sonra değişmezler.

```dart
class SelamlamaWidget extends StatelessWidget {
  final String isim;

  const SelamlamaWidget({
    Key? key,
    required this.isim,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Merhaba, $isim!');
  }
}
```

### Stateful Widgets
Durumu olan, dinamik widget'lardır. Kullanıcı etkileşimi veya veri değişikliği ile yeniden oluşturulabilirler.

```dart
class SayacWidget extends StatefulWidget {
  const SayacWidget({Key? key}) : super(key: key);

  @override
  _SayacWidgetState createState() => _SayacWidgetState();
}

class _SayacWidgetState extends State<SayacWidget> {
  int _sayac = 0;

  void _sayaciArtir() {
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
          onPressed: _sayaciArtir,
          child: Text('Artır'),
        ),
      ],
    );
  }
}
```

## Widget Yaşam Döngüsü

### Stateless Widget Yaşam Döngüsü
1. Constructor
2. build()

### Stateful Widget Yaşam Döngüsü
1. Constructor
2. createState()
3. initState()
4. didChangeDependencies()
5. build()
6. didUpdateWidget()
7. setState()
8. dispose()

```dart
class YasamDongusuWidget extends StatefulWidget {
  const YasamDongusuWidget({Key? key}) : super(key: key);

  @override
  _YasamDongusuWidgetState createState() => _YasamDongusuWidgetState();
}

class _YasamDongusuWidgetState extends State<YasamDongusuWidget> {
  @override
  void initState() {
    super.initState();
    print('Widget başlatıldı');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('Bağımlılıklar değişti');
  }

  @override
  void didUpdateWidget(covariant YasamDongusuWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('Widget güncellendi');
  }

  @override
  void dispose() {
    print('Widget dispose edildi');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Widget build edildi');
    return Container();
  }
}
```

## Widget Ağacı (Widget Tree)

Flutter uygulamaları, iç içe geçmiş widget'lardan oluşan bir ağaç yapısına sahiptir:

```dart
MaterialApp(
  home: Scaffold(
    appBar: AppBar(
      title: Text('Widget Ağacı Örneği'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Merhaba'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: Text('Tıkla'),
          ),
        ],
      ),
    ),
  ),
)
```

## Inherited Widget ve BuildContext

Inherited Widget, widget ağacında veri paylaşımı için kullanılır:

```dart
class VeriPaylasimi extends InheritedWidget {
  final String veri;

  const VeriPaylasimi({
    Key? key,
    required this.veri,
    required Widget child,
  }) : super(key: key, child: child);

  static VeriPaylasimi? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VeriPaylasimi>();
  }

  @override
  bool updateShouldNotify(VeriPaylasimi old) {
    return veri != old.veri;
  }
}

// Kullanımı
class VeriKullananWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final veriPaylasimi = VeriPaylasimi.of(context);
    return Text(veriPaylasimi?.veri ?? '');
  }
}
```

## Widget Kompozisyonu

Widget'ları birleştirerek daha karmaşık arayüzler oluşturabilirsiniz:

```dart
class OzelKart extends StatelessWidget {
  final String baslik;
  final String icerik;
  final VoidCallback? onTap;

  const OzelKart({
    Key? key,
    required this.baslik,
    required this.icerik,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                baslik,
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 8.0),
              Text(icerik),
            ],
          ),
        ),
      ),
    );
  }
}

// Kullanımı
OzelKart(
  baslik: 'Flutter',
  icerik: 'Modern uygulama geliştirme framework\'ü',
  onTap: () => print('Karta tıklandı'),
)
```

## Widget Performansı

Widget'ların performanslı çalışması için dikkat edilmesi gerekenler:

1. **const Constructor Kullanımı**
```dart
// Performanslı
const Text('Sabit Metin')

// Daha az performanslı
Text('Sabit Metin')
```

2. **Widget Parçalama**
```dart
// Büyük widget'ı parçalara ayırma
class BuyukWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _UstKisim(),
        _OrtaKisim(),
        _AltKisim(),
      ],
    );
  }
}
```

3. **ListView.builder Kullanımı**
```dart
// Performanslı liste
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ListTile(
    title: Text(items[index]),
  ),
)
```

Bu temel widget kavramları, Flutter uygulamaları geliştirirken sıkça kullanacağınız yapı taşlarıdır. Widget sistemini iyi anlamak, etkili ve performanslı uygulamalar geliştirmenize yardımcı olur. 