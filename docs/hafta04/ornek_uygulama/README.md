# Hafta 4 - Örnek Uygulama: Hatırlatıcı Uygulaması

Bu örnek uygulama, Flutter'da bildirim sistemini kullanarak basit bir hatırlatıcı uygulaması geliştirmeyi gösterecek.

## 🎯 Uygulama Özellikleri

- Zamanlı hatırlatıcılar
- Tekrarlanan hatırlatıcılar
- Bildirim grupları
- Bildirim eylemleri
- Bildirim geçmişi
- Bildirim ayarları

## 📱 Ekran Görüntüleri

[Ekran görüntüleri buraya eklenecek]

## 💻 Uygulama Yapısı

```
lib/
├── models/
│   ├── reminder.dart
│   └── notification_settings.dart
├── services/
│   ├── notification_service.dart
│   └── storage_service.dart
├── screens/
│   ├── home_screen.dart
│   ├── reminder_form_screen.dart
│   ├── notification_history_screen.dart
│   └── settings_screen.dart
├── widgets/
│   ├── reminder_list_item.dart
│   ├── notification_card.dart
│   └── time_picker_dialog.dart
└── main.dart
```

## 🚀 Başlangıç

1. Yeni bir Flutter projesi oluşturun:

```bash
flutter create reminder_app
cd reminder_app
```

2. Gerekli bağımlılıkları ekleyin:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_local_notifications: ^16.3.0
  timezone: ^0.9.2
  shared_preferences: ^2.2.2
  intl: ^0.18.1
  uuid: ^4.2.1
```

## 💻 Adım Adım Geliştirme

### 1. Bildirim Servisi

`lib/services/notification_service.dart` dosyasını oluşturun:

```dart
class NotificationService {
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  late FlutterLocalNotificationsPlugin _notifications;
  
  NotificationService._() {
    _notifications = FlutterLocalNotificationsPlugin();
    _init();
  }

