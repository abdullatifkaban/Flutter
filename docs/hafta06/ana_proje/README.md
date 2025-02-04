# Hafta 6 - Ana Proje: Durum Yönetimi

Bu hafta, alışkanlık takip uygulamamıza durum yönetimi (state management) özelliklerini ekleyeceğiz.

## 🎯 Hedefler

1. Provider ile Alışkanlık Yönetimi
   - Alışkanlık listesi
   - Alışkanlık detayları
   - Alışkanlık durumu
   - İlerleme takibi

2. Riverpod ile Tema ve Ayarlar
   - Tema yönetimi
   - Dil ayarları
   - Bildirim tercihleri
   - Görünüm seçenekleri

3. Bloc ile İstatistikler
   - Günlük istatistikler
   - Haftalık grafikler
   - Aylık raporlar
   - Başarı analizleri

4. Mimari Yapı
   - Repository pattern
   - Service layer
   - Clean architecture
   - Dependency injection

## 📱 Ekran Tasarımları

[Ekran tasarımlarının görselleri]

## 💻 Uygulama Yapısı

```
lib/
├── models/
│   ├── habit.dart
│   ├── progress.dart
│   └── statistics.dart
├── providers/
│   ├── habit_provider.dart
│   └── settings_provider.dart
├── blocs/
│   ├── statistics_bloc.dart
│   ├── statistics_event.dart
│   └── statistics_state.dart
├── repositories/
│   ├── habit_repository.dart
│   └── settings_repository.dart
├── services/
│   ├── database_service.dart
│   └── notification_service.dart
└── screens/
    ├── habits_screen.dart
    ├── statistics_screen.dart
    └── settings_screen.dart
```

## 🚀 Başlangıç

1. Yeni bağımlılıkları ekleyin:

```yaml
dependencies:
  provider: ^6.1.1
  flutter_riverpod: ^2.4.9
  flutter_bloc: ^8.1.3
  get_it: ^7.6.4
  injectable: ^2.3.2
```

## 💻 Adım Adım Geliştirme

### 1. Provider ile Alışkanlık Yönetimi

`lib/providers/habit_provider.dart` dosyasını oluşturun:

```dart
class HabitProvider with ChangeNotifier {
  final HabitRepository _repository;
  List<Habit> _habits = [];
  bool _isLoading = false;

  HabitProvider(this._repository) {
    _loadHabits();
  }

  List<Habit> get habits => [..._habits];
  bool get isLoading => _isLoading;

  Future<void> _loadHabits() async {
    _isLoading = true;
    notifyListeners();

    try {
      _habits = await _repository.getHabits();
    } catch (e) {
      print('Hata: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addHabit(Habit habit) async {
    try {
      final newHabit = await _repository.createHabit(habit);
      _habits.add(newHabit);
      notifyListeners();
    } catch (e) {
      print('Hata: $e');
    }
  }

  Future<void> updateHabit(Habit habit) async {
    try {
      await _repository.updateHabit(habit);
      final index = _habits.indexWhere((h) => h.id == habit.id);
      if (index >= 0) {
        _habits[index] = habit;
        notifyListeners();
      }
    } catch (e) {
      print('Hata: $e');
    }
  }

  Future<void> deleteHabit(int id) async {
    try {
      await _repository.deleteHabit(id);
      _habits.removeWhere((h) => h.id == id);
      notifyListeners();
    } catch (e) {
      print('Hata: $e');
    }
  }

  Future<void> toggleHabitStatus(int id, DateTime date) async {
    try {
      final habit = _habits.firstWhere((h) => h.id == id);
      final progress = Progress(
        habitId: id,
        date: date,
        status: ProgressStatus.completed,
      );
      
      await _repository.saveProgress(progress);
      notifyListeners();
    } catch (e) {
      print('Hata: $e');
    }
  }

  List<Habit> getHabitsByCategory(String category) {
    return _habits.where((h) => h.category == category).toList();
  }

  List<Habit> searchHabits(String query) {
    return _habits.where((h) {
      return h.title.toLowerCase().contains(query.toLowerCase()) ||
          h.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
```

### 2. Riverpod ile Tema ve Ayarlar

`lib/providers/settings_provider.dart` dosyasını oluşturun:

```dart
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, Settings>((ref) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier() : super(Settings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    state = Settings(
      themeMode: ThemeMode.values[prefs.getInt('themeMode') ?? 0],
      language: prefs.getString('language') ?? 'tr',
      notificationsEnabled: prefs.getBool('notifications') ?? true,
      reminderTime: TimeOfDay(
        hour: prefs.getInt('reminderHour') ?? 20,
        minute: prefs.getInt('reminderMinute') ?? 0,
      ),
      weekStartDay: prefs.getInt('weekStart') ?? DateTime.monday,
      chartType: prefs.getString('chartType') ?? 'line',
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    state = state.copyWith(language: language);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', enabled);
    state = state.copyWith(notificationsEnabled: enabled);
  }

  Future<void> setReminderTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminderHour', time.hour);
    await prefs.setInt('reminderMinute', time.minute);
    state = state.copyWith(reminderTime: time);
  }

  Future<void> setWeekStartDay(int day) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('weekStart', day);
    state = state.copyWith(weekStartDay: day);
  }

  Future<void> setChartType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chartType', type);
    state = state.copyWith(chartType: type);
  }
}
```

