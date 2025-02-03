# Hafta 4 - Ana Proje: Bildirim Sistemi

Bu hafta, alışkanlık takip uygulamamıza bildirim sistemini entegre edeceğiz.

## 🎯 Hedefler

1. Alışkanlık Hatırlatıcıları
   - Günlük hatırlatmalar
   - Özelleştirilebilir bildirim saatleri
   - Tekrarlanan bildirimler
   - Bildirim öncelikleri

2. Günlük Özet Bildirimleri
   - Günlük başarı durumu
   - Tamamlanan alışkanlıklar
   - Eksik alışkanlıklar
   - Motivasyon mesajları

3. Başarı Bildirimleri
   - Seri devam bildirimleri
   - Hedef tamamlama bildirimleri
   - Özel başarı bildirimleri
   - Rozet kazanma bildirimleri

4. Bildirim Ayarları
   - Bildirim türü seçimi
   - Bildirim zamanlaması
   - Bildirim sesi ve titreşimi
   - Rahatsız etme modu

## 📱 Ekran Tasarımları

[Ekran tasarımlarının görselleri]

## 💻 Uygulama Yapısı

```
lib/
├── services/
│   ├── notification_service.dart
│   └── notification_scheduler.dart
├── models/
│   ├── notification_settings.dart
│   └── notification_history.dart
├── screens/
│   ├── notification_settings_screen.dart
│   └── notification_history_screen.dart
└── widgets/
    ├── notification_settings_card.dart
    └── notification_history_item.dart
```

## 🚀 Başlangıç

1. Yeni bağımlılıkları ekleyin:

```yaml
dependencies:
  flutter_local_notifications: ^16.3.0
  timezone: ^0.9.2
  firebase_messaging: ^14.7.10
  awesome_notifications: ^0.9.2
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
    // Android için bildirim kanalları
    const habitChannel = AndroidNotificationChannel(
      'habits',
      'Alışkanlık Hatırlatıcıları',
      description: 'Günlük alışkanlık hatırlatmaları',
      importance: Importance.high,
    );

    const summaryChannel = AndroidNotificationChannel(
      'summaries',
      'Günlük Özetler',
      description: 'Günlük başarı durumu ve özetler',
      importance: Importance.high,
    );

    const achievementChannel = AndroidNotificationChannel(
      'achievements',
      'Başarılar',
      description: 'Başarı ve rozet bildirimleri',
      importance: Importance.high,
    );

    // Kanalları oluştur
    final platform = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
            
    await platform?.createNotificationChannels([
      habitChannel,
      summaryChannel,
      achievementChannel,
    ]);
  }

  Future<void> scheduleHabitReminder({
    required String habitId,
    required String title,
    required String body,
    required DateTime time,
    required List<int> days,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'habits',
      'Alışkanlık Hatırlatıcıları',
      channelDescription: 'Günlük alışkanlık hatırlatmaları',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(body),
      actions: [
        const AndroidNotificationAction(
          'complete',
          'Tamamla',
          showsUserInterface: true,
        ),
        const AndroidNotificationAction(
          'skip',
          'Atla',
          showsUserInterface: true,
        ),
      ],
    );

    final details = NotificationDetails(android: androidDetails);

    // Her gün için tekrarlanan bildirim planla
    for (final day in days) {
      final scheduledDate = _nextInstanceOfDay(time, day);
      await _notifications.zonedSchedule(
        int.parse('${habitId.hashCode}$day'),
        title,
        body,
        scheduledDate,
        details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: jsonEncode({
          'type': 'habit',
          'habitId': habitId,
          'action': 'reminder',
        }),
      );
    }
  }

  Future<void> showDailySummary({
    required int completed,
    required int total,
    required List<String> completedHabits,
    required List<String> missedHabits,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'summaries',
      'Günlük Özetler',
      channelDescription: 'Günlük başarı durumu ve özetler',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(
        'Bugün $completed/$total alışkanlığı tamamladınız!\n\n'
        'Tamamlananlar:\n${completedHabits.join('\n')}\n\n'
        'Eksikler:\n${missedHabits.join('\n')}',
      ),
    );

    final details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      DateTime.now().day,
      'Günlük Özet',
      'Bugünkü başarı durumunuz',
      details,
      payload: jsonEncode({
        'type': 'summary',
        'date': DateTime.now().toIso8601String(),
      }),
    );
  }

  Future<void> showAchievement({
    required String title,
    required String description,
    String? imageUrl,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'achievements',
      'Başarılar',
      channelDescription: 'Başarı ve rozet bildirimleri',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigPictureStyleInformation(
        FilePathAndroidBitmap(imageUrl ?? 'assets/achievement.png'),
        largeIcon: FilePathAndroidBitmap(imageUrl ?? 'assets/achievement.png'),
      ),
    );

    final details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      DateTime.now().millisecond,
      'Yeni Başarı: $title',
      description,
      details,
      payload: jsonEncode({
        'type': 'achievement',
        'title': title,
      }),
    );
  }

  tz.TZDateTime _nextInstanceOfDay(DateTime time, int day) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    while (scheduledDate.weekday != day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    return scheduledDate;
  }
}
```

