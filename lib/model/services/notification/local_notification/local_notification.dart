import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static NotificationDetails notificationDetails =
      NotificationDetails(iOS: iosSettings, android: androidSettings);
  static DarwinNotificationDetails iosSettings =
      const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentBanner: true,
          presentList: true,
          presentSound: true);
  static AndroidNotificationDetails androidSettings =
      const AndroidNotificationDetails(
    "tita",
    "tita",
    importance: Importance.max,
    visibility: NotificationVisibility.public,
    icon: '@drawable/notification_icon',
    priority: Priority.high,
    styleInformation: BigTextStyleInformation(''),
    color: Colors.white,
  );

  static void initilize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("notification_icon"),
      iOS: DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      ),
    );
    _notificationsPlugin.initialize(
    settings:   initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        log('tapped from onDidReceiveNotificationResponse ${details.payload}');
        if (details.payload != null && details.payload!.contains('https') ||
            details.payload!.contains('http')) {
          openURL(details.payload!);
        }
      },
    );
  }

  static void display(Map message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await _notificationsPlugin.show(
      id:  id,
      title:   message['title'],
     body:    message['message'],
      notificationDetails:   notificationDetails,
        payload: message["link"] ?? '',
      );
    } on Exception catch (e) {
      // ignore: avoid_print
      log(e.toString());
    }
  }

  static void showNotificationOnForeground(RemoteMessage message) async {
    try {
      await _notificationsPlugin.show(
      id:   DateTime.now().microsecond,
      title:   message.notification!.title,
      body:   message.notification!.body,
      notificationDetails:   notificationDetails,
        payload: message.data["link"] ?? '',
      );
    } catch (e) {
      log(e.toString());
    }
  }
}
