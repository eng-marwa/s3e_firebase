import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:s3e_firebase/main.dart';
import 'package:s3e_firebase/utils/context_extension.dart';

class NotificationHandler {
  NotificationHandler._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static void handleForegroundNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) =>
        _showNotification(remoteMessage, 'onMessage'));

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) =>
        _showNotification(remoteMessage, 'onMessageOpenedApp'));
  }

  static void handleBackgroundNotification() {
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessageHandler);
  }

  //notification UI
  static Future<void> _showNotification(
      RemoteMessage remoteMessage, String message) async {
    viewNotification(remoteMessage, message);
  }

  static Future<bool> getPermission() async {
    FirebaseMessaging.instance.requestPermission();
    bool? permissionGranted = await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    return permissionGranted ?? false;
  }

  static void initialize() {
    //initialization
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('app_icon');
    DarwinInitializationSettings darwinInitializationSettings =
        const DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: darwinInitializationSettings);
    _plugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {
      if (GlobalNotificationHandler.remoteMessage != null) {
        if (GlobalNotificationHandler.remoteMessage!.data.isNotEmpty) {
          navigateTo('/item', GlobalNotificationHandler.remoteMessage!.data);
        } else {
          navigateTo('/home');
        }
      }
    },
        onDidReceiveBackgroundNotificationResponse:
            _onTapBackgroundNotification);
  }

  static void viewNotification(RemoteMessage remoteMessage, String message) {
    GlobalNotificationHandler.remoteMessage = remoteMessage;
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      's3e_id',
      's3e_name',
      autoCancel: true,
      importance: Importance.high,
      priority: Priority.high,
      enableLights: true,
      enableVibration: true,
    );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
            presentBadge: true, presentSound: true, presentAlert: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    print(remoteMessage);
    if (remoteMessage.notification != null) {
      print(
          '$message -> ${remoteMessage.notification!.title} - ${remoteMessage.notification!.body}');
      _plugin.show(remoteMessage.hashCode, remoteMessage.notification!.title,
          remoteMessage.notification!.body, notificationDetails);
    }
  }
}

void navigateTo(String route, [Object? data]) {
  if (data != null) {
    navKey.currentContext!.navigateTo(route, data);
  }
}

Future<void> _onBackgroundMessageHandler(RemoteMessage remoteMessage) async {
  NotificationHandler._showNotification(remoteMessage, 'onBackgroundMessage');
}

void _onTapBackgroundNotification(NotificationResponse details) {
  if (GlobalNotificationHandler.remoteMessage != null) {
    if (GlobalNotificationHandler.remoteMessage!.data.isNotEmpty) {
      navigateTo('/item', GlobalNotificationHandler.remoteMessage!.data);
    } else {
      navigateTo('/home');
    }
  }
}

class GlobalNotificationHandler {
  static RemoteMessage? remoteMessage;
}
