# Hafta 8: UI/UX Geliştirmeleri ve Animasyonlar

Bu haftada HabitMaster uygulamamızın kullanıcı arayüzünü geliştirecek ve animasyonlar ekleyeceğiz.

## 🎯 Hedefler

- Custom widget'lar oluşturma
- Tema yönetimi
- Animasyonlar
- Responsive tasarım

## 📝 Konu Başlıkları

1. Custom Widget'lar
   - Reusable component'ler
   - Custom painter
   - Custom clipper
   - Gesture detector

2. Tema Yönetimi
   - ThemeData kullanımı
   - Dark/Light mode
   - Custom renkler
   - Text stilleri

3. Animasyonlar
   - Implicit animations
   - Explicit animations
   - Hero animations
   - Custom route transitions

## 💻 Adım Adım Uygulama Geliştirme

### 1. Custom Progress Indicator

```dart
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - (strokeWidth / 2);

    // Background circle
    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class HabitProgressIndicator extends StatelessWidget {
  final double progress;
  final double size;
  final Color color;

  const HabitProgressIndicator({
    Key? key,
    required this.progress,
    this.size = 100.0,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: CircularProgressPainter(
        progress: progress,
        color: color,
      ),
    );
  }
}
```

### 2. Tema Yönetimi

```dart
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Color(0xFF121212),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
    ),
  );
}
```

### 3. Animasyonlu Liste Öğesi

```dart
class AnimatedHabitItem extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;
  final Animation<double> animation;

  const AnimatedHabitItem({
    Key? key,
    required this.habit,
    required this.onTap,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: ListTile(
              title: Text(habit.title),
              subtitle: Text(habit.description),
              trailing: HabitProgressIndicator(
                progress: habit.progress,
                size: 40,
              ),
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }
}
```

## 📝 Ödevler

1. Custom bir chart widget'ı oluşturun
2. Tema değiştirme animasyonu ekleyin
3. Liste öğeleri için custom swipe actions ekleyin

## 🔍 Sonraki Adımlar

Gelecek hafta:
- Unit testler
- Widget testleri
- Integration testler 