### 2. Bildirim Ayarları Modeli

`lib/models/notification_settings.dart` dosyasını oluşturun:

```dart
class NotificationSettings {
  final bool habitReminders;
  final bool dailySummary;
  final bool achievements;
  final TimeOfDay summaryTime;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool doNotDisturb;
  final TimeOfDay doNotDisturbStart;
  final TimeOfDay doNotDisturbEnd;

  NotificationSettings({
    this.habitReminders = true,
    this.dailySummary = true,
    this.achievements = true,
    this.summaryTime = const TimeOfDay(hour: 21, minute: 0),
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.doNotDisturb = false,
    this.doNotDisturbStart = const TimeOfDay(hour: 23, minute: 0),
    this.doNotDisturbEnd = const TimeOfDay(hour: 7, minute: 0),
  });

  NotificationSettings copyWith({
    bool? habitReminders,
    bool? dailySummary,
    bool? achievements,
    TimeOfDay? summaryTime,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? doNotDisturb,
    TimeOfDay? doNotDisturbStart,
    TimeOfDay? doNotDisturbEnd,
  }) {
    return NotificationSettings(
      habitReminders: habitReminders ?? this.habitReminders,
      dailySummary: dailySummary ?? this.dailySummary,
      achievements: achievements ?? this.achievements,
      summaryTime: summaryTime ?? this.summaryTime,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      doNotDisturb: doNotDisturb ?? this.doNotDisturb,
      doNotDisturbStart: doNotDisturbStart ?? this.doNotDisturbStart,
      doNotDisturbEnd: doNotDisturbEnd ?? this.doNotDisturbEnd,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'habitReminders': habitReminders,
      'dailySummary': dailySummary,
      'achievements': achievements,
      'summaryTime': {
        'hour': summaryTime.hour,
        'minute': summaryTime.minute,
      },
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'doNotDisturb': doNotDisturb,
      'doNotDisturbStart': {
        'hour': doNotDisturbStart.hour,
        'minute': doNotDisturbStart.minute,
      },
      'doNotDisturbEnd': {
        'hour': doNotDisturbEnd.hour,
        'minute': doNotDisturbEnd.minute,
      },
    };
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      habitReminders: json['habitReminders'] ?? true,
      dailySummary: json['dailySummary'] ?? true,
      achievements: json['achievements'] ?? true,
      summaryTime: TimeOfDay(
        hour: json['summaryTime']['hour'] ?? 21,
        minute: json['summaryTime']['minute'] ?? 0,
      ),
      soundEnabled: json['soundEnabled'] ?? true,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
      doNotDisturb: json['doNotDisturb'] ?? false,
      doNotDisturbStart: TimeOfDay(
        hour: json['doNotDisturbStart']['hour'] ?? 23,
        minute: json['doNotDisturbStart']['minute'] ?? 0,
      ),
      doNotDisturbEnd: TimeOfDay(
        hour: json['doNotDisturbEnd']['hour'] ?? 7,
        minute: json['doNotDisturbEnd']['minute'] ?? 0,
      ),
    );
  }

  bool isInDoNotDisturbPeriod(DateTime dateTime) {
    if (!doNotDisturb) return false;

    final time = TimeOfDay.fromDateTime(dateTime);
    final start = doNotDisturbStart;
    final end = doNotDisturbEnd;

    if (start.hour > end.hour) {
      return time.hour >= start.hour || time.hour < end.hour;
    } else {
      return time.hour >= start.hour && time.hour < end.hour;
    }
  }
}
```

### 3. Bildirim Ayarları Ekranı

`lib/screens/notification_settings_screen.dart` dosyasını oluşturun:

```dart
class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirim Ayarları'),
      ),
      body: Consumer<NotificationSettingsProvider>(
        builder: (context, provider, child) {
          final settings = provider.settings;
          
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSection(
                title: 'Bildirim Türleri',
                children: [
                  SwitchListTile(
                    title: const Text('Alışkanlık Hatırlatıcıları'),
                    subtitle: const Text(
                      'Her alışkanlık için belirlenen saatlerde hatırlatma',
                    ),
                    value: settings.habitReminders,
                    onChanged: (value) {
                      provider.updateSettings(
                        settings.copyWith(habitReminders: value),
                      );
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Günlük Özet'),
                    subtitle: const Text(
                      'Günlük başarı durumu ve eksik alışkanlıklar',
                    ),
                    value: settings.dailySummary,
                    onChanged: (value) {
                      provider.updateSettings(
                        settings.copyWith(dailySummary: value),
                      );
                    },
                  ),
                  if (settings.dailySummary)
                    ListTile(
                      title: const Text('Özet Saati'),
                      subtitle: Text(settings.summaryTime.format(context)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _selectTime(
                        context,
                        settings.summaryTime,
                        (time) {
                          provider.updateSettings(
                            settings.copyWith(summaryTime: time),
                          );
                        },
                      ),
                    ),
                  SwitchListTile(
                    title: const Text('Başarı Bildirimleri'),
                    subtitle: const Text(
                      'Hedef tamamlama ve rozet kazanma bildirimleri',
                    ),
                    value: settings.achievements,
                    onChanged: (value) {
                      provider.updateSettings(
                        settings.copyWith(achievements: value),
                      );
                    },
                  ),
                ],
              ),
              const Divider(),
              _buildSection(
                title: 'Bildirim Tercihleri',
                children: [
                  SwitchListTile(
                    title: const Text('Ses'),
                    subtitle: const Text('Bildirim sesi çal'),
                    value: settings.soundEnabled,
                    onChanged: (value) {
                      provider.updateSettings(
                        settings.copyWith(soundEnabled: value),
                      );
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Titreşim'),
                    subtitle: const Text('Bildirimde titreşim kullan'),
                    value: settings.vibrationEnabled,
                    onChanged: (value) {
                      provider.updateSettings(
                        settings.copyWith(vibrationEnabled: value),
                      );
                    },
                  ),
                ],
              ),
              const Divider(),
              _buildSection(
                title: 'Rahatsız Etme Modu',
                children: [
                  SwitchListTile(
                    title: const Text('Rahatsız Etme'),
                    subtitle: const Text(
                      'Belirli saatlerde bildirimleri sessize al',
                    ),
                    value: settings.doNotDisturb,
                    onChanged: (value) {
                      provider.updateSettings(
                        settings.copyWith(doNotDisturb: value),
                      );
                    },
                  ),
                  if (settings.doNotDisturb) ...[
                    ListTile(
                      title: const Text('Başlangıç Saati'),
                      subtitle: Text(settings.doNotDisturbStart.format(context)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _selectTime(
                        context,
                        settings.doNotDisturbStart,
                        (time) {
                          provider.updateSettings(
                            settings.copyWith(doNotDisturbStart: time),
                          );
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Bitiş Saati'),
                      subtitle: Text(settings.doNotDisturbEnd.format(context)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _selectTime(
                        context,
                        settings.doNotDisturbEnd,
                        (time) {
                          provider.updateSettings(
                            settings.copyWith(doNotDisturbEnd: time),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Future<void> _selectTime(
    BuildContext context,
    TimeOfDay initialTime,
    void Function(TimeOfDay) onSelected,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      onSelected(picked);
    }
  }
}
```

## 🎯 Ödevler

1. Bildirim Sistemi:
   - [ ] Özel bildirim sesleri ekleyin
   - [ ] Bildirim grupları oluşturun
   - [ ] Bildirim önizlemeleri ekleyin
   - [ ] Bildirim eylemleri ekleyin

2. Bildirim İçeriği:
   - [ ] Motivasyon mesajları ekleyin
   - [ ] İlerleme grafikleri ekleyin
   - [ ] Başarı rozetleri ekleyin
   - [ ] Özelleştirilebilir mesajlar ekleyin

3. Kullanıcı Deneyimi:
   - [ ] Bildirim geçmişi ekleyin
   - [ ] Bildirim istatistikleri ekleyin
   - [ ] Bildirim öncelikleri ekleyin
   - [ ] Bildirim kategorileri ekleyin

## 🔍 Kontrol Listesi

Her değişiklik sonrası şunları kontrol edin:
- [ ] Bildirimler doğru zamanda geliyor mu?
- [ ] Bildirim içerikleri doğru mu?
- [ ] Bildirim eylemleri çalışıyor mu?
- [ ] Rahatsız etme modu aktif mi?

## 💡 İpuçları

1. Bildirim Zamanlaması:
   - Zaman dilimlerini kontrol edin
   - Tekrarlanan bildirimleri optimize edin
   - Rahatsız etme modunu test edin
   - Bildirim sıklığını ayarlayın

2. Bildirim İçeriği:
   - Kısa ve öz mesajlar kullanın
   - Görsel öğeler ekleyin
   - Eylem butonları ekleyin
   - Kişiselleştirme yapın

3. Performans:
   - Bildirim sayısını sınırlayın
   - Arka plan işlemlerini optimize edin
   - Bellek kullanımını kontrol edin
   - Pil tüketimini azaltın

## 📚 Faydalı Kaynaklar

- [Local Notifications Guide](https://pub.dev/packages/flutter_local_notifications)
- [Notification Styling](https://developer.android.com/develop/ui/views/notifications/custom-notification)
- [Background Tasks](https://developer.android.com/guide/background)
- [iOS Notifications](https://developer.apple.com/documentation/usernotifications) 