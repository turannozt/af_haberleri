// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import '../api/noti_helper.dart';

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late WebViewController _controller;
  bool isLoading = false;
  String previousContent = '';
  late final WebViewController controller;
  String url = 'https://www.afhaberleri.com';

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadRequest(Uri.parse(url));
    _controller = controller;
    super.initState();
    NotifyHelper().initializeNotification();

    // loadWebView();

    startPeriodicChecks();
    _requestNotificationPermissions();
  }

  Future<void> _requestNotificationPermissions() async {
    PermissionStatus status = await Permission.notification.request();
    debugPrint("Bildirim izni durumu: $status");
  }

  void startPeriodicChecks() {
    const Duration checkInterval = Duration(minutes: 5);
    Timer.periodic(checkInterval, (timer) {
      fetchAndCompareContent();
    });
  }

  Future<void> fetchAndCompareContent() async {
    final response =
        await http.get(Uri.parse('https://www.afhaberleri.com/haberler/'));
    final newContent = response.body;

    if (newContent != previousContent) {
      sendNotification();
      previousContent = newContent;
    }
  }

  void sendNotification() async {
    // Kullanıcı bildirime tıkladığında yönlendirilecek URL
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Kanal ID'si
      'Kanal Adı',
      channelDescription: 'Kanal Açıklaması',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: "app_icon",
      fullScreenIntent: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Yeni Makale Eklendi',
      'Yeni bir makale eklenmiştir!',
      platformChannelSpecifics,
      payload: 'news', // Özel payload değeri
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBarrr(),
      body: WillPopScope(
        onWillPop: () async {
          if (await controller.canGoBack()) {
            controller.goBack();
            return false; // Geri tuşunun işlevini yaptık, devam etme
          }
          return true; // Geri tuşunu Flutter'a bırak
        },
        child: SafeArea(
          child: WebViewWidget(
            controller: controller,
          ),
        ),
      ),
    );
  }

  AppBar AppBarrr() {
    return AppBar(
      elevation: 0,
      title: const Text('Af Haberleri', style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
        ),
        onPressed: () async {
          if (await _controller.canGoBack()) {
            _controller.goBack();
          }
        },
      ),
      actions: [
        // Diğer butonlar burada devam eder
        IconButton(
          onPressed: () async {
            _controller.reload();
          },
          icon: const Icon(
            Icons.replay_outlined,
            color: Colors.black,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black,
          ),
          onPressed: () async {
            if (await _controller.canGoForward()) {
              _controller.goForward();
            }
          },
        ),
      ],
    );
  }
}
