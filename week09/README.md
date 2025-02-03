# Hafta 9: Test ve Kalite Güvencesi

Bu haftada HabitMaster uygulamamız için test senaryoları yazacak ve kod kalitesini artıracağız.

## 🎯 Hedefler

- Unit testler yazma
- Widget testleri yazma
- Integration testler yazma
- Test coverage analizi

## 📝 Konu Başlıkları

1. Unit Testing
   - Test paketleri
   - Mock objects
   - Test grupları
   - Test coverage

2. Widget Testing
   - Widget test yazımı
   - Pump ve pumpAndSettle
   - Finder kullanımı
   - Widget test senaryoları

3. Integration Testing
   - Integration test yazımı
   - Driver kullanımı
   - Senaryo testleri
   - Performance testleri

## 💻 Adım Adım Uygulama Geliştirme

### 1. Unit Test Örnekleri

```dart
void main() {
  group('HabitRepository Tests', () {
    late HabitRepository repository;
    late MockDatabaseHelper mockDb;

    setUp(() {
      mockDb = MockDatabaseHelper();
      repository = HabitRepository(mockDb);
    });

    test('getAllHabits returns list of habits', () async {
      // Arrange
      final mockHabits = [
        Habit(
          id: '1',
          title: 'Test Habit',
          description: 'Test Description',
          type: HabitType.daily,
          reminderTime: DateTime.now(),
          frequency: 1,
        ),
      ];

      when(mockDb.query('habits')).thenAnswer((_) async => [
        {
          'id': '1',
          'title': 'Test Habit',
          'description': 'Test Description',
          'type': 'daily',
          'reminderTime': DateTime.now().toIso8601String(),
          'frequency': 1,
          'isCompleted': 0,
        }
      ]);

      // Act
      final habits = await repository.getAllHabits();

      // Assert
      expect(habits.length, equals(1));
      expect(habits.first.title, equals('Test Habit'));
      verify(mockDb.query('habits')).called(1);
    });

    test('insertHabit adds habit to database', () async {
      // Arrange
      final habit = Habit(
        id: '1',
        title: 'Test Habit',
        description: 'Test Description',
        type: HabitType.daily,
        reminderTime: DateTime.now(),
        frequency: 1,
      );

      when(mockDb.insert('habits', any))
          .thenAnswer((_) async => 1);

      // Act
      await repository.insertHabit(habit);

      // Assert
      verify(mockDb.insert('habits', any)).called(1);
    });
  });
}
```

### 2. Widget Test Örnekleri

```dart
void main() {
  group('HabitListView Widget Tests', () {
    testWidgets('renders list of habits', (WidgetTester tester) async {
      // Arrange
      final habits = [
        Habit(
          id: '1',
          title: 'Test Habit 1',
          description: 'Description 1',
          type: HabitType.daily,
          reminderTime: DateTime.now(),
          frequency: 1,
        ),
        Habit(
          id: '2',
          title: 'Test Habit 2',
          description: 'Description 2',
          type: HabitType.weekly,
          reminderTime: DateTime.now(),
          frequency: 1,
        ),
      ];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => HabitProvider(MockRepository())..setHabits(habits),
            child: const HabitListView(),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Habit 1'), findsOneWidget);
      expect(find.text('Test Habit 2'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(2));
    });

    testWidgets('shows empty state when no habits',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => HabitProvider(MockRepository()),
            child: const HabitListView(),
          ),
        ),
      );

      // Assert
      expect(find.text('Henüz alışkanlık eklenmemiş'), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
    });
  });
}
```

### 3. Integration Test Örnekleri

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
        (tester) async {
      // Build app
      app.main();
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.text('Henüz alışkanlık eklenmemiş'), findsOneWidget);

      // Tap FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify form is shown
      expect(find.text('Yeni Alışkanlık'), findsOneWidget);

      // Fill form
      await tester.enterText(
        find.byType(TextFormField).first,
        'Test Alışkanlık',
      );
      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();

      // Verify habit is added
      expect(find.text('Test Alışkanlık'), findsOneWidget);
    });
  });
}
```

## 📝 Ödevler

1. Repository sınıfı için kapsamlı unit testler yazın
2. Custom widget'lar için widget testleri yazın
3. Temel kullanıcı akışları için integration testler yazın

## 🔍 Sonraki Adımlar

Gelecek hafta:
- CI/CD pipeline kurulumu
- GitHub Actions
- Automated testing 