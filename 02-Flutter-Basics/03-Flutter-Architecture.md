# Flutter Mimarisi

![Flutter Architecture](https://docs.flutter.dev/assets/images/docs/arch-overview/archdiagram.png)

## Flutter'ın Katmanlı Mimarisi

Flutter'ın mimarisi, farklı katmanlardan oluşan bir yapıya sahiptir. Bu katmanlar, en üstten en alta doğru şu şekildedir:

### 1. Framework Katmanı
- **Widget Katmanı**: UI bileşenlerinin tanımlandığı en üst katman
- **Rendering Katmanı**: Layout ve paint işlemlerinin yapıldığı katman
- **Animation Katmanı**: Animasyon sisteminin yönetildiği katman
- **Painting Katmanı**: Çizim işlemlerinin yapıldığı katman
- **Foundation Katmanı**: Temel utility sınıflarının bulunduğu katman

### 2. Engine Katmanı
- **Skia**: 2D grafik motoru
- **Dart Runtime**: Dart kodunun çalıştırıldığı ortam
- **Text Layout**: Metin düzeni ve render işlemleri
- **Platform Channels**: Native kod ile iletişim

### 3. Platform Katmanı
- **iOS (Cocoa/UIKit)**
- **Android (Android SDK)**
- **Web (DOM/Canvas)**
- **Windows (Win32)**
- **macOS (Cocoa)**
- **Linux (GTK)**

## Widget Ağacı Mimarisi

Flutter'da üç temel ağaç yapısı bulunur:

### 1. Widget Tree
Widget'ların hiyerarşik yapısını temsil eder:

```dart
MaterialApp
  ├── Scaffold
  │   ├── AppBar
  │   │   └── Text
  │   └── Body
  │       └── Center
  │           └── Column
  │               ├── Text
  │               └── ElevatedButton
  └── Theme
```

### 2. Element Tree
Widget'ların canlı örneklerini yönetir:

```dart
MaterialApp Element
  ├── Scaffold Element
  │   ├── AppBar Element
  │   │   └── Text Element
  │   └── Body Element
  │       └── Center Element
  │           └── Column Element
  │               ├── Text Element
  │               └── ElevatedButton Element
  └── Theme Element
```

### 3. Render Tree
Ekranda görünen gerçek layout ve paint işlemlerini yönetir:

```dart
RenderView
  ├── RenderBox (MaterialApp)
  │   ├── RenderBox (Scaffold)
  │   │   ├── RenderBox (AppBar)
  │   │   └── RenderBox (Body)
  │   │       └── RenderBox (Center)
  │   │           └── RenderFlex (Column)
  │   └── RenderBox (Theme)
```

## BuildContext ve Widget İlişkisi

BuildContext, widget ağacında bir widget'ın konumunu temsil eder:

```dart
class OrnekWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Theme verilerine erişim
    final theme = Theme.of(context);
    
    // MediaQuery ile ekran bilgilerine erişim
    final screenSize = MediaQuery.of(context).size;
    
    // Navigator ile sayfa yönetimi
    Navigator.of(context).push(...);
    
    return Container();
  }
}
```

## State Yönetimi ve Veri Akışı

### 1. Widget State İlişkisi
```dart
class StateOrnegi extends StatefulWidget {
  @override
  _StateOrnegiState createState() => _StateOrnegiState();
}

class _StateOrnegiState extends State<StateOrnegi> {
  int _sayac = 0;

  void _artir() {
    setState(() => _sayac++);
  }

  @override
  Widget build(BuildContext context) => Text('$_sayac');
}
```

### 2. InheritedWidget ile Veri Paylaşımı
```dart
class VeriSaglayici extends InheritedWidget {
  final int veri;
  
  VeriSaglayici({required this.veri, required Widget child})
      : super(child: child);
      
  static VeriSaglayici of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VeriSaglayici>()!;
  }

  @override
  bool updateShouldNotify(VeriSaglayici old) => veri != old.veri;
}
```

## Platform Channel Mimarisi

Native kod ile iletişim için platform channel'lar kullanılır:

```dart
// Dart tarafı
static const platform = MethodChannel('ornek_kanal');

Future<void> nativeMetodCagir() async {
  try {
    final String sonuc = await platform.invokeMethod('getNativeVeri');
    print(sonuc);
  } catch (e) {
    print('Hata: $e');
  }
}

// Native tarafı (Android - Kotlin)
override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "ornek_kanal")
            .setMethodCallHandler { call, result ->
                if (call.method == "getNativeVeri") {
                    result.success("Native verisi")
                }
            }
}
```

## Hot Reload ve Hot Restart

### Hot Reload
- Sadece widget ağacını yeniler
- State'i korur
- Çok hızlıdır

### Hot Restart
- Tüm uygulamayı yeniden başlatır
- State'i sıfırlar
- Hot Reload'dan daha yavaştır

## Performans Optimizasyonu

### 1. Widget Ağacı Optimizasyonu
```dart
// Kötü örnek
class KotuOrnek extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Container(
          child: Text('Çok fazla iç içe widget'),
        ),
      ),
    );
  }
}

// İyi örnek
class IyiOrnek extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Daha az iç içe widget'),
    );
  }
}
```

### 2. const Constructor Kullanımı
```dart
// Performanslı
const Text('Sabit metin')

// Daha az performanslı
Text('Sabit metin')
```

### 3. ListView Optimizasyonu
```dart
// Performanslı
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ListTile(
    title: Text(items[index]),
  ),
)

// Daha az performanslı
ListView(
  children: items.map((item) => ListTile(
    title: Text(item),
  )).toList(),
)
```

Bu mimari yapı, Flutter'ın nasıl çalıştığını ve uygulamaların nasıl oluşturulduğunu anlamak için temel oluşturur. 