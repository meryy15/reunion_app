import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart'; // Assurez-vous que la bibliothèque timezone est incluse

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialisation des notifications locales
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Afficher une notification locale
  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'meeting_channel_id',
      'meeting_channel_name',
      channelDescription: 'Notifications pour les réunions',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // ID de la notification
      title,
      body,
      notificationDetails,
      payload: 'item x',
    );
  }

  // Planifier une notification 15 minutes avant la réunion
  Future<void> scheduleMeetingNotification(DateTime meetingTime, String title) async {
    final currentTime = DateTime.now();
    final timeDifference = meetingTime.difference(currentTime);

    // Si la réunion est dans moins de 15 minutes, afficher immédiatement la notification
    if (timeDifference.isNegative || timeDifference.inMinutes < 15) {
      await showNotification("Réunion à venir", "La réunion '$title' commence dans 15 minutes.");
    } else {
      // Planifier la notification 15 minutes avant l'heure de la réunion
      final scheduledTime = meetingTime.subtract(const Duration(minutes: 15));

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0, 
        "Réunion à venir",
        "La réunion '$title' commence dans 15 minutes.",
        TZDateTime.from(scheduledTime, local), // Utiliser le fuseau horaire local
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'meeting_channel_id',
            'meeting_channel_name',
            channelDescription: 'Notifications pour les réunions',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }
}