### 3. Bloc ile İstatistikler

`lib/blocs/statistics_bloc.dart` dosyasını oluşturun:

```dart
// Events
abstract class StatisticsEvent {}

class LoadStatisticsEvent extends StatisticsEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String period;

  LoadStatisticsEvent({
    required this.startDate,
    required this.endDate,
    required this.period,
  });
}

// States
abstract class StatisticsState {}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final List<Statistics> statistics;
  final Map<String, double> completionRates;
  final int totalHabits;
  final int completedHabits;
  final int currentStreak;
  final int longestStreak;

  StatisticsLoaded({
    required this.statistics,
    required this.completionRates,
    required this.totalHabits,
    required this.completedHabits,
    required this.currentStreak,
    required this.longestStreak,
  });
}

class StatisticsError extends StatisticsState {
  final String message;

  StatisticsError(this.message);
}

// Bloc
class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final StatisticsRepository _repository;

  StatisticsBloc(this._repository) : super(StatisticsInitial()) {
    on<LoadStatisticsEvent>(_onLoadStatistics);
  }

  Future<void> _onLoadStatistics(
    LoadStatisticsEvent event,
    Emitter<StatisticsState> emit,
  ) async {
    emit(StatisticsLoading());

    try {
      final statistics = await _repository.getStatistics(
        event.startDate,
        event.endDate,
      );

      final completionRates = await _repository.getCompletionRates(
        event.startDate,
        event.endDate,
      );

      final totalHabits = await _repository.getTotalHabits();
      final completedHabits = await _repository.getCompletedHabits(
        event.startDate,
        event.endDate,
      );

      final currentStreak = await _repository.getCurrentStreak();
      final longestStreak = await _repository.getLongestStreak();

      emit(StatisticsLoaded(
        statistics: statistics,
        completionRates: completionRates,
        totalHabits: totalHabits,
        completedHabits: completedHabits,
        currentStreak: currentStreak,
        longestStreak: longestStreak,
      ));
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }
}
```

### 4. Dependency Injection

`lib/injection.dart` dosyasını oluşturun:

```dart
@InjectableInit()
void configureDependencies() => getIt.init();

@module
abstract class RegisterModule {
  @singleton
  DatabaseService get databaseService => DatabaseService();

  @singleton
  HabitRepository get habitRepository => HabitRepository(
        get<DatabaseService>(),
      );

  @singleton
  StatisticsRepository get statisticsRepository => StatisticsRepository(
        get<DatabaseService>(),
      );

  @singleton
  SettingsRepository get settingsRepository => SettingsRepository();
}
```

### 5. Ana Uygulama

`lib/main.dart` dosyasını düzenleyin:

```dart
void main() {
  configureDependencies();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HabitProvider(getIt<HabitRepository>()),
        ),
        Provider(
          create: (_) => StatisticsBloc(getIt<StatisticsRepository>()),
        ),
      ],
      child: ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'Alışkanlık Takibi',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: settings.themeMode,
      locale: Locale(settings.language),
      home: HomeScreen(),
    );
  }
}
```

## 🎯 Ödevler

1. Provider:
   - [ ] Alışkanlık filtreleme ekleyin
   - [ ] Sıralama seçenekleri ekleyin
   - [ ] Arama özelliği ekleyin
   - [ ] Çoklu seçim ekleyin

2. Riverpod:
   - [ ] Özel tema desteği ekleyin
   - [ ] Font ayarları ekleyin
   - [ ] Veri yedekleme ekleyin
   - [ ] Çoklu dil desteği ekleyin

3. Bloc:
   - [ ] PDF rapor oluşturma ekleyin
   - [ ] Grafik türleri ekleyin
   - [ ] Hedef analizi ekleyin
   - [ ] Başarı tahminleri ekleyin

## 🔍 Kontrol Listesi

Her değişiklik sonrası şunları kontrol edin:
- [ ] State değişiklikleri doğru çalışıyor mu?
- [ ] Widget'lar gereksiz rebuild olmuyor mu?
- [ ] Memory leak var mı?
- [ ] Error handling düzgün çalışıyor mu?

## 💡 İpuçları

1. State Management:
   - State'i immutable tutun
   - Gereksiz notifyListeners çağrılarından kaçının
   - State değişimlerini debug edin
   - Provider kombinasyonlarını optimize edin

2. Architecture:
   - Business logic'i UI'dan ayırın
   - Repository pattern kullanın
   - Dependency injection kullanın
   - SOLID prensiplerine uyun

3. Performance:
   - Selector kullanın
   - const constructor kullanın
   - Lazy loading yapın
   - Caching mekanizmaları ekleyin

## 📚 Faydalı Kaynaklar

- [Provider Documentation](https://pub.dev/packages/provider)
- [Riverpod Documentation](https://riverpod.dev)
- [Bloc Library](https://bloclibrary.dev)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) 