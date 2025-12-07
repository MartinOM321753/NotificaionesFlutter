import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  String _lastTitle = 'Sin notificaciones';
  String _lastBody = '';

  @override
void initState() {
  super.initState();

  FirebaseMessaging.instance.requestPermission();

  FirebaseMessaging.instance.getToken().then((token) {
    print('🔥 FCM Token: $token');
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;

    if (notification != null) {
      setState(() {
        _lastTitle = notification.title ?? 'Sin título';
        _lastBody = notification.body ?? 'Sin contenido';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Notificación: ${notification.title ?? 'Sin título'}',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  });
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFF4F6FA),
    appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      title: const Text(
        'Notificaciones',
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    ),
    body: Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: Colors.black.withOpacity(0.06),
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: const [
                Icon(Icons.notifications_active, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  'Última notificación',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),
            const Divider(),
            const SizedBox(height: 14),

            Text(
              _lastTitle,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              _lastBody.isEmpty ? 'Aún no hay mensajes' : _lastBody,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),

            const SizedBox(height: 18),

            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'Firebase Cloud Messaging',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
}