  Future<void> _init() async {
    const androidSettings = AndroidInitializationSettings('app_icon');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Android için bildirim kanalı oluştur
    const channel = AndroidNotificationChannel(
      'reminders',
      'Hatırlatıcılar',
      description: 'Hatırlatıcı bildirimleri',
      importance: Importance.high,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _onNotificationTap(NotificationResponse response) async {
    // Bildirime tıklandığında
    if (response.payload != null) {
      // Hatırlatıcı detayına git
      // Navigator.pushNamed(context, '/reminder/${response.payload}');
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'reminders',
      'Hatırlatıcılar',
      channelDescription: 'Hatırlatıcı bildirimleri',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notifications.show(
      DateTime.now().millisecond,
      title,
      body,
      details,
      payload: payload,
    );
  }

  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'reminders',
      'Hatırlatıcılar',
      channelDescription: 'Hatırlatıcı bildirimleri',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notifications.zonedSchedule(
      DateTime.now().millisecond,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  Future<void> scheduleRepeatingNotification({
    required String title,
    required String body,
    required DateTime firstDate,
    required RepeatInterval interval,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'reminders',
      'Hatırlatıcılar',
      channelDescription: 'Hatırlatıcı bildirimleri',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notifications.periodicallyShow(
      DateTime.now().millisecond,
      title,
      body,
      interval,
      details,
      androidAllowWhileIdle: true,
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
```

### 2. Hatırlatıcı Modeli

`lib/models/reminder.dart` dosyasını oluşturun:

```dart
enum ReminderRepeatType {
  none,
  daily,
  weekly,
  monthly,
}

class Reminder {
  final String id;
  String title;
  String? description;
  DateTime dateTime;
  ReminderRepeatType repeatType;
  bool isActive;

  Reminder({
    required this.title,
    this.description,
    required this.dateTime,
    this.repeatType = ReminderRepeatType.none,
    this.isActive = true,
    String? id,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'repeatType': repeatType.index,
      'isActive': isActive,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime']),
      repeatType: ReminderRepeatType.values[json['repeatType']],
      isActive: json['isActive'],
    );
  }

  RepeatInterval get repeatInterval {
    switch (repeatType) {
      case ReminderRepeatType.daily:
        return RepeatInterval.daily;
      case ReminderRepeatType.weekly:
        return RepeatInterval.weekly;
      case ReminderRepeatType.monthly:
        return RepeatInterval.monthly;
      default:
        throw Exception('Geçersiz tekrar tipi');
    }
  }

  Future<void> schedule() async {
    if (!isActive) return;

    if (repeatType == ReminderRepeatType.none) {
      await NotificationService.instance.scheduleNotification(
        title: title,
        body: description ?? 'Hatırlatıcı zamanı geldi!',
        scheduledDate: dateTime,
        payload: id,
      );
    } else {
      await NotificationService.instance.scheduleRepeatingNotification(
        title: title,
        body: description ?? 'Hatırlatıcı zamanı geldi!',
        firstDate: dateTime,
        interval: repeatInterval,
        payload: id,
      );
    }
  }

  Future<void> cancel() async {
    await NotificationService.instance.cancelNotification(
      int.parse(id.split('-')[0]),
    );
  }
}
```

### 3. Ana Ekran

`lib/screens/home_screen.dart` dosyasını oluşturun:

```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hatırlatıcılar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showHistory(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(context),
          ),
        ],
      ),
      body: Consumer<ReminderProvider>(
        builder: (context, provider, child) {
          if (provider.reminders.isEmpty) {
            return const Center(
              child: Text('Henüz hatırlatıcı eklenmedi'),
            );
          }

          return ListView.builder(
            itemCount: provider.reminders.length,
            itemBuilder: (context, index) {
              final reminder = provider.reminders[index];
              return ReminderListItem(
                reminder: reminder,
                onTap: () => _showReminderDetails(context, reminder),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReminder(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationHistoryScreen(),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _showReminderDetails(BuildContext context, Reminder reminder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReminderFormScreen(reminder: reminder),
      ),
    );
  }

  void _showAddReminder(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReminderFormScreen(),
      ),
    );
  }
}
```

### 4. Hatırlatıcı Form Ekranı

`lib/screens/reminder_form_screen.dart` dosyasını oluşturun:

```dart
class ReminderFormScreen extends StatefulWidget {
  final Reminder? reminder;

  const ReminderFormScreen({
    super.key,
    this.reminder,
  });

  @override
  State<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends State<ReminderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late ReminderRepeatType _repeatType;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.reminder?.title);
    _descriptionController = TextEditingController(
      text: widget.reminder?.description,
    );
    _selectedDate = widget.reminder?.dateTime ?? DateTime.now();
    _selectedTime = TimeOfDay.fromDateTime(
      widget.reminder?.dateTime ?? DateTime.now(),
    );
    _repeatType = widget.reminder?.repeatType ?? ReminderRepeatType.none;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.reminder == null ? 'Yeni Hatırlatıcı' : 'Hatırlatıcıyı Düzenle',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Başlık',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Başlık boş olamaz';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Açıklama',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Tarih'),
              subtitle: Text(
                DateFormat('d MMMM y').format(_selectedDate),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDate,
            ),
            ListTile(
              title: const Text('Saat'),
              subtitle: Text(_selectedTime.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: _selectTime,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ReminderRepeatType>(
              value: _repeatType,
              decoration: const InputDecoration(
                labelText: 'Tekrar',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: ReminderRepeatType.none,
                  child: Text('Tekrar Yok'),
                ),
                DropdownMenuItem(
                  value: ReminderRepeatType.daily,
                  child: Text('Her Gün'),
                ),
                DropdownMenuItem(
                  value: ReminderRepeatType.weekly,
                  child: Text('Her Hafta'),
                ),
                DropdownMenuItem(
                  value: ReminderRepeatType.monthly,
                  child: Text('Her Ay'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _repeatType = value!;
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (widget.reminder != null)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _deleteReminder,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Sil'),
                  ),
                ),
              if (widget.reminder != null)
                const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveReminder,
                  child: const Text('Kaydet'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveReminder() async {
    if (_formKey.currentState!.validate()) {
      final dateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final reminder = Reminder(
        id: widget.reminder?.id,
        title: _titleController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        dateTime: dateTime,
        repeatType: _repeatType,
      );

      if (widget.reminder == null) {
        await context.read<ReminderProvider>().addReminder(reminder);
      } else {
        await context.read<ReminderProvider>().updateReminder(reminder);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _deleteReminder() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hatırlatıcıyı Sil'),
        content: const Text(
          'Bu hatırlatıcıyı silmek istediğinize emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true && widget.reminder != null) {
      await context.read<ReminderProvider>().deleteReminder(widget.reminder!.id);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
```

## 🎯 Öğrenilen Kavramlar

1. Bildirim Sistemi:
   - Yerel bildirimler
   - Bildirim kanalları
   - Bildirim izinleri
   - Bildirim eylemleri

2. Zamanlama:
   - DateTime işlemleri
   - TimeOfDay kullanımı
   - Zaman dilimi yönetimi
   - Tekrarlanan görevler

3. Veri Yönetimi:
   - SharedPreferences
   - JSON dönüşümleri
   - CRUD operasyonları
   - Veri kalıcılığı

## ✅ Alıştırma Önerileri

1. Yeni Özellikler:
   - [ ] Bildirim sesi seçimi
   - [ ] Özel tekrar aralıkları
   - [ ] Kategori sistemi
   - [ ] Öncelik seviyeleri

2. UI İyileştirmeleri:
   - [ ] Takvim görünümü
   - [ ] Sürükle-bırak sıralama
   - [ ] Tema desteği
   - [ ] Animasyonlar

## 🔍 Önemli Noktalar

1. Bildirimler:
   - İzinleri kontrol edin
   - Kanalları yapılandırın
   - Arka plan işlemlerini test edin
   - Bildirim limitlerini gözetin

2. Zamanlama:
   - Zaman dilimlerini doğru yönetin
   - Geçmiş tarihleri engelleyin
   - Tekrar aralıklarını optimize edin
   - Sistem saatini kontrol edin

3. Kullanıcı Deneyimi:
   - Kolay tarih/saat seçimi
   - Anlaşılır hata mesajları
   - Bildirim önizlemeleri
   - Hızlı erişim seçenekleri

## 📚 Faydalı Kaynaklar

- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
- [DateTime Guide](https://api.flutter.dev/flutter/dart-core/DateTime-class.html)
- [TimeOfDay Class](https://api.flutter.dev/flutter/material/TimeOfDay-class.html)
- [SharedPreferences Guide](https://pub.dev/packages/shared_preferences) 