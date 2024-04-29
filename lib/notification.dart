import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Noti {
  static Future<void> showBigTextNotification({
    int id = 0,
    required String title,
    required String body,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_name',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: IOSNotificationDetails(),
    );

    await fln.show(id, title, body, notificationDetails);
  }
}
