# Hafta 2: Form İşlemleri ve Alışkanlık Ekleme

Bu haftada HabitMaster uygulamamıza alışkanlık ekleme formunu ekleyeceğiz ve form işlemlerini öğreneceğiz.

## 🎯 Hedefler

- Form widget'larını öğrenme
- Form validasyonları
- Dialog ve BottomSheet kullanımı
- Alışkanlık ekleme ekranının tasarımı

## 📝 Konu Başlıkları

1. Form Widget'ları
   - TextFormField
   - DropdownButtonFormField
   - Form validasyonu
   - Form state yönetimi

2. Dialog ve BottomSheet
   - AlertDialog kullanımı
   - BottomSheet implementasyonu
   - Custom dialog tasarımı

3. Alışkanlık Ekleme Ekranı
   - Alışkanlık türü seçimi
   - Tekrar sıklığı ayarları
   - Hatırlatıcı zamanı seçimi

## 💻 Adım Adım Uygulama Geliştirme

### 1. Alışkanlık Modeli Oluşturma

```dart
class Habit {
  final String id;
  final String title;
  final String description;
  final HabitType type;
  final DateTime reminderTime;
  final int frequency;
  final bool isCompleted;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.reminderTime,
    required this.frequency,
    this.isCompleted = false,
  });
}

enum HabitType {
  daily,
  weekly,
  monthly
}
```

### 2. Form Tasarımı

```dart
class AddHabitForm extends StatefulWidget {
  @override
  _AddHabitFormState createState() => _AddHabitFormState();
}

class _AddHabitFormState extends State<AddHabitForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  HabitType _selectedType = HabitType.daily;
  DateTime _reminderTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Alışkanlık Adı',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen bir isim girin';
              }
              return null;
            },
          ),
          // ... Diğer form alanları
        ],
      ),
    );
  }
}
```

## 📝 Ödevler

1. Alışkanlık türüne göre özel form alanları ekleyin
2. Form verilerini yerel depolamada saklayın
3. Tarih ve saat seçimi için özel bir widget oluşturun

## 🔍 Sonraki Adımlar

Gelecek hafta:
- State management (Provider)
- Alışkanlık listesi görünümü
- Liste filtreleme ve sıralama 