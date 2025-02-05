import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/aliskanlik.dart';

class BildirimServisi {
  static final BildirimServisi _instance = BildirimServisi._internal();
  factory BildirimServisi() => _instance;
  BildirimServisi._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notifications.initialize(initSettings);
  }

  Future<void> bildirimPlanla(Aliskanlik aliskanlik) async {
    for (final gun in aliskanlik.gunler) {
      final gunIndex = _gunIndexi(gun);
      if (gunIndex != -1) {
        final now = DateTime.now();
        var bildirimZamani = DateTime(
          now.year,
          now.month,
          now.day,
          aliskanlik.hatirlatmaSaati.hour,
          aliskanlik.hatirlatmaSaati.minute,
        );

        // Bir sonraki gün için ayarla
        while (bildirimZamani.weekday != gunIndex + 1 ||
            bildirimZamani.isBefore(now)) {
          bildirimZamani = bildirimZamani.add(const Duration(days: 1));
        }

        final androidDetails = AndroidNotificationDetails(
          aliskanlik.id,
          'Alışkanlık Hatırlatıcı',
          channelDescription: 'Alışkanlık hatırlatmaları için bildirim kanalı',
          importance: Importance.high,
          priority: Priority.high,
        );

        const iosDetails = DarwinNotificationDetails();
        final details = NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        );

        await _notifications.zonedSchedule(
          int.parse(aliskanlik.id.split('-')[0], radix: 16),
          'Alışkanlık Hatırlatması',
          '${aliskanlik.baslik} zamanı geldi!',
          tz.TZDateTime.from(bildirimZamani, tz.local),
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }
    }
  }

  Future<void> bildirimIptalEt(String id) async {
    await _notifications.cancel(int.parse(id.split('-')[0], radix: 16));
  }

  int _gunIndexi(String gun) {
    const gunler = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    return gunler.indexOf(gun);
  }
}
