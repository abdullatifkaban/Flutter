# Hafta 4 - Bildirim Sistemi

Bu hafta, Flutter uygulamalarında bildirim sistemlerini öğreneceğiz.

## 🎯 Bu Hafta Neler Öğreneceğiz?

1. Bildirim Sistemi Temelleri
   - Bildirim türleri
   - Bildirim izinleri
   - Bildirim kanalları
   - Bildirim öncelikleri

2. Yerel Bildirimler
   - flutter_local_notifications
   - Zamanlı bildirimler
   - Tekrarlanan bildirimler
   - Bildirim eylemleri

3. Push Bildirimleri
   - Firebase Cloud Messaging (FCM)
   - Token yönetimi
   - Bildirim gönderme
   - Arka plan işleme

4. Bildirim Yönetimi
   - Bildirim gruplandırma
   - Bildirim geçmişi
   - Bildirim ayarları
   - Bildirim etkileşimleri

## 📚 Konu Anlatımı

### Bildirim Sistemi Temelleri

1. **Bildirim İzinleri**:
   ```dart
   // Android Manifest
   <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
   
   // iOS Info.plist
   <key>NSUserNotificationAlertStyle</key>
   <string>alert</string>
   ```

2. **Bildirim Kanalları (Android)**:
   ```dart
   const AndroidNotificationChannel channel = AndroidNotificationChannel(
     'high_importance_channel',
     'Önemli Bildirimler',
     description: 'Bu kanal önemli bildirimleri içerir',
     importance: Importance.high,
   );
   ```

### Yerel Bildirimler

1. **Basit Bildirim**:
   ```dart
   Future<void> showNotification() async {
     const AndroidNotificationDetails androidDetails =
         AndroidNotificationDetails(
       'channel_id',
       'channel_name',
       channelDescription: 'channel_description',
       importance: Importance.max,
       priority: Priority.high,
     );

     const NotificationDetails platformDetails =
         NotificationDetails(android: androidDetails);

     await flutterLocalNotificationsPlugin.show(
       0,
       'Başlık',
       'Mesaj',
       platformDetails,
     );
   }
   ```

2. **Zamanlı Bildirim**:
   ```dart
   Future<void> scheduleNotification() async {
     await flutterLocalNotificationsPlugin.zonedSchedule(
       0,
       'Zamanlı Bildirim',
       'Bu bildirim zamanlandı!',
       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
       const NotificationDetails(
         android: AndroidNotificationDetails(
           'channel_id',
           'channel_name',
           channelDescription: 'channel_description',
         ),
       ),
       androidAllowWhileIdle: true,
       uiLocalNotificationDateInterpretation:
           UILocalNotificationDateInterpretation.absoluteTime,
     );
   }
   ```

### Push Bildirimleri

1. **FCM Kurulumu**:
   ```yaml
   dependencies:
     firebase_core: ^2.24.2
     firebase_messaging: ^14.7.10
   ```

2. **Token Alma**:
   ```dart
   Future<void> getFCMToken() async {
     final fcmToken = await FirebaseMessaging.instance.getToken();
     print('FCM Token: $fcmToken');
     
     // Token'ı sunucuya kaydet
     await saveTokenToServer(fcmToken);
   }
   ```

3. **Bildirim İşleme**:
   ```dart
   Future<void> setupFCM() async {
     // Ön plan bildirimleri
     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
       print('Ön plan bildirimi alındı!');
       print('Başlık: ${message.notification?.title}');
       print('Mesaj: ${message.notification?.body}');
       print('Veri: ${message.data}');
     });

     // Arka plan bildirimleri
     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
   }

   Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
     print('Arka plan bildirimi alındı!');
     print('Başlık: ${message.notification?.title}');
     print('Mesaj: ${message.notification?.body}');
     print('Veri: ${message.data}');
   }
   ```

### Bildirim Yönetimi

1. **Bildirim Gruplandırma**:
   ```dart
   Future<void> showGroupedNotifications() async {
     const String groupKey = 'com.example.app.NOTIFICATION_GROUP';
     
     const AndroidNotificationDetails firstNotificationDetails =
         AndroidNotificationDetails(
       'channel_id',
       'channel_name',
       channelDescription: 'channel_description',
       groupKey: groupKey,
     );

     await flutterLocalNotificationsPlugin.show(
       0,
       'Birinci Bildirim',
       'Bu ilk bildirim',
       const NotificationDetails(android: firstNotificationDetails),
     );

     const AndroidNotificationDetails secondNotificationDetails =
         AndroidNotificationDetails(
       'channel_id',
       'channel_name',
       channelDescription: 'channel_description',
       groupKey: groupKey,
     );

     await flutterLocalNotificationsPlugin.show(
       1,
       'İkinci Bildirim',
       'Bu ikinci bildirim',
       const NotificationDetails(android: secondNotificationDetails),
     );

     const AndroidNotificationDetails summaryNotificationDetails =
         AndroidNotificationDetails(
       'channel_id',
       'channel_name',
       channelDescription: 'channel_description',
       groupKey: groupKey,
       setAsGroupSummary: true,
     );

     await flutterLocalNotificationsPlugin.show(
       2,
       'Özet Bildirim',
       '2 yeni bildirim',
       const NotificationDetails(android: summaryNotificationDetails),
     );
   }
   ```

2. **Bildirim Etkileşimleri**:
   ```dart
   Future<void> setupNotificationActions() async {
     const AndroidInitializationSettings initializationSettingsAndroid =
         AndroidInitializationSettings('app_icon');

     final InitializationSettings initializationSettings =
         InitializationSettings(android: initializationSettingsAndroid);

     await flutterLocalNotificationsPlugin.initialize(
       initializationSettings,
       onDidReceiveNotificationResponse: (NotificationResponse response) {
         // Bildirime tıklandığında
         print('Bildirime tıklandı: ${response.payload}');
       },
     );
   }
   ```

## 💻 Örnek Uygulama: Hatırlatıcı Uygulaması

Bu haftaki örnek uygulamamızda, bildirim sistemini kullanarak basit bir hatırlatıcı uygulaması geliştireceğiz. Detaylar için [tıklayınız](./ornek_uygulama/README.md).

## 🚀 Ana Proje: Alışkanlık Takip Uygulaması

Bu hafta ana projemizde şunları yapacağız:

1. Alışkanlık hatırlatıcıları
2. Günlük özet bildirimleri
3. Başarı bildirimleri
4. Bildirim ayarları

Ana proje detayları için [tıklayınız](./ana_proje/README.md).

## 🎯 Alıştırmalar

1. Yerel Bildirimler:
   - [ ] Farklı bildirim türleri oluşturun
   - [ ] Özel bildirim sesleri ekleyin
   - [ ] Bildirim eylemlerini özelleştirin
   - [ ] Bildirim zamanlaması yapın

2. Push Bildirimleri:
   - [ ] FCM entegrasyonu yapın
   - [ ] Topic tabanlı bildirimler ekleyin
   - [ ] Bildirim verilerini işleyin
   - [ ] Bildirim yönlendirmesi yapın

## 🔍 Hata Ayıklama İpuçları

- Bildirim izinlerini kontrol edin
- FCM token'ı düzenli güncelleyin
- Bildirim kanallarını doğru yapılandırın
- Arka plan işlemlerini test edin

## 📚 Faydalı Kaynaklar

- [Local Notifications Guide](https://pub.dev/packages/flutter_local_notifications)
- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [Notification Permissions](https://developer.android.com/develop/ui/views/notifications/notification-permission)
- [iOS Push Notifications](https://developer.apple.com/documentation/usernotifications) 