# Hafta 7 - Animasyonlar ve Geçişler

Bu hafta, Flutter'da animasyonlar ve geçişler konusunu öğreneceğiz.

## 🎯 Bu Hafta Neler Öğreneceğiz?

1. Temel Animasyon Kavramları
   - Animation Controller
   - Tween
   - Curve
   - AnimatedBuilder
   - AnimatedWidget

2. Önceden Hazırlanmış Animasyonlar
   - AnimatedContainer
   - AnimatedOpacity
   - AnimatedPositioned
   - AnimatedSwitcher
   - Hero Animasyonları

3. Özel Animasyonlar
   - CustomPainter
   - Canvas
   - Path
   - Matrix4
   - Transform

4. Sayfa Geçişleri
   - PageRouteBuilder
   - CustomRoute
   - Shared Element Transitions
   - Navigation Animations

## 📚 Konu Anlatımı

### 1. Temel Animasyon Kavramları

```dart
class AnimasyonOrnegi extends StatefulWidget {
  @override
  _AnimasyonOrnegiState createState() => _AnimasyonOrnegiState();
}

class _AnimasyonOrnegiState extends State<AnimasyonOrnegi>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: FlutterLogo(size: 200),
        );
      },
    );
  }
}
```

### 2. Önceden Hazırlanmış Animasyonlar

```dart
class HazirAnimasyonlar extends StatefulWidget {
  @override
  _HazirAnimasyonlarState createState() => _HazirAnimasyonlarState();
}

class _HazirAnimasyonlarState extends State<HazirAnimasyonlar> {
  bool _genislet = false;
  double _opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(seconds: 1),
          width: _genislet ? 200 : 100,
          height: _genislet ? 200 : 100,
          color: _genislet ? Colors.blue : Colors.red,
          curve: Curves.easeInOut,
        ),
        AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: _opacity,
          child: FlutterLogo(size: 100),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _genislet = !_genislet;
              _opacity = _opacity == 1.0 ? 0.0 : 1.0;
            });
          },
          child: Text('Animasyonu Başlat'),
        ),
      ],
    );
  }
}
```

### 3. Özel Animasyonlar

```dart
class OzelAnimasyon extends StatefulWidget {
  @override
  _OzelAnimasyonState createState() => _OzelAnimasyonState();
}

class _OzelAnimasyonState extends State<OzelAnimasyon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DalgaPainter(_controller),
      child: Container(
        height: 200,
      ),
    );
  }
}

class DalgaPainter extends CustomPainter {
  final Animation<double> _animation;

  DalgaPainter(this._animation) : super(repaint: _animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final path = Path();
    final y = size.height * 0.5;
    final amplitude = 20.0;

    path.moveTo(0, y);

    for (double x = 0; x < size.width; x++) {
      path.lineTo(
        x,
        y + sin((x / size.width * 2 * pi) + _animation.value * 2 * pi) * amplitude,
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(DalgaPainter oldDelegate) => true;
}
```

### 4. Sayfa Geçişleri

```dart
class OzelSayfaGecisi extends PageRouteBuilder {
  final Widget page;

  OzelSayfaGecisi({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;
            var tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}

// Kullanımı
Navigator.push(
  context,
  OzelSayfaGecisi(page: YeniSayfa()),
);
```

## 💻 Örnek Uygulama: Animasyonlu Hava Durumu

Bu haftaki örnek uygulamamızda, öğrendiğimiz animasyon tekniklerini kullanarak interaktif bir hava durumu uygulaması geliştireceğiz. Detaylar için [tıklayınız](./ornek_uygulama/README.md).

## 🚀 Ana Proje: Alışkanlık Takip Uygulaması

Bu hafta ana projemizde şunları yapacağız:

1. Sayfa geçiş animasyonları
2. İlerleme animasyonları
3. Başarı animasyonları
4. Etkileşim animasyonları

Ana proje detayları için [tıklayınız](./ana_proje/README.md).

## 🎯 Alıştırmalar

1. Temel Animasyonlar:
   - [ ] Farklı Tween'ler deneyin
   - [ ] Farklı Curve'ler deneyin
   - [ ] Zincirleme animasyonlar oluşturun
   - [ ] Döngülü animasyonlar yapın

2. Özel Animasyonlar:
   - [ ] Özel şekiller çizin
   - [ ] Gradient animasyonları yapın
   - [ ] Parçacık efektleri ekleyin
   - [ ] Dalga efekti oluşturun

3. Sayfa Geçişleri:
   - [ ] Fade geçişi yapın
   - [ ] Scale geçişi yapın
   - [ ] Rotate geçişi yapın
   - [ ] Hero animasyonu ekleyin

## 🔍 Hata Ayıklama İpuçları

- Animasyon performansını kontrol edin
- Memory leak'leri önleyin
- dispose() metodunu unutmayın
- Gereksiz rebuild'lerden kaçının

## 📚 Faydalı Kaynaklar

- [Flutter Animation Documentation](https://flutter.dev/docs/development/ui/animations)
- [Flutter Animation Tutorial](https://flutter.dev/docs/development/ui/animations/tutorial)
- [Flutter Custom Painter](https://api.flutter.dev/flutter/rendering/CustomPainter-class.html)
- [Flutter Hero Animations](https://flutter.dev/docs/development/ui/animations/hero-animations) 