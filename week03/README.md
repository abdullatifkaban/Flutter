# Hafta 3: State Management ve Liste İşlemleri

Bu haftada HabitMaster uygulamamıza state management ekleyeceğiz ve alışkanlık listesi görünümünü oluşturacağız.

## 🎯 Hedefler

- Provider pattern'i öğrenme
- Alışkanlık listesi görünümü
- Liste filtreleme ve sıralama
- Alışkanlık detay sayfası

## 📝 Konu Başlıkları

1. State Management
   - Provider pattern nedir?
   - ChangeNotifier kullanımı
   - Consumer widget'ı
   - State güncelleme

2. Liste İşlemleri
   - ListView.builder kullanımı
   - Custom list item tasarımı
   - Pull to refresh
   - Swipe to delete/edit

3. Filtreleme ve Sıralama
   - Alışkanlık türüne göre filtreleme
   - Tarihe göre sıralama
   - Arama fonksiyonu

## 💻 Adım Adım Uygulama Geliştirme

### 1. HabitProvider Oluşturma

```dart
class HabitProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  HabitType _selectedFilter = HabitType.all;

  List<Habit> get habits {
    if (_selectedFilter == HabitType.all) {
      return _habits;
    }
    return _habits.where((habit) => habit.type == _selectedFilter).toList();
  }

  void addHabit(Habit habit) {
    _habits.add(habit);
    notifyListeners();
  }

  void removeHabit(String id) {
    _habits.removeWhere((habit) => habit.id == id);
    notifyListeners();
  }

  void setFilter(HabitType type) {
    _selectedFilter = type;
    notifyListeners();
  }
}
```

### 2. Liste Görünümü

```dart
class HabitListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        return ListView.builder(
          itemCount: habitProvider.habits.length,
          itemBuilder: (context, index) {
            final habit = habitProvider.habits[index];
            return HabitListItem(habit: habit);
          },
        );
      },
    );
  }
}

class HabitListItem extends StatelessWidget {
  final Habit habit;

  const HabitListItem({required this.habit});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(habit.id),
      onDismissed: (direction) {
        context.read<HabitProvider>().removeHabit(habit.id);
      },
      child: ListTile(
        title: Text(habit.title),
        subtitle: Text(habit.description),
        trailing: Icon(
          habit.isCompleted ? Icons.check_circle : Icons.circle_outlined,
        ),
        onTap: () {
          // Detay sayfasına yönlendirme
        },
      ),
    );
  }
}
```

## 📝 Ödevler

1. Alışkanlıkları kategorilere göre gruplandırın
2. İlerleme durumuna göre renklendirme yapın
3. Detay sayfasında istatistik gösterimi ekleyin

## 🔍 Sonraki Adımlar

Gelecek hafta:
- Yerel veritabanı (SQLite)
- CRUD işlemleri
- Veri persistance 