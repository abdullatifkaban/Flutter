# Hafta 7: Bildirim Sistemi ve Firebase Cloud Messaging

Bu haftada HabitMaster uygulamamıza bildirim sistemini entegre edeceğiz ve Firebase Cloud Messaging kullanarak push notification'ları implemente edeceğiz.

## 🎯 Hedefler

- Firebase Cloud Messaging kurulumu
- Local notifications
- Push notifications
- Bildirim yönetimi

## 📝 Konu Başlıkları

1. Firebase Entegrasyonu
   - Firebase projesinin oluşturulması
   - FCM kurulumu
   - Firebase Analytics
   - Crashlytics

2. Local Notifications
   - flutter_local_notifications
   - Bildirim kanalları
   - Zamanlı bildirimler
   - Bildirim etkileşimleri

3. Push Notifications
   - FCM token yönetimi
   - Topic-based notifications
   - Notification payload
   - Background handlers

## 💻 Adım Adım Uygulama Geliştirme

### 1. Firebase Kurulumu

```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_messaging: ^14.7.10
  flutter_local_notifications: ^16.3.0
```

### 2. Notification Service

```dart
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // FCM izinleri
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Local notifications kurulumu
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // FCM token alma
    String? token = await _fcm.getToken();
    print('FCM Token: $token');

    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Foreground message handler
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Background message: ${message.notification?.title}');
    // Background işlemleri
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    print('Foreground message: ${message.notification?.title}');
    showNotification(
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
    );
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'habit_master_channel',
      'HabitMaster Notifications',
      channelDescription: 'HabitMaster bildirim kanalı',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecond,
      title,
      body,
      details,
      payload: payload,
    );
  }

  static Future<void> scheduleHabitReminder(Habit habit) async {
    final DateTime now = DateTime.now();
    final DateTime scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      habit.reminderTime.hour,
      habit.reminderTime.minute,
    );

    const androidDetails = AndroidNotificationDetails(
      'habit_reminder_channel',
      'Habit Reminders',
      channelDescription: 'Alışkanlık hatırlatıcıları',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      habit.id.hashCode,
      'Alışkanlık Hatırlatıcısı',
      '${habit.title} zamanı geldi!',
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static void _onNotificationTap(NotificationResponse response) {
    // Bildirime tıklandığında yapılacak işlemler
    print('Notification tapped: ${response.payload}');
  }
}
```

### 3. Bildirim Yönetimi

```dart
class HabitProvider extends ChangeNotifier {
  // ... diğer kodlar ...

  Future<void> addHabit(Habit habit) async {
    await _repository.insertHabit(habit);
    await NotificationService.scheduleHabitReminder(habit);
    await _loadHabits();
  }

  Future<void> completeHabit(String id) async {
    final habit = _habits.firstWhere((h) => h.id == id);
    await _repository.updateHabit(habit.copyWith(isCompleted: true));
    
    // Başarı bildirimi
    await NotificationService.showNotification(
      title: 'Tebrikler!',
      body: '${habit.title} alışkanlığını tamamladınız!',
    );
    
    await _loadHabits();
  }
}
```

## 📝 Ödevler

1. Özel bildirim sesleri ekleyin
2. Bildirim gruplandırma yapın
3. Bildirim etkileşimlerine özel aksiyonlar ekleyin

## 🔍 Sonraki Adımlar

Gelecek hafta:
- Tema ve UI/UX geliştirmeleri
- Custom widget'lar
- Animasyonlar 