// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';


class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true, // Bildirim ses izni
      requestBadgePermission: true, // Bildirim rozeti izni
      requestAlertPermission: true, // Bildirim görüntüleme izni
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("app_icon");

    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponsee,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveNotificationResponsee,
    );
  }

  void displayNotification(
      {required String title, required String body}) async {
    debugPrint("doing test");

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    try {
      await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        platformChannelSpecifics,
        payload: title,
      );
    } catch (e) {
      debugPrint("Error while displaying notification: $e");
    }
  }

  void onDidReceiveNotificationResponsee(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }

    if (payload == "news") {
      final String? redirectUrl =
          notificationResponse.payload; // Payload olarak gönderilen URL'yi al
      if (redirectUrl != null) {
        // Get.off(
        //   () => NotifiedPage(label: 'Yeni Makale', redirectUrl: redirectUrl),
        // );
      }
    } else if (payload == "test") {
      // Test bildirimine tıklanıldığında başka bir işlem yapabilirsiniz.
      // Örnek: Sayfanın üstüne bir metin gösterme
    }
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    Get.dialog(const Text("Welcome"));
  }
}
