import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main.dart'; 

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String? _token;
  String _lastTitle = 'Sin notificaciones';
  String _lastBody = '';

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    await FirebaseMessaging.instance.requestPermission();

    final token = await FirebaseMessaging.instance.getToken();
    print(" TOKEN FCM: $token");

    setState(() {
      _token = token;
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _setNotificationData(initialMessage, "Cold start");
    }

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _setNotificationData(message, "Notificación abierta por el usuario");
    });

    FirebaseMessaging.onMessage.listen((message) {
      _setNotificationData(message, "Foreground");

      _showLocalNotification(
        message.notification?.title ?? "Sin título",
        message.notification?.body ?? "Sin contenido",
      );
    });
  }

  void _setNotificationData(RemoteMessage message, String origen) {
    setState(() {
      _lastTitle = message.notification?.title ?? 'Sin título';
      _lastBody = "$origen → ${message.notification?.body ?? 'Sin contenido'}";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("📩 $_lastTitle")),
    );
  }

  Future<void> _showLocalNotification(String title, String body) async {
    const android = AndroidNotificationDetails(
      'demo_channel',
      'Demo Notifs',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: android);

    await flutterLocalNotificationsPlugin.show(
      1,
      title,
      body,
      details,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Notificaciones Firebase'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔑 Token FCM:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SelectableText(
              _token ?? 'Obteniendo token...',
              style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
            const SizedBox(height: 30),

            Row(
              children: const [
                Icon(Icons.notifications_active, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  'Última notificación',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 25),
            Text(
              _lastTitle,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _lastBody,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
