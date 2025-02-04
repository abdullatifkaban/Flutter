# Hafta 7 - Örnek Uygulama: Animasyonlu Hava Durumu

Bu örnek uygulama, Flutter'da animasyonlar ve geçişler konusunu pratik olarak göstermek için tasarlanmış interaktif bir hava durumu uygulamasıdır.

## 🎯 Uygulama Özellikleri

1. Hava Durumu Animasyonları:
   - Güneş animasyonu
   - Yağmur animasyonu
   - Kar animasyonu
   - Bulut animasyonu
   - Rüzgar animasyonu

2. Geçiş Efektleri:
   - Sayfa geçişleri
   - Kart geçişleri
   - Liste animasyonları
   - Hero animasyonları

3. İnteraktif Animasyonlar:
   - Sıcaklık değişimi
   - Nem oranı göstergesi
   - Rüzgar hızı göstergesi
   - Günlük tahmin grafikleri

## 📱 Ekran Tasarımları

[Ekran tasarımlarının görselleri]

## 💻 Uygulama Yapısı

```
lib/
├── animations/
│   ├── weather_animations.dart
│   ├── transition_animations.dart
│   └── interactive_animations.dart
├── models/
│   ├── weather.dart
│   └── forecast.dart
├── screens/
│   ├── home_screen.dart
│   ├── details_screen.dart
│   └── forecast_screen.dart
├── widgets/
│   ├── weather_card.dart
│   ├── temperature_gauge.dart
│   └── forecast_chart.dart
└── main.dart
```

## 🚀 Başlangıç

1. Yeni bir Flutter projesi oluşturun:

```bash
flutter create weather_app
cd weather_app
```

2. Gerekli bağımlılıkları ekleyin:

```yaml
dependencies:
  flutter:
    sdk: flutter
  vector_math: ^2.1.4
  simple_animations: ^5.0.2
  supercharged: ^2.1.1
  fl_chart: ^0.65.0
```

## 💻 Adım Adım Geliştirme

### 1. Hava Durumu Animasyonları

`lib/animations/weather_animations.dart`:

```dart
class SunAnimation extends StatefulWidget {
  @override
  _SunAnimationState createState() => _SunAnimationState();
}

class _SunAnimationState extends State<SunAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotateAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _rotateAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotateAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow,
                boxShadow: [
                  BoxShadow(
                    color: Colors.yellow.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
```

### 2. Geçiş Animasyonları

`lib/animations/transition_animations.dart`:

```dart
class WeatherCardTransition extends StatelessWidget {
  final Widget child;
  final bool isExpanded;

  WeatherCardTransition({
    required this.child,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: isExpanded ? double.infinity : 200,
      height: isExpanded ? 300 : 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: child,
      ),
    );
  }
}
```

### 3. İnteraktif Animasyonlar

`lib/animations/interactive_animations.dart`:

```dart
class TemperatureGauge extends StatefulWidget {
  final double temperature;

  TemperatureGauge({required this.temperature});

  @override
  _TemperatureGaugeState createState() => _TemperatureGaugeState();
}

class _TemperatureGaugeState extends State<TemperatureGauge>
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

    _animation = Tween<double>(
      begin: 0,
      end: widget.temperature,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(TemperatureGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.temperature != widget.temperature) {
      _animation = Tween<double>(
        begin: oldWidget.temperature,
        end: widget.temperature,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.elasticOut,
        ),
      );

      _controller.forward(from: 0);
    }
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
        return CustomPaint(
          size: Size(200, 200),
          painter: TemperatureGaugePainter(_animation.value),
        );
      },
    );
  }
}

class TemperatureGaugePainter extends CustomPainter {
  final double temperature;

  TemperatureGaugePainter(this.temperature);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    // Arka plan çemberi
    final backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi,
      pi,
      false,
      backgroundPaint,
    );

    // Sıcaklık göstergesi
    final tempPaint = Paint()
      ..color = _getTemperatureColor(temperature)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    final progress = (temperature + 20) / 60; // -20°C ile 40°C arası
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi,
      pi * progress,
      false,
      tempPaint,
    );

    // Sıcaklık değeri
    final textSpan = TextSpan(
      text: '${temperature.toStringAsFixed(1)}°C',
      style: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  Color _getTemperatureColor(double temp) {
    if (temp < 0) return Colors.blue;
    if (temp < 15) return Colors.green;
    if (temp < 25) return Colors.orange;
    return Colors.red;
  }

  @override
  bool shouldRepaint(TemperatureGaugePainter oldDelegate) {
    return oldDelegate.temperature != temperature;
  }
}
```

### 4. Ana Uygulama

`lib/main.dart`:

```dart
void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hava Durumu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isExpanded = false;
  double _temperature = 25.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SunAnimation(),
            SizedBox(height: 20),
            WeatherCardTransition(
              isExpanded: _isExpanded,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'İstanbul',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      TemperatureGauge(temperature: _temperature),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _temperature = _temperature + 5 > 40 ? -20 : _temperature + 5;
          });
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
```

## 🎯 Ödevler

1. Animasyonlar:
   - [ ] Gece/gündüz geçiş animasyonu ekleyin
   - [ ] Farklı hava olayları için animasyonlar ekleyin
   - [ ] Parçacık sistemleri ekleyin
   - [ ] Özel geçiş efektleri ekleyin

2. İnteraktif Özellikler:
   - [ ] Sürükle-bırak etkileşimleri ekleyin
   - [ ] Yakınlaştırma/uzaklaştırma ekleyin
   - [ ] Kaydırma efektleri ekleyin
   - [ ] Dokunma geri bildirimleri ekleyin

3. Performans:
   - [ ] Animasyon performansını optimize edin
   - [ ] Bellek kullanımını optimize edin
   - [ ] Frame düşmelerini önleyin
   - [ ] Repaint alanlarını optimize edin

## 🔍 Kontrol Listesi

Her değişiklik sonrası şunları kontrol edin:
- [ ] Animasyonlar akıcı çalışıyor mu?
- [ ] Geçişler düzgün çalışıyor mu?
- [ ] Memory leak var mı?
- [ ] Performans sorunları var mı?

## 💡 İpuçları

1. Animasyonlar:
   - Karmaşık animasyonları basitleştirin
   - Curve'leri doğru seçin
   - Süreleri kullanıcı deneyimine göre ayarlayın
   - Animasyonları senkronize edin

2. Performans:
   - RepaintBoundary kullanın
   - Gereksiz build'leri önleyin
   - Ağır işlemleri arka planda yapın
   - Animasyon önbelleğini kullanın

3. Kullanıcı Deneyimi:
   - Animasyonları abartmayın
   - Geri bildirim verin
   - Erişilebilirliği unutmayın
   - Duyarlı tasarım yapın

## 📚 Faydalı Kaynaklar

- [Flutter Animation Cookbook](https://flutter.dev/docs/cookbook/animation)
- [Flutter Custom Painter](https://api.flutter.dev/flutter/rendering/CustomPainter-class.html)
- [Flutter Animation Cheat Sheet](https://flutter.dev/docs/development/ui/animations/cheat-sheet)
- [Flutter Performance Best Practices](https://flutter.dev/docs/perf/rendering/best-practices) 