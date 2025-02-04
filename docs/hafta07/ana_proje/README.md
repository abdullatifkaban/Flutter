# Hafta 7 - Ana Proje: Animasyonlar ve Geçişler

Bu hafta, alışkanlık takip uygulamamıza çeşitli animasyonlar ve geçişler ekleyeceğiz.

## 🎯 Hedefler

1. Sayfa Geçiş Animasyonları
   - Özel sayfa geçişleri
   - Hero animasyonları
   - Paylaşılan element geçişleri
   - Kart animasyonları

2. İlerleme Animasyonları
   - Dairesel ilerleme göstergesi
   - Çizgisel ilerleme göstergesi
   - Skor animasyonları
   - İstatistik grafikleri

3. Başarı Animasyonları
   - Konfeti efekti
   - Yıldız animasyonu
   - Başarı rozeti animasyonu
   - Seviye atlama efekti

4. Etkileşim Animasyonları
   - Liste geçişleri
   - Kart etkileşimleri
   - Buton animasyonları
   - Giriş/çıkış animasyonları

## 📱 Ekran Tasarımları

[Ekran tasarımlarının görselleri]

## 💻 Uygulama Yapısı

```
lib/
├── animations/
│   ├── page_transitions.dart
│   ├── progress_animations.dart
│   ├── achievement_animations.dart
│   └── interaction_animations.dart
├── screens/
│   ├── home_screen.dart
│   ├── habit_detail_screen.dart
│   ├── statistics_screen.dart
│   └── achievements_screen.dart
├── widgets/
│   ├── animated_habit_card.dart
│   ├── progress_indicator.dart
│   ├── achievement_badge.dart
│   └── animated_list_item.dart
└── main.dart
```

## 🚀 Başlangıç

1. Yeni bağımlılıkları ekleyin:

```yaml
dependencies:
  flutter:
    sdk: flutter
  animations: ^2.0.8
  rive: ^0.12.3
  lottie: ^2.7.0
  confetti: ^0.7.0
```

## 💻 Adım Adım Geliştirme

### 1. Sayfa Geçiş Animasyonları

`lib/animations/page_transitions.dart`:

```dart
class HabitPageTransition extends PageRouteBuilder {
  final Widget page;

  HabitPageTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.easeInOutCubic;
            var tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 500),
          reverseTransitionDuration: Duration(milliseconds: 500),
        );
}

// Hero widget kullanımı
class HabitHero extends StatelessWidget {
  final String tag;
  final Widget child;

  HabitHero({
    required this.tag,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Material(
        color: Colors.transparent,
        child: child,
      ),
    );
  }
}
```

### 2. İlerleme Animasyonları

`lib/animations/progress_animations.dart`:

```dart
class AnimatedProgressIndicator extends StatefulWidget {
  final double progress;
  final Color color;
  final double size;

  AnimatedProgressIndicator({
    required this.progress,
    required this.color,
    this.size = 100,
  });

  @override
  _AnimatedProgressIndicatorState createState() =>
      _AnimatedProgressIndicatorState();
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.progress,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
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
          size: Size(widget.size, widget.size),
          painter: ProgressPainter(
            progress: _animation.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  ProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.2;

    // Arka plan çemberi
    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    // İlerleme çemberi
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );

    // İlerleme yüzdesi
    final textSpan = TextSpan(
      text: '${(progress * 100).toInt()}%',
      style: TextStyle(
        color: color,
        fontSize: radius * 0.4,
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

  @override
  bool shouldRepaint(ProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
```

### 3. Başarı Animasyonları

`lib/animations/achievement_animations.dart`:

```dart
class AchievementAnimation extends StatefulWidget {
  final String title;
  final String description;
  final String badgeAsset;

  AchievementAnimation({
    required this.title,
    required this.description,
    required this.badgeAsset,
  });

  @override
  _AchievementAnimationState createState() => _AchievementAnimationState();
}

class _AchievementAnimationState extends State<AchievementAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5),
      ),
    );

    _confettiController = ConfettiController(
      duration: Duration(seconds: 2),
    );

    _controller.forward();
    _confettiController.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    padding: EdgeInsets.all(20),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          widget.badgeAsset,
                          width: 100,
                          height: 100,
                        ),
                        SizedBox(height: 20),
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi / 2,
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 50,
            gravity: 0.1,
          ),
        ),
      ],
    );
  }
}
```

### 4. Etkileşim Animasyonları

`lib/animations/interaction_animations.dart`:

```dart
class AnimatedHabitCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  AnimatedHabitCard({
    required this.child,
    required this.onTap,
  });

  @override
  _AnimatedHabitCardState createState() => _AnimatedHabitCardState();
}

class _AnimatedHabitCardState extends State<AnimatedHabitCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
```

## 🎯 Ödevler

1. Sayfa Geçişleri:
   - [ ] Farklı geçiş efektleri ekleyin
   - [ ] Paylaşılan element geçişleri ekleyin
   - [ ] Özel route animasyonları ekleyin
   - [ ] Modal geçişleri ekleyin

2. İlerleme Göstergeleri:
   - [ ] Haftalık ilerleme grafiği ekleyin
   - [ ] Aylık başarı grafiği ekleyin
   - [ ] Streak göstergesi ekleyin
   - [ ] Seviye göstergesi ekleyin

3. Başarı Efektleri:
   - [ ] Yeni rozetler ekleyin
   - [ ] Seviye atlama efektleri ekleyin
   - [ ] Özel başarı animasyonları ekleyin
   - [ ] Ödül animasyonları ekleyin

